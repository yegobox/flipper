#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Adjust the base path to the correct root folder
# Adjust the base path to the correct root folder
BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"  # VERIFY THIS IN THE LOGS
# 
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

# Function to write environment variables to files
write_to_file() {
  local var_name="$1"
  local file_path="$2"
  local content="${!var_name}"  # Get the value of the variable

  if [[ -n "$content" ]]; then
    mkdir -p "$(dirname "$file_path")"  # Ensure directory exists
    echo "$content" > "$file_path"
    echo "✅ Successfully wrote $var_name to $file_path"
  else
    echo "⚠️ Warning: $var_name is empty, skipping $file_path" >&2
  fi
}

# Write environment variables to their respective files
write_to_file "SECRETS_PATH1" "$SECRETS_PATH1"
write_to_file "SECRETS_PATH2" "$SECRETS_PATH2"
write_to_file "FIREBASE_OPTIONS1_PATH" "$FIREBASE_OPTIONS1_PATH"
write_to_file "FIREBASE_OPTIONS2_PATH" "$FIREBASE_OPTIONS2_PATH"

write_to_file "INDEX" "$INDEX_PATH"
write_to_file "CONFIGDART" "$CONFIGDART_PATH"
write_to_file "AMPLIFY_CONFIG" "$AMPLIFY_CONFIG_PATH"
write_to_file "AMPLIFY_TEAM_PROVIDER" "$AMPLIFY_TEAM_PROVIDER_PATH"


# Prevent Git from converting line endings
git config --global core.autocrlf false

# Ensure correct Ruby version (at least 3.2.2)
REQUIRED_RUBY_VERSION="3.2.2"
CURRENT_RUBY_VERSION=$(ruby -e 'puts RUBY_VERSION' 2>/dev/null || echo "0.0.0")

if [[ "$(printf '%s\n' "$REQUIRED_RUBY_VERSION" "$CURRENT_RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_RUBY_VERSION" ]]; then
  echo "🔄 Upgrading Ruby..."
  brew install rbenv
  rbenv install 3.2.2  # Install latest stable Ruby version
  rbenv global 3.2.2   # Set it as the default version
  export PATH="$HOME/.rbenv/shims:$PATH"
  echo "✅ Ruby upgraded to: $(ruby -v)"
else
  echo "✅ Ruby version is sufficient: $(ruby -v)"
fi


# Ensure correct gem paths
export PATH="$HOME/.gem/ruby/$(ruby -e 'puts RUBY_VERSION')/bin:$PATH"

# Install required Ruby gems
echo "🔄 Installing required Ruby gems..."
# gem install ffi cocoapods drb --user-install --no-document
echo "✅ Ruby gems installed."


# Ensure CocoaPods is installed
if ! command -v pod &> /dev/null; then
  echo "🔄 Installing CocoaPods..."
  gem install cocoapods --user-install --no-document
fi
echo "✅ CocoaPods version: $(pod --version)"

# Install Flutter if missing
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="$HOME/flutter"

if ! command -v flutter &> /dev/null; then
  echo "🚀 Installing Flutter $FLUTTER_VERSION..."
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 --branch "stable" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  export PATH="$FLUTTER_DIR/bin:$PATH"
  flutter precache
  flutter --version
  echo "✅ Flutter installed successfully."
else
  echo "✅ Flutter is already installed."
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

# Install & configure Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
if ! command -v melos &> /dev/null; then
  echo "🔄 Installing Melos..."
  dart pub global activate melos 6.3.2
fi

melos bootstrap

echo "✅ Melos setup completed successfully."

# Install Flutter dependencies
cd "$BASE_PATH/apps/flipper" || exit 1

echo "🔄 Navigated into apps/flipper"

cd ios || exit 1
echo "🔄 Navigated into apps/flipper/ios"
pod install

echo "✅ Post-clone setup completed successfully."
