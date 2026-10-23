"""
Code retrieval for PLSQL-Fix: dense (bge-m3), BM25 and hybrid search.

Corpus: every PL/SQL object (spec + body as one document) and every table definition
from ALL tasks in tasks/ - i.e. one shared "application" of ~30+ objects. The search has
to find the relevant objects among unrelated ones (other tasks act as distractors),
while the graph setting follows real dependencies only.

Query: bug report + failing test output + source of the entry object.
The entry object itself is never returned (it is always shown separately).

Dense embeddings run on CPU (sentence-transformers) and are cached in .cache/ by the
SHA-1 of each document, so the corpus is embedded only once.

Override the model with PLSQLFIX_EMBED_MODEL (a Hugging Face name or a local folder).
"""
import hashlib
import json
import math
import os
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CACHE_DIR = ROOT / ".cache"
EMBED_MODEL = os.getenv("PLSQLFIX_EMBED_MODEL", "BAAI/bge-m3")
MAX_SEQ_LEN = 1024  # chunks are small; keeps CPU encoding fast


# --------------------------------------------------------------------------- corpus
DISTRACTOR_DIR = ROOT / "utPLSQL" / "source"
DISTRACTOR_EXT = {".pks", ".pkb", ".tps", ".tpb", ".trg"}
DISTRACTOR_MAX_CHARS = 3000


def distractor_docs(seen):
    """Real open-source PL/SQL (utPLSQL, Apache 2.0) as realistic search distractors.

    Spec + body files of one object are joined into one document; the licence header
    comment is removed (identical in every file) and each document is capped.
    """
    if not DISTRACTOR_DIR.exists():
        raise SystemExit(f"Distractor source not found: {DISTRACTOR_DIR}. "
                         "Run scripts/setup_oracle.ps1 once to download utPLSQL.")
    groups = {}
    for f in sorted(DISTRACTOR_DIR.rglob("*")):
        if f.suffix.lower() in DISTRACTOR_EXT:
            groups.setdefault(f.stem.upper(), []).append(f)
    docs = []
    for name, files in sorted(groups.items()):
        if name in seen:
            continue
        parts = []
        for f in sorted(files, key=lambda x: x.suffix not in (".pks", ".tps")):  # spec first
            text = f.read_text(encoding="utf-8", errors="replace")
            text = re.sub(r"/\*.*?Licensed under the Apache License.*?\*/", "", text,
                          count=1, flags=re.S)
            parts.append(text.strip())
        text = "\n\n".join(parts)
        if len(text) > DISTRACTOR_MAX_CHARS:
            text = text[:DISTRACTOR_MAX_CHARS] + "\n-- (truncated)"
        seen.add(name)
        docs.append({"name": name, "kind": "code", "task": "utplsql", "text": text})
    return docs


def build_corpus(load_task, as_script, distractors=False):
    """[{name, kind, task, text}] for all objects and tables of all tasks
    (+ utPLSQL objects as distractors when `distractors` is True)."""
    docs, seen = [], set()
    for d in sorted((ROOT / "tasks").iterdir()):
        if not (d / "01_buggy.sql").exists():
            continue
        t = load_task(d)
        for name, stmts in t["codebase"].items():
            if name not in seen:
                seen.add(name)
                docs.append({"name": name, "kind": "code", "task": t["id"],
                             "text": as_script(stmts)})
        for name, ddl in t["tables"].items():
            if name not in seen:
                seen.add(name)
                docs.append({"name": name, "kind": "table", "task": t["id"],
                             "text": ddl})
    if distractors:
        docs += distractor_docs(seen)
    return docs


# --------------------------------------------------------------------------- BM25
def tokenize(text):
    """Lower-case word tokens; identifiers like t004_util also yield 't004', 'util'."""
    out = []
    for tok in re.findall(r"[a-z0-9_]+", text.lower()):
        out.append(tok)
        if "_" in tok:
            out.extend(p for p in tok.split("_") if p)
    return out


class BM25:
    def __init__(self, texts, k1=1.5, b=0.75):
        self.k1, self.b = k1, b
        self.docs = [Counter(tokenize(t)) for t in texts]
        self.lens = [sum(c.values()) for c in self.docs]
        self.avg = sum(self.lens) / max(len(self.lens), 1)
        df = Counter()
        for c in self.docs:
            df.update(c.keys())
        n = len(self.docs)
        self.idf = {w: math.log(1 + (n - f + 0.5) / (f + 0.5)) for w, f in df.items()}

    def scores(self, query):
        q = tokenize(query)
        out = []
        for c, length in zip(self.docs, self.lens):
            s = 0.0
            for w in q:
                f = c.get(w)
                if f:
                    s += self.idf[w] * f * (self.k1 + 1) / (
                        f + self.k1 * (1 - self.b + self.b * length / self.avg))
            out.append(s)
        return out


