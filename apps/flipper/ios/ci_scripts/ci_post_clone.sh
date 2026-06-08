#!/bin/bash
set -e

# Helper for debug logging
log_step() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔵 STEP: $1"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# Helper to write files from env vars
write_to_file() {
  local content="$1"
  local file_path="$2"
  if [[ -n "$content" ]]; then
    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
    echo "✅ Wrote to $file_path"
  else
    echo "⚠️ Skipped $file_path (empty content)"
  fi
}

echo "🚀 Starting ci_post_clone.sh for flipper ---"

log_step "Determining Base Path"

# Adjust the base path to the correct root folder
if [[ -n "${CI_PRIMARY_REPOSITORY_PATH:-}" ]]; then
  BASE_PATH="$CI_PRIMARY_REPOSITORY_PATH"
  echo "Using CI_PRIMARY_REPOSITORY_PATH as BASE_PATH: $BASE_PATH"
elif [[ -n "${CI_WORKSPACE:-}" ]]; then
  BASE_PATH="$CI_WORKSPACE"
  echo "Using CI_WORKSPACE as BASE_PATH: $BASE_PATH"
else
  # Fallback for local testing or non-Xcode Cloud envs
  # SCRIPT_DIR is apps/flipper/ios/ci_scripts
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BASE_PATH="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
  echo "Using relative BASE_PATH: $BASE_PATH"
fi
echo "BASE_PATH is: $BASE_PATH"

# Verify base path exists
if [[ ! -d "$BASE_PATH" ]]; then
  echo "❌ ERROR: BASE_PATH does not exist: $BASE_PATH"
  exit 1
fi

log_step "Setting Up File Paths"

# Define file paths
INDEX_PATH="$BASE_PATH/apps/flipper/ios/ci_scripts/web/index.html"
CONFIGDART_PATH="$BASE_PATH/packages/flipper_login/lib/config.dart"
SECRETS1_PATH="$BASE_PATH/apps/flipper/lib/secrets.dart"
SECRETS2_PATH="$BASE_PATH/packages/flipper_models/lib/secrets.dart"
FIREBASE1_PATH="$BASE_PATH/apps/flipper/lib/firebase_options.dart"
FIREBASE2_PATH="$BASE_PATH/packages/flipper_models/lib/firebase_options.dart"
AMPLIFY_CONFIG_PATH="$BASE_PATH/apps/flipper/lib/amplifyconfiguration.dart"
AMPLIFY_TEAM_PROVIDER_PATH="$BASE_PATH/apps/flipper/amplify/team-provider-info.json"
GOOGLE_SERVICES_PLIST_PATH="$BASE_PATH/apps/flipper/ios/GoogleService-Info.plist"

log_step "Processing Firebase Configuration"

# Extract Firebase values

if [[ -n "$GOOGLE_SERVICE_INFO_PLIST_CONTENT" ]]; then
  write_to_file "$GOOGLE_SERVICE_INFO_PLIST_CONTENT" "$GOOGLE_SERVICES_PLIST_PATH"
else
  echo "⚠️ WARNING: GOOGLE_SERVICE_INFO_PLIST_CONTENT environment variable is not set"
fi

echo "Checking for GoogleService-Info.plist at $GOOGLE_SERVICES_PLIST_PATH"
if [[ -f "$GOOGLE_SERVICES_PLIST_PATH" ]]; then
    echo "✅ File exists."
else
    echo "❌ File does NOT exist."
    echo "Listing ios directory content:"
    ls -l "$BASE_PATH/apps/flipper/ios/" || echo "Failed to list directory."
    echo "❌ ERROR: GoogleService-Info.plist is required but not found."
    echo "Please ensure GOOGLE_SERVICE_INFO_PLIST_CONTENT environment variable is set in Xcode Cloud."
    exit 1
fi

GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)
GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$GOOGLE_SERVICES_PLIST_PATH" 2>/dev/null || true)

