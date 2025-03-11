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

# Extract the GOOGLE_APP_ID, FIREBASE_PROJECT_ID, and GCM_SENDER_ID from GoogleService-Info.plist
GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null)

# Validate that variables are not empty
if [[ -z "$GOOGLE_APP_ID" || -z "$FIREBASE_PROJECT_ID" || -z "$GCM_SENDER_ID" ]]; then
  echo "❌ ERROR: Missing Firebase configuration values. Check GoogleService-Info.plist."
  exit 1
fi

# Create the JSON content
JSON_CONTENT=$(cat <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID for this Firebase app in this directory",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
)

# Ensure the file is correctly named and placed in the right directory
echo "$JSON_CONTENT" > "$BASE_PATH/firebase_app_id_file.json"

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
write_to_file "INDEX" "$INDEX_PATH"
write_to_file "CONFIGDART" "$CONFIGDART_PATH"
write_to_file "SECRETS" "$SECRETS_PATH"
write_to_file "FIREBASEOPTIONS" "$FIREBASE_OPTIONS1_PATH"
write_to_file "FIREBASEOPTIONS" "$FIREBASE_OPTIONS2_PATH"
write_to_file "AMPLIFY_CONFIG" "$AMPLIFY_CONFIG_PATH"
write_to_file "AMPLIFY_TEAM_PROVIDER" "$AMPLIFY_TEAM_PROVIDER_PATH"

# Configure Git to prevent line ending conversion issues
git config --global core.autocrlf false

# Log actions for debugging
echo "✅ All environment variables have been written to their respective files."

# Ensure Ruby is available (Pre-installed in Xcode Cloud)
echo "🔄 Upgrading Ruby..."

# Install latest Ruby using Homebrew (if not installed)
if ! command -v ruby &> /dev/null || [[ "$(ruby -e 'puts RUBY_VERSION')" < "3.1.0" ]]; then
  brew install ruby
  export PATH="$(brew --prefix ruby)/bin:$PATH"
fi

echo "✅ Ruby version: $(ruby -v)"

# Ensure CocoaPods and FFI are installed correctly
echo "🔄 Ensuring FFI and CocoaPods are installed..."
gem install ffi cocoapods --user-install --no-document

# Ensure CocoaPods is accessible
export PATH="$HOME/.gem/ruby/$(ruby -e 'puts RUBY_VERSION')/bin:$PATH"

# Verify CocoaPods installation
echo "✅ CocoaPods version: $(pod --version)"

# ==========================
#  Install Flutter if missing
# ==========================
FLUTTER_VERSION="3.29.0"
FLUTTER_DIR="$HOME/flutter"

if ! command -v flutter &> /dev/null; then
  echo "🚀 Installing Flutter $FLUTTER_VERSION..."

  # Remove existing Flutter directory if any
  rm -rf "$FLUTTER_DIR"

  # Clone Flutter repo
  git clone --depth 1 --branch "stable" https://github.com/flutter/flutter.git "$FLUTTER_DIR"

  # Set Flutter in PATH
  export PATH="$FLUTTER_DIR/bin:$PATH"
  
  # Enable caching of Flutter binaries
  flutter precache

  # Check Flutter version
  flutter --version
else
  echo "✅ Flutter is already installed."
fi

# Ensure Flutter is in the PATH
export PATH="$FLUTTER_DIR/bin:$PATH"

# ==========================
# Install Dependencies
# ==========================

# Navigate to the repository root (assumes script is in `ios/ci_scripts/`)
cd "$BASE_PATH/../../.." || exit 1

# Install Dart & Flutter dependencies
flutter pub get

# ==========================
#  Install & Configure Melos
# ==========================

# Add Dart global bin directory to PATH
export PATH="$HOME/.pub-cache/bin:$PATH"

# Install Melos globally if not already installed
if ! command -v melos &> /dev/null; then
  echo "🔄 Installing Melos..."
  dart pub global activate melos 6.3.2
fi

# Verify Melos is available
if ! command -v melos &> /dev/null; then
  echo "❌ ERROR: Melos is still not found in PATH"
  exit 1
fi

# Run Melos bootstrap to link packages
echo "🔗 Running Melos Bootstrap..."
melos bootstrap

# Navigate back to the iOS project directory
cd "$BASE_PATH" || exit 1

# Install CocoaPods dependencies
rm -rf Pods Podfile.lock
pod install 

echo "✅ Post-clone setup completed successfully."