# --------------------------------------------------------------------------- dense
class DenseEncoder:
    """bge-m3 via sentence-transformers on CPU, with an on-disk embedding cache."""

    def __init__(self, model_name=EMBED_MODEL):
        self.model_name = model_name
        self._model = None
        safe = re.sub(r"[^\w.-]", "_", model_name)
        self.cache_file = CACHE_DIR / f"embeddings_{safe}.json"
        try:
            self.cache = json.loads(self.cache_file.read_text(encoding="utf-8"))
        except (FileNotFoundError, json.JSONDecodeError):
            self.cache = {}

    def _load(self):
        if self._model is None:
            from sentence_transformers import SentenceTransformer
            self._model = SentenceTransformer(self.model_name, device="cpu")
            self._model.max_seq_length = MAX_SEQ_LEN
        return self._model

    def encode(self, texts, use_cache=True):
        keys = [hashlib.sha1(t.encode("utf-8")).hexdigest() for t in texts]
        missing = [i for i, k in enumerate(keys) if not (use_cache and k in self.cache)]
        if missing:
            vecs = self._load().encode([texts[i] for i in missing],
                                       normalize_embeddings=True, batch_size=8)
            for i, v in zip(missing, vecs):
                self.cache[keys[i]] = [float(x) for x in v]
            if use_cache:
                CACHE_DIR.mkdir(exist_ok=True)
                self.cache_file.write_text(json.dumps(self.cache), encoding="utf-8")
        return [self.cache[k] for k in keys]

    def scores(self, query, texts):
        q = self.encode([query], use_cache=False)[0]
        return [sum(a * b for a, b in zip(q, d)) for d in self.encode(texts)]


# --------------------------------------------------------------------------- search
def _minmax(xs):
    lo, hi = min(xs), max(xs)
    return [0.0 if hi == lo else (x - lo) / (hi - lo) for x in xs]


def search(docs, query, method, k=4, alpha=0.7, exclude=(), encoder=None):
    """Top-k documents for `query`. method: 'dense', 'bm25' or 'hybrid'.

    hybrid score = alpha * dense + (1 - alpha) * bm25, each min-max normalised.
    Returns [{name, kind, task, text, score}] best first.
    """
    pool = [d for d in docs if d["name"] not in set(exclude)]
    if not pool:
        return []
    texts = [d["text"] for d in pool]
    if method in ("dense", "hybrid"):
        encoder = encoder or DenseEncoder()
        dense = encoder.scores(query, texts)
    if method in ("bm25", "hybrid"):
        lexical = BM25(texts).scores(query)
    if method == "dense":
        final = dense
    elif method == "bm25":
        final = lexical
    elif method == "hybrid":
        final = [alpha * a + (1 - alpha) * b
                 for a, b in zip(_minmax(dense), _minmax(lexical))]
    else:
        raise ValueError(f"unknown retrieval method: {method}")
    ranked = sorted(zip(final, range(len(pool))), key=lambda x: -x[0])[:k]
    return [{**pool[i], "score": round(s, 4)} for s, i in ranked]


# --------------------------------------------------------------------------- self-check
def main():
    """Warm the embedding cache and report recall@k of the buggy object per method.

    Query here = bug report + entry object source (no test output, since that needs
    Oracle); the agent's real query also includes the failing test output.
    """
    import argparse
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    from run_task import load_task, as_script

    p = argparse.ArgumentParser(description="Check code search on all tasks.")
    p.add_argument("--k", type=int, default=4)
    p.add_argument("--alpha", type=float, default=0.7)
    p.add_argument("--methods", default="bm25,dense,hybrid")
    p.add_argument("--distractors", action="store_true",
                   help="add utPLSQL source objects to the corpus")
    a = p.parse_args()

    docs = build_corpus(load_task, as_script, distractors=a.distractors)
    print(f"Corpus: {len(docs)} documents "
          f"({sum(d['kind'] == 'code' for d in docs)} objects, "
          f"{sum(d['kind'] == 'table' for d in docs)} tables). Model: {EMBED_MODEL}")
    methods = a.methods.split(",")
    encoder = DenseEncoder() if {"dense", "hybrid"} & set(methods) else None
    if encoder:
        print("Embedding the corpus (first run downloads/loads the model, ~1-3 min on CPU)...")
        encoder.encode([d["text"] for d in docs])

    found = {m: 0 for m in methods}
    cross = [t for t in sorted((ROOT / "tasks").iterdir()) if (t / "01_buggy.sql").exists()]
    n = 0
    for d in cross:
        t = load_task(d)
        targets = set(t["buggy_objects"]) - {t["entry"]}
        if not targets:
            continue  # local bug: the entry object is always shown anyway
        n += 1
        query = f"{t['bug_report']}\n{as_script(t['codebase'][t['entry']])}"
        line = [f"{t['id']:<22}"]
        for m in methods:
            hits = search(docs, query, m, k=a.k, alpha=a.alpha, exclude=[t["entry"]],
                          encoder=encoder)
            names = [h["name"] for h in hits]
            ok = bool(targets & set(names))
            found[m] += ok
            line.append(f"{m}:{'HIT ' if ok else 'miss'} {','.join(names)}")
        print("  " + " | ".join(line))
    print(f"\nRecall@{a.k} of the buggy object on {n} cross-object tasks:")
    for m in methods:
        print(f"  {m:<7} {found[m]}/{n}")


if __name__ == "__main__":
    main()
