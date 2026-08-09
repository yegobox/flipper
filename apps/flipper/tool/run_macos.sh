#!/usr/bin/env bash
#
# Run the macOS app so that it owns its own TCC (privacy) attribution.
#
# Why this exists: `flutter run` launches the app as a child of `dartvm`, which
# makes the *terminal's* host app (Cursor, VS Code, Terminal…) the "responsible
# process" for privacy prompts. TCC then looks for the usage description in
# that host's Info.plist instead of ours. Cursor ships
# NSMicrophoneUsageDescription but no NSSpeechRecognitionUsageDescription, so
# the first dictation attempt SIGKILLs the app with:
#
#   Termination Reason: Namespace TCC ... must contain an
#   NSSpeechRecognitionUsageDescription key
#
# even though our Info.plist has the key. Launching through `open` hands the
# app to LaunchServices, so it becomes its own responsible process and TCC
# reads our Info.plist. Shipped builds launched from Finder/Dock are already
# fine — this only bites the `flutter run` dev loop.
#
# Usage:  ./tool/run_macos.sh [--release] [-- <extra flutter build args>]
#
# Hot reload still works: the script attaches after launching.

set -euo pipefail

cd "$(dirname "$0")/.."

MODE="debug"
if [[ "${1:-}" == "--release" ]]; then
  MODE="release"
  shift
fi
if [[ "${1:-}" == "--" ]]; then
  shift
fi

echo "==> Building macOS app ($MODE)"
flutter build macos "--$MODE" "$@"

APP="build/macos/Build/Products/$(tr '[:lower:]' '[:upper:]' <<<"${MODE:0:1}")${MODE:1}/flipper.app"
if [[ ! -d "$APP" ]]; then
  echo "Build did not produce $APP" >&2
  exit 1
fi

# Fail loudly on the misconfiguration this script exists to work around,
# rather than letting TCC kill the app minutes later.
for key in NSMicrophoneUsageDescription NSSpeechRecognitionUsageDescription; do
  if ! plutil -p "$APP/Contents/Info.plist" | grep -q "$key"; then
    echo "WARNING: $APP is missing $key — dictation will crash the app." >&2
  fi
done
if ! codesign -d --entitlements - "$APP" 2>/dev/null |
  grep -q "com.apple.security.device.audio-input"; then
  echo "WARNING: $APP lacks the audio-input entitlement — the mic will be denied." >&2
fi

echo "==> Launching via LaunchServices (own TCC responsibility)"
open "$APP"

if [[ "$MODE" == "debug" ]]; then
  echo "==> Attaching for hot reload (Ctrl-C to detach; the app keeps running)"
  exec flutter attach -d macos
fi
