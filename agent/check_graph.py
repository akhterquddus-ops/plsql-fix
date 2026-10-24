"""
For each task, does the dependency graph (graph v2, default 2 hops) reach the buggy object?
Run after `python agent/validate_task.py --all`, so every task's objects exist in the schema.

Usage (repo root):  python agent/check_graph.py [task_dir ...]
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracledb  # noqa: E402
from run_task import DB_DSN, DB_PASSWORD, DB_USER, ROOT, dependency_closure, load_task  # noqa: E402


def main():
    dirs = [Path(a) for a in sys.argv[1:]] or sorted(
        d for d in (ROOT / "tasks").iterdir() if (d / "01_buggy.sql").exists())
    conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    for d in dirs:
        t = load_task(d)
        targets = set(t["buggy_objects"]) - {t["entry"]}
        if not targets:
            continue
        found = {name: depth for name, _typ, depth in dependency_closure(conn, t["entry"], 2)}
        hit = sorted(targets & set(found))
        status = f"HIT at depth {found[hit[0]]}" if hit else "MISS"
        print(f"{t['id']:<24} {status:<15} reached: {', '.join(sorted(found))}")


if __name__ == "__main__":
    main()
