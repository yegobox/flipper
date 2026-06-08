#!/bin/bash
set -e

# Lightweight pre-xcodebuild hook for Xcode Cloud.
# Heavy setup (Flutter install, melos, first pod install) stays in ci_post_clone.sh.
# This script only refreshes paths Flutter/Xcode need immediately before archive.

log_step() {
  echo ""
  echo "==> $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -n "${CI_PRIMARY_REPOSITORY_PATH:-}" ]]; then
  REPO_ROOT="$CI_PRIMARY_REPOSITORY_PATH"
elif [[ -n "${CI_WORKSPACE:-}" ]]; then
  REPO_ROOT="$CI_WORKSPACE"
else
  REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

if [[ -f "$REPO_ROOT/apps/flipper/pubspec.yaml" ]]; then
  FLUTTER_APP_DIR="$REPO_ROOT/apps/flipper"
elif [[ -f "$REPO_ROOT/pubspec.yaml" ]]; then
  FLUTTER_APP_DIR="$REPO_ROOT"
  REPO_ROOT="$(cd "$FLUTTER_APP_DIR/../.." && pwd)"
else
  echo "ERROR: Could not locate apps/flipper from REPO_ROOT=$REPO_ROOT"
  exit 1
fi

FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
export PATH="$FLUTTER_DIR/bin:$HOME/.pub-cache/bin:$PATH"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

PLIST_PATH="$IOS_DIR/GoogleService-Info.plist"

log_step "ci_pre_xcodebuild: paths"
echo "REPO_ROOT=$REPO_ROOT"
echo "FLUTTER_APP_DIR=$FLUTTER_APP_DIR"
echo "IOS_DIR=$IOS_DIR"
echo "FLUTTER_DIR=$FLUTTER_DIR"

log_step "ci_pre_xcodebuild: ensure Flutter SDK"
if ! command -v flutter &>/dev/null; then
  if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
    echo "ERROR: flutter not found. ci_post_clone.sh should install it to $FLUTTER_DIR"
    exit 1
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi
flutter --version

log_step "ci_pre_xcodebuild: refresh Flutter iOS config"
cd "$FLUTTER_APP_DIR"
flutter pub get
flutter build ios --config-only --release

GENERATED_XCCONFIG="$IOS_DIR/Flutter/Generated.xcconfig"
if [[ ! -f "$GENERATED_XCCONFIG" ]]; then
  echo "ERROR: Missing $GENERATED_XCCONFIG after flutter pub get"
  exit 1
fi
grep '^FLUTTER_ROOT=' "$GENERATED_XCCONFIG" || true

mkdir -p "$IOS_DIR/Flutter"
echo "$FLUTTER_DIR" > "$IOS_DIR/Flutter/.ci_flutter_root"

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
  fi
fi

log_step "ci_pre_xcodebuild: sync CocoaPods"
cd "$IOS_DIR"
if ! command -v pod &>/dev/null; then
  echo "ERROR: pod not found. ci_post_clone.sh should install CocoaPods."
  exit 1
fi
pod install

if [[ ! -f Podfile.lock || ! -f Pods/Manifest.lock ]]; then
  echo "ERROR: pod install did not produce Podfile.lock and Pods/Manifest.lock"
  exit 1
fi
if ! diff Podfile.lock Pods/Manifest.lock >/dev/null; then
  echo "ERROR: Podfile.lock and Pods/Manifest.lock differ after pod install"
  diff Podfile.lock Pods/Manifest.lock || true
  exit 1
fi

echo "ci_pre_xcodebuild completed successfully"
