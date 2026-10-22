"""
PLSQL-Fix agent loop.

Settings (what the model is shown besides the bug report and the failing test output):
  none   source of the entry object only (the unit the tests call)
  graph  entry object + every object reachable from it in Oracle's dependency graph
         (USER_DEPENDENCIES), up to --hops levels
  (dense, hybrid, hybrid_graph: added in the retrieval step)

For one task folder:
  1. Reset: run 00_setup.sql (tables), compile 01_buggy.sql and 02_test.sql.
  2. Baseline: the utPLSQL suite must fail.
  3. Ask Gemma (Ollama /api/chat) for a fix; compile it; rerun the suite.
  4. Repeat with the error as feedback, up to --max-attempts.
  5. Write a JSON log to results/<task>/ incl. whether the right object was fixed.

Usage (repo root, conda env with oracledb + requests):
  python agent/run_task.py tasks/t001_order_discount --setting graph
  python agent/run_task.py tasks/t001_order_discount --setting none --cpu

Connection overrides: PLSQLFIX_DB_USER, PLSQLFIX_DB_PASSWORD, PLSQLFIX_DB_DSN, OLLAMA_URL
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

SETTINGS = ("none", "graph")

# SQL*Plus-only commands that must not be sent to the database.
SQLPLUS_ONLY = re.compile(
    r"^\s*(show\s+err|exit|quit|set\s|spool|prompt|exec\s|execute\s|whenever|@)", re.I)

# "create or replace <type> <name>": captures object type and name.
CREATE_RE = re.compile(
    r"create\s+(?:or\s+replace\s+)?(?:(?:editionable|noneditionable)\s+)?"
    r"(package\s+body|type\s+body|package|function|procedure|trigger|type)\s+"
    r'(?:"?\w+"?\.)?"?([\w$#]+)"?',
    re.I)
PLSQL_START_RE = re.compile(r"^\s*create\s+(or\s+replace\s+)?", re.I)
TABLE_RE = re.compile(r'create\s+table\s+(?:"?\w+"?\.)?"?([\w$#]+)"?', re.I)
SUMMARY_RE = re.compile(r"(\d+) tests?, (\d+) failed, (\d+) errored", re.I)

SYSTEM_PROMPT = """You are an expert Oracle PL/SQL developer fixing a bug in an application.
You get a bug report, some of the application's code and the output of failing utPLSQL tests.
The bug may be in the code you are shown or in code it calls.
Rules:
- Return the COMPLETE corrected code of every object you change, as CREATE OR REPLACE statements.
- Keep object names, parameters and return types unchanged.
- Change only what is needed. Never create or change test packages.
- Put all code in ONE ```sql code block. End each statement with a line containing only "/".
- The first line inside the code block must be a comment: -- Cause: <object name and the exact
  mistake, in one sentence>
- Your code must differ from the current code. Returning it unchanged never fixes anything.
- No explanation outside the code block."""

CAUSE_RE = re.compile(r"--\s*cause\s*:\s*(.+)", re.I)


# --------------------------------------------------------------------------- script parsing
def split_statements(sql_text):
    """Split a SQL*Plus-style script into statements terminated by a line with only '/'.

    SQL*Plus commands and comment lines between statements are dropped.
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
            s = line.strip()
            if not s or s.startswith("--") or SQLPLUS_ONLY.match(line):
                buf = []
                continue
        buf.append(line)
    tail = "\n".join(buf).strip()
    if tail and CREATE_RE.search(tail):  # model forgot the final '/'
        stmts.append(tail)
    return stmts


def object_name(stmt):
    m = CREATE_RE.search(stmt)
    return m.group(2).upper() if m else None


def object_names(stmts):
    return [n for n in (object_name(s) for s in stmts) if n]


def unique(seq):
    return list(dict.fromkeys(seq))


def group_by_object(stmts):
    """{OBJECT_NAME: [spec, body, ...]} in script order."""
    groups = {}
    for s in stmts:
        name = object_name(s)
        if name:
            groups.setdefault(name, []).append(s)
    return groups


def unit_key(stmt):
    """(OBJECT_NAME, 'PACKAGE BODY' / 'FUNCTION' / ...) for a CREATE statement."""
    m = CREATE_RE.search(stmt)
    return (m.group(2).upper(), re.sub(r"\s+", " ", m.group(1)).upper()) if m else None


def normalize(stmt):
    return re.sub(r"\s+", " ", stmt).strip().lower()


def as_script(stmts):
    return "\n/\n".join(stmts) + "\n/"


def read_script(path):
    return split_statements(path.read_text(encoding="utf-8")) if path.exists() else []


def load_task(task_dir):
    d = Path(task_dir).resolve()
    meta = {}
    if (d / "task.json").exists():
        meta = json.loads((d / "task.json").read_text(encoding="utf-8"))
    setup = read_script(d / "00_setup.sql")
    buggy = read_script(d / "01_buggy.sql")
    tests = read_script(d / "02_test.sql")
    if not buggy or not tests:
        sys.exit(f"{d.name}: 01_buggy.sql and 02_test.sql are required.")
    buggy_names = unique(object_names(buggy))
    tables = {}
    for s in setup:
        m = TABLE_RE.search(s)
        if m:
            tables[m.group(1).upper()] = s
    return {
        "id": meta.get("id", d.name),
        "dir": d,
        "setup": setup,
        "buggy": buggy,
        "tests": tests,
        "fixed": read_script(d / "03_fixed.sql"),
        "codebase": group_by_object(buggy),
        "tables": tables,
        "entry": meta.get("entry_object", buggy_names[0]).upper(),
        "buggy_objects": [n.upper() for n in meta.get("buggy_objects", buggy_names)],
        "bug_report": meta.get("bug_report", "The unit tests for this code fail."),
        "category": meta.get("category", "unknown"),
        "hops": meta.get("hops"),
        "suite": object_names(tests)[0],
    }


# --------------------------------------------------------------------------- database
def run_statements(conn, stmts):
    """Execute statements; return a list of error strings (empty = all compiled cleanly)."""
    errors = []
    with conn.cursor() as cur:
        for s in stmts:
            body = s if CREATE_RE.search(s) else s.rstrip().rstrip(";")
            try:
                cur.execute(body)
            except oracledb.DatabaseError as e:
                errors.append(str(e).strip().splitlines()[0])
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


compile_sql = run_statements  # backwards-compatible name


def reset_task(conn, task):
    """Recreate tables and compile the buggy code + tests. Returns error strings."""
    errs = run_statements(conn, task["setup"])
    errs += run_statements(conn, task["buggy"])
    errs += run_statements(conn, task["tests"])
    return errs


def run_tests(conn, suite):
    """Run a utPLSQL suite and capture its DBMS_OUTPUT report."""
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


def dependency_closure(conn, start, hops):
    """Objects reachable from `start` in USER_DEPENDENCIES: [(name, type, depth), ...]."""
    seen, frontier, found = {start}, [start], []
    with conn.cursor() as cur:
        for depth in range(1, hops + 1):
            nxt = []
            for name in frontier:
                cur.execute(
                    "select distinct referenced_name, referenced_type from user_dependencies "
                    "where name = :n and referenced_owner = user "
                    "and referenced_type in "
                    "('PACKAGE','FUNCTION','PROCEDURE','TYPE','TABLE','VIEW') "
                    "order by referenced_name", n=name)
                for ref, typ in cur.fetchall():
                    if ref not in seen:
                        seen.add(ref)
                        nxt.append(ref)
                        found.append((ref, typ, depth))
            frontier = nxt
    return found


# --------------------------------------------------------------------------- context
def build_context(conn, task, setting, hops):
    """Return (prompt_section_text, [object names shown])."""
    entry = task["entry"]
    parts = [f"Code of the object under test ({entry}):\n```sql\n"
             f"{as_script(task['codebase'][entry])}\n```"]
    shown = [entry]
    if setting == "graph":
        related = []
        for name, typ, depth in dependency_closure(conn, entry, hops):
            src = task["codebase"].get(name)
            code = as_script(src) if src else task["tables"].get(name)
            if not code:
                continue
            hop = "hop" if depth == 1 else "hops"
            related.append(f"-- {typ.lower()} {name} ({depth} {hop} from {entry})\n{code}")
            shown.append(name)
        if related:
            parts.append("Related objects from the Oracle dependency graph:\n```sql\n"
                         + "\n\n".join(related) + "\n```")
    return "\n\n".join(parts), shown


