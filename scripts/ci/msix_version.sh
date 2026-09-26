#!/usr/bin/env bash
# Print the msix version a CI build must use: Major.Minor.<run>.0.
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
# The run number makes the name unique per build, and (Major, Minor, run) only
# ever grows on a branch, so every build is also an update over the last one.
# Major.Minor still come from pubspec.yaml, so the hook's numbering stays
# visible. The fourth part stays 0: the Store rejects any other revision.
# (Android does the same with github.run_number for its versionCode.)
#
# Usage
#   scripts/ci/msix_version.sh [path/to/pubspec.yaml]
# Reads GITHUB_RUN_NUMBER; appends version=<v> to GITHUB_OUTPUT when set.
set -euo pipefail

PUBSPEC="${1:-apps/flipper/pubspec.yaml}"
RUN="${GITHUB_RUN_NUMBER:-}"

if [[ ! "$RUN" =~ ^[0-9]+$ ]] || (( RUN < 1 )); then
  echo "::error::GITHUB_RUN_NUMBER is missing or not a number ('$RUN')." >&2
  exit 1
fi
# Each msix version part is a 16-bit number.
if (( RUN > 65535 )); then
  echo "::error::Run number $RUN does not fit an msix version part (max 65535). Move the run number into another part, or bump Major in pubspec.yaml and subtract an offset here." >&2
  exit 1
fi

# The active (uncommented) msix_version line, as the pre-commit hook reads it.
BASE="$(awk '/^[[:space:]]*msix_version:[[:space:]]*/ && $1 !~ /^#/ { print $2; exit }' "$PUBSPEC")"
if [[ ! "$BASE" =~ ^([0-9]+)\.([0-9]+)\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::No usable msix_version in $PUBSPEC (found '$BASE')." >&2
  exit 1
fi

VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${RUN}.0"
echo "msix version: $VERSION (pubspec $BASE, run $RUN)" >&2
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "version=$VERSION" >> "$GITHUB_OUTPUT"
fi
echo "$VERSION"
