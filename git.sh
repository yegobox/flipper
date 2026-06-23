#!/usr/bin/env bash
# Push local changes in flipper open-source forks (and sibling data-connector).
# Usage: ./git.sh [commit-message]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MESSAGE="${1:-clean-up}"

# path (relative to flipper/) | branch | stash before checkout (1/0)
REPOS=(
  "open-sources/flutter.widgets|main|0"
  "open-sources/qr.flutter|main|0"
  "open-sources/receipt|sql|0"
  "open-sources/flutter_slidable|dev|1"
  "open-sources/form_bloc|master|0"
  "open-sources/brick|main|0"
  "../data-connector|main|0"
)

# Optional — uncomment to include:
# "open-sources/kds|master|0"
# "open-sources/flutter_list_drag_and_drop|main|1"
# "open-sources/flutter_datetime_picker|master|0"
# "open-sources/flutter_luban|master|1"
# "../flipper-turbo|uat|0"
# "../dart_pdf|master|0"

push_repo() {
  local spec="$1"
  local relpath="${spec%%|*}"
  local rest="${spec#*|}"
  local branch="${rest%%|*}"
  local stash="${rest##*|}"
  local dir="$ROOT/$relpath"

  if [[ ! -e "$dir/.git" ]]; then
    echo "skip: $relpath (not a git repo)"
    return 0
  fi

  echo "=== $relpath ($branch) ==="
  cd "$dir"

  if [[ "$stash" == "1" ]]; then
    git stash push -u -m "git.sh auto-stash" || true
  fi

  git checkout "$branch"

  local dirty=0
  if ! git diff --quiet || ! git diff --cached --quiet; then
    dirty=1
    git add -A
    git commit -m "$MESSAGE"
  else
    echo "  nothing to commit"
  fi

  if [[ "$dirty" == "1" ]] || { git rev-parse --verify '@{u}' >/dev/null 2>&1 && [[ "$(git rev-list --count '@{u}'..HEAD)" -gt 0 ]]; }; then
    git push origin "$branch"
  fi
}

for spec in "${REPOS[@]}"; do
  push_repo "$spec"
done

echo "done"
