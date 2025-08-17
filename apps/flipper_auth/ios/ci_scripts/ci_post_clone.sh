#!/bin/bash
set -e

echo "--- Starting ci_post_clone.sh for flipper_auth ---"

echo "--- Setting BASE_PATH ---"
echo "SRCROOT is: $SRCROOT"
BASE_PATH="$(cd "$(dirname "$SRCROOT")/../../../../" && pwd)"
echo "BASE_PATH is: $BASE_PATH"

echo "--- Defining SECRETS_PATH ---"
SECRETS_PATH="$BASE_PATH/apps/flipper_auth/lib/core/secrets.dart"
echo "SECRETS_PATH is: $SECRETS_PATH"

echo "--- Reading SECRETS_DART_CONTENT from environment variable ---"
if [ -z "$SECRETS_DART_CONTENT" ]; then
  echo "ERROR: SECRETS_DART_CONTENT environment variable is not set."
  exit 1
else
  echo "SECRETS_DART_CONTENT is set."
fi

# Function to write content to files with proper error handling
write_to_file() {
  local content="$1"
  local file_path="$2"
  
  if [[ -n "$content" ]]; then
    echo "--- Writing to file: $file_path ---"
    echo "Creating directory if it doesn't exist..."
    mkdir -p "$(dirname "$file_path")"
    echo "Directory created."
    
    echo "Writing content to file..."
    echo "$content" > "$file_path"
    echo "Content written."
    
    echo "✅ Successfully wrote content to $file_path"
  else
    echo "⚠️ Warning: Empty content, skipping $file_path" >&2
  fi
}

write_to_file "$SECRETS_DART_CONTENT" "$SECRETS_PATH"

echo "--- Changing to repo root ---"
echo "CI_PRIMARY_REPOSITORY_PATH is: $CI_PRIMARY_REPOSITORY_PATH"
cd "$CI_PRIMARY_REPOSITORY_PATH" || exit 1
pwd

echo "--- Installing Flutter ---"
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$HOME/flutter/bin:$PATH"
flutter --version

echo "--- Precaching iOS artifacts ---"
flutter precache --ios

echo "--- Navigating to Flutter app folder ---"
cd apps/flipper_auth || exit 1
pwd


echo "--- Cleaning old builds ---"
flutter clean



# Install Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
dart pub global activate melos 6.3.2


# Network diagnostics
ping -c 2 pub.dev || true
nslookup pub.dev || true

# Melos bootstrap with retries
for i in {1..3}; do
  melos bootstrap && break
  echo "Retrying melos bootstrap ($i/3)..."
  sleep 5
  if [[ $i -eq 3 ]]; then
    echo "❌ Melos bootstrap failed."
    exit 1
  fi
done


echo "--- Building iOS once to generate Generated.xcconfig ---"
flutter build ios --release --no-codesign


echo "--- Installing CocoaPods dependencies ---"
cd ios || exit 1
pwd
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
pod install
cd ../..
pwd

echo "--- Flutter build completed ---"
echo "--- ci_post_clone.sh for flipper_auth finished successfully ---"
