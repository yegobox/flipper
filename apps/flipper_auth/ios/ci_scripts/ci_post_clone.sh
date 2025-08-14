#!/bin/bash
set -e


BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"  # VERIFY THIS IN THE LOGS

# Define the destination paths relative to BASE_PATH
SECRETS_PATH1="$BASE_PATH/apps/flipper_auth/lib/secrets.dart" 

# Go to repo root
cd $CI_PRIMARY_REPOSITORY_PATH

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

# Precache iOS artifacts
flutter precache --ios

# Navigate to your Flutter app folder
cd apps/flipper_auth

# Clean old builds
flutter clean

# Install dependencies
flutter pub get

# Build iOS once to generate Generated.xcconfig
flutter build ios --release --no-codesign

# Install CocoaPods dependencies
cd ios
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
pod install
cd ../..

echo "=== Flutter build completed ==="
