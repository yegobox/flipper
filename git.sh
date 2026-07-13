#!/usr/bin/env bash
# Push local changes in flipper open-source forks (and sibling data-connector).
# Usage: ./git.sh [commit-message]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MESSAGE="${1:-clean-up}"

# path (relative to flipper/) | branch
REPOS=(
  "open-sources/flutter.widgets|main"
  "open-sources/qr.flutter|main"
  "open-sources/receipt|sql"
  "open-sources/flutter_slidable|dev"
  "open-sources/form_bloc|master"
  "open-sources/brick|main"
  "../data-connector|main"
)

# Optional — uncomment to include:
# "open-sources/kds|master"
# "open-sources/flutter_list_drag_and_drop|main"
# "open-sources/flutter_datetime_picker|master"
# "open-sources/flutter_luban|master"
# "../flipper-turbo|uat"
# "../dart_pdf|master"

# Flutter iOS ephemeral files are machine-local; never commit them.
drop_flutter_ephemeral_noise() {
  local path
  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    git restore -- "$path" 2>/dev/null || true
  done < <(git status --porcelain | awk '{print $2}' | grep 'Flutter/ephemeral/' || true)
}

ensure_branch() {
  local branch="$1"
  local current
  current="$(git branch --show-current)"

  if [[ "$current" == "$branch" ]]; then
    return 0
  fi

  local stashed=0
  if [[ -n "$(git status --porcelain)" ]]; then
    git stash push -u -m "git.sh auto-stash"
    stashed=1
  fi

  git checkout "$branch"

  if [[ "$stashed" == "1" ]]; then
    if ! git stash pop; then
      echo "  warning: git stash pop failed — stash remains; recover manually with: git stash list / git stash pop" >&2
    fi
  fi
}

sync_with_remote() {
  local branch="$1"
  # Remote branch may not exist yet (first push); do not abort under set -e.
  git fetch origin "$branch" || true
  if ! git rev-parse --verify "origin/$branch" >/dev/null 2>&1; then
    return 0
  fi
  local behind
  behind="$(git rev-list --count HEAD.."origin/$branch" 2>/dev/null || echo 0)"
  if [[ "$behind" -gt 0 ]]; then
    echo "  rebasing onto origin/$branch ($behind behind)"
    if ! git pull --rebase origin "$branch"; then
      echo "  error: rebase onto origin/$branch failed — resolve conflicts then \`git rebase --continue\`, or \`git rebase --abort\` to undo" >&2
      exit 1
    fi
  fi
}

push_repo() {
  local spec="$1"
  local relpath="${spec%%|*}"
  local branch="${spec#*|}"
  local dir="$ROOT/$relpath"

  if [[ ! -e "$dir/.git" ]]; then
    echo "skip: $relpath (not a git repo)"
    return 0
  fi

  echo "=== $relpath ($branch) ==="
  cd "$dir"

  ensure_branch "$branch"
  drop_flutter_ephemeral_noise

  local dirty=0
  if ! git diff --quiet || ! git diff --cached --quiet; then
    dirty=1
    git add -A
    git commit -m "$MESSAGE"
  else
    echo "  nothing to commit"
  fi

  if [[ "$dirty" == "1" ]] || { git rev-parse --verify '@{u}' >/dev/null 2>&1 && [[ "$(git rev-list --count '@{u}'..HEAD)" -gt 0 ]]; }; then
    sync_with_remote "$branch"
    git push origin "$branch"
  fi
}

bump_flipper_submodules() {
  cd "$ROOT"
  [[ -e .git ]] || return 0

  local path updated=0
  for spec in "${REPOS[@]}"; do
    path="${spec%%|*}"
    [[ "$path" == ../* ]] && continue
    [[ -e "$path/.git" ]] || continue
    if ! git diff --quiet HEAD -- "$path" 2>/dev/null; then
      updated=1
      git add "$path"
    fi
  done

  if [[ "$updated" == "1" ]]; then
    echo "=== flipper (submodule pointers) ==="
    git commit -m "chore: bump open-source submodule pointers"
    if git rev-parse --verify '@{u}' >/dev/null 2>&1; then
      git push origin "$(git branch --show-current)"
    else
      echo "  committed locally (no upstream — push flipper manually)"
    fi
  fi
}

for spec in "${REPOS[@]}"; do
  push_repo "$spec"
done

bump_flipper_submodules

echo "done"
