#!/usr/bin/env bash
# Tests for launcher_version.sh against canned tag lists. Run directly.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

printf 'version: 1.548.0+1\nmsix_config:\n  msix_version: 1.552.0.0\n' >"$TMP/pubspec.yaml"

# Prints the version for CHANNEL=$1 SHA=$2 RUN=$3 over the refs in $TMP/tags.
run() {
  CHANNEL="$1" GITHUB_SHA="$2" GITHUB_RUN_NUMBER="$3" \
    LAUNCHER_TAGS_FILE="$TMP/tags" LAUNCHER_STORE_WAIT=0 LAUNCHER_STORE_POLL=0 \
    GITHUB_OUTPUT='' "$HERE/launcher_version.sh" "$TMP/pubspec.yaml" 2>/dev/null
}
expect() { [[ "$1" == "$2" ]] || fail "$3: got '$1', want '$2'"; }

cat >"$TMP/tags" <<TAGS
refs/tags/v1.586.0.0_windows_prod commit aaa
refs/tags/v1.587.0.0_windows_prod commit bbb
refs/tags/v1.590.0.0_windows_prerelease_hotfix-x commit zzz
refs/tags/v1.552.0.0_windows_debug commit bbb
refs/tags/desktop-v1.548.65 commit bbb
refs/tags/desktop-v1.560.66-beta commit yyy
TAGS

expect "$(run stable bbb 67)" "1.587.67" "takes the Store Minor of the same commit"
expect "$(run stable aaa 67)" "1.586.67" "an older commit keeps its own Store Minor"
expect "$(run stable ccc 67)" "1.587.67" "no Store tag on the commit falls back to the latest Store Minor"
expect "$(run beta ccc 67)" "1.587.67-beta" "beta takes the latest Store Minor"

echo "refs/tags/desktop-v1.588.70 commit ddd" >>"$TMP/tags"
expect "$(run stable aaa 71)" "1.588.71" "never drops below the last stable launcher release"

printf 'refs/tags/desktop-v1.548.65 commit bbb\n' >"$TMP/tags"
expect "$(run stable bbb 66)" "1.552.66" "no Store release yet starts from pubspec's msix Minor"

echo "launcher_version_test: all passed"