echo "Extracted Firebase values:"
echo "  GOOGLE_APP_ID: ${GOOGLE_APP_ID:-[MISSING]}"
echo "  FIREBASE_PROJECT_ID: ${FIREBASE_PROJECT_ID:-[MISSING]}"
echo "  GCM_SENDER_ID: ${GCM_SENDER_ID:-[MISSING]}"

if [[ -z "$GOOGLE_APP_ID" || -z "$FIREBASE_PROJECT_ID" || -z "$GCM_SENDER_ID" ]]; then
  echo "❌ ERROR: Missing Firebase configuration values."
  echo "Please verify GoogleService-Info.plist contains all required fields."
  exit 1
fi

# Create temporary Firebase App ID file
cat > "$BASE_PATH/apps/flipper/ios/firebase_app_id_file.json" <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
echo "✅ firebase_app_id_file.json generated at $BASE_PATH/apps/flipper/ios/firebase_app_id_file.json."

log_step "Writing Environment Configuration Files"

# Write files from environment variables
write_to_file "$INDEX" "$INDEX_PATH"
write_to_file "$CONFIGDART" "$CONFIGDART_PATH"
write_to_file "$SECRETS1" "$SECRETS1_PATH"
write_to_file "$SECRETS2" "$SECRETS2_PATH"
write_to_file "$FIREBASE1" "$FIREBASE1_PATH"
write_to_file "$FIREBASE2" "$FIREBASE2_PATH"
write_to_file "$AMPLIFY_CONFIG" "$AMPLIFY_CONFIG_PATH"
write_to_file "$AMPLIFY_TEAM_PROVIDER" "$AMPLIFY_TEAM_PROVIDER_PATH"

log_step "Configuring Git Settings"

# Prevent Git from changing line endings
git config --global core.autocrlf false

log_step "Checking Git Submodule Access"

cd "$BASE_PATH"
if [[ -f ".gitmodules" ]]; then
  echo "Submodule repositories required by the Flutter workspace:"
  git config --file .gitmodules --get-regexp 'submodule\..*\.url' || true
  git submodule sync --recursive
  if ! git submodule update --init --force --recursive; then
    echo "❌ ERROR: Could not initialize one or more submodules."
    echo "Authorize the yegobox submodule repositories in App Store Connect → Xcode Cloud."
    echo "A PAT inside ci_post_clone.sh cannot fix the pre-clone 'additional repository requires authorization' error."
    exit 1
  fi
else
  echo "No .gitmodules file found at $BASE_PATH"
fi

log_step "Installing Flutter"

# Install Flutter if missing
FLUTTER_DIR="$HOME/flutter"
if ! command -v flutter &> /dev/null; then
  echo "📦 Installing Flutter..."
  FLUTTER_VERSION="${FLUTTER_VERSION:-3.41.9}"
  FLUTTER_ARCHIVE="flutter_macos_${FLUTTER_VERSION}-stable.zip"
  FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/$FLUTTER_ARCHIVE"
  echo "Downloading Flutter SDK $FLUTTER_VERSION from $FLUTTER_URL"
  curl -fL "$FLUTTER_URL" -o "/tmp/$FLUTTER_ARCHIVE"
  unzip -q "/tmp/$FLUTTER_ARCHIVE" -d "$HOME"
  export PATH="$FLUTTER_DIR/bin:$PATH"
  # Only precache iOS artifacts to avoid downloading Android build tools
  flutter precache --ios
  echo "✅ Flutter installed successfully"
else
  echo "✅ Flutter already installed"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

# Verify Flutter is available
if ! command -v flutter &> /dev/null; then
  echo "❌ ERROR: Flutter command not found after installation"
  exit 1
fi

echo "Flutter version:"
flutter --version

log_step "Installing Melos"

# Install Melos
export PATH="$HOME/.pub-cache/bin:$PATH"
dart pub global activate melos 6.3.2

log_step "Running Network Diagnostics"

# Network diagnostics
ping -c 2 pub.dev || true
nslookup pub.dev || true