# --------------------------------------------------------------------------- model
def preflight():
    """Fail fast with a plain message if Ollama or Oracle is not running."""
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


def ask_model(model, messages, num_ctx, timeout, num_gpu=None, seed=42, temperature=0.0):
    options = {"temperature": temperature, "seed": seed, "num_ctx": num_ctx}
    if num_gpu is not None:
        options["num_gpu"] = num_gpu  # 0 = run fully on CPU
    try:
        r = requests.post(
            f"{OLLAMA_URL}/api/chat",
            json={"model": model, "messages": messages, "stream": False,
                  "think": False, "keep_alive": "30m", "options": options},
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
    """SQL inside ``` fences (all blocks joined), or the raw text if there are none."""
    blocks = re.findall(r"```(?:sql|plsql|oracle)?[ \t]*\r?\n(.*?)```", text, re.S | re.I)
    if not blocks:
        return text
    return "\n/\n".join(b.strip() for b in blocks)


# --------------------------------------------------------------------------- main loop
def run_task(task_dir, setting="none", model="gemma4:e4b", max_attempts=3, num_ctx=8192,
             timeout=300, num_gpu=None, hops=2, seed=42, temperature=0.0):
    preflight()
    task = load_task(task_dir)
    protected = set(object_names(task["tests"]))
    allowed = set(task["codebase"])

    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

    errs = reset_task(conn, task)
    if errs:
        sys.exit("Task setup failed:\n" + "\n".join(errs))
    baseline = run_tests(conn, task["suite"])
    if baseline["passed"]:
        sys.exit("Invalid task: tests already pass on the buggy code.")
    print(f"Task {task['id']} [{setting}]: baseline {baseline['tests']} tests, "
          f"{baseline['failed']} failed, {baseline['errored']} errored")

    context, shown = build_context(conn, task, setting, hops)
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": (
            f"Bug report:\n{task['bug_report']}\n\n{context}\n\n"
            f"Failing utPLSQL test output:\n```\n{baseline['report']}\n```\n\n"
            "Fix the bug so that all tests pass.")},
    ]

    # Current source of every unit in the database, to detect "fixes" that change nothing.
    current = {unit_key(s): normalize(s) for s in task["buggy"] if unit_key(s)}

    attempts, solved, final_edit, t0 = [], False, [], time.time()
    for i in range(1, max_attempts + 1):
        reply, stats = ask_model(model, messages, num_ctx, timeout, num_gpu, seed, temperature)
        candidate = split_statements(extract_code(reply))
        names = unique(object_names(candidate))
        cause = CAUSE_RE.search(reply)
        record = {"attempt": i, **stats, "edited_objects": names,
                  "cause": cause.group(1).strip() if cause else None,
                  "candidate": as_script(candidate) if candidate else reply}

        if not candidate:
            outcome, feedback = "no_code", (
                "Your reply did not contain a CREATE OR REPLACE statement. "
                "Return the complete corrected code in one ```sql block.")
        elif any(not PLSQL_START_RE.match(s) or not object_name(s) for s in candidate):
            outcome, feedback = "invalid_statement", (
                "Only CREATE OR REPLACE statements for PL/SQL objects are allowed "
                "(no DDL, DML or anonymous blocks).")
        elif protected & set(names):
            outcome, feedback = "touched_tests", (
                "Do not create or modify the test package. Fix only the application code.")
        elif set(names) - allowed:
            unknown = ", ".join(sorted(set(names) - allowed))
            outcome, feedback = "unknown_object", (
                f"These objects do not exist in the application: {unknown}. "
                "Only modify existing objects.")
        elif all(current.get(unit_key(s)) == normalize(s) for s in candidate):
            outcome, feedback = "unchanged", (
                "Your code is identical to the current code, so nothing changed and the tests "
                "fail exactly as before. Compare the expected and actual values in the test "
                "output, find the expression that produces the wrong value, and change it.")
        else:
            errs = run_statements(conn, candidate)
            for s in candidate:
                current[unit_key(s)] = normalize(s)
            if errs:
                outcome = "compile_error"
                record["compile_errors"] = errs
                feedback = ("Your code did not compile:\n```\n" + "\n".join(errs) +
                            "\n```\nReturn the complete corrected code.")
            else:
                res = run_tests(conn, task["suite"])
                record["tests"] = {k: res[k] for k in ("tests", "failed", "errored")}
                if res["passed"]:
                    outcome, solved, feedback, final_edit = "pass", True, None, names
                else:
                    outcome = "test_fail"
                    feedback = ("The tests still fail:\n```\n" + res["report"] +
                                "\n```\nReturn the complete corrected code.")

        record["outcome"] = outcome
        attempts.append(record)
        print(f"  attempt {i}: {outcome:<17} edited {','.join(names) or '-':<28} "
              f"({stats['seconds']}s, {stats['prompt_tokens']} in / "
              f"{stats['output_tokens']} out tokens)")
        if record["cause"]:
            print(f"             cause: {record['cause'][:110]}")
        if solved:
            break
        messages.append({"role": "assistant", "content": reply})
        messages.append({"role": "user", "content": feedback})

    conn.close()
    localized = bool(set(final_edit) & set(task["buggy_objects"])) if solved else None
    result = {
        "task": task["id"],
        "category": task["category"],
        "task_hops": task["hops"],
        "setting": setting,
        "graph_hops": hops if setting == "graph" else None,
        "model": model,
        "seed": seed,
        "temperature": temperature,
        "device": "cpu" if num_gpu == 0 else "gpu",
        "num_ctx": num_ctx,
        "max_attempts": max_attempts,
        "context_objects": shown,
        "buggy_objects": task["buggy_objects"],
        "buggy_object_in_context": bool(set(shown) & set(task["buggy_objects"])),
        "solved": solved,
        "attempts_used": len(attempts),
        "fixed_objects": final_edit,
        "localized": localized,
        "touched_buggy_object": any(set(a["edited_objects"]) & set(task["buggy_objects"])
                                    for a in attempts),
        "first_prompt_tokens": attempts[0]["prompt_tokens"] if attempts else None,
        "wall_seconds": round(time.time() - t0, 2),
        "timestamp": datetime.now().isoformat(timespec="seconds"),
        "baseline": {k: baseline[k] for k in ("tests", "failed", "errored")},
        "attempts": attempts,
    }

    out_dir = ROOT / "results" / task["id"]
    out_dir.mkdir(parents=True, exist_ok=True)
    safe_model = re.sub(r"[^\w.-]", "_", model)
    out_file = out_dir / f"{setting}_{safe_model}_s{seed}_{datetime.now():%Y%m%d_%H%M%S}.json"
    out_file.write_text(json.dumps(result, indent=2), encoding="utf-8")

    status = "SOLVED" if solved else "NOT SOLVED"
    where = "" if not solved else (" (right object)" if localized else " (WRONG object)")
    print(f"{status}{where} in {len(attempts)} attempt(s), {result['wall_seconds']}s. "
          f"Context: {', '.join(shown)}. Log: {out_file}")
    return result


