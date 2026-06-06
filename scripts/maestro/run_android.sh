#!/usr/bin/env bash
set -euo pipefail

APP_ID="${APP_ID:-rw.flipper}"
FLOW_PATH="${FLOW_PATH:-.maestro/00_landing_to_pin_smoke.yaml}"
APK_PATH="${APK_PATH:-build/app/outputs/flutter-apk/app-debug.apk}"

if ! command -v maestro >/dev/null 2>&1; then
  echo "Maestro CLI was not found on PATH." >&2
  echo "Install it with: curl -fsSL \"https://get.maestro.mobile.dev\" | bash" >&2
  exit 127
fi

if command -v adb >/dev/null 2>&1 && [ -f "$APK_PATH" ]; then
  adb install -r "$APK_PATH"
fi

APP_ID="$APP_ID" maestro test "$FLOW_PATH"
