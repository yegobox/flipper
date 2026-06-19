#!/usr/bin/env bash
#
# Collect Flutter test coverage for a package one test file at a time, then merge
# the per-file reports into coverage/lcov.info.
#
# Why per-file? `flutter test --coverage` over a large suite crashes the
# flutter_tester shell subprocess with a SIGSEGV during coverage finalization
# once accumulated coverage data passes a threshold (~60-90 tests). It is
# reproducible locally and in CI, at random test files, regardless of
# --concurrency. A single test file under --coverage is reliable, so we drive one
# file per invocation (each into its own lcov file via --coverage-path), retry the
# flaky segfault, and concatenate the partial reports. lcov records are
# self-contained per source file, so concatenation yields a valid report that
# Codecov / genhtml accept.
#
# See: https://github.com/flutter/flutter/issues (flutter_tester coverage SIGSEGV)
#
# Usage:
#   scripts/package_coverage.sh <package-dir>      # e.g. packages/flipper_dashboard
#   scripts/package_coverage.sh                    # defaults to current directory
#
# Env vars:
#   COVERAGE_JOBS   files to run concurrently (default 1). KEEP THIS AT 1 unless
#                   you know what you are doing: concurrent `flutter test`
#                   invocations in the same package race on shared build
#                   artifacts (pub ephemeral files and build/native_assets/),
#                   producing spurious "install_name_tool" / "unable to delete"
#                   failures unrelated to the tests.
#   COVERAGE_LIMIT  only the first N files (debugging; default 0 = all)
#
# Exit code is non-zero if any test file has a real test failure, or if a
# segfault never clears after retries.

set -uo pipefail

TARGET_DIR="${1:-$PWD}"
cd "$TARGET_DIR" || {
  echo "ERROR: cannot cd to $TARGET_DIR"
  exit 1
}
PKG_NAME="$(basename "$TARGET_DIR")"

PARTIAL_DIR="coverage/partial"
JOBS="${COVERAGE_JOBS:-1}"
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
TOTAL=${#FILES[@]}
if [ "$TOTAL" -eq 0 ]; then
  echo "ERROR: no *_test.dart files found under $TARGET_DIR/test"
  exit 1
fi
echo "[$PKG_NAME] collecting coverage for $TOTAL test file(s) (jobs=$JOBS)"

# Resolve dependencies ONCE up front. Each `flutter test` would otherwise run an
# implicit `flutter pub get`; running many concurrently races on the generated
# ephemeral package files (e.g. ios/Flutter/ephemeral/.packages) and fails with
# "Unable to delete file or directory". We pub-get here and pass --no-pub below,
# which also makes every per-file invocation much faster.
echo "[$PKG_NAME] resolving dependencies (flutter pub get)"
if ! flutter pub get >"$PARTIAL_DIR/pub_get.log" 2>&1; then
  echo "ERROR: flutter pub get failed (see $PARTIAL_DIR/pub_get.log)"
  exit 1
fi

run_one() {
  local idx="$1" file="$2"
  local out="$PARTIAL_DIR/$idx.info"
  local log="$PARTIAL_DIR/$idx.log"
  local attempt
  for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
    if flutter test --no-pub --coverage --coverage-path="$out" \
      --dart-define=FLUTTER_TEST_ENV=true "$file" >"$log" 2>&1; then
      echo "  ok   [$idx/$TOTAL] $file"
      return 0
    fi
    if grep -q "segmentation fault" "$log"; then
      echo "  warn [$idx/$TOTAL] segfault (attempt $attempt/$MAX_ATTEMPTS) $file"
      rm -f "$out"
      continue
    fi
    echo "  FAIL [$idx/$TOTAL] real test failure: $file (see $log)"
    return 1
  done
  echo "  FAIL [$idx/$TOTAL] segfault persisted after $MAX_ATTEMPTS attempts: $file"
  return 1
}

fail=0
idx=0
pids=()
for file in "${FILES[@]}"; do
  idx=$((idx + 1))
  if [ "$JOBS" -le 1 ]; then
    run_one "$idx" "$file" || fail=1
  else
    run_one "$idx" "$file" &
    pids+=("$!")
    # Throttle to at most $JOBS concurrent flutter_tester processes.
    while [ "$(jobs -rp | wc -l)" -ge "$JOBS" ]; do
      sleep 0.3
    done
  fi
done
# Reap background jobs (guard empty-array expansion under `set -u` on bash 3.2).
for pid in ${pids[@]+"${pids[@]}"}; do
  wait "$pid" || fail=1
done

# Merge partial lcov reports into the canonical coverage/lcov.info.
shopt -s nullglob
parts=("$PARTIAL_DIR"/*.info)
if [ "${#parts[@]}" -eq 0 ]; then
  echo "ERROR: no partial coverage reports were produced"
  exit 1
fi
cat "${parts[@]}" >coverage/lcov.info
echo "[$PKG_NAME] merged ${#parts[@]} report(s) -> coverage/lcov.info ($(wc -l <coverage/lcov.info) lines)"

exit "$fail"
