#!/bin/bash

# Define the destination paths
INDEX_PATH="${SRCROOT}/apps/flipper/web/index.html"
CONFIGDART_PATH="${SRCROOT}/packages/flipper_login/lib/config.dart"
SECRETS_PATH="${SRCROOT}/packages/flipper_models/lib/secrets.dart"
FIREBASE_OPTIONS1_PATH="${SRCROOT}/apps/flipper/lib/firebase_options.dart"
FIREBASE_OPTIONS2_PATH="${SRCROOT}/packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="${SRCROOT}/apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="${SRCROOT}/apps/flipper/amplify/team-provider-info.json"

# Write environment variables to the respective files
echo "$INDEX" > "$INDEX_PATH"
echo "$CONFIGDART" > "$CONFIGDART_PATH"
echo "$SECRETS" > "$SECRETS_PATH"
echo "$FIREBASEOPTIONS" > "$FIREBASE_OPTIONS1_PATH"
echo "$FIREBASEOPTIONS" > "$FIREBASE_OPTIONS2_PATH"
echo "$AMPLIFY_CONFIG" > "$AMPLIFY_CONFIG_PATH"
echo "$AMPLIFY_TEAM_PROVIDER" > "$AMPLIFY_TEAM_PROVIDER_PATH"

# Configure Git to prevent line ending conversion issues
git config --global core.autocrlf false

# Log actions for debugging (optional)
echo "Environment variables have been written to their respective files."
echo "Writing INDEX to: $INDEX_PATH"
echo "INDEX content: $INDEX"
