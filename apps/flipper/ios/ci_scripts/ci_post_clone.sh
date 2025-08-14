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

# Get content from environment variables
INDEX_CONTENT="${INDEX:-{}}"
CONFIGDART_CONTENT="${CONFIGDART:-{}}"
SECRETS_CONTENT="${SECRETS_PATH:-{}}"
SECRETS_PATH2_CONTENT="${SECRETS_PATH2:-{}}"
FIREBASE_OPTIONS_CONTENT="${FIREBASE_OPTIONS2_PATH:-{}}"
FIREBASE_OPTIONS2_CONTENT="${FIREBASE_OPTIONS2_PATH:-{}}"
AMPLIFY_CONFIG_CONTENT="${AMPLIFY_CONFIG:-{}}"
AMPLIFY_TEAM_PROVIDER_CONTENT="${AMPLIFY_TEAM_PROVIDER:-{}}"

# Function to write content to files with proper error handling
write_to_file() {
  local content="$1"
  local file_path="$2"
  
  if [[ -n "$content" ]]; then
    echo "🔍 Content to be written to $file_path:"
    echo "$content" | head -n 10  # Show first 10 lines of content
    if [[ $(echo "$content" | wc -l) -gt 10 ]]; then
      echo "...(truncated)"
    fi
    
    mkdir -p "$(dirname "$file_path")" || {
      echo "❌ ERROR: Failed to create directory for $file_path" >&2
      exit 1
    }
    echo "$content" > "$file_path" || {
      echo "❌ ERROR: Failed to write to $file_path" >&2
      exit 1
    }
    echo "✅ Successfully wrote content to $file_path"
  else
    echo "⚠️ Warning: Empty content, skipping $file_path" >&2
  fi
}

# Write environment variables with proper content
write_to_file "$INDEX_CONTENT" "$INDEX_PATH"
write_to_file "$CONFIGDART_CONTENT" "$CONFIGDART_PATH"
write_to_file "$SECRETS_CONTENT" "$SECRETS_PATH1"
write_to_file "$SECRETS_PATH2_CONTENT" "$SECRETS_PATH2"
write_to_file "$FIREBASE_OPTIONS_CONTENT" "$FIREBASE_OPTIONS1_PATH"
write_to_file "$FIREBASE_OPTIONS2_CONTENT" "$FIREBASE_OPTIONS2_PATH"
write_to_file "$AMPLIFY_CONFIG_CONTENT" "$AMPLIFY_CONFIG_PATH"
write_to_file "$AMPLIFY_TEAM_PROVIDER_CONTENT" "$AMPLIFY_TEAM_PROVIDER_PATH"

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

# Fix gem conflicts with proper error handling
echo "🔄 Fixing gem conflicts..."
gem uninstall -aIx rexml xcodeproj || {
  echo "⚠️ Warning: Failed to uninstall gems, continuing..." >&2
}
gem install rexml -v 3.3.6 --user-install --no-document || {
  echo "❌ ERROR: Failed to install rexml" >&2
  exit 1
}
gem install xcodeproj --user-install --no-document || {
  echo "❌ ERROR: Failed to install xcodeproj" >&2
  exit 1
}
echo "✅ Gems fixed."

# Install required Ruby gems with proper error handling
echo "🔄 Installing required Ruby gems..."
gem install ffi cocoapods --user-install --no-document || {
  echo "❌ ERROR: Failed to install required gems" >&2
  exit 1
}
echo "✅ Ruby gems installed."

# Ensure CocoaPods is installed with proper error handling
if ! command -v pod &> /dev/null; then
  echo "🔄 Installing CocoaPods..."
  gem install cocoapods --user-install --no-document || {
    echo "❌ ERROR: Failed to install CocoaPods" >&2
    exit 1
  }
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

# Add cleanup trap for temporary files
trap 'rm -f "$BASE_PATH/firebase_app_id_file.json"' EXIT

# --- Network Debugging ---
echo "--- Running Network Diagnostics ---"
echo "--- Pinging pub.dev ---"
ping -c 5 pub.dev || echo "Ping failed, continuing..."
echo "--- nslookup pub.dev ---"
nslookup pub.dev || echo "nslookup failed, continuing..."
echo "--- curl pub.dev ---"
curl -v https://pub.dev || echo "curl failed, continuing..."
echo "--- Network Diagnostics Finished ---"

# Add explicit error handling for melos bootstrap with retries
echo "🔄 Running melos bootstrap..."
MAX_RETRIES=3
RETRY_COUNT=0
until melos bootstrap; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "❌ ERROR: melos bootstrap failed after $MAX_RETRIES attempts." >&2
    exit 1
  fi
  echo "⚠️ melos bootstrap failed. Retrying in 5 seconds... (Attempt $RETRY_COUNT/$MAX_RETRIES)"
  sleep 5
done
echo "✅ Melos setup completed successfully."

# Install Flutter dependencies
cd "$BASE_PATH/apps/flipper" || exit 1
echo "🔄 Navigated into apps/flipper"

cd ios || exit 1
echo "🔄 Navigated into apps/flipper/ios"

# Add explicit error handling for pod install
echo "🔄 Running pod install..."
if [[ -f "Gemfile" ]]; then
  echo "🔄 Using Bundler for pod install..."
  bundle install || {
    echo "❌ ERROR: bundle install failed" >&2
    exit 1
  }
  bundle exec pod install || {
    echo "❌ ERROR: bundle exec pod install failed" >&2
    exit 1
  }
else
  pod install || {
    echo "❌ ERROR: pod install failed" >&2
    exit 1
  }
fi
echo "✅ Post-clone setup completed successfully."
