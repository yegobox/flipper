#!/usr/bin/env bash
#
# Formatting gate, scoped to what the pull request actually changed.
#
# Why not `dart format .` over the repo? Because the repo has never had a
# formatting gate, so a repo-wide reformat would rewrite thousands of files at
# once. That would collide with every branch in flight and bury real changes
# under whitespace in `git blame`.
#
# Instead: a file you touched must be formatted. Files you did not touch are
# left exactly as they are. The repo converges on `dart format` one PR at a
# time, at zero risk, and `git blame` stays readable.
#
# Usage
#   scripts/ci/format_changed.sh                    # against origin/main
#   scripts/ci/format_changed.sh --base origin/dev
#   scripts/ci/format_changed.sh --fix              # format them in place
#
# Exit codes
#   0  every changed Dart file is formatted (or there were none)
#   1  at least one changed Dart file needs formatting
set -euo pipefail
cd "$(dirname "$0")/../.."

BASE="origin/main"
FIX=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --fix)  FIX=1; shift ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
  echo "Base ref '$BASE' is not available; skipping the formatting gate."
  echo "(In CI this means the checkout was too shallow -- use fetch-depth: 0.)"
  exit 0
fi

# Added/copied/modified/renamed only -- a deleted file has nothing to format.
# Read into an array with a portable loop: macOS ships bash 3.2, which has no
# `mapfile`, and this must behave the same locally and on ubuntu-latest.
CHANGED_LIST="$(
  git diff --name-only --diff-filter=ACMR "$BASE"...HEAD -- '*.dart' \
  | grep -v -E '\.(g|freezed|mocks|config)\.dart$' \
  | grep -v -E '(^|/)(build|\.dart_tool|\.symlinks|ephemeral|open-sources|third_party|node_modules)/' \
  | grep -v -E '(^|/)app\.(router|locator|dialogs|bottomsheets)\.dart$' \
  | grep -v -E '/l10n/' \
  || true
)"

# Files can vanish between the diff and now (e.g. a rebase); keep only what exists.
FILES=()
while IFS= read -r f; do
  [[ -n "$f" && -f "$f" ]] && FILES+=("$f")
done <<< "$CHANGED_LIST"

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No hand-written Dart files changed against $BASE -- nothing to format."
  exit 0
fi

echo "Checking formatting of ${#FILES[@]} changed Dart file(s) against $BASE..."

if [[ "$FIX" == "1" ]]; then
  dart format ${FILES[@]+"${FILES[@]}"}
  echo "Formatted in place. Review and commit the result."
  exit 0
fi

if dart format --output=none --set-exit-if-changed ${FILES[@]+"${FILES[@]}"}; then
  echo "OK: every changed Dart file is formatted."
  exit 0
fi

cat <<'MSG'

------------------------------------------------------------------
The files listed above are ones this PR changed, and they are not
formatted. Fix with:
    scripts/ci/format_changed.sh --fix
Only files you touched are checked; the rest of the repo is left alone.
------------------------------------------------------------------
MSG
exit 1
