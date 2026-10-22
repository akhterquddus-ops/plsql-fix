"""
Check that benchmark tasks are valid before running the agent on them.

For each task:
  - 00_setup.sql, 01_buggy.sql and 02_test.sql run/compile without errors
  - the tests FAIL on 01_buggy.sql
  - the tests PASS after applying 03_fixed.sql
  - 03_fixed.sql only changes objects listed in task.json "buggy_objects"
  - entry_object and buggy_objects exist in 01_buggy.sql
  - 01_buggy.sql has no comments that give the answer away (bug / fix / todo ...)
The task is left in its buggy state afterwards.

Usage (repo root):
  python agent/validate_task.py tasks/t001_order_discount
  python agent/validate_task.py --all
"""
import argparse
import re
import sys
from pathlib import Path

import oracledb

from run_task import (ROOT, DB_USER, DB_PASSWORD, DB_DSN, load_task, object_names,
                      reset_task, run_statements, run_tests)

HINT_RE = re.compile(r"--.*\b(bug|bugs|buggy|fix|fixed|todo|hack|wrong|broken)\b", re.I)


def summary(res):
    if res["tests"] is None:
        return "no test summary"
    return f"{res['tests']} tests, {res['failed']} failed, {res['errored']} errored"


def validate(conn, task):
    problems = []
    if task["entry"] not in task["codebase"]:
        problems.append(f"entry_object {task['entry']} not found in 01_buggy.sql")
    missing = set(task["buggy_objects"]) - set(task["codebase"])
    if missing:
        problems.append(f"buggy_objects not found in 01_buggy.sql: {sorted(missing)}")
    text = (task["dir"] / "01_buggy.sql").read_text(encoding="utf-8")
    for n, line in enumerate(text.splitlines(), 1):
        if HINT_RE.search(line):
            problems.append(f"possible hint in 01_buggy.sql line {n}: {line.strip()}")

    errs = reset_task(conn, task)
    if errs:
        return problems + ["setup/compile error: " + e for e in errs], None, None

    before = run_tests(conn, task["suite"])
    if before["tests"] is None:
        problems.append("buggy run produced no utPLSQL summary:\n" + before["report"][:500])
    elif before["passed"]:
        problems.append("tests already PASS on the buggy code")

    after = None
    if not task["fixed"]:
        problems.append("03_fixed.sql is missing or empty")
    else:
        extra = set(object_names(task["fixed"])) - set(task["buggy_objects"])
        if extra:
            problems.append(f"03_fixed.sql changes objects not in buggy_objects: {sorted(extra)}")
        errs = run_statements(conn, task["fixed"])
        if errs:
            problems += ["03_fixed.sql compile error: " + e for e in errs]
        else:
            after = run_tests(conn, task["suite"])
            if not after["passed"]:
                problems.append("tests still FAIL with 03_fixed.sql:\n" + after["report"])

    reset_task(conn, task)  # leave the task in its buggy state
    return problems, before, after


def main():
    p = argparse.ArgumentParser(description="Validate PLSQL-Fix tasks.")
    p.add_argument("task_dirs", nargs="*", help="task folders")
    p.add_argument("--all", action="store_true", help="validate every folder in tasks/")
    a = p.parse_args()

    dirs = [Path(d) for d in a.task_dirs]
    if a.all:
        dirs = sorted(d for d in (ROOT / "tasks").iterdir() if (d / "01_buggy.sql").exists())
    if not dirs:
        p.error("give task folders or --all")

    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    bad = 0
    for d in dirs:
        task = load_task(d)
        problems, before, after = validate(conn, task)
        b = summary(before) if before else "-"
        f = summary(after) if after else "-"
        status = "OK  " if not problems else "FAIL"
        print(f"{status} {task['id']:<24} buggy: {b:<32} fixed: {f}")
        for prob in problems:
            print("     - " + prob.replace("\n", "\n       "))
        bad += bool(problems)
    conn.close()
    print(f"\n{len(dirs) - bad}/{len(dirs)} tasks valid.")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
