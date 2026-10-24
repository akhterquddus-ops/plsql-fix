# PLSQL-Fix

**A benchmark of PL/SQL bug-fix tasks for local coding agents, and a study of whether Oracle's own
dependency graph helps a small Gemma 4 model fix bugs that live outside the code a failing test calls.**

Entry for the Kaggle competition *Google – The Gemma 4 Developer Agent Paper Track*.

## Headline results

Gemma 4 E4B (`gemma4:e4b` via Ollama), 3 seeds per task and setting, temperature 0.2.
Cross-object tasks: the bug is 1–3 objects away from the entry object (17 tasks × 3 seeds = 51 runs per setting).

| Context setting | Right fix | Workaround | Bug in context | Prompt tokens |
|---|---|---|---|---|
| none (entry object only) | 0% | 37% | 0% | 779 |
| dense search (bge-m3) | 63% | 12% | 86% | 1,591 |
| hybrid search (0.7 dense + 0.3 BM25) | 71% | 12% | 88% | 1,565 |
| **dependency graph** (USER_DEPENDENCIES, 2 hops) | 69% | 12% | 94% | **1,144** |
| hybrid + graph | **76%** | **6%** | **100%** | 2,133 |

* **Right fix** = all tests pass **and** the agent edited the ground-truth buggy object.
* **Workaround** = tests pass, but only other objects were changed, so the real bug remains.
* Every retrieval setting beats none (exact McNemar, p < 0.0001). The graph matches dense and
  hybrid search (p = 0.51 and 1.0) with about 28% fewer prompt tokens and no embedding model.

**Larger model.** Gemma 4 26B (MoE, run on Kaggle T4 GPUs) on the 9 hidden-dependency tasks,
27 runs per setting: right fix none 4%, dense 70%, hybrid 89%, graph 89% (no workarounds),
hybrid + graph 100%. A bigger model uses context better but still needs it.

All tables can be rebuilt from the run logs with [`notebooks/plsql_fix_results.ipynb`](notebooks/plsql_fix_results.ipynb)
(no database needed).

## What is in the repository

| Path | Contents |
|---|---|
| `tasks/` | 22 tasks: `demo_leap_year` and `t001`–`t021` (5 local, 17 cross-object) |
| `agent/run_task.py` | the agent loop: context setting → Gemma 4 → compile → utPLSQL tests, up to 3 attempts |
| `agent/retrieval.py` | dense (bge-m3), BM25 and hybrid code search; `--distractors` adds utPLSQL source as noise |
| `agent/validate_task.py` | checks every task: buggy code fails, reference fix passes, fix touches only the buggy objects |
| `agent/summarize.py` | builds `results/summary.md` and `results/runs.csv` from the JSON logs |
| `results/` | one JSON log per run (setting, model, seed, device, context shown, every attempt and its test output) |
| `notebooks/` | analysis notebook and Figure 1 |
| `scripts/setup_oracle.ps1` | one-command setup: Oracle Database Free in Docker + utPLSQL + demo check |

### Task format

Each task is a folder:

| File | Purpose |
|---|---|
| `task.json` | id, title, bug report, entry object, ground-truth `buggy_objects`, category, hops, bug kind, dependency kind |
| `00_setup.sql` | tables and data (only in tasks that need tables) |
| `01_buggy.sql` | the application code, containing one bug |
| `02_test.sql` | utPLSQL test package (fails on the buggy code) |
| `03_fixed.sql` | reference fix (all tests pass) |
| `run_tests.sql` | runs the suite |

The 9 tasks `t012`–`t021` (except the local control `t020`) hide the dependency from the entry code:
the bug is in a DML trigger, a view, a synonym, or a package the entry object does not name.

All task code is self-written for this benchmark. utPLSQL source (Apache-2.0) is used only as optional
search distractors and is downloaded by the setup script, not stored here.

## Reproduce

Requirements: Windows with Docker Desktop (WSL2), Python 3.10+, [Ollama](https://ollama.com).

```powershell
# 1. Oracle Database Free + utPLSQL (prints SETUP OK at the end)
powershell -ExecutionPolicy Bypass -File .\scripts\setup_oracle.ps1

# 2. Python packages and the model
pip install -r requirements.txt
ollama pull gemma4:e4b

# 3. Check all tasks (buggy fails, fix passes)
python agent\validate_task.py --all

# 4. One run, exactly as in the paper
python agent\run_task.py tasks\t012_scholarship_fee --setting graph --temperature 0.2 --seed 1 --cpu

# 5. Rebuild the tables
python agent\summarize.py --temperature 0.2
```

Settings: `none`, `dense`, `hybrid`, `graph`, `hybrid_graph`. Graph depth: `--hops` (default 2).
The first `dense`/`hybrid` run downloads BAAI/bge-m3 (about 2 GB) and caches embeddings in `.cache/`.

Database connection defaults (local demo values, see the setup script) can be overridden with
`PLSQLFIX_DB_USER`, `PLSQLFIX_DB_PASSWORD`, `PLSQLFIX_DB_DSN`; the Ollama address with `OLLAMA_URL`.

## Licences of what is used

Oracle Database Free (free to use), utPLSQL (Apache-2.0), Ollama (MIT), Gemma 4 (Gemma terms of use),
BAAI/bge-m3 (MIT). The tasks and code in this repository are the author's own work.
