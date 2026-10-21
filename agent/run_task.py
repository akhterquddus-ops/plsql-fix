"""
PLSQL-Fix agent loop (setting: no retrieval).

For one task folder:
  1. Reset: compile 01_buggy.sql and 02_test.sql in Oracle.
  2. Run the utPLSQL suite and capture the failure report.
  3. Ask Gemma (via the Ollama API) for a fixed version of the buggy code.
  4. Compile the candidate, check USER_ERRORS, rerun the suite.
  5. Repeat with the new error as feedback, up to --max-attempts.
A JSON log of every attempt is written to results/<task>/.

Usage (from the repo root, conda env with oracledb + requests):
  python agent/run_task.py tasks/demo_leap_year
  python agent/run_task.py tasks/demo_leap_year --model gemma4:e4b --max-attempts 3

Connection settings can be overridden with environment variables:
  PLSQLFIX_DB_USER, PLSQLFIX_DB_PASSWORD, PLSQLFIX_DB_DSN, OLLAMA_URL
"""
import argparse
import json
import os
import re
import sys
import time
from datetime import datetime
from pathlib import Path

import oracledb
import requests

ROOT = Path(__file__).resolve().parent.parent

DB_USER = os.getenv("PLSQLFIX_DB_USER", "plsqlfix")
DB_PASSWORD = os.getenv("PLSQLFIX_DB_PASSWORD", "plsqlfix123")
DB_DSN = os.getenv("PLSQLFIX_DB_DSN", "localhost:1521/FREEPDB1")
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")

# SQL*Plus-only commands that must not be sent to the database.
SQLPLUS_ONLY = re.compile(
    r"^\s*(show\s+err|exit|quit|set\s|spool|prompt|exec\s|execute\s|whenever|@)", re.I)

# Matches "create or replace <type> <name>" and captures the object type and name.
CREATE_RE = re.compile(
    r"create\s+(?:or\s+replace\s+)?(?:(?:editionable|noneditionable)\s+)?"
    r"(package\s+body|type\s+body|package|function|procedure|trigger|type)\s+"
    r'(?:"?\w+"?\.)?"?([\w$#]+)"?',
    re.I)

SUMMARY_RE = re.compile(r"(\d+) tests?, (\d+) failed, (\d+) errored", re.I)

SYSTEM_PROMPT = """You are an expert Oracle PL/SQL developer fixing a bug.
You are given the current code and the output of its failing utPLSQL unit tests.
Rules:
- Return the COMPLETE corrected code as CREATE OR REPLACE statement(s).
- Keep the same object names, parameters and return types.
- Change only what is needed to fix the bug. Do not create or change test packages.
- Put all code in ONE ```sql code block. End each statement with a line containing only "/".
- No explanation outside the code block."""


# --------------------------------------------------------------------------- SQL helpers
def split_statements(sql_text):
    """Split a SQL*Plus-style script into executable statements.

    PL/SQL units end with a line containing only '/'. SQL*Plus commands
    (show errors, exit, set ...) between statements are dropped.
    """
    stmts, buf = [], []
    for line in sql_text.splitlines():
        if line.strip() == "/":
            text = "\n".join(buf).strip()
            if text:
                stmts.append(text)
            buf = []
            continue
        if not "\n".join(buf).strip():
            # Between statements: skip blank lines and SQL*Plus commands.
            if not line.strip() or SQLPLUS_ONLY.match(line):
                buf = []
                continue
        buf.append(line)
    tail = "\n".join(buf).strip()
    if tail and CREATE_RE.search(tail):  # the model forgot the final '/'
        stmts.append(tail)
    return stmts


def object_names(stmts):
    names = []
    for s in stmts:
        m = CREATE_RE.search(s)
        if m:
            names.append(m.group(2).upper())
    return names


def compile_sql(conn, stmts):
    """Execute statements; return a list of error strings (empty list = clean compile)."""
    errors = []
    with conn.cursor() as cur:
        for s in stmts:
            body = s if CREATE_RE.search(s) else s.rstrip().rstrip(";")
            try:
                cur.execute(body)
            except oracledb.DatabaseError as e:
                errors.append(str(e).strip())
        names = sorted(set(object_names(stmts)))
        if names:
            binds = {f"n{i}": n for i, n in enumerate(names)}
            placeholders = ", ".join(":" + k for k in binds)
            cur.execute(
                "select name, type, line, position, text from user_errors "
                f"where name in ({placeholders}) order by name, type, sequence",
                binds)
            for name, typ, line, pos, text in cur:
                errors.append(f"{typ} {name} line {line}, col {pos}: {text.strip()}")
    return errors


