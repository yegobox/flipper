#!/bin/bash
set -e

# Xcode Cloud kills scripts after ~15 minutes with NO stdout/stderr output.
# Keep frequent echoes and use run_with_heartbeat around slow commands.

HEARTBEAT_INTERVAL="${HEARTBEAT_INTERVAL:-90}"

log_step() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔵 STEP: $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

log_heartbeat() {
  echo "[ci_post_clone heartbeat] $1 at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

run_with_heartbeat() {
  local label="$1"
  shift
  echo "Starting: $label"
  "$@" &
  local cmd_pid=$!
  while kill -0 "$cmd_pid" 2>/dev/null; do
    sleep "$HEARTBEAT_INTERVAL"
    if kill -0 "$cmd_pid" 2>/dev/null; then
      log_heartbeat "$label"
    fi
  done
  wait "$cmd_pid"
}

write_to_file() {
  local content="$1"
  local file_path="$2"
  if [[ -n "$content" ]]; then
    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
    echo "✅ Wrote to $file_path"
  else
    echo "⚠️ Skipped $file_path (empty content)"
  fi
}

echo "🚀 Starting ci_post_clone.sh for flipper"
log_heartbeat "script start"

log_step "Determining Base Path"

if [[ -n "${CI_PRIMARY_REPOSITORY_PATH:-}" ]]; then
  BASE_PATH="$CI_PRIMARY_REPOSITORY_PATH"
  echo "Using CI_PRIMARY_REPOSITORY_PATH as BASE_PATH: $BASE_PATH"
elif [[ -n "${CI_WORKSPACE:-}" ]]; then
  BASE_PATH="$CI_WORKSPACE"
  echo "Using CI_WORKSPACE as BASE_PATH: $BASE_PATH"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BASE_PATH="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
  echo "Using relative BASE_PATH: $BASE_PATH"
fi

if [[ ! -d "$BASE_PATH" ]]; then
  echo "❌ ERROR: BASE_PATH does not exist: $BASE_PATH"
  exit 1
fi

FLUTTER_APP_DIR="$BASE_PATH/apps/flipper"
IOS_DIR="$FLUTTER_APP_DIR/ios"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

log_step "Writing secrets and Firebase config"

INDEX_PATH="$BASE_PATH/apps/flipper/ios/ci_scripts/web/index.html"
CONFIGDART_PATH="$BASE_PATH/packages/flipper_login/lib/config.dart"
SECRETS1_PATH="$BASE_PATH/apps/flipper/lib/secrets.dart"
SECRETS2_PATH="$BASE_PATH/packages/flipper_models/lib/secrets.dart"
FIREBASE1_PATH="$BASE_PATH/apps/flipper/lib/firebase_options.dart"
FIREBASE2_PATH="$BASE_PATH/packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="$BASE_PATH/apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="$BASE_PATH/apps/flipper/amplify/team-provider-info.json"
GOOGLE_SERVICES_PLIST_PATH="$IOS_DIR/GoogleService-Info.plist"

if [[ -n "$GOOGLE_SERVICE_INFO_PLIST_CONTENT" ]]; then
  write_to_file "$GOOGLE_SERVICE_INFO_PLIST_CONTENT" "$GOOGLE_SERVICES_PLIST_PATH"
else
  echo "⚠️ WARNING: GOOGLE_SERVICE_INFO_PLIST_CONTENT is not set"
fi

if [[ ! -f "$GOOGLE_SERVICES_PLIST_PATH" ]]; then
  echo "❌ ERROR: GoogleService-Info.plist is required at $GOOGLE_SERVICES_PLIST_PATH"
  exit 1
fi

GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)

if [[ -z "$GOOGLE_APP_ID" || -z "$FIREBASE_PROJECT_ID" || -z "$GCM_SENDER_ID" ]]; then
  echo "❌ ERROR: GoogleService-Info.plist is missing required Firebase keys"
  exit 1
fi

cat > "$IOS_DIR/firebase_app_id_file.json" <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
echo "✅ Wrote firebase_app_id_file.json"

write_to_file "$INDEX" "$INDEX_PATH"
write_to_file "$CONFIGDART" "$CONFIGDART_PATH"
write_to_file "$SECRETS1" "$SECRETS1_PATH"
write_to_file "$SECRETS2" "$SECRETS2_PATH"
write_to_file "$FIREBASE1" "$FIREBASE1_PATH"
write_to_file "$FIREBASE2" "$FIREBASE2_PATH"
write_to_file "$AMPLIFY_CONFIG" "$AMPLIFY_CONFIG_PATH"
write_to_file "$AMPLIFY_TEAM_PROVIDER" "$AMPLIFY_TEAM_PROVIDER_PATH"

log_step "Git submodules"

cd "$BASE_PATH"
git config --global core.autocrlf false

if [[ -f ".gitmodules" ]]; then
  git config --file .gitmodules --get-regexp 'submodule\..*\.url' || true
  run_with_heartbeat "git submodule sync" git submodule sync --recursive
  run_with_heartbeat "git submodule update" git submodule update --init --force --recursive
else
  echo "No .gitmodules file found"
fi

log_step "Flutter SDK"

FLUTTER_DIR="$HOME/flutter"
if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  FLUTTER_VERSION="${FLUTTER_VERSION:-3.41.9}"
  FLUTTER_ARCHIVE="flutter_macos_${FLUTTER_VERSION}-stable.zip"
  FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/$FLUTTER_ARCHIVE"
  echo "Downloading Flutter $FLUTTER_VERSION from $FLUTTER_URL"
  run_with_heartbeat "flutter sdk download" curl -fL --retry 3 --retry-delay 5 "$FLUTTER_URL" -o "/tmp/$FLUTTER_ARCHIVE"
  echo "Unzipping Flutter SDK..."
  run_with_heartbeat "flutter sdk unzip" unzip -o "/tmp/$FLUTTER_ARCHIVE" -d "$HOME"
  rm -f "/tmp/$FLUTTER_ARCHIVE"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version
run_with_heartbeat "flutter precache --ios" flutter precache --ios

log_step "Melos bootstrap (skip unused apps/examples)"

export PATH="$HOME/.pub-cache/bin:$PATH"
dart pub global activate melos 6.3.2
cd "$BASE_PATH"

# Skip other Flutter apps and example packages to save time.
# --verbose prints per-package progress so Xcode Cloud sees output.
run_with_heartbeat "melos bootstrap" \
  melos bootstrap --verbose \
  --ignore=flipper_auth \
  --ignore=flipper_ai \
  --ignore=flipper_web \
  --ignore=flipper_personal \
  --ignore='*example*'

log_step "CocoaPods CLI"

if ! command -v pod &>/dev/null; then
  echo "Installing CocoaPods via Homebrew..."
  run_with_heartbeat "brew install cocoapods" env HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
fi
pod --version

log_step "Post-clone complete"

echo "ℹ️ pod install and flutter build ios --config-only run in ci_pre_xcodebuild.sh"
echo ""
echo "✅ Post-clone setup completed successfully!"
log_heartbeat "script finished"
