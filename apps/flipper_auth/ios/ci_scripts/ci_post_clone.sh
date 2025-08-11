#!/bin/bash
set -e  # Exit on any error

# 1. Setup Flutter
echo "=== Setting up Flutter ==="
if [ ! -d "$HOME/flutter" ]; then
  echo "Installing Flutter..."
  git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
fi
export PATH="$HOME/flutter/bin:$PATH"
flutter --version

# 2. Navigate to project
echo "=== Changing to project directory ==="
cd /Volumes/workspace/repository/apps/flipper_auth
pwd
ls -la

# 3. Clean and prepare
echo "=== Cleaning and preparing build ==="
flutter clean
rm -f ios/Flutter/*.xcconfig
flutter pub get

# 4. Build Flutter
echo "=== Building Flutter for iOS ==="
flutter build ios --release --no-codesign --verbose

# 5. Verify critical files
echo "=== Verifying generated files ==="
if [ ! -f "ios/Flutter/Release.xcconfig" ]; then
  echo "ERROR: Release.xcconfig not found!"
  echo "Contents of ios/Flutter:"
  ls -la ios/Flutter/
  exit 1
fi

echo "=== Build completed successfully ==="
echo "Release.xcconfig contents:"
cat ios/Flutter/Release.xcconfig