"""
Summarize PLSQL-Fix result logs (results/<task>/*.json) into the paper's tables.

Metrics per group:
  runs          number of runs
  solved        tests pass after the agent's fix
  right_fix     solved AND the fix edited a ground-truth buggy object
  workaround    solved but only by editing other objects (tests pass, real bug remains)
  bug_in_ctx    the buggy object was shown to the model
  touched_bug   the model edited the buggy object in at least one attempt
  attempts      mean attempts used
  prompt_tok    mean prompt tokens of the first attempt (context size)
  seconds       mean wall time per run

Usage (repo root):
  python agent/summarize.py                     # runs that have a seed (pilot 3 onwards)
  python agent/summarize.py --temperature 0.2   # only runs at this temperature
  python agent/summarize.py --all               # include older runs without a seed
Writes results/summary.md and results/runs.csv as well as printing the tables.
"""
import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAIN_MODEL = "gemma4:e4b"  # other models get a suffix, e.g. graph@26b
SETTING_ORDER = ["none", "dense", "dense+noise", "hybrid", "hybrid+noise", "graph", "graph_h3",
                 "graph_h4", "hybrid_graph", "hybrid_graph+noise"]


def setting_label(d):
    """'graph' for the default depth (2); 'graph_h3' etc. for other depths."""
    s = d["setting"]
    hops = d.get("graph_hops")
    if s in ("graph", "hybrid_graph") and hops not in (None, 2):
        s = f"{s}_h{hops}"
    if d.get("corpus") == "tasks+utplsql":
        s += "+noise"
    model = d.get("model") or ""
    if model and model != MAIN_MODEL:
        s += "@" + model.split(":")[-1]          # e.g. graph@26b
    return s


def load_runs(include_all, temperature):
    runs = []
    for f in sorted((ROOT / "results").glob("*/*.json")):
        try:
            d = json.loads(f.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, UnicodeDecodeError):
            continue
        if "setting" not in d or "solved" not in d:
            continue
        if not include_all and "seed" not in d:
            continue
        if temperature is not None and d.get("temperature") != temperature:
            continue
        solved = bool(d["solved"])
        right = solved and bool(d.get("localized"))
        runs.append({
            "file": f.relative_to(ROOT).as_posix(),
            "task": d["task"],
            "category": d.get("category", "unknown"),
            "setting": setting_label(d),
            "model": d.get("model"),
            "device": d.get("device"),
            "seed": d.get("seed"),
            "temperature": d.get("temperature"),
            "solved": solved,
            "right_fix": right,
            "workaround": solved and not right,
            "bug_in_ctx": bool(d.get("buggy_object_in_context")),
            "touched_bug": bool(d.get("touched_buggy_object")),
            "attempts": d.get("attempts_used", 0),
            "prompt_tok": d.get("first_prompt_tokens") or 0,
            "seconds": d.get("wall_seconds", 0),
        })
    return runs


def aggregate(rows):
    n = len(rows)
    if not n:
        return None

    def pct(key):
        return 100.0 * sum(r[key] for r in rows) / n

    def mean(key):
        return sum(r[key] for r in rows) / n

    return {"runs": n, "solved": pct("solved"), "right_fix": pct("right_fix"),
            "workaround": pct("workaround"), "bug_in_ctx": pct("bug_in_ctx"),
            "touched_bug": pct("touched_bug"), "attempts": mean("attempts"),
            "prompt_tok": mean("prompt_tok"), "seconds": mean("seconds")}


def table(title, groups, key_names):
    cols = ["runs", "solved", "right_fix", "workaround", "bug_in_ctx", "touched_bug",
            "attempts", "prompt_tok", "seconds"]
    head = "| " + " | ".join(key_names + cols) + " |"
    sep = "|" + "|".join(["---"] * (len(key_names) + len(cols))) + "|"
    lines = [f"### {title}", "", head, sep]
    for key, rows in groups:
        a = aggregate(rows)
        if not a:
            continue
        cells = list(key) + [
            str(a["runs"]),
            f"{a['solved']:.0f}%", f"{a['right_fix']:.0f}%", f"{a['workaround']:.0f}%",
            f"{a['bug_in_ctx']:.0f}%", f"{a['touched_bug']:.0f}%",
            f"{a['attempts']:.2f}", f"{a['prompt_tok']:.0f}", f"{a['seconds']:.0f}"]
        lines.append("| " + " | ".join(cells) + " |")
    return "\n".join(lines) + "\n"


def sort_setting(s):
    """Main model first in the usual order; other models after, in the same order."""
    base, _, model = s.partition("@")
    i = SETTING_ORDER.index(base) if base in SETTING_ORDER else len(SETTING_ORDER)
    return (model, i)


def main():
    p = argparse.ArgumentParser(description="Summarize PLSQL-Fix results.")
    p.add_argument("--all", action="store_true", help="include runs logged without a seed")
    p.add_argument("--temperature", type=float, help="only runs at this temperature")
    a = p.parse_args()

    runs = load_runs(a.all, a.temperature)
    if not runs:
        raise SystemExit("No matching result logs found in results/.")

    by_setting, by_cat, by_task = defaultdict(list), defaultdict(list), defaultdict(list)
    for r in runs:
        by_setting[r["setting"]].append(r)
        by_cat[(r["category"], r["setting"])].append(r)
        by_task[(r["task"], r["setting"])].append(r)

    settings = sorted(by_setting, key=sort_setting)
    out = [f"# PLSQL-Fix results ({len(runs)} runs, "
           f"{len({r['task'] for r in runs})} tasks, "
           f"models: {', '.join(sorted({str(r['model']) for r in runs}))})\n",
           table("By setting", [((s,), by_setting[s]) for s in settings], ["setting"]),
           table("By bug location and setting",
                 [(k, by_cat[k]) for k in sorted(by_cat, key=lambda k: (k[0], sort_setting(k[1])))],
                 ["category", "setting"]),
           table("By task and setting",
                 [(k, by_task[k]) for k in sorted(by_task, key=lambda k: (k[0], sort_setting(k[1])))],
                 ["task", "setting"])]
    text = "\n".join(out)
    print(text)

    (ROOT / "results" / "summary.md").write_text(text, encoding="utf-8")
    with open(ROOT / "results" / "runs.csv", "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=list(runs[0]))
        w.writeheader()
        w.writerows(runs)
    print("Wrote results/summary.md and results/runs.csv")


if __name__ == "__main__":
    main()
