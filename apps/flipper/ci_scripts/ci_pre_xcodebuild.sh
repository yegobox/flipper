#!/bin/bash
set -e  # Exit on error

echo "Configuring missing files in Xcode Cloud..."

echo "Running ci_post_clone.sh..."

# Ensure Flutter is installed
flutter --version || export PATH="$HOME/flutter/bin:$PATH"

# Get dependencies
flutter pub get
# Install CocoaPods dependencies
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..

# Generate iOS dependencies
cd ios
rm -rf Flutter/Generated.xcconfig  # Remove old xcconfig file
flutter build ios --no-codesign
cd ..

echo "Generated.xcconfig should now be available."

# Define file paths
INDEX_FILE="apps/flipper/web/index.html"
CONFIGDART_FILE="packages/flipper_login/lib/config.dart"
SECRETS_FILE="packages/flipper_models/lib/secrets.dart"
FIREBASE_OPTIONS_FLIPPER="apps/flipper/lib/firebase_options.dart"
FIREBASE_OPTIONS_MODELS="packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_FILE="apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_FILE="apps/flipper/amplify/team-provider-info.json"

# Write secrets to respective files
echo "$INDEX" > "$INDEX_FILE"
echo "$CONFIGDART" > "$CONFIGDART_FILE"
echo "$SECRETS" > "$SECRETS_FILE"
echo "$FIREBASEOPTIONS" > "$FIREBASE_OPTIONS_FLIPPER"
echo "$FIREBASEOPTIONS" > "$FIREBASE_OPTIONS_MODELS"
echo "$AMPLIFY_CONFIG" > "$AMPLIFY_CONFIG_FILE"
echo "$AMPLIFY_TEAM_PROVIDER" > "$AMPLIFY_TEAM_PROVIDER_FILE"

echo "Configuration files set up successfully for Xcode Cloud."
