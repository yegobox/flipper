#!/usr/bin/env bash
# Print the version the launcher catalog (desktop_launcher_release.yml) must
# publish: Major.N.<run>, where N is the Store msix Minor of the same commit.
#
# Why? The Store build (release.yml, scripts/ci/msix_version.sh) and the
# launcher build of one commit used to carry unrelated numbers: the Store
# counts its own releases (1.587.0.0), the launcher took pubspec's Minor
# (1.548.65). Both were built from the same commit, yet the numbers suggested
# two different apps, one of them "behind". Now both show the same N, so
# Store 1.587.0.0 and launcher 1.587.65 read as the same build.
#
# How N is found:
#   - stable (main): wait for release.yml to tag v<Major>.<N>.0.0_windows_prod
#     on this commit (up to LAUNCHER_STORE_WAIT seconds). If it never appears
#     (that job failed or was skipped), take the highest Store-format Minor so
#     far.
#   - beta (branches): no Store tag will name this commit; take the highest
#     Store Minor so far.
#   - Either way N never drops below the highest stable launcher release, so
#     every run still sorts above the last one (PATCH is the run number, which
#     only grows). Installed launchers compare versions to decide on updates.
#
# Usage
#   scripts/ci/launcher_version.sh [path/to/pubspec.yaml]
# Needs CHANNEL, GITHUB_SHA, GITHUB_RUN_NUMBER, and either GH_TOKEN +
# GITHUB_REPOSITORY (lists tags with `gh api`) or LAUNCHER_TAGS_FILE, which
# holds "<ref> <type> <sha>" per line (for tests).
# Appends version=<v> and tag=<t> to GITHUB_OUTPUT when set.
set -euo pipefail

PUBSPEC="${1:-apps/flipper/pubspec.yaml}"
WAIT="${LAUNCHER_STORE_WAIT:-2700}"
POLL="${LAUNCHER_STORE_POLL:-60}"
: "${CHANNEL:?CHANNEL is not set}"
: "${GITHUB_SHA:?GITHUB_SHA is not set}"
: "${GITHUB_RUN_NUMBER:?GITHUB_RUN_NUMBER is not set}"

# Same Major as the Store: the active msix_version line.
BASE="$(awk '/^[[:space:]]*msix_version:[[:space:]]*/ && $1 !~ /^#/ { print $2; exit }' "$PUBSPEC")"
if [[ ! "$BASE" =~ ^([0-9]+)\.([0-9]+)\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::No usable msix_version in $PUBSPEC (found '$BASE')." >&2
  exit 1
fi
MAJOR="${BASH_REMATCH[1]}"
PUBSPEC_MINOR="${BASH_REMATCH[2]}"

# "<ref> <commit sha>" for every Store-format and launcher tag of this Major.
list_refs() {
  if [[ -n "${LAUNCHER_TAGS_FILE:-}" ]]; then
    awk '{ print $1, $3 }' "$LAUNCHER_TAGS_FILE"
    return
  fi
  local repo="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is not set}" prefix ref type sha
  for prefix in "v${MAJOR}." "desktop-v${MAJOR}."; do
    gh api --paginate "repos/$repo/git/matching-refs/tags/$prefix" \
      --jq '.[] | "\(.ref) \(.object.type) \(.object.sha)"' |
      while read -r ref type sha; do
        # An annotated tag points at a tag object; name the commit instead.
        if [[ "$type" == tag && "$ref" == *_windows_prod ]]; then
          sha="$(gh api "repos/$repo/git/tags/$sha" --jq .object.sha)"
        fi
        echo "$ref $sha"
      done
  done
}

# Highest Minor of a Store production tag, of this commit only when $2 is set
# (-1 when there is none).
store_minor() {
  printf '%s\n' "$1" | awk -v major="$MAJOR" -v sha="${2:-}" '
    BEGIN { max = -1 }
    {
      ref = $1
      sub(/^refs\/tags\//, "", ref)
      if (ref !~ /^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_windows_prod$/) next
      if (sha != "" && $2 != sha) next
      split(substr(ref, 2), part, /[._]/)
      if (part[1] != major) next
      if (part[2] + 0 > max) max = part[2] + 0
    }
    END { print max }
  '
}

# Highest Minor of a stable launcher release (desktop-v<Major>.<N>.<run>).
launcher_minor() {
  printf '%s\n' "$1" | awk -v major="$MAJOR" '
    BEGIN { max = -1 }
    {
      ref = $1
      sub(/^refs\/tags\/desktop-v/, "", ref)
      if (ref !~ /^[0-9]+\.[0-9]+\.[0-9]+$/) next
      split(ref, part, /\./)
      if (part[1] != major) next
      if (part[2] + 0 > max) max = part[2] + 0
    }
    END { print max }
  '
}

if ! REFS="$(list_refs)"; then
  echo "::error::Could not list release tags, so the Store version of this commit is unknown." >&2
  exit 1
fi

MINOR=-1
if [[ "$CHANNEL" == stable ]]; then
  DEADLINE=$(( SECONDS + WAIT ))
  while :; do
    MINOR="$(store_minor "$REFS" "$GITHUB_SHA")"
    (( MINOR >= 0 )) && break
    if (( SECONDS >= DEADLINE )); then
      echo "::warning::No v${MAJOR}.*_windows_prod tag on $GITHUB_SHA after ${WAIT}s; using the latest Store version instead." >&2
      break
    fi
    echo "Waiting for the Store build of $GITHUB_SHA to be tagged..." >&2
    sleep "$POLL"
    if ! REFS="$(list_refs)"; then
      echo "::error::Could not list release tags." >&2
      exit 1
    fi
  done
fi
if (( MINOR < 0 )); then
  MINOR="$(store_minor "$REFS")"
fi
# No Store release at all yet: start from pubspec, as msix_version.sh does.
if (( MINOR < 0 )); then
  MINOR=$PUBSPEC_MINOR
fi
LAUNCHER_MINOR="$(launcher_minor "$REFS")"
if (( LAUNCHER_MINOR > MINOR )); then
  MINOR=$LAUNCHER_MINOR
fi

VERSION="${MAJOR}.${MINOR}.${GITHUB_RUN_NUMBER}"
[[ "$CHANNEL" == beta ]] && VERSION="$VERSION-beta"
TAG="desktop-v$VERSION"
echo "launcher version: $VERSION" >&2
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$VERSION" >> "$GITHUB_OUTPUT"
  echo "tag=$TAG" >> "$GITHUB_OUTPUT"
fi
echo "$VERSION"
