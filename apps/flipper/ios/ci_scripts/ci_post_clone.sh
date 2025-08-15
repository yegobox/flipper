#!/bin/bash
set -e

echo "🚀 Starting ci_post_clone.sh for flipper ---"

# Adjust the base path to the correct root folder
BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"

# Define file paths
INDEX_PATH="$BASE_PATH/apps/flipper/ios/ci_scripts/web/index.html"
CONFIGDART_PATH="$BASE_PATH/packages/flipper_login/lib/config.dart"
SECRETS1_PATH="$BASE_PATH/apps/flipper/lib/secrets.dart" 
SECRETS2_PATH="$BASE_PATH/packages/flipper_models/lib/secrets.dart"
FIREBASE1_PATH="$BASE_PATH/apps/flipper/lib/firebase_options.dart"
FIREBASE2_PATH="$BASE_PATH/packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="$BASE_PATH/apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="$BASE_PATH/apps/flipper/amplify/team-provider-info.json"
GOOGLE_SERVICES_PLIST_PATH="$BASE_PATH/apps/flipper/ios/GoogleService-Info.plist"

# Extract Firebase values
GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)

if [[ -z "$GOOGLE_APP_ID" || -z "$FIREBASE_PROJECT_ID" || -z "$GCM_SENDER_ID" ]]; then
  echo "❌ ERROR: Missing Firebase configuration values."
  exit 1
fi

# Create temporary Firebase App ID file
cat > "$BASE_PATH/firebase_app_id_file.json" <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
echo "✅ firebase_app_id_file.json generated."

# Helper to write files from env vars
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

# Write files from environment variables
write_to_file "$INDEX" "$INDEX_PATH"
write_to_file "$CONFIGDART" "$CONFIGDART_PATH"
write_to_file "$SECRETS1" "$SECRETS1_PATH"
write_to_file "$SECRETS2" "$SECRETS2_PATH"
write_to_file "$FIREBASE1" "$FIREBASE1_PATH"
write_to_file "$FIREBASE2" "$FIREBASE2_PATH"
write_to_file "$AMPLIFY_CONFIG" "$AMPLIFY_CONFIG_PATH"
write_to_file "$AMPLIFY_TEAM_PROVIDER" "$AMPLIFY_TEAM_PROVIDER_PATH"

# Prevent Git from changing line endings
git config --global core.autocrlf false

# Install Flutter if missing
FLUTTER_DIR="$HOME/flutter"
if ! command -v flutter &> /dev/null; then
  echo "📦 Installing Flutter..."
  git clone --depth 1 --branch "stable" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  export PATH="$FLUTTER_DIR/bin:$PATH"
  flutter precache
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

# Install Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
dart pub global activate melos 6.3.2

# Cleanup temp file at exit
trap 'rm -f "$BASE_PATH/firebase_app_id_file.json"' EXIT

# Network diagnostics
ping -c 2 pub.dev || true
nslookup pub.dev || true

# Melos bootstrap with retries
for i in {1..3}; do
  melos bootstrap && break
  echo "Retrying melos bootstrap ($i/3)..."
  sleep 5
  if [[ $i -eq 3 ]]; then
    echo "❌ Melos bootstrap failed."
    exit 1
  fi
done


# CocoaPods setup
cd "$BASE_PATH/apps/flipper/ios"
echo "📂 In $(pwd)"

# Install CocoaPods
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
pod repo update || echo "⚠️ Skipped pod repo update."

# Targeted pod update for sqlite3
pod update sqlite3 || echo "⚠️ sqlite3 update failed, will retry later."

run_pod_install() {
  rm -f Podfile.lock
  pod install || return 1
}

if ! run_pod_install; then
  echo "⚠️ pod install failed. Trying targeted updates..."
  pod update sqlite3 GoogleSignIn || true
  if ! run_pod_install; then
    echo "🔄 Running full pod update..."
    pod update || exit 1
  fi
fi



# -------------------------
# Prepare iOS Release Config
# -------------------------
echo "⚙️ Preparing Flutter iOS release configuration..."
cd "$BASE_PATH/apps/flipper"
flutter build ios --config-only --release

echo "✅ Post-clone setup completed successfully."