def main():
    p = argparse.ArgumentParser(description="Run the PLSQL-Fix agent on one task.")
    p.add_argument("task_dir", help="e.g. tasks/t001_order_discount")
    p.add_argument("--setting", choices=SETTINGS, default="none")
    p.add_argument("--hops", type=int, default=2, help="dependency depth for --setting graph")
    p.add_argument("--model", default="gemma4:e4b")
    p.add_argument("--max-attempts", type=int, default=3)
    p.add_argument("--num-ctx", type=int, default=8192,
                   help="context window; Ollama's default (4096) is too small for larger tasks")
    p.add_argument("--timeout", type=int, default=300, help="seconds per model call")
    p.add_argument("--temperature", type=float, default=0.0,
                   help="0 = greedy; use e.g. 0.2 with different --seed values for repeat runs")
    p.add_argument("--seed", type=int, default=42, help="sampling seed (matters when temperature > 0)")
    p.add_argument("--cpu", action="store_true",
                   help="run the model fully on CPU (num_gpu=0), e.g. while the GPU is unstable")
    a = p.parse_args()
    result = run_task(a.task_dir, a.setting, a.model, a.max_attempts, a.num_ctx, a.timeout,
                      num_gpu=0 if a.cpu else None, hops=a.hops, seed=a.seed,
                      temperature=a.temperature)
    sys.exit(0 if result["solved"] else 1)


if __name__ == "__main__":
    main()