def run_tests(conn, suite):
    """Run a utPLSQL suite via the ut.run procedure and capture DBMS_OUTPUT."""
    with conn.cursor() as cur:
        cur.callproc("dbms_output.enable", [None])
        cur.execute("begin ut.run(:s); end;", s=suite)
        lines, chunk = [], 200
        lines_var = cur.arrayvar(str, chunk)
        num_var = cur.var(int)
        while True:
            num_var.setvalue(0, chunk)
            cur.callproc("dbms_output.get_lines", (lines_var, num_var))
            n = num_var.getvalue()
            lines.extend((x or "") for x in lines_var.getvalue()[:n])
            if n < chunk:
                break
    report = "\n".join(lines).strip()
    m = SUMMARY_RE.search(report)
    if not m:
        return {"tests": None, "failed": None, "errored": None, "passed": False, "report": report}
    tests, failed, errored = map(int, m.groups())
    return {"tests": tests, "failed": failed, "errored": errored,
            "passed": tests > 0 and failed == 0 and errored == 0, "report": report}


# --------------------------------------------------------------------------- model helpers
def preflight():
    """Fail fast with a plain message if Oracle or Ollama is not running."""
    try:
        requests.get(f"{OLLAMA_URL}/api/version", timeout=5).raise_for_status()
    except requests.RequestException:
        sys.exit("Ollama is not running. Start it with:\n"
                 '  Start-Process "$env:LOCALAPPDATA\\Programs\\Ollama\\ollama app.exe"')
    try:
        oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN).close()
    except oracledb.Error as e:
        sys.exit("Cannot connect to Oracle (" + str(e).splitlines()[0] + ").\n"
                 "Start Docker Desktop, then run: "
                 "powershell -ExecutionPolicy Bypass -File .\\scripts\\setup_oracle.ps1")


def ask_model(model, messages, num_ctx, timeout, num_gpu=None):
    options = {"temperature": 0, "seed": 42, "num_ctx": num_ctx}
    if num_gpu is not None:
        options["num_gpu"] = num_gpu  # 0 = run fully on CPU
    try:
        r = requests.post(
            f"{OLLAMA_URL}/api/chat",
            json={
                "model": model,
                "messages": messages,
                "stream": False,
                "think": False,
                "options": options,
            },
            timeout=timeout)
    except requests.Timeout:
        sys.exit(f"Model call timed out after {timeout}s. Check `ollama ps` and `nvidia-smi` "
                 "(if the GPU is lost, reboot and use --cpu).")
    r.raise_for_status()
    d = r.json()
    stats = {
        "prompt_tokens": d.get("prompt_eval_count"),
        "output_tokens": d.get("eval_count"),
        "seconds": round((d.get("total_duration") or 0) / 1e9, 2),
    }
    return d["message"]["content"], stats


def extract_code(text):
    """Return the SQL inside ``` fences (all blocks joined), or the raw text if none."""
    blocks = re.findall(r"```(?:sql|plsql|oracle)?[ \t]*\r?\n(.*?)```", text, re.S | re.I)
    if not blocks:
        return text
    return "\n/\n".join(b.strip() for b in blocks)


def as_script(stmts):
    return "\n/\n".join(stmts) + "\n/"


