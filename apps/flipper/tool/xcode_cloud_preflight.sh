#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
app_dir="$repo_root/apps/flipper"
ios_dir="$app_dir/ios"

log_step() {
  echo ""
  echo "==> $1"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: $1 is not installed or not on PATH" >&2
    exit 1
  }
}

write_from_env_if_missing() {
  local env_name="$1"
  local file_path="$2"
  local value="${!env_name:-}"

  if [[ -s "$file_path" ]]; then
    return
  fi

  if [[ -n "$value" ]]; then
    mkdir -p "$(dirname "$file_path")"
    printf "%s" "$value" > "$file_path"
    echo "Created $file_path from \$$env_name"
  fi
}

log_step "Checking required tools"
require_command git
require_command dart
require_command flutter
require_command pod
require_command xcodebuild

log_step "Checking repository and submodules"
cd "$repo_root"
git config --file .gitmodules --get-regexp 'submodule\..*\.url' || true
git submodule status --recursive

missing_submodules="$(git submodule status --recursive | awk '/^-/ { print $2 }')"
if [[ -n "$missing_submodules" ]]; then
  echo "ERROR: Missing submodules:"
  echo "$missing_submodules"
  echo "Run: git submodule update --init --recursive"
  exit 1
fi

log_step "Checking generated secret/config files"
write_from_env_if_missing SECRETS "$repo_root/packages/flipper_models/lib/secrets.dart"
write_from_env_if_missing FIREBASEOPTIONS "$repo_root/packages/flipper_models/lib/firebase_options.dart"
write_from_env_if_missing FIREBASEOPTIONS "$app_dir/lib/firebase_options.dart"
write_from_env_if_missing GOOGLE_SERVICE_INFO_PLIST_CONTENT "$ios_dir/GoogleService-Info.plist"

if [[ ! -s "$ios_dir/GoogleService-Info.plist" && -s "$ios_dir/Runner/GoogleService-Info.plist" ]]; then
  cp "$ios_dir/Runner/GoogleService-Info.plist" "$ios_dir/GoogleService-Info.plist"
  echo "Created $ios_dir/GoogleService-Info.plist from ios/Runner/GoogleService-Info.plist"
fi

required_files=(
  "$repo_root/packages/flipper_models/lib/secrets.dart"
  "$repo_root/packages/flipper_models/lib/firebase_options.dart"
  "$app_dir/lib/firebase_options.dart"
  "$ios_dir/GoogleService-Info.plist"
)

for file in "${required_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "ERROR: Required file is missing or empty: $file"
    exit 1
  fi
done

log_step "Checking Shorebird initialization"
[[ -s "$app_dir/shorebird.yaml" ]] || { echo "ERROR: shorebird.yaml is missing"; exit 1; }
grep -q "shorebird.yaml" "$app_dir/pubspec.yaml" || {
  echo "ERROR: shorebird.yaml is not listed in apps/flipper/pubspec.yaml assets"
  exit 1
}

log_step "Bootstrapping Flutter workspace"
dart run melos bootstrap

log_step "Preparing Flutter iOS configuration"
cd "$app_dir"
flutter pub get
flutter build ios --config-only --release

log_step "Installing CocoaPods"
cd "$ios_dir"
pod install

log_step "Compiling iOS Release without code signing"
xcodebuild \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

echo ""
echo "Xcode Cloud preflight passed."
echo "This predicts dependencies, CocoaPods, Flutter config, and unsigned Release compilation."
echo "Xcode Cloud can still fail on Apple-side repository authorization or signing/profile configuration."
