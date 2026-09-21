#!/usr/bin/env bash
#
# Raise the dwds `Debugger.enable` timeout so `flutter run -d chrome` can attach
# to our large web apps.
#
# Why: dwds allows Chrome 4 attempts x 5s = 20s to answer `Debugger.enable`.
# DDC emits one JS module per library and flipper_web / flipper_hr resolve ~378
# packages, so Chrome replies with a `scriptParsed` storm it cannot finish in
# 20s. The run then dies with:
#
#   Failed to establish connection with the web debug service:
#   TimeoutException after 0:00:05.000000
#     WebkitDebugger.enable (package:dwds/.../webkit_debugger.dart)
#
# The page itself has already loaded — only the debugger attach fails. Upstream
# acknowledges the race in a TODO on the same function.
#
# This patch lives in the shared pub-cache, NOT in this repo, so it is undone by
# `flutter upgrade`, `dart pub cache repair`, a Flutter bump that moves dwds to a
# new version, or a fresh machine. Re-run this script after any of those.
#
# Usage:
#   scripts/patch_dwds_timeout.sh           # apply (idempotent, no-op if done)
#   scripts/patch_dwds_timeout.sh --check   # is it applied here? non-zero if not
#   scripts/patch_dwds_timeout.sh --ci      # does the patch still APPLY? (for CI)
#   scripts/patch_dwds_timeout.sh --revert  # restore the original file
#
# Env:
#   DWDS_ENABLE_TIMEOUT   seconds to allow (default 60)

set -euo pipefail

TIMEOUT="${DWDS_ENABLE_TIMEOUT:-60}"
MODE="${1:-apply}"

# The dwds release this patch was derived and verified against. --ci fails when
# the resolved version drifts, which is the signal to re-verify the call site
# and bump this line. Do not bump it without re-testing `flutter run -d chrome`.
EXPECTED_DWDS="dwds-26.2.5"

die() { printf 'patch_dwds_timeout: %s\n' "$*" >&2; exit 1; }
info() { printf 'patch_dwds_timeout: %s\n' "$*"; }

command -v flutter >/dev/null 2>&1 || die "flutter not on PATH"

# $FLUTTER/bin/flutter -> $FLUTTER
flutter_bin="$(command -v flutter)"
if command -v realpath >/dev/null 2>&1; then
  flutter_bin="$(realpath "$flutter_bin")"
fi
FLUTTER_ROOT="$(cd "$(dirname "$flutter_bin")/.." && pwd)"

# Resolving dwds has to work in two very different places:
#
#   * a dev machine, where flutter_tools has been built from source and its
#     .dart_tool/package_config.json names the exact resolved path, and
#   * CI, where Flutter ships a prebuilt snapshot, flutter_tools was never
#     pub-got, and that file does not exist at all.
#
# packages/flutter_tools/pubspec.yaml pins dwds to an exact version and is
# present in every Flutter checkout, so it is the reliable source. The
# package_config is preferred when present because it also survives any local
# dependency override.
pkg_config="$FLUTTER_ROOT/packages/flutter_tools/.dart_tool/package_config.json"
tools_pubspec="$FLUTTER_ROOT/packages/flutter_tools/pubspec.yaml"

dwds_root=""
if [ -f "$pkg_config" ]; then
  dwds_root="$(python3 - "$pkg_config" <<'PY'
import json, sys, urllib.parse
cfg = json.load(open(sys.argv[1]))
for pkg in cfg.get("packages", []):
    if pkg["name"] == "dwds":
        uri = pkg["rootUri"]
        # urlparse keeps percent-encoding, so a path containing a space
        # comes back as %20 and every later file test misses.
        path = urllib.parse.urlparse(uri).path if uri.startswith("file://") else uri
        print(urllib.parse.unquote(path))
        break
PY
)"
fi

if [ -n "$dwds_root" ]; then
  dwds_version="$(basename "$dwds_root")"
else
  [ -f "$tools_pubspec" ] || die "cannot find $tools_pubspec"
  pinned="$(grep -oE '^[[:space:]]*dwds:[[:space:]]*[0-9][0-9A-Za-z.+-]*' "$tools_pubspec" \
            | head -1 | awk '{print $2}')"
  [ -n "$pinned" ] || die "no exact dwds pin in $tools_pubspec"
  dwds_version="dwds-$pinned"
  dwds_root="$HOME/.pub-cache/hosted/pub.dev/$dwds_version"
