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

cd ..
# Install dependencies
pod install --repo-update