log_step "Running Melos Bootstrap"

# Melos bootstrap with retries
for i in {1..3}; do
  melos bootstrap && break
  echo "⚠️ Retrying melos bootstrap ($i/3)..."
  sleep 5
  if [[ $i -eq 3 ]]; then
    echo "❌ Melos bootstrap failed after 3 attempts."
    exit 1
  fi
done
echo "✅ Melos bootstrap completed successfully"

log_step "Setting Up CocoaPods Environment"

# CocoaPods setup
IOS_DIR="$BASE_PATH/apps/flipper/ios"
if [[ ! -d "$IOS_DIR" ]]; then
  echo "❌ ERROR: iOS directory does not exist: $IOS_DIR"
  exit 1
fi

cd "$IOS_DIR"
echo "📂 Working directory: $(pwd)"

log_step "Generating Flutter Configuration Files"

# Ensure Flutter configuration files are generated before pod install
echo "🔧 Running flutter pub get to generate Flutter configuration..."
FLUTTER_APP_DIR="$BASE_PATH/apps/flipper"
if [[ ! -d "$FLUTTER_APP_DIR" ]]; then
  echo "❌ ERROR: Flutter app directory does not exist: $FLUTTER_APP_DIR"
  exit 1
fi

cd "$FLUTTER_APP_DIR"
flutter pub get
echo "✅ Flutter pub get completed"

# Verify Generated.xcconfig was created
GENERATED_XCCONFIG="$IOS_DIR/Flutter/Generated.xcconfig"
if [[ -f "$GENERATED_XCCONFIG" ]]; then
  echo "✅ Generated.xcconfig exists at $GENERATED_XCCONFIG"
else
  echo "⚠️ WARNING: Generated.xcconfig not found at $GENERATED_XCCONFIG"
fi

# Return to iOS directory for CocoaPods
cd "$IOS_DIR"
echo "📂 Back in iOS directory: $(pwd)"

log_step "Installing CocoaPods"

export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Install CocoaPods if not present (removed env var requirement for better reliability)
if ! command -v pod &> /dev/null; then
  echo "📦 CocoaPods not found. Installing via Homebrew..."
  HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
  echo "✅ CocoaPods installed successfully"
else
  echo "✅ CocoaPods already installed"
fi

# Verify pod command is available
if ! command -v pod &> /dev/null; then
  echo "❌ ERROR: pod command not found after installation"
  exit 1
fi

echo "CocoaPods version:"
pod --version

log_step "Updating CocoaPods Repository (Optional)"

# Conditionally update pod repo
if [[ -n "$POD_REPO_UPDATE" ]]; then
  echo "🔄 Updating pod repo..."
  pod repo update || echo "⚠️ Pod repo update failed, continuing anyway."
else
  echo "ℹ️ Skipping pod repo update (POD_REPO_UPDATE not set)."
fi

log_step "Running CocoaPods Install"

# Targeted pod update for sqlite3
echo "🔄 Attempting targeted update for sqlite3..."
pod update sqlite3 || echo "⚠️ sqlite3 update failed, will retry during pod install."

run_pod_install() {
  pod install || return 1
}

echo "🔧 Running pod install..."
if ! run_pod_install; then
  echo "⚠️ pod install failed. Trying targeted updates..."
  pod update sqlite3 GoogleSignIn || true
  if ! run_pod_install; then
    echo "🔄 Running full pod update (last resort, lockfile preserved if present)..."
    pod update || {
      echo "❌ ERROR: pod install and pod update both failed"
      exit 1
    }
  fi
fi
echo "✅ CocoaPods setup completed successfully"

log_step "Preparing iOS Release Configuration"

# -------------------------
# Prepare iOS Release Config
# -------------------------
echo "⚙️ Building iOS configuration..."
cd "$FLUTTER_APP_DIR"
flutter build ios --config-only --release
echo "✅ iOS release configuration prepared"

log_step "Build Script Completed Successfully"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Post-clone setup completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
