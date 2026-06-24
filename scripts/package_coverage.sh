#!/usr/bin/env bash
#
# Collect Flutter test coverage for a package in size-bounded shards, then merge
# the per-shard lcov reports into coverage/lcov.info.
#
# Why shard? `flutter test --coverage` over a large suite crashes the
# flutter_tester shell subprocess with a SIGSEGV during coverage finalization
# once accumulated coverage data passes a threshold (empirically ~60-90 tests).
# It is reproducible locally and in CI, at random test files, regardless of
# --concurrency. Splitting the suite into shards whose combined test count stays
# under COVERAGE_MAX_TESTS keeps every invocation below that threshold, while
# using far fewer (and therefore much faster) `flutter test` runs than going one
# file at a time. lcov reports merge cleanly across shards.
#
# See: flutter_tester coverage SIGSEGV (flutter/flutter).
#
# Usage:
#   scripts/package_coverage.sh <package-dir>   # e.g. packages/flipper_dashboard
#   scripts/package_coverage.sh                 # defaults to current directory
#
# Env vars:
#   COVERAGE_MAX_TESTS  max combined test count per shard (default 50). A single
#                       test file larger than this becomes its own shard.
#   COVERAGE_LIMIT      only the first N test files (debugging; default 0 = all)
#
# Exit code is non-zero if any shard has a real test failure, or if a shard keeps
# crashing after retries. Concurrency is intentionally NOT supported: parallel
# `flutter test` invocations in one package race on shared build artifacts
# (pub ephemeral files, build/native_assets/) and fail spuriously.

set -uo pipefail

TARGET_DIR="${1:-$PWD}"
cd "$TARGET_DIR" || {
  echo "ERROR: cannot cd to $TARGET_DIR"
  exit 1
}
PKG_NAME="$(basename "$TARGET_DIR")"

PARTIAL_DIR="coverage/partial"
MAX_TESTS="${COVERAGE_MAX_TESTS:-50}"
LIMIT="${COVERAGE_LIMIT:-0}"
MAX_ATTEMPTS=3

rm -rf "$PARTIAL_DIR"
mkdir -p "$PARTIAL_DIR"

# Portable file collection (bash 3.2 / macOS has no mapfile).
FILES=()
while IFS= read -r f; do
  FILES+=("$f")
done < <(find test -name '*_test.dart' | sort)
if [ "$LIMIT" -gt 0 ]; then
  FILES=("${FILES[@]:0:$LIMIT}")
fi
if [ "${#FILES[@]}" -eq 0 ]; then
  echo "ERROR: no *_test.dart files found under $TARGET_DIR/test"
  exit 1
fi

# Resolve dependencies ONCE up front, then pass --no-pub to each shard. This
# avoids the implicit per-invocation `flutter pub get` (slow, and racy when
# anything else touches the package) and speeds every shard up.
echo "[$PKG_NAME] resolving dependencies (flutter pub get)"
if ! flutter pub get >"$PARTIAL_DIR/pub_get.log" 2>&1; then
  echo "ERROR: flutter pub get failed (see $PARTIAL_DIR/pub_get.log)"
  exit 1
fi

count_tests() {
  # Approximate test count: test(...) / testWidgets(...) declarations.
  grep -cE "testWidgets\(|[^a-zA-Z]test\(" "$1" 2>/dev/null || echo 0
}

# Greedily bin files into shards whose combined test count stays under MAX_TESTS.
SHARD_FILES=()  # each element: space-separated list of files in that shard
cur=""
cur_count=0
for file in "${FILES[@]}"; do
  n=$(count_tests "$file")
  if [ -n "$cur" ] && [ $((cur_count + n)) -gt "$MAX_TESTS" ]; then
    SHARD_FILES+=("$cur")
    cur=""
    cur_count=0
  fi
  if [ -z "$cur" ]; then cur="$file"; else cur="$cur $file"; fi
  cur_count=$((cur_count + n))
done
[ -n "$cur" ] && SHARD_FILES+=("$cur")

NSHARDS=${#SHARD_FILES[@]}
echo "[$PKG_NAME] ${#FILES[@]} test file(s) -> $NSHARDS shard(s) (<= $MAX_TESTS tests each)"

run_shard() {
  local idx="$1" files="$2"
  local out="$PARTIAL_DIR/$idx.info"
  local log="$PARTIAL_DIR/$idx.log"
  local attempt
  for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
    # --concurrency=1 runs the shard's files serially. Some widget tests are
    # load/timing-sensitive and flake (e.g. "found 0 widgets") when files run
    # concurrently; serial execution matches how the full `flutter test` gate
    # passes them. Shards stay small enough that serial coverage stays under the
    # segfault threshold.
    # shellcheck disable=SC2086 -- intentional word splitting of the file list.
    if flutter test --no-pub --coverage --coverage-path="$out" --concurrency=1 \
      --dart-define=FLUTTER_TEST_ENV=true $files >"$log" 2>&1; then
      return 0
    fi
    # Retry transient flutter_tester crashes / temp-dir finalization flakes;
    # treat anything else as a genuine test failure.
    if grep -qiE "segmentation fault|PathNotFoundException|Deletion failed|crashed" "$log"; then
      echo "  warn [$idx/$NSHARDS] transient crash (attempt $attempt/$MAX_ATTEMPTS)"
      rm -f "$out"
      continue
    fi
    echo "  FAIL [$idx/$NSHARDS] real test failure (see $log)"
    return 1
  done
  echo "  FAIL [$idx/$NSHARDS] kept crashing after $MAX_ATTEMPTS attempts (see $log)"
  return 1
}

fail=0
idx=0
for files in "${SHARD_FILES[@]}"; do
  idx=$((idx + 1))
  nf=$(echo "$files" | wc -w | tr -d ' ')
  echo "[$PKG_NAME] shard $idx/$NSHARDS ($nf file(s))"
  if run_shard "$idx" "$files"; then
    echo "  ok   [$idx/$NSHARDS]"
  else
    fail=1
  fi
done

# Merge partial lcov reports. Prefer `lcov` (accurately merges hit counts for
# source files covered by more than one shard); fall back to concatenation,
# which Codecov also accepts.
shopt -s nullglob
parts=("$PARTIAL_DIR"/*.info)
if [ "${#parts[@]}" -eq 0 ]; then
  echo "ERROR: no partial coverage reports were produced"
  exit 1
fi
if command -v lcov >/dev/null 2>&1; then
  args=()
  for p in "${parts[@]}"; do args+=(-a "$p"); done
  lcov "${args[@]}" -o coverage/lcov.info >"$PARTIAL_DIR/merge.log" 2>&1 ||
    cat "${parts[@]}" >coverage/lcov.info
else
  cat "${parts[@]}" >coverage/lcov.info
fi
echo "[$PKG_NAME] merged ${#parts[@]} shard report(s) -> coverage/lcov.info ($(wc -l <coverage/lcov.info) lines)"

exit "$fail"