# --------------------------------------------------------------------------- main loop
def run_task(task_dir, model, max_attempts, num_ctx, timeout, num_gpu=None):
    preflight()
    task_dir = Path(task_dir).resolve()
    buggy = split_statements((task_dir / "01_buggy.sql").read_text(encoding="utf-8"))
    tests = split_statements((task_dir / "02_test.sql").read_text(encoding="utf-8"))
    suite = object_names(tests)[0]
    protected = set(object_names(tests))

    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

    # 1. Reset the task to its buggy state.
    errs = compile_sql(conn, buggy) + compile_sql(conn, tests)
    if errs:
        sys.exit("Task setup failed to compile:\n" + "\n".join(errs))

    # 2. Baseline: tests must fail on the buggy code.
    baseline = run_tests(conn, suite)
    if baseline["passed"]:
        sys.exit("Invalid task: tests already pass on the buggy code.")
    print(f"Task {task_dir.name}: baseline {baseline['tests']} tests, "
          f"{baseline['failed']} failed, {baseline['errored']} errored")

    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": (
            "Fix the bug in this Oracle PL/SQL code so that all unit tests pass.\n\n"
            f"Current code:\n```sql\n{as_script(buggy)}\n```\n\n"
            f"Failing utPLSQL test output:\n```\n{baseline['report']}\n```")},
    ]

    attempts, solved, t0 = [], False, time.time()
    for i in range(1, max_attempts + 1):
        reply, stats = ask_model(model, messages, num_ctx, timeout, num_gpu)
        candidate = split_statements(extract_code(reply))
        record = {"attempt": i, **stats, "candidate": as_script(candidate) if candidate else reply}

        if not candidate:
            outcome, feedback = "no_code", (
                "Your reply did not contain a CREATE OR REPLACE statement. "
                "Return the complete corrected code in one ```sql block.")
        elif protected & set(object_names(candidate)):
            outcome, feedback = "touched_tests", (
                "Do not create or modify the test package. Fix only the code under test.")
        else:
            errs = compile_sql(conn, candidate)
            if errs:
                outcome = "compile_error"
                record["compile_errors"] = errs
                feedback = ("Your code did not compile:\n```\n" + "\n".join(errs) +
                            "\n```\nReturn the complete corrected code.")
            else:
                res = run_tests(conn, suite)
                record["tests"] = {k: res[k] for k in ("tests", "failed", "errored")}
                if res["passed"]:
                    outcome, solved, feedback = "pass", True, None
                else:
                    outcome = "test_fail"
                    feedback = ("The tests still fail:\n```\n" + res["report"] +
                                "\n```\nReturn the complete corrected code.")

        record["outcome"] = outcome
        attempts.append(record)
        print(f"  attempt {i}: {outcome:<14} ({stats['seconds']}s, "
              f"{stats['prompt_tokens']} in / {stats['output_tokens']} out tokens)")
        if solved:
            break
        messages.append({"role": "assistant", "content": reply})
        messages.append({"role": "user", "content": feedback})

    conn.close()
    result = {
        "task": task_dir.name,
        "setting": "none",
        "model": model,
        "num_ctx": num_ctx,
        "device": "cpu" if num_gpu == 0 else "gpu",
        "max_attempts": max_attempts,
        "solved": solved,
        "attempts_used": len(attempts),
        "wall_seconds": round(time.time() - t0, 2),
        "timestamp": datetime.now().isoformat(timespec="seconds"),
        "baseline": {k: baseline[k] for k in ("tests", "failed", "errored")},
        "attempts": attempts,
    }

    out_dir = ROOT / "results" / task_dir.name
    out_dir.mkdir(parents=True, exist_ok=True)
    safe_model = re.sub(r"[^\w.-]", "_", model)
    out_file = out_dir / f"none_{safe_model}_{datetime.now():%Y%m%d_%H%M%S}.json"
    out_file.write_text(json.dumps(result, indent=2), encoding="utf-8")

    status = "SOLVED" if solved else "NOT SOLVED"
    print(f"{status} in {len(attempts)} attempt(s), {result['wall_seconds']}s. Log: {out_file}")
    return result


def main():
    p = argparse.ArgumentParser(description="Run the PLSQL-Fix agent on one task.")
    p.add_argument("task_dir", help="e.g. tasks/demo_leap_year")
    p.add_argument("--model", default="gemma4:e4b")
    p.add_argument("--max-attempts", type=int, default=3)
    p.add_argument("--num-ctx", type=int, default=8192,
                   help="context window; Ollama's default (4096) is too small for larger tasks")
    p.add_argument("--timeout", type=int, default=300, help="seconds per model call")
    p.add_argument("--cpu", action="store_true",
                   help="run the model fully on CPU (num_gpu=0), e.g. while the GPU is unstable")
    a = p.parse_args()
    result = run_task(a.task_dir, a.model, a.max_attempts, a.num_ctx, a.timeout,
                      num_gpu=0 if a.cpu else None)
    sys.exit(0 if result["solved"] else 1)


if __name__ == "__main__":
    main()
