#!/usr/bin/env python3
"""Enforce the architectural rules that are currently only written down in prose.

Why this exists
---------------
`AGENTS.md`, `docs/` and the `.md` files at the repo root carry a large body of
hard-won rules -- things that cost real debugging time to learn. But prose does
not run in CI, so a rule can be written down and still regress. Commit
77b92324f is the proof: "updateCounters must NOT write Sar.sarNo" was known and
documented, and it regressed anyway.

Each rule below is one of those, turned into something the build can check.

    RULE 1  updateCounters must not write Sar.sarNo            [hard failure]
    RULE 2  LocalStorage writes must use an allow-listed key   [ratchet]
    RULE 3  Report/export builders should not use              [ratchet]
            ProxyService.strategy

"Hard failure" means the rule holds today with zero exceptions, so any
violation is new and is rejected outright. "Ratchet" means there are known
existing violations recorded in the baseline; the count may fall but never
rise.

Usage
    python3 scripts/ci/documented_rules_check.py
    python3 scripts/ci/documented_rules_check.py --update   # re-record baselines

Exit codes
    0  all rules satisfied (or no worse than baseline)
    1  a rule was broken, or a ratchet went the wrong way
"""
from __future__ import annotations

import json
import os
import re
import sys

REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
BASELINE_PATH = os.path.join(REPO, ".github", "baselines", "documented_rules.json")

SKIP_DIRS = ("/build/", "/.dart_tool/", "/.symlinks/", "/ephemeral/",
             "/open-sources/", "/third_party/", "/node_modules/")
GENERATED = (".g.dart", ".freezed.dart", ".mocks.dart", ".config.dart")


def dart_files(roots=("packages", "apps"), include_tests=True):
    for root in roots:
        root_abs = os.path.join(REPO, root)
        if not os.path.isdir(root_abs):
            continue
        for dirpath, dirnames, filenames in os.walk(root_abs):
            posix = "/" + os.path.relpath(dirpath, REPO).replace(os.sep, "/") + "/"
            if any(s in posix for s in SKIP_DIRS):
                dirnames[:] = []
                continue
            if not include_tests and "/test/" in posix:
                dirnames[:] = []
                continue
            for name in filenames:
                if name.endswith(".dart") and not name.endswith(GENERATED):
                    yield os.path.join(dirpath, name)


def rel(path):
    return os.path.relpath(path, REPO).replace(os.sep, "/")


def read(path):
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def strip_comments(text):
    """Remove // and /* */ comments so a rule is never matched inside one.

    The two counter mixins each carry a NOTE comment that literally says
    "Do NOT write Sar.sarNo here" -- without this, the rule would match its
    own documentation and fail permanently.
    """
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return re.sub(r"//[^\n]*", "", text)


# --------------------------------------------------------------- RULE 1
def rule_sarno():
    """`updateCounters` must not write Sar.sarNo.

    `sarNo` is the stock-movement counter. Sale receipts derive their own
    number from the invoice. Letting updateCounters advance sarNo desynchronises
    the RRA stock sequence from the invoice sequence, which RRA then rejects.
    Regressed once in 77b92324f; this is the guard that stops a third time.
    """
    offenders = []
    for path in dart_files(include_tests=False):
        if "counter" not in os.path.basename(path).lower():
            continue
        body = strip_comments(read(path))
        match = re.search(r"Future<void>\s+updateCounters\s*\(", body)
        if not match:
            continue
        # Walk braces from the method signature to find the exact method body,
        # so a sarNo write elsewhere in the same file is not misattributed.
        start = body.find("{", match.end())
        if start == -1:
            continue
        depth, end = 0, len(body)
        for i in range(start, len(body)):
            if body[i] == "{":
                depth += 1
            elif body[i] == "}":
                depth -= 1
                if depth == 0:
                    end = i
                    break
        method = body[start:end]
        for m in re.finditer(r"\bsarNo\s*[:=]", method):
            line = body[:start + m.start()].count("\n") + 1
            offenders.append(f"{rel(path)}:{line}")
    return offenders


