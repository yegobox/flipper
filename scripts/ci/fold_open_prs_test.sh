#!/usr/bin/env bash
# Tests for fold_open_prs.sh against a scratch repository. Run directly.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

git init -q --bare "$TMP/origin.git"
git clone -q "$TMP/origin.git" "$TMP/work" 2>/dev/null
cd "$TMP/work"
git config user.name t; git config user.email t@t
commit() { echo "$2" >"$1"; git add "$1"; git commit -qm "$3"; }

commit app.txt base "base"; git branch -M main; git push -q origin main
git switch -qc feat/a; commit a.txt a "a"; git push -q origin feat/a
git switch -q main; git switch -qc feat/stack; commit a.txt a "a"; commit b.txt b "b"; git push -q origin feat/stack
git switch -q main; git switch -qc fix/clash; commit app.txt clash "clash"; git push -q origin fix/clash
git switch -q main; git switch -qc feat/draft; commit d.txt d "d"; git push -q origin feat/draft
git switch -q main; git switch -qc ci/parked; commit p.txt p "p"; git push -q origin ci/parked
git switch -q main; git switch -qc feat/strings; commit strings.txt feature "new string"; git push -q origin feat/strings
git switch -q main; git switch -qc l10n_translations; commit strings.txt crowdin "crowdin rewrite"; git push -q origin l10n_translations
git switch -q main; commit app.txt main2 "main moves on"; git push -q origin main

cat >"$TMP/prs.json" <<JSON
[
  {"number": 5, "headRefName": "fix/clash",  "isDraft": false, "title": "Clash"},
  {"number": 2, "headRefName": "feat/a",     "isDraft": false, "title": "A"},
  {"number": 3, "headRefName": "feat/stack", "isDraft": false, "title": "Stack on A"},
  {"number": 6, "headRefName": "feat/draft", "isDraft": true,  "title": "Draft"},
  {"number": 668, "headRefName": "ci/parked", "isDraft": false, "title": "Parked"},
  {"number": 9, "headRefName": "gone",       "isDraft": false, "title": "Fork"},
  {"number": 1, "headRefName": "l10n_translations", "isDraft": false, "title": "New translations"},
  {"number": 7, "headRefName": "feat/strings", "isDraft": false, "title": "Adds a string"}
]
JSON

git fetch -q origin
git checkout -q --detach origin/main
"$HERE/fold_open_prs.sh" --prs-json "$TMP/prs.json" \
  --notes "$TMP/notes.txt" --summary "$TMP/summary.md" >"$TMP/out.txt"

[ -f a.txt ] && [ -f b.txt ] || fail "#2 and #3 should be folded"
[ "$(cat app.txt)" = main2 ] || fail "conflicting #5 must leave main's app.txt"
[ ! -f d.txt ] || fail "draft #6 must not be folded"
[ ! -f p.txt ] || fail "parked #668 must not be folded"
[ -z "$(git status --porcelain)" ] || fail "tree must be clean after a skipped conflict"
[ "$(cat strings.txt)" = feature ] || fail "feature #7 must win over the lower-numbered bot #1"
grep -q "In: #2 #3 #7" "$TMP/notes.txt" || fail "notes: $(cat "$TMP/notes.txt")"
grep -q "#1 (conflict)" "$TMP/notes.txt" || fail "bot #1 should fold last and be the one skipped"
grep -q "#5 (conflict)" "$TMP/notes.txt" || fail "notes miss the conflict"
grep -q "#6 (draft)" "$TMP/notes.txt" || fail "notes miss the draft"
grep -q "#668 (parked)" "$TMP/notes.txt" || fail "notes miss the parked PR"
grep -q "#9 (branch not on origin)" "$TMP/notes.txt" || fail "notes miss the fork PR"
[ "$(wc -c <"$TMP/notes.txt")" -le 500 ] || fail "notes over Play's 500 characters"
grep -q "| #5 | \`fix/clash\` | skipped: conflict |" "$TMP/summary.md" || fail "summary row for #5"
[ "$(git log --oneline origin/main..HEAD --merges | wc -l | tr -d ' ')" = 3 ] || fail "expected three fold merges"

# Pinned heads (headRefOid): a build job folds the commit the plan saw, even
# after the branch moved on, so every platform builds the same tree.
pinned="$(git rev-parse origin/feat/a)"
git switch -q -c feat/a-moved origin/feat/a; commit late.txt late "pushed after the plan"
git push -q origin HEAD:feat/a; git fetch -q origin
cat >"$TMP/pinned.json" <<JSON
[
  {"number": 2, "headRefName": "feat/a", "headRefOid": "$pinned", "isDraft": false, "title": "A"},
  {"number": 4, "headRefName": "feat/x", "headRefOid": "0123456789abcdef0123456789abcdef01234567", "isDraft": false, "title": "Force-pushed"}
]
JSON
git checkout -q --detach origin/main
"$HERE/fold_open_prs.sh" --prs-json "$TMP/pinned.json" --notes "$TMP/pinned-notes.txt" >/dev/null
[ -f a.txt ] || fail "pinned #2 should be folded"
[ ! -f late.txt ] || fail "pinned #2 must not pick up the later push"
grep -q "#4 (commit not fetched)" "$TMP/pinned-notes.txt" || fail "notes: $(cat "$TMP/pinned-notes.txt")"

echo "fold_open_prs: all tests passed"
