#!/bin/bash

# Exit if any command fails
set -e
# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods



echo "=== Running Flutter build for iOS in Xcode Cloud ==="

# Navigate to the Flutter project root (flipper_auth)
# Xcode Cloud typically clones the repo into /Volumes/workspace/repository
# and then runs scripts from the project root.
# Adjust this path if your project structure is different in Xcode Cloud.
# cd "$CI_WORKSPACE/apps/flipper_auth"


# Install CocoaPods dependencie
cd  "$CI_WORKSPACE/apps/flipper_auth/ios"  && pod install # run `pod install` in the `ios` directory.



# Ensure Flutter is available (Xcode Cloud usually handles this, but good to be explicit)
# If Flutter is not in PATH, you might need to add:
# export PATH="$HOME/flutter/bin:$PATH"
# flutter --version

# Get Flutter dependencies
flutter pub get


# Build the Flutter iOS project
# This command generates the Generated.xcconfig and other necessary files.
cd "$CI_WORKSPACE/apps/flipper_auth" && flutter build ios --release --no-codesign

echo "=== Flutter build completed ==="

exit 0