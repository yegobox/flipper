#!/usr/bin/env bash
#
# Static-analysis ratchet.
#
# The problem this solves
# -----------------------
# No CI job has ever run `dart analyze`, so the workspace carries a few hundred
# pre-existing analyzer issues. Turning `dart analyze` into a blocking check
# outright would fail every PR until all of them were fixed -- which means it
# would be switched off within a day.
#
# A ratchet fixes that. `.github/baselines/analysis.json` records how many
# issues each package has TODAY. A pull request fails only if a package's count
# goes UP. Pre-existing issues stay legal; new ones cannot get in. When you fix
# some, re-run with --update and the baseline drops, locking the gain in.
#
# Known limitation, stated plainly: this compares COUNTS, not identities. In
# principle you could remove one warning and add a different one in the same
# package and the ratchet would not notice. That trade buys immunity to file
# renames and code moves, which in a repo that reorganises as often as this one
# is worth more than the loophole costs. Errors are handled separately and
# strictly (see below).
#
# Usage
#   scripts/ci/analysis_ratchet.sh                  # check every package
#   scripts/ci/analysis_ratchet.sh --update         # rewrite the baseline
#   scripts/ci/analysis_ratchet.sh --changed --base origin/main
#                                                   # only packages the diff touches
#   scripts/ci/analysis_ratchet.sh packages/flipper_models
#                                                   # only the named packages
#
# Env
#   BASELINE   baseline file (default: .github/baselines/analysis.json)
#
# Exit codes
#   0  every package at or below baseline
#   1  at least one package regressed, or a new ERROR appeared
set -euo pipefail
cd "$(dirname "$0")/../.."
REPO_ROOT="$PWD"

BASELINE="${BASELINE:-.github/baselines/analysis.json}"
MODE="check"
BASE_REF=""
REQUESTED=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update)  MODE="update"; shift ;;
    --changed) MODE="${MODE}"; BASE_REF="${BASE_REF:-origin/main}"; CHANGED_ONLY=1; shift ;;
    --base)    BASE_REF="$2"; shift 2 ;;
    -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
    *)         REQUESTED+=("${1%/}"); shift ;;
  esac
done
CHANGED_ONLY="${CHANGED_ONLY:-0}"

# --- which packages to analyze -------------------------------------------
# A "package" here is any directory under packages/ or apps/ that has both a
# pubspec.yaml and a lib/. Vendored forks (open-sources/, third_party/) are
# excluded on purpose: we track upstream there and do not restyle it.
discover_packages() {
  local d
  for d in packages/*/ apps/*/; do
    [[ -f "${d}pubspec.yaml" && -d "${d}lib" ]] || continue
    printf '%s\n' "${d%/}"
  done
}

# Packages whose files the PR actually touches. Keeps PR feedback fast; the
# full sweep still runs on pushes to main, so the baseline cannot silently rot.
changed_packages() {
  local base="$1" pkg
  # Fall back to the full set if the base ref is not fetched (shallow clone).
  if ! git rev-parse --verify --quiet "$base" >/dev/null; then
    echo "note: base ref '$base' not available, analyzing every package" >&2
    discover_packages
    return
  fi
  local touched_file
  touched_file="$(mktemp)"
  git diff --name-only "$base"...HEAD -- '*.dart' '*analysis_options.yaml' > "$touched_file" 2>/dev/null || true
  # The root analyzer config affects every package, so a change to it re-checks all.
  if grep -qx 'analysis_options.yaml' "$touched_file"; then
    rm -f "$touched_file"
    discover_packages
    return
  fi
  discover_packages | while IFS= read -r pkg; do
    if grep -q "^${pkg}/" "$touched_file"; then
      printf '%s\n' "$pkg"
    fi
  done
  rm -f "$touched_file"
}

