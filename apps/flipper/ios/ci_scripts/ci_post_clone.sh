#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Adjust the base path to the correct root folder
BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"

# Define the destination paths relative to BASE_PATH
INDEX_PATH="$BASE_PATH/apps/flipper/ios/ci_scripts/web/index.html"
CONFIGDART_PATH="$BASE_PATH/packages/flipper_login/lib/config.dart"
SECRETS_PATH1="$BASE_PATH/apps/flipper/lib/secrets.dart" 
SECRETS_PATH2="$BASE_PATH/packages/flipper_models/lib/secrets.dart"
FIREBASE_OPTIONS1_PATH="$BASE_PATH/apps/flipper/lib/firebase_options.dart"
FIREBASE_OPTIONS2_PATH="$BASE_PATH/packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="$BASE_PATH/apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="$BASE_PATH/apps/flipper/amplify/team-provider-info.json"
GOOGLE_SERVICES_PLIST_PATH="$BASE_PATH/apps/flipper/ios/GoogleService-Info.plist"

# Extract Firebase configuration values
GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)

# Validate Firebase configuration
if [[ -z "$GOOGLE_APP_ID" || -z "$FIREBASE_PROJECT_ID" || -z "$GCM_SENDER_ID" ]]; then
  echo "❌ ERROR: Missing Firebase configuration values. Check GoogleService-Info.plist."
  exit 1
fi

# Create JSON configuration file
echo "{
  \"file_generated_by\": \"FlutterFire CLI\",
  \"purpose\": \"FirebaseAppID & ProjectID\",
  \"GOOGLE_APP_ID\": \"$GOOGLE_APP_ID\",
  \"FIREBASE_PROJECT_ID\": \"$FIREBASE_PROJECT_ID\",
  \"GCM_SENDER_ID\": \"$GCM_SENDER_ID\"
}" > "$BASE_PATH/firebase_app_id_file.json"

echo "✅ firebase_app_id_file.json has been generated successfully."

# Function to write content to files
write_to_file() {
  local content="$1"
  local file_path="$2"

  if [[ -n "$content" ]]; then
    echo "🔍 Writing to $file_path..."
    mkdir -p "$(dirname "$file_path")" || exit 1
    echo "$content" > "$file_path" || exit 1
    echo "✅ Wrote content to $file_path"
  else
    echo "⚠️ Warning: Empty content for $file_path"
  fi
}

# Write environment variables
write_to_file "${INDEX:-{}}" "$INDEX_PATH"
write_to_file "${CONFIGDART:-{}}" "$CONFIGDART_PATH"
write_to_file "${SECRETS_PATH:-{}}" "$SECRETS_PATH1"
write_to_file "${SECRETS_PATH2:-{}}" "$SECRETS_PATH2"
write_to_file "${FIREBASE_OPTIONS2_PATH:-{}}" "$FIREBASE_OPTIONS1_PATH"
write_to_file "${FIREBASE_OPTIONS2_PATH:-{}}" "$FIREBASE_OPTIONS2_PATH"
write_to_file "${AMPLIFY_CONFIG:-{}}" "$AMPLIFY_CONFIG_PATH"
write_to_file "${AMPLIFY_TEAM_PROVIDER:-{}}" "$AMPLIFY_TEAM_PROVIDER_PATH"

# Prevent Git from converting line endings
git config --global core.autocrlf false

# Ensure correct Ruby version
REQUIRED_RUBY_VERSION="3.2.2"
CURRENT_RUBY_VERSION=$(ruby -e 'puts RUBY_VERSION' 2>/dev/null || echo "0.0.0")

if [[ "$(printf '%s\n' "$REQUIRED_RUBY_VERSION" "$CURRENT_RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_RUBY_VERSION" ]]; then
  echo "🔄 Installing Ruby $REQUIRED_RUBY_VERSION..."
  brew install rbenv
  rbenv install $REQUIRED_RUBY_VERSION
  rbenv global $REQUIRED_RUBY_VERSION
else
  echo "✅ Ruby version is OK: $(ruby -v)"
fi

# Fix gem conflicts
gem uninstall -aIx rexml xcodeproj || true
gem install rexml -v 3.3.6 --user-install --no-document
gem install xcodeproj --user-install --no-document
gem install ffi cocoapods --user-install --no-document

# Install Flutter if missing
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="$HOME/flutter"

if ! command -v flutter &> /dev/null; then
  echo "🚀 Installing Flutter..."
  git clone --depth 1 --branch "stable" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  export PATH="$FLUTTER_DIR/bin:$PATH"
  flutter precache
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

# Install Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
dart pub global activate melos 6.3.2

# Cleanup temporary file on exit
trap 'rm -f "$BASE_PATH/firebase_app_id_file.json"' EXIT

# Network diagnostics (optional)
ping -c 2 pub.dev || true
nslookup pub.dev || true
curl -v https://pub.dev || true

# Melos bootstrap
MAX_RETRIES=3
RETRY_COUNT=0
until melos bootstrap; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "❌ Melos bootstrap failed."
    exit 1
  fi
  echo "Retrying melos bootstrap ($RETRY_COUNT/$MAX_RETRIES)..."
  sleep 5
done

# CocoaPods Handling
cd "$BASE_PATH/apps/flipper/ios" || exit 1
echo "📂 In apps/flipper/ios"

# Ensure sqlite3 is updated to match plugin requirements
echo "🔄 Updating sqlite3 pod..."
pod update sqlite3 || echo "⚠️ Could not update sqlite3, will retry later."

# Update CocoaPods specs repo
pod repo update || echo "⚠️ Skipping 'pod repo update' due to network issues..."

run_pod_install() {
  rm -f Podfile.lock
  if [[ -f "Gemfile" ]]; then
    bundle install || return 1
    bundle exec pod install
  else
    pod install
  fi
}

if ! run_pod_install; then
  echo "⚠️ pod install failed. Trying targeted pod updates..."
  pod update sqlite3 GoogleSignIn || true
  if ! run_pod_install; then
    echo "🔄 Full pod update as last resort..."
    pod update || exit 1
  fi
fi

echo "✅ Post-clone setup completed successfully."
