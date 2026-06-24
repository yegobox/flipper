#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APP_DIR="$ROOT_DIR/apps/flipper"

APP_ID="${APP_ID:-rw.flipper}"
FLOW_PATH="${FLOW_PATH:-$ROOT_DIR/.maestro/00_landing_to_pin_smoke.yaml}"
if [[ "$FLOW_PATH" != /* ]]; then
  FLOW_PATH="$ROOT_DIR/$FLOW_PATH"
fi
APK_PATH="${APK_PATH:-$APP_DIR/build/app/outputs/flutter-apk/app-debug.apk}"

cd "$APP_DIR"
flutter build apk \
  --debug \
  --dart-define=FLUTTER_TEST_ENV=true

adb install -r "$APK_PATH"
APP_ID="$APP_ID" maestro test "$FLOW_PATH"
