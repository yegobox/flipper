#!/bin/bash
set -e

# Runs before xcodebuild. Does iOS-specific prep that is too slow for post-clone.

HEARTBEAT_INTERVAL="${HEARTBEAT_INTERVAL:-90}"

log_step() {
  echo ""
  echo "==> $1"
}

log_heartbeat() {
  echo "[ci_pre_xcodebuild heartbeat] $1 at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
}

start_heartbeat() {
  local label="$1"
  (
    while true; do
      sleep "$HEARTBEAT_INTERVAL"
      log_heartbeat "$label"
    done
  ) &
  echo $!
}

stop_heartbeat() {
  local pid="$1"
  if [[ -n "$pid" ]]; then
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  fi
}

run_pod_command() {
  local label="$1"
  shift
  local log_file="$1"
  shift

  echo "Running: $*"
  local hb_pid
  hb_pid="$(start_heartbeat "$label")"
  set +e
  "$@" 2>&1 | tee "$log_file"
  local exit_code="${PIPESTATUS[0]}"
  set -e
  stop_heartbeat "$hb_pid"

  if [[ "$exit_code" -ne 0 ]]; then
    echo "ERROR: $label failed with exit code $exit_code"
    echo "Last 60 lines of $log_file:"
    tail -60 "$log_file" || true
    return "$exit_code"
  fi
  return 0
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -n "${CI_PRIMARY_REPOSITORY_PATH:-}" ]]; then
  REPO_ROOT="$CI_PRIMARY_REPOSITORY_PATH"
elif [[ -n "${CI_WORKSPACE:-}" ]]; then
  REPO_ROOT="$CI_WORKSPACE"
else
  REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

if [[ -f "$REPO_ROOT/apps/flipper/pubspec.yaml" ]]; then
  FLUTTER_APP_DIR="$REPO_ROOT/apps/flipper"
elif [[ -f "$REPO_ROOT/pubspec.yaml" ]]; then
  FLUTTER_APP_DIR="$REPO_ROOT"
else
  echo "ERROR: Could not locate apps/flipper from REPO_ROOT=$REPO_ROOT"
  exit 1
fi

FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
export PATH="$FLUTTER_DIR/bin:$HOME/.pub-cache/bin:$PATH"
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

PLIST_PATH="$IOS_DIR/GoogleService-Info.plist"
POD_LOG_DIR="$IOS_DIR/ci_scripts/pod-logs"
mkdir -p "$POD_LOG_DIR"

log_step "ci_pre_xcodebuild: paths"
echo "REPO_ROOT=$REPO_ROOT"
echo "FLUTTER_APP_DIR=$FLUTTER_APP_DIR"
echo "IOS_DIR=$IOS_DIR"

if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
  echo "ERROR: Flutter not found at $FLUTTER_DIR (ci_post_clone.sh should install it)"
  exit 1
fi
flutter --version

log_step "ci_pre_xcodebuild: Flutter iOS config"
cd "$FLUTTER_APP_DIR"
flutter pub get
flutter build ios --config-only --release

GENERATED_XCCONFIG="$IOS_DIR/Flutter/Generated.xcconfig"
if [[ ! -f "$GENERATED_XCCONFIG" ]]; then
  echo "ERROR: Missing $GENERATED_XCCONFIG"
  exit 1
fi
grep '^FLUTTER_ROOT=' "$GENERATED_XCCONFIG" || true

mkdir -p "$IOS_DIR/Flutter"
echo "$FLUTTER_DIR" > "$IOS_DIR/Flutter/.ci_flutter_root"

if [[ -f "$PLIST_PATH" ]]; then
  GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  FIREBASE_PROJECT_ID=$(plutil -extract PROJECT_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  GCM_SENDER_ID=$(plutil -extract GCM_SENDER_ID raw -o - "$PLIST_PATH" 2>/dev/null || true)
  if [[ -n "$GOOGLE_APP_ID" && -n "$FIREBASE_PROJECT_ID" && -n "$GCM_SENDER_ID" ]]; then
    cat > "$IOS_DIR/firebase_app_id_file.json" <<EOF
{
  "file_generated_by": "FlutterFire CLI",
  "purpose": "FirebaseAppID & ProjectID",
  "GOOGLE_APP_ID": "$GOOGLE_APP_ID",
  "FIREBASE_PROJECT_ID": "$FIREBASE_PROJECT_ID",
  "GCM_SENDER_ID": "$GCM_SENDER_ID"
}
EOF
  fi
fi

log_step "ci_pre_xcodebuild: CocoaPods"
if ! command -v pod &>/dev/null; then
  echo "Installing CocoaPods via Homebrew..."
  env HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
fi

# Match Podfile.lock (COCOAPODS: 1.16.2) when possible.
gem install cocoapods -v 1.16.2 -N --user-install 2>/dev/null || true
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

echo "pod version: $(pod --version)"
pod repo list || true
# Legacy git-based master repo conflicts with CDN trunk on fresh CI images.
pod repo remove master 2>/dev/null || true

cd "$IOS_DIR"
rm -rf Pods

if run_pod_command "pod install --repo-update" "$POD_LOG_DIR/install.log" \
  pod install --repo-update --verbose; then
  echo "pod install succeeded"
elif run_pod_command "pod update --repo-update" "$POD_LOG_DIR/update.log" \
  pod update --repo-update --verbose; then
  echo "pod update succeeded"
else
  echo "ERROR: All CocoaPods install strategies failed"
  exit 1
fi

if [[ ! -f Podfile.lock || ! -f Pods/Manifest.lock ]]; then
  echo "ERROR: pod install did not produce lockfiles"
  exit 1
fi
if ! diff Podfile.lock Pods/Manifest.lock >/dev/null; then
  echo "ERROR: Podfile.lock and Pods/Manifest.lock differ after pod install"
  diff Podfile.lock Pods/Manifest.lock || true
  exit 1
fi

echo "ci_pre_xcodebuild completed successfully"
log_heartbeat "script finished"
