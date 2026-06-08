#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  apps/flipper/tool/shorebird_mobile.sh doctor
  apps/flipper/tool/shorebird_mobile.sh release android [extra shorebird args...]
  apps/flipper/tool/shorebird_mobile.sh release ios [extra shorebird args...]
  apps/flipper/tool/shorebird_mobile.sh release both [extra shorebird args...]
  apps/flipper/tool/shorebird_mobile.sh patch android [extra shorebird args...]
  apps/flipper/tool/shorebird_mobile.sh patch ios [extra shorebird args...]
  apps/flipper/tool/shorebird_mobile.sh patch both [extra shorebird args...]

Examples:
  apps/flipper/tool/shorebird_mobile.sh release android
  apps/flipper/tool/shorebird_mobile.sh release ios -- --dart-define=FLUTTER_TEST_ENV=false
  apps/flipper/tool/shorebird_mobile.sh patch both --release-version latest
  apps/flipper/tool/shorebird_mobile.sh patch ios --release-version 1.185.4252223235382+1756529387

Notes:
  - Run from the flipper repo root.
  - SHOREBIRD_TOKEN is required for CI. Local interactive login also works.
  - Shorebird release creates the store artifact and registers the release.
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "$1 is not installed or not on PATH"
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
app_dir="$repo_root/apps/flipper"

[[ -d "$app_dir" ]] || die "Could not find apps/flipper from $repo_root"
cd "$app_dir"

action="${1:-}"
platform="${2:-}"

if [[ -z "$action" || "$action" == "-h" || "$action" == "--help" ]]; then
  usage
  exit 0
fi

require_command shorebird
require_command flutter
require_command dart

[[ -f shorebird.yaml ]] || die "apps/flipper/shorebird.yaml is missing"
grep -q "shorebird.yaml" pubspec.yaml || die "shorebird.yaml is not listed under flutter assets in apps/flipper/pubspec.yaml"
grep -q "android.permission.INTERNET" android/app/src/main/AndroidManifest.xml || die "Android INTERNET permission is missing"

case "$action" in
  doctor)
    shorebird doctor
    flutter --version
    dart --version
    ;;
  release|patch)
    [[ -n "$platform" ]] || die "Missing platform: android, ios, or both"
    shift 2
    case "$platform" in
      android|ios)
        shorebird "$action" "$platform" "$@"
        ;;
      both)
        shorebird "$action" android "$@"
        shorebird "$action" ios "$@"
        ;;
      *)
        die "Unsupported platform: $platform"
        ;;
    esac
    ;;
  *)
    usage
    die "Unsupported action: $action"
    ;;
esac