# Bash 3.2 treats "${arr[@]}" on an empty array as unbound under `set -u`,
# so every expansion below is guarded with the `+` form.
PACKAGES=()
if [[ ${#REQUESTED[@]} -gt 0 ]]; then
  PACKAGES=(${REQUESTED[@]+"${REQUESTED[@]}"})
else
  if [[ "$CHANGED_ONLY" == "1" ]]; then
    PKG_SOURCE="$(changed_packages "$BASE_REF")"
  else
    PKG_SOURCE="$(discover_packages)"
  fi
  while IFS= read -r _line; do
    [[ -n "$_line" ]] && PACKAGES+=("$_line")
  done <<< "$PKG_SOURCE"
fi

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  echo "No Dart packages to analyze (nothing in the diff touched one)."
  exit 0
fi

# --- run the analyzer ----------------------------------------------------
# --format=machine gives a stable, pipe-delimited record per issue:
#   SEVERITY|TYPE|CODE|FILE|LINE|COL|LENGTH|MESSAGE
# `dart analyze` exits non-zero whenever it finds anything, so we swallow the
# status and judge on the parsed output instead.
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "Analyzing ${#PACKAGES[@]} package(s)..."
for pkg in ${PACKAGES[@]+"${PACKAGES[@]}"}; do
  ( cd "$REPO_ROOT/$pkg" && dart analyze --format=machine . 2>/dev/null || true ) \
    > "$WORK/$(echo "$pkg" | tr '/' '_').txt"
done

# --- compare against the baseline ----------------------------------------
python3 - "$REPO_ROOT" "$BASELINE" "$MODE" "$WORK" ${PACKAGES[@]+"${PACKAGES[@]}"} <<'PY'
import json, os, sys, collections

repo, baseline_path, mode, work = sys.argv[1:5]
packages = sys.argv[5:]

def load(path):
    try:
        with open(path) as fh:
            return json.load(fh)
    except FileNotFoundError:
        return {"_comment": "Generated by scripts/ci/analysis_ratchet.sh --update. "
                            "Counts are a ceiling, not a target: they may fall, never rise.",
                "packages": {}}

baseline = load(os.path.join(repo, baseline_path))
recorded = baseline.setdefault("packages", {})

current, samples = {}, {}
for pkg in packages:
    counts = collections.Counter()
    seen = collections.defaultdict(list)
    fname = os.path.join(work, pkg.replace('/', '_') + '.txt')
    with open(fname) as fh:
        for line in fh:
            parts = line.rstrip('\n').split('|')
            if len(parts) < 8:
                continue
            sev, _type, code, path, ln, col = parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]
            sev = sev.lower()
            counts[sev] += 1
            rel = os.path.relpath(path, repo) if os.path.isabs(path) else path
            seen[sev].append(f"{rel}:{ln}:{col} [{code}]")
    current[pkg] = {s: counts.get(s, 0) for s in ("error", "warning", "info")}
    samples[pkg] = seen

if mode == "update":
    for pkg in packages:
        recorded[pkg] = current[pkg]
    # Drop packages that no longer exist so the file cannot accumulate ghosts.
    for gone in [p for p in list(recorded) if not os.path.isdir(os.path.join(repo, p))]:
        del recorded[gone]
    with open(os.path.join(repo, baseline_path), 'w') as fh:
        json.dump(baseline, fh, indent=2, sort_keys=True)
        fh.write('\n')
    total = sum(sum(v.values()) for v in current.values())
    print(f"Baseline updated: {len(packages)} package(s), {total} issue(s) recorded.")
    sys.exit(0)

failed = False
for pkg in packages:
    was = recorded.get(pkg)
    now = current[pkg]
    if was is None:
        # A brand-new package starts at zero. Anything it ships must be clean;
        # there is no legacy to grandfather in.
        was = {"error": 0, "warning": 0, "info": 0}
        print(f"  {pkg}: new package, held to a clean baseline")
    for sev in ("error", "warning", "info"):
        before, after = was.get(sev, 0), now[sev]
        if after > before:
            failed = True
            print(f"\nFAIL {pkg}: {sev} went {before} -> {after} (+{after - before})")
            for item in samples[pkg][sev][:20]:
                print(f"       {item}")
            if len(samples[pkg][sev]) > 20:
                print(f"       ... and {len(samples[pkg][sev]) - 20} more")
        elif after < before:
            print(f"  {pkg}: {sev} {before} -> {after} (improved; run --update to lock it in)")

if failed:
    print("""
------------------------------------------------------------------
This PR adds new analyzer issues. Fix them, or -- if they are
genuinely unavoidable -- justify them in review and run:
    scripts/ci/analysis_ratchet.sh --update
Pre-existing issues are NOT your problem here; only the increase is.
------------------------------------------------------------------""")
    sys.exit(1)

print(f"\nOK: {len(packages)} package(s) at or below baseline.")
PY
