#!/bin/bash
set -e


BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"  # VERIFY THIS IN THE LOGS

# Define the destination path relative to BASE_PATH
SECRETS_PATH="$BASE_PATH/apps/flipper_auth/lib/core/secrets.dart"

# Get content from environment variables
SECRETS_CONTENT="${SECRETS_PATH:-{}}"

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
write_to_file "$SECRETS_CONTENT" "$SECRETS_PATH"
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
