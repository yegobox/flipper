#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Adjust the base path to the correct root folder
BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"  # VERIFY THIS IN THE LOGS

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

# Define required environment variables
REQUIRED_ENV_VARS=(
  "SECRETS_CONTENT_1"
  "SECRETS_CONTENT_2"
  "FIREBASE_OPTIONS1_CONTENT"
  "FIREBASE_OPTIONS2_CONTENT"
  "INDEX_HTML_CONTENT"
  "CONFIG_DART_CONTENT"
  "AMPLIFY_CONFIG_CONTENT"
  "AMPLIFY_TEAM_PROVIDER_CONTENT"
)

# Optional environment variables - script will continue if these are missing
OPTIONAL_ENV_VARS=()

# Check if required environment variables are set
MISSING_VARS=0
echo "🔍 Checking required environment variables..."
for var_name in "${REQUIRED_ENV_VARS[@]}"; do
  if [[ -z "${!var_name}" ]]; then
    echo "❌ Required environment variable $var_name is not set or empty!"
    MISSING_VARS=$((MISSING_VARS+1))
  else
    echo "✅ Found environment variable: $var_name"
  fi
done

# Exit if any required environment variables are missing
if [[ $MISSING_VARS -gt 0 ]]; then
  echo "❌ ERROR: $MISSING_VARS required environment variables are missing!"
  echo "⚠️ Make sure these environment variables are properly defined in your Xcode scheme"
  echo "⚠️ and marked to be passed to the build script."
  exit 1
fi

# Function to write environment variables to files
write_to_file() {
  local var_name="$1"    # Name of the env var containing content
  local file_path="$2"   # Destination file path
  local is_required="${3:-true}"  # Is this a required file? Default: true
  local content="${!var_name}"

  echo "📝 Processing $var_name -> $file_path"
  
  if [[ -n "$content" ]]; then
    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
    echo "✅ Successfully wrote $var_name to $file_path"
    # Verify the file was created and has content
    if [[ ! -s "$file_path" ]]; then
      echo "❌ ERROR: File $file_path was created but is empty!"
      [[ "$is_required" == "true" ]] && exit 1
    fi
  else
    echo "⚠️ Warning: $var_name is empty" >&2
    if [[ "$is_required" == "true" ]]; then
      echo "❌ ERROR: Required variable $var_name is empty, cannot create $file_path" >&2
      exit 1
    else
      echo "⚠️ Skipping optional file $file_path" >&2
    fi
  fi
}

echo "📋 Writing environment variables to files..."

# Write environment variables (content) to the correct file paths
write_to_file "SECRETS_CONTENT_1" "$SECRETS_PATH1"
write_to_file "SECRETS_CONTENT_2" "$SECRETS_PATH2"
write_to_file "FIREBASE_OPTIONS1_CONTENT" "$FIREBASE_OPTIONS1_PATH"
write_to_file "FIREBASE_OPTIONS2_CONTENT" "$FIREBASE_OPTIONS2_PATH"
write_to_file "INDEX_HTML_CONTENT" "$INDEX_PATH"
write_to_file "CONFIG_DART_CONTENT" "$CONFIGDART_PATH"
write_to_file "AMPLIFY_CONFIG_CONTENT" "$AMPLIFY_CONFIG_PATH"
write_to_file "AMPLIFY_TEAM_PROVIDER_CONTENT" "$AMPLIFY_TEAM_PROVIDER_PATH"

# Verify all required files were created
echo "🔍 Verifying files were created properly..."
ALL_PATHS=(
  "$SECRETS_PATH1"
  "$SECRETS_PATH2"
  "$FIREBASE_OPTIONS1_PATH"
  "$FIREBASE_OPTIONS2_PATH"
  "$INDEX_PATH"
  "$CONFIGDART_PATH"
  "$AMPLIFY_CONFIG_PATH"
  "$AMPLIFY_TEAM_PROVIDER_PATH"
)

MISSING_FILES=0
for file_path in "${ALL_PATHS[@]}"; do
  if [[ ! -f "$file_path" ]]; then
    echo "❌ ERROR: File not created: $file_path"
    MISSING_FILES=$((MISSING_FILES+1))
  elif [[ ! -s "$file_path" ]]; then
    echo "❌ ERROR: File exists but is empty: $file_path"
    MISSING_FILES=$((MISSING_FILES+1))
  else
    echo "✅ File created successfully: $file_path"
  fi
done

if [[ $MISSING_FILES -gt 0 ]]; then
  echo "❌ ERROR: $MISSING_FILES files were not created properly!"
  exit 1
fi

echo "✅ All environment variables were successfully copied to their files."

# Prevent Git from converting line endings
git config --global core.autocrlf false

# Ensure correct Ruby version
REQUIRED_RUBY_VERSION="3.2.2"
CURRENT_RUBY_VERSION=$(ruby -e 'puts RUBY_VERSION' 2>/dev/null || echo "0.0.0")

if [[ "$(printf '%s\n' "$REQUIRED_RUBY_VERSION" "$CURRENT_RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_RUBY_VERSION" ]]; then
  echo "🔄 Upgrading Ruby..."
  brew install rbenv
  rbenv install 3.2.2
  rbenv global 3.2.2
  export PATH="$HOME/.rbenv/shims:$PATH"
  echo "✅ Ruby upgraded to: $(ruby -v)"
else
  echo "✅ Ruby version is sufficient: $(ruby -v)"
fi

# Ensure correct gem paths
export PATH="$HOME/.gem/ruby/$(ruby -e 'puts RUBY_VERSION')/bin:$PATH"

# Fix rexml & xcodeproj issue
echo "🔄 Fixing gem conflicts..."
gem uninstall -aIx rexml xcodeproj
gem install rexml -v 3.3.6 --user-install --no-document
gem install xcodeproj --user-install --no-document
echo "✅ Gems fixed."

# Install required Ruby gems
echo "🔄 Installing required Ruby gems..."
gem install ffi cocoapods --user-install --no-document
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

# Use Bundler if a Gemfile exists
if [[ -f "Gemfile" ]]; then
  echo "🔄 Using Bundler for pod install..."
  bundle install
  bundle exec pod install
else
  pod install
fi

echo "✅ Post-clone setup completed successfully."