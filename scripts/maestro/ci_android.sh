#!/usr/bin/env bash
set -euo pipefail

APP_ID="${APP_ID:-rw.flipper}"
FLOW_PATH="${FLOW_PATH:-.maestro}"
APK_PATH="${APK_PATH:-build/app/outputs/flutter-apk/app-debug.apk}"

flutter build apk \
  --debug \
  --dart-define=FLUTTER_TEST_ENV=true

adb install -r "$APK_PATH"
APP_ID="$APP_ID" maestro test "$FLOW_PATH"
