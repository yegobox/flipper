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
