# Flutter version

Flipper builds with **Flutter 3.47.9** (Dart 3.13.7). Every pipeline uses this one version, so the version that tests run on is the version that ships.

## Where it is pinned

Change all of these in one PR:

| Place | Field |
|---|---|
| `.github/workflows/release.yml` | `env.FLUTTER_VERSION` (the reference; the others follow it) |
| `.github/workflows/quality.yml` | `env.FLUTTER_VERSION` |
| `.github/workflows/web_ci.yml` | `env.FLUTTER_VERSION` |
| `.github/workflows/android_preview.yml` | `env.FLUTTER_VERSION` |
| `.github/workflows/mobile_shorebird.yml` | `env.FLUTTER_VERSION` |
| `.github/workflows/desktop_launcher_release.yml` | `env.FLUTTER_VERSION` |
| `.github/workflows/readme_screenshots.yaml` | `env.FLUTTER_VERSION` |
| `apps/flipper/ios/ci_scripts/ci_post_clone.sh` | `FLUTTER_VERSION` default (Xcode Cloud) |
| `apps/flipper_auth/ios/ci_scripts/ci_post_clone.sh`, `apps/flipper_ai/ios/ci_scripts/ci_post_clone.sh` | `git clone -b <version>` (Xcode Cloud) |

`build_android.yaml`, `build_windows.yaml` and `windows.yaml` still say 3.29.3. Their jobs run only when a commit message contains a magic string, so they are effectively dead.

## Shorebird decides the ceiling

Every Android and iOS release goes through `shorebird release`. Shorebird runs its own fork of Flutter, and it supports only the versions that have a `flutter_release/<version>` branch:

```sh
git ls-remote https://github.com/shorebirdtech/flutter.git | grep -oE 'flutter_release/[0-9.]+$' | sort -V | tail
```

`shorebird release` is passed `--flutter-version="$FLUTTER_VERSION"` in the workflows. The fallback in `apps/flipper/android/fastlane/Fastfile` (used when the AAB is not prebuilt) passes it too, whenever `FLUTTER_VERSION` is set in the environment. Set it when releasing from a local machine. Without it, Shorebird uses its own default, which moves without warning. Until 3.47.9, Android shipped on Shorebird's 3.47.9 while CI tested on 3.44.6. `shorebird patch` takes no flag, because a patch always uses its release's Flutter. A Flutter bump therefore has to ship as a new store release, never as a patch.

## Bumping

1. Pick a version that Shorebird supports and that has at least one patch release (`x.y.1` or later).
2. Look up its real Dart version in `https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json` (`dart_sdk_version`). Flutter's own `pubspec.yaml` lists only a minimum Dart version, not the one it ships with.
3. Change every pin in the table above.
4. Run `flutter pub get`, not `upgrade`, and check that every change in `apps/flipper/pubspec.lock` comes from the SDK.
5. Refresh the analyzer baseline: run `quality.yml` manually with `refresh_baseline: true` and commit the `analysis-baseline` artifact (see `docs/quality_gates.md`).
6. Re-apply `scripts/patch_dwds_timeout.sh`. A new SDK undoes the local web-debugging patch.

## Intel Macs

Flutter is deprecating Intel Macs as a *build host*: a future version will need an Apple Silicon Mac to build. CI already builds macOS on `macos-14`, which runs on Apple Silicon.

Shops running on Intel Macs are a separate matter. Release builds are still universal (`x86_64` and `arm64`), but Flutter plans to make arm64-only the default (`flutter config --enable-macos-arm64-only`; see flutter.dev/go/macos-intel-deprecation). The macOS job in `desktop_launcher_release.yml` fails if the app is not universal, so that change cannot silently drop Intel shops.

## material_ui readiness

Flutter 3.50 deprecates `package:flutter/material.dart` and `cupertino.dart` in favour of the `material_ui` and `cupertino_ui` packages. Those are a **separate copy** of Material with distinct types, so the switch has to happen in one step, once the packages we render through have moved too.

`MaterialUiCompatibilityBridge` carries only `colorScheme`, `textTheme`, `visualDensity` and `platform` across. Widgets still on the legacy library would lose:
- our component themes (HR, Books) and `FlipperThemeExtension`
- their legacy `Material`/`ScaffoldMessenger` ancestors
- go_router's exact-type `MaterialApp` check

`scripts/ci/material_ui_readiness.py` lists every third-party or vendored package that our `lib/` code imports and that still imports the legacy libraries. The list lives in `.github/baselines/material_ui.json`, and quality.yml fails a PR that adds a new one. When it is empty, or the remaining entries are low-exposure enough to bridge, the switch can happen (`dart fix --apply --code=migrate_design_widgets`).

```sh
python3 scripts/ci/material_ui_readiness.py --list    # what still blocks the switch
python3 scripts/ci/material_ui_readiness.py --update  # lock in an improvement
```

### Upgrade order: migrated packages wait for the switch

Many entries already have a release that moved to `material_ui`. On 2026-11-13 these included:
- badges 4
- shimmer 4
- pinput 7
- pin_code_fields 10
- flex_color_picker 4
- animations 3
- cached_network_image 4
- google_fonts 9
- go_router 18
- dropdown_search 8
- wolt_modal_sheet 0.12
- syncfusion 35

**Do not bump them before our own switch.** These releases target apps that already use `material_ui`. In an app still on `package:flutter/material.dart` they lose our theme, because the bridge only works the other way: badges 4 falls back to the default text style. Their Material-ancestor checks also change. pin_code_fields 10 says so directly: "If your app is still on `package:flutter/material.dart`, stay on `^9.4.0`."

So the switch PR bumps them in the same step. Before the switch, only these are safe:
- removing packages, and replacing abandoned ones (#899, #900, #901)
- narrowing imports to `widgets.dart`
- building the `material_ui` themes alongside the current ones

The check works at the import level, so it is coarse. Some entries touch Material only lightly, such as a `Colors` constant. Treat the list as the inventory to work through, not a measure of effort.
