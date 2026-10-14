#!/usr/bin/env bash
#
# Fold every open pull request onto the current checkout, for the internal
# preview build (.github/workflows/android_preview.yml).
#
# The Play internal track holds one build at a time, so uploading each branch
# separately only ever shows testers the branch that pushed last. Instead every
# upload is "main + all open PRs": checkout origin/main, then merge each open,
# non-draft, non-parked PR's head in number order. A PR that conflicts is
# skipped (merge aborted) and the fold carries on. Stacked PRs fold cleanly:
# a child already contains its parent's commits.
#
# Nothing is pushed: the merges are local commits on a detached HEAD.
#
# Usage
#   scripts/ci/fold_open_prs.sh [--prs-json FILE] [--notes FILE] [--summary FILE]
#
#   --prs-json  `gh pr list --json number,headRefName,isDraft,title` output to
#               use instead of calling gh (tests).
#   --notes     write short release notes (Play allows 500 characters).
#   --summary   append a markdown table (e.g. $GITHUB_STEP_SUMMARY).
#
# Parked PRs are listed in scripts/ci/preview_parked.txt, one number per line.

set -euo pipefail

PRS_JSON=""
NOTES=""
SUMMARY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --prs-json) PRS_JSON="$2"; shift 2 ;;
    --notes) NOTES="$2"; shift 2 ;;
    --summary) SUMMARY="$2"; shift 2 ;;
    -h|--help) sed -n '2,24p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

HERE="$(cd "$(dirname "$0")" && pwd)"
PARKED_FILE="$HERE/preview_parked.txt"

parked() { # parked <number>
  [ -f "$PARKED_FILE" ] || return 1
  grep -Eq "^[[:space:]]*#?$1([[:space:]]|$)" "$PARKED_FILE"
}

if [ -n "$PRS_JSON" ]; then
  prs="$(cat "$PRS_JSON")"
else
  prs="$(gh pr list --state open --limit 200 --json number,headRefName,isDraft,title)"
fi

rows="$(printf '%s' "$prs" | jq -r 'sort_by(.number)[] |
  [.number, .headRefName, (if .isDraft then "draft" else "ready" end), .title] | @tsv')"

base_sha="$(git rev-parse --short HEAD)"
folded=""
skipped=""
table=""

while IFS="$(printf '\t')" read -r num head state title; do
  [ -n "$num" ] || continue
  reason=""
  if [ "$state" = draft ]; then
    reason="draft"
  elif parked "$num"; then
    reason="parked"
  elif ! git rev-parse --verify --quiet "origin/$head" >/dev/null; then
    reason="branch not on origin"
  elif ! git -c user.name="Flipper preview" -c user.email="info@yegobox.com" \
      merge --no-ff --no-edit -m "preview: fold #$num $head" \
      "origin/$head" >/dev/null 2>&1; then
    git merge --abort >/dev/null 2>&1 || git reset --hard --quiet HEAD
    reason="conflict"
  fi

  if [ -z "$reason" ]; then
    folded="$folded #$num"
    table="$table| #$num | \`$head\` | folded | $title |\n"
    echo "folded  #$num $head"
  else
    skipped="$skipped #$num ($reason)"
    table="$table| #$num | \`$head\` | skipped: $reason | $title |\n"
    echo "skipped #$num $head ($reason)"
  fi
done <<EOF
$rows
EOF

# Submodule pins can differ between PRs; build what the folded tree says.
git submodule update --init --recursive --quiet 2>/dev/null || true

if [ -n "$NOTES" ]; then
  {
    echo "Preview: main $base_sha + open PRs"
    echo "In:${folded:- none}"
    [ -n "$skipped" ] && echo "Skipped:$skipped"
  } | cut -c1-500 | head -c 500 >"$NOTES"
fi

if [ -n "$SUMMARY" ]; then
  {
    echo "### Preview build: \`main\` $base_sha + open PRs"
    echo
    echo "| PR | Branch | Result | Title |"
    echo "|---|---|---|---|"
    printf '%b' "$table"
  } >>"$SUMMARY"
fi
