#!/bin/bash
set -e

# Runs immediately before xcodebuild on Xcode Cloud.
# Refreshes Flutter iOS config so build phases see a valid FLUTTER_ROOT.

log_step() {
  echo ""
  echo "==> $1"
}

if [[ -n "$CI_WORKSPACE" ]]; then
  BASE_PATH="$CI_WORKSPACE"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BASE_PATH="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
export PATH="$FLUTTER_DIR/bin:$HOME/.pub-cache/bin:$PATH"

FLUTTER_APP_DIR="$BASE_PATH/apps/flipper"
IOS_DIR="$FLUTTER_APP_DIR/ios"
PLIST_PATH="$IOS_DIR/GoogleService-Info.plist"

log_step "ci_pre_xcodebuild: verify Flutter SDK"
if ! command -v flutter &>/dev/null; then
  echo "ERROR: flutter not found on PATH (expected $FLUTTER_DIR/bin)"
  exit 1
fi
flutter --version

log_step "ci_pre_xcodebuild: refresh Generated.xcconfig"
cd "$FLUTTER_APP_DIR"
flutter pub get
flutter build ios --config-only --release

GENERATED_XCCONFIG="$IOS_DIR/Flutter/Generated.xcconfig"
if [[ ! -f "$GENERATED_XCCONFIG" ]]; then
  echo "ERROR: $GENERATED_XCCONFIG was not created"
  exit 1
fi
echo "FLUTTER_ROOT from Generated.xcconfig:"
grep '^FLUTTER_ROOT=' "$GENERATED_XCCONFIG" || true

log_step "ci_pre_xcodebuild: ensure firebase_app_id_file.json exists"
if [[ -f "$PLIST_PATH" ]]; then
  GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  if [[ -n "$GOOGLE_APP_ID" && -n "$FIREBASE_PROJECT_ID" && -n "$GCM_SENDER_ID" ]]; then
    cat > "$IOS_DIR/firebase_app_id_file.json" <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
    echo "Wrote $IOS_DIR/firebase_app_id_file.json"
  fi
fi

log_step "ci_pre_xcodebuild: verify CocoaPods manifest"
cd "$IOS_DIR"
if [[ -f Podfile.lock && -f Pods/Manifest.lock ]]; then
  if ! diff Podfile.lock Pods/Manifest.lock >/dev/null; then
    echo "Podfile.lock and Pods/Manifest.lock differ; running pod install..."
    pod install
  else
    echo "Pods manifest is in sync"
  fi
else
  echo "WARNING: Podfile.lock or Pods/Manifest.lock missing; running pod install..."
  pod install
fi

echo "ci_pre_xcodebuild completed successfully"
