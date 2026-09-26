#!/usr/bin/env bash
# Print the msix version a Store-format CI build must use: Major.N.0.0.
#
# Why not msix_version from pubspec.yaml as-is? That value only moves when a
# developer's pre-commit hook bumps it, and plenty of app changes legitimately
# land without one: stacked PRs skip it, merges take the parent's value, and CI
# commits never run the hook. Every Windows build between two bumps then ships
# a *different* package under the *same* name, and Partner Center rejects the
# upload: "two packages with the full name yegobox.yegoboxflipper_1.478.0.0_X64_
# which have different contents". The GitHub release tag reused that name too,
# so each build silently replaced the msix on the previous release.
#
# The scheme stays the familiar one: only the second number moves
# (1.478.0.0 -> 1.479.0.0). N is the larger of
#   - Minor in pubspec.yaml (so a hook bump is still honoured), and
#   - one more than the highest Minor already released as a Store-format
#     package (v<ver>_windows_prod / v<ver>_windows_prerelease_* tags),
# so a build can never reuse a name the Store may already have, and every
# build is an update over the last. Debug tags are ignored: those packages are
# never uploaded to the Store. The Store jobs share a concurrency group, so two
# builds cannot read the same highest tag at once. The last two parts stay 0;
# the Store rejects any revision other than 0.
#
# Usage
#   scripts/ci/msix_version.sh [path/to/pubspec.yaml]
# Lists tags with `gh api` (needs GH_TOKEN and GITHUB_REPOSITORY), or reads
# one ref per line from MSIX_TAGS_FILE when set (for tests).
# Appends version=<v> to GITHUB_OUTPUT when set.
set -euo pipefail

PUBSPEC="${1:-apps/flipper/pubspec.yaml}"

# The active (uncommented) msix_version line, as the pre-commit hook reads it.
BASE="$(awk '/^[[:space:]]*msix_version:[[:space:]]*/ && $1 !~ /^#/ { print $2; exit }' "$PUBSPEC")"
if [[ ! "$BASE" =~ ^([0-9]+)\.([0-9]+)\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::No usable msix_version in $PUBSPEC (found '$BASE')." >&2
  exit 1
fi
MAJOR="${BASH_REMATCH[1]}"
PUBSPEC_MINOR="${BASH_REMATCH[2]}"

# Fail rather than guess: without the tag list we cannot tell which names the
# Store already has, and guessing is exactly how the duplicate happened.
if [[ -n "${MSIX_TAGS_FILE:-}" ]]; then
  REFS="$(cat "$MSIX_TAGS_FILE")"
else
  if ! REFS="$(gh api --paginate "repos/${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is not set}/git/matching-refs/tags/v${MAJOR}." --jq '.[].ref')"; then
    echo "::error::Could not list release tags, so the next msix version is unknown. Not building rather than risk reusing a published name." >&2
    exit 1
  fi
fi

# Highest Minor among Store-format tags of this Major (-1 when there are none).
HIGHEST="$(printf '%s\n' "$REFS" | awk -v major="$MAJOR" '
  {
    ref = $0
    sub(/^refs\/tags\//, "", ref)
    if (ref !~ /^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_windows_(prod$|prerelease)/) next
    split(substr(ref, 2), part, /[._]/)
    if (part[1] != major) next
    if (part[2] + 0 > max) max = part[2] + 0
  }
  BEGIN { max = -1 }
  END { print max }
')"

MINOR=$(( HIGHEST + 1 ))
if (( PUBSPEC_MINOR > MINOR )); then
  MINOR=$PUBSPEC_MINOR
fi
# Each msix version part is a 16-bit number.
if (( MINOR > 65535 )); then
  echo "::error::Minor $MINOR does not fit an msix version part (max 65535). Bump Major in pubspec.yaml and reset Minor." >&2
  exit 1
fi

VERSION="${MAJOR}.${MINOR}.0.0"
echo "msix version: $VERSION (pubspec $BASE, highest Store-format release ${MAJOR}.${HIGHEST}.0.0)" >&2
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$VERSION" >> "$GITHUB_OUTPUT"
fi
echo "$VERSION"