fi

target="$dwds_root/lib/src/debugging/webkit_debugger.dart"
info "dwds: $dwds_version"

# On CI the dwds sources are usually absent from pub-cache, because
# flutter_tools was never pub-got. That is not an error: --ci still verifies
# the version pin, which is what drift detection actually needs.
have_source=0
current=""
if [ -f "$target" ]; then
  have_source=1
  current="$(grep -oE 'enable\(\)\.timeout\(const Duration\(seconds: [0-9]+\)\)' "$target" | grep -oE '[0-9]+' || true)"
  [ -n "$current" ] || die "timeout call not found in $target — dwds internals changed, re-derive the patch"
elif [ "$MODE" != "--ci" ]; then
  die "dwds sources not found at $target — run 'flutter run -d chrome' once to populate pub-cache"
fi

case "$MODE" in
  --ci)
    # CI installs a pristine Flutter, so the patch is never applied there and
    # asking "is it patched?" would always fail. What CI checks instead is that
    # the patch remains APPLICABLE: dwds has not moved underneath us, and the
    # call site still looks right wherever the sources are available.
    if [ "$have_source" = "1" ]; then
      info "call site present, stock timeout is ${current}s"
    else
      info "dwds sources not in pub-cache (normal on CI) — checking the version pin only"
    fi
    if [ "$dwds_version" != "$EXPECTED_DWDS" ]; then
      cat >&2 <<MSG

  dwds drifted: resolved $dwds_version, patch derived against $EXPECTED_DWDS.

  Nothing is broken in this build - web release builds do not use dwds. But
  local 'flutter run -d chrome' debugging may break or may no longer need the
  patch. To resolve:
    1. Re-run scripts/patch_dwds_timeout.sh locally.
    2. Confirm 'flutter run -d chrome' attaches for apps/flipper_web.
    3. Update EXPECTED_DWDS in this script to $dwds_version and commit.

MSG
      exit 1
    fi
    info "OK: dwds matches $EXPECTED_DWDS"
    exit 0
    ;;
  --check)
    if [ "$current" -ge "$TIMEOUT" ]; then
      info "OK: timeout is ${current}s (>= ${TIMEOUT}s)"
      exit 0
    fi
    info "UNPATCHED: timeout is ${current}s, want ${TIMEOUT}s — run scripts/patch_dwds_timeout.sh"
    exit 1
    ;;
  --revert)
    if [ -f "$target.orig" ]; then
      cp "$target.orig" "$target"
      info "reverted from $target.orig"
    else
      die "no backup at $target.orig"
    fi
    ;;
  apply)
    if [ "$current" -ge "$TIMEOUT" ]; then
      info "already patched (${current}s) — nothing to do"
      exit 0
    fi
    [ -f "$target.orig" ] || cp "$target" "$target.orig"
    # macOS sed needs the empty -i argument; GNU sed must not get one.
    if sed --version >/dev/null 2>&1; then
      sed -i "s/enable()\.timeout(const Duration(seconds: ${current}))/enable().timeout(const Duration(seconds: ${TIMEOUT}))/" "$target"
    else
      sed -i '' "s/enable()\.timeout(const Duration(seconds: ${current}))/enable().timeout(const Duration(seconds: ${TIMEOUT}))/" "$target"
    fi
    info "patched ${current}s -> ${TIMEOUT}s"
    ;;
  *)
    die "unknown mode '$MODE' (use --check, --ci or --revert)"
    ;;
esac

# dwds is compiled INTO flutter_tools.snapshot, so the snapshot must be rebuilt
# or the edit has no effect. Move it aside rather than deleting it.
snapshot="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
stamp="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"
if [ -f "$snapshot" ]; then
  backup="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot.pre-dwds-patch.$(date +%s)"
  mv "$snapshot" "$backup"
  [ -f "$stamp" ] && mv "$stamp" "$backup.stamp"
  info "snapshot moved to $(basename "$backup")"
fi

info "rebuilding flutter_tools snapshot (~30s)..."
flutter --version >/dev/null
info "done — 'flutter run -d chrome' should now attach"
