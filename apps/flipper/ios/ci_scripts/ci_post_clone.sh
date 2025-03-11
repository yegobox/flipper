#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Adjust the base path to the correct root folder
BASE_PATH="$(cd "$(dirname "$SRCROOT")" && pwd)"

# Define the destination paths relative to BASE_PATH
INDEX_PATH="$BASE_PATH/web/index.html"
CONFIGDART_PATH="$BASE_PATH/../../packages/flipper_login/lib/config.dart"
SECRETS_PATH="$BASE_PATH/../../packages/flipper_models/lib/secrets.dart"
FIREBASE_OPTIONS1_PATH="$BASE_PATH/lib/firebase_options.dart"
FIREBASE_OPTIONS2_PATH="$BASE_PATH/../../packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="$BASE_PATH/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="$BASE_PATH/amplify/team-provider-info.json"
GOOGLE_SERVICES_PLIST_PATH="$BASE_PATH/ios/Runner/GoogleService-Info.plist"

# Extract Firebase configuration values from GoogleService-Info.plist
GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)

# Validate that variables are not empty
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

# Ensure the correct Ruby version is used in Xcode Cloud
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="$HOME/.gem/ruby/$(ruby -e 'puts RUBY_VERSION')/bin:$PATH"

# Install necessary Ruby gems in CI/CD
echo "🔄 Installing required Ruby gems..."
gem install ffi cocoapods drb --user-install --no-document
echo "✅ Ruby gems installed."

# Ensure CocoaPods is up-to-date
echo "🔄 Updating CocoaPods..."
pod repo update
echo "✅ CocoaPods repo updated."

# Ensure Flutter is installed
export PATH="$HOME/flutter/bin:$PATH"

# Install Flutter dependencies
echo "🔄 Running Flutter setup..."
cd "$BASE_PATH/../../.." || exit 1
flutter pub get

# Install & configure Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
if ! command -v melos &> /dev/null; then
  echo "🔄 Installing Melos..."
  dart pub global activate melos 6.3.2
fi
melos bootstrap

# Ensure sqlite3 version compatibility in CocoaPods
echo "🔄 Updating Podfile dependencies..."
cd "$BASE_PATH/ios" || exit 1
echo "pod 'sqlite3', '~> 3.48.0'" >> Podfile

# Reinstall CocoaPods dependencies
rm -rf Pods Podfile.lock
pod install --repo-update --verbose

echo "✅ Post-clone setup completed successfully."