# --------------------------------------------------------------- RULE 2
def rule_localstorage_keys():
    """Every LocalStorage key written must be in `_allowedKeys`.

    `LocalStorage.write*` checks the key against a static allow-list and
    SILENTLY does nothing when the key is absent -- no throw, no log. A typo or
    a newly invented key therefore looks like it saved and simply never
    persists. That failure is invisible until someone notices a setting not
    sticking, so it belongs in CI.
    """
    ls_path = os.path.join(REPO, "packages", "supabase_models", "lib", "brick",
                           "repository", "local_storage.dart")
    if not os.path.isfile(ls_path):
        return ["local_storage.dart not found -- rule cannot be checked"]
    src = read(ls_path)
    block = re.search(r"_allowedKeys\s*=\s*\{(.*?)\n  \};", src, re.S)
    if not block:
        return ["_allowedKeys set not found -- rule cannot be checked"]
    allowed = set(re.findall(r"'([^']+)'", block.group(1)))

    call = re.compile(r"\.(?:write(?:Int|String|Bool|Double)|remove)\(\s*key:\s*'([^']+)'")
    offenders = []
    for path in dart_files(include_tests=False):
        text = read(path)
        for m in call.finditer(text):
            key = m.group(1)
            # Interpolated keys ('business_${id}_uuid') are computed at runtime
            # and cannot be allow-listed statically.
            if "$" in key or key in allowed:
                continue
            line = text[:m.start()].count("\n") + 1
            offenders.append(f"{rel(path)}:{line} key={key!r}")
    return sorted(offenders)


# --------------------------------------------------------------- RULE 3
def rule_report_strategy():
    """Report and export builders should read through Strategy.capella.

    `ProxyService.strategy` resolves via the cloudSync default, which off-web
    is empty -- so a report built through it silently produces no rows rather
    than failing loudly. Report paths are expected to call
    `ProxyService.getStrategy(Strategy.capella)` explicitly.

    A ratchet rather than a hard rule: not every `ProxyService.strategy` call
    inside a report file is fetching report data (some just look up a business
    name), and deciding which is which needs a human. The count may not grow.
    """
    offenders = []
    for path in dart_files(include_tests=False):
        name = rel(path).lower()
        if not re.search(r"(report|export)", name):
            continue
        text = strip_comments(read(path))
        for m in re.finditer(r"ProxyService\s*\.\s*strategy\b", text):
            line = text[:m.start()].count("\n") + 1
            offenders.append(f"{rel(path)}:{line}")
    return sorted(offenders)


RULES = [
    ("sarno_in_update_counters", "updateCounters must not write Sar.sarNo",
     rule_sarno, "hard"),
    ("localstorage_unlisted_keys", "LocalStorage writes must use an allow-listed key",
     rule_localstorage_keys, "ratchet"),
    ("report_uses_default_strategy", "Report/export builders should use Strategy.capella",
     rule_report_strategy, "ratchet"),
]


def main():
    update = "--update" in sys.argv
    try:
        with open(BASELINE_PATH) as fh:
            baseline = json.load(fh)
    except FileNotFoundError:
        baseline = {}

    results, failed = {}, False
    for key, title, fn, kind in RULES:
        found = fn()
        results[key] = {"count": len(found), "known": found}
        was = baseline.get(key, {})
        before = was.get("count", 0 if kind == "hard" else None)

        if update:
            print(f"  {title}: {len(found)} occurrence(s) recorded")
            continue

        if kind == "hard":
            if found:
                failed = True
                print(f"FAIL [{key}] {title}")
                for item in found:
                    print(f"       {item}")
                print(f"       This rule has no known exceptions. Do not add one.")
            else:
                print(f"OK   [{key}] {title}")
        else:
            if before is None:
                before = len(found)
            if len(found) > before:
                failed = True
                print(f"FAIL [{key}] {title}: {before} -> {len(found)} (+{len(found) - before})")
                for item in sorted(set(found) - set(was.get("known", []))):
                    print(f"       new: {item}")
            elif len(found) < before:
                print(f"OK   [{key}] improved {before} -> {len(found)} "
                      f"(run --update to lock it in)")
            else:
                print(f"OK   [{key}] {title} (holding at {before} known)")

    if update:
        os.makedirs(os.path.dirname(BASELINE_PATH), exist_ok=True)
        results["_comment"] = (
            "Generated by scripts/ci/documented_rules_check.py --update. "
            "These are the KNOWN violations of rules documented in AGENTS.md and docs/. "
            "Counts are a ceiling: they may fall, never rise.")
        with open(BASELINE_PATH, "w") as fh:
            json.dump(results, fh, indent=2, sort_keys=True)
            fh.write("\n")
        print(f"\nBaseline written to {rel(BASELINE_PATH)}")
        return 0

    if failed:
        print("""
------------------------------------------------------------------
A rule that this repo learned the hard way has been broken. Each one
is documented in AGENTS.md or docs/ and cost real debugging time.
If the change is genuinely correct, say why in the PR and run:
    python3 scripts/ci/documented_rules_check.py --update
------------------------------------------------------------------""")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
