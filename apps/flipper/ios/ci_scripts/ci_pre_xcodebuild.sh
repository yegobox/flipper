#!/bin/bash
set -e

# Runs immediately before xcodebuild on Xcode Cloud.
# Refreshes Flutter iOS config so build phases see a valid FLUTTER_ROOT.

log_step() {
  echo ""
  echo "==> $1"
}

if [[ -n "${CI_PRIMARY_REPOSITORY_PATH:-}" ]]; then
  BASE_PATH="$CI_PRIMARY_REPOSITORY_PATH"
elif [[ -n "${CI_WORKSPACE:-}" ]]; then
  BASE_PATH="$CI_WORKSPACE"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BASE_PATH="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
export PATH="$FLUTTER_DIR/bin:$HOME/.pub-cache/bin:$PATH"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

FLUTTER_APP_DIR="$BASE_PATH/apps/flipper"
IOS_DIR="$FLUTTER_APP_DIR/ios"
PLIST_PATH="$IOS_DIR/GoogleService-Info.plist"

log_step "ci_pre_xcodebuild: verify required generated files"
required_files=(
  "$BASE_PATH/packages/flipper_models/lib/secrets.dart"
  "$BASE_PATH/packages/flipper_models/lib/firebase_options.dart"
  "$FLUTTER_APP_DIR/lib/firebase_options.dart"
  "$PLIST_PATH"
)
for file in "${required_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "ERROR: Required file is missing or empty: $file"
    echo "Set Xcode Cloud secrets: SECRETS2, FIREBASE1, FIREBASE2, GOOGLE_SERVICE_INFO_PLIST_CONTENT"
    exit 1
  fi
done

log_step "ci_pre_xcodebuild: verify Flutter SDK"
if ! command -v flutter &>/dev/null; then
  echo "ERROR: flutter not found on PATH (expected $FLUTTER_DIR/bin)"
  exit 1
fi
flutter --version

log_step "ci_pre_xcodebuild: refresh workspace dependencies"
cd "$BASE_PATH"
dart pub global activate melos 6.3.2
melos bootstrap

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

# Marker file read by Xcode Run Script phases on Xcode Cloud.
mkdir -p "$IOS_DIR/Flutter"
echo "$FLUTTER_DIR" > "$IOS_DIR/Flutter/.ci_flutter_root"
echo "Wrote $IOS_DIR/Flutter/.ci_flutter_root -> $FLUTTER_DIR"

log_step "ci_pre_xcodebuild: compile Flutter iOS release (fail here, not in Xcode)"
# Compile before xcodebuild so Dart errors appear in Pre-Xcodebuild logs instead of
# the generic "PhaseScriptExecution failed" wrapper during archive.
flutter build ios --release --no-codesign

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

log_step "ci_pre_xcodebuild: install CocoaPods (always, after melos/flutter)"
cd "$IOS_DIR"
pod install
if [[ ! -f Podfile.lock || ! -f Pods/Manifest.lock ]]; then
  echo "ERROR: pod install did not create Podfile.lock and Pods/Manifest.lock"
  exit 1
fi
if ! diff Podfile.lock Pods/Manifest.lock >/dev/null; then
  echo "ERROR: Podfile.lock and Pods/Manifest.lock still differ after pod install"
  diff Podfile.lock Pods/Manifest.lock || true
  exit 1
fi
echo "Pods manifest is in sync"

echo "ci_pre_xcodebuild completed successfully"
