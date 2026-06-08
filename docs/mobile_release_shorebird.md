# Mobile release and patch plan

Flipper is already initialized for Shorebird in `apps/flipper`:

- `apps/flipper/shorebird.yaml` contains the committed Shorebird `app_id`.
- `apps/flipper/pubspec.yaml` includes `shorebird.yaml` in Flutter assets.
- `apps/flipper/android/app/src/main/AndroidManifest.xml` has `android.permission.INTERNET`.

This matches the current Shorebird initialization flow: `shorebird init` creates the app id, writes `shorebird.yaml`, and adds that file to Flutter assets. Shorebird release commands create the store artifacts and register the compiled Dart release. Patches are then created against an existing release and can be promoted to stable.

## Golden path

Run all commands from the `flipper/` repo root.

```bash
apps/flipper/tool/shorebird_mobile.sh doctor
```

For a store release:

```bash
apps/flipper/tool/shorebird_mobile.sh release android
apps/flipper/tool/shorebird_mobile.sh release ios
```

Upload the generated Android AAB to Play Console and the generated iOS IPA to App Store Connect. The submitted binaries must come from `shorebird release`, not plain `flutter build`, otherwise later patches cannot target that store binary.

For an urgent Dart fix after the store binary has been submitted:

```bash
apps/flipper/tool/shorebird_mobile.sh patch android --release-version latest
apps/flipper/tool/shorebird_mobile.sh patch ios --release-version latest
```

Use a concrete version instead of `latest` when patching an older release:

```bash
apps/flipper/tool/shorebird_mobile.sh patch both --release-version 1.185.4252223235382+1756529387
```

This lets a patch exist before Apple or Google finishes review. Once the approved binary reaches users, the Shorebird updater can fetch the already-published patch on launch.

## CI secrets

For CI, create a Shorebird API key in the Shorebird Console and store it as:

```text
SHOREBIRD_TOKEN
```

Do not use deprecated `shorebird login:ci` for new setup. The current CI guidance is to provide `SHOREBIRD_TOKEN` directly.

## GitHub Actions integration

Shorebird is wired into the mobile Flipper workflows in this repo:

- `.github/workflows/build_android.yaml` installs Shorebird and sets `USE_SHOREBIRD=true`.
- `.github/workflows/release.yml` installs Shorebird for the `flipper` matrix entry and keeps `flipper_auth` on the normal Flutter build path.
- `apps/flipper/android/fastlane/Fastfile` uses `shorebird release android` when `USE_SHOREBIRD=true`, then uploads the Shorebird-generated AAB through the existing Fastlane lane.
- `.github/workflows/mobile_shorebird.yml` provides a direct release/patch workflow. It can be run manually, by pushing `mobile-v*`, `mobile-android-v*`, or `mobile-ios-v*` release tags, or by including `[shorebird patch]` in a push commit message.

Do not add Shorebird to `flipper-turbo/.github/workflows/release.yaml`; that workflow deploys the Quarkus backend JAR, not the Flutter mobile app.

## Xcode Cloud authorization failure

The current error, `An additional repository requires authorization`, is expected for this repository shape. Xcode Cloud sees additional Git repositories before `ci_post_clone.sh` runs.

Authorize these repositories in App Store Connect / Xcode Cloud for the workflow:

```text
https://github.com/yegobox/qr.flutter.git
https://github.com/yegobox/receipt.git
https://github.com/yegobox/flutter.widgets.git
https://github.com/yegobox/flutter_slidable.git
https://github.com/yegobox/form_bloc.git
https://github.com/yegobox/brick.git
```

Also ensure the GitHub integration can read public Git package dependencies used during `melos bootstrap`, especially:

```text
https://github.com/justkawal/excel.git
```

If App Store Connect does not show one of the `yegobox/*` repositories, install or reconfigure the Apple Xcode Cloud GitHub app on the `yegobox` organization and grant access to all repositories above. A personal GitHub token inside `ci_post_clone.sh` cannot fix this specific pre-clone authorization error, because the failure happens before scripts execute.

Apple's Xcode Cloud documentation calls out this exact dependency class: private Git submodules, Swift packages, and Git repositories used by custom scripts must be accessible to Xcode Cloud before the build can run.

Recommended Xcode Cloud workflow:

```text
Repository: yegobox/flipper
Workspace: apps/flipper/ios/Runner.xcworkspace
Scheme: Runner
Branch trigger: main, dev, or the release branch you use
Environment: all variables printed by apps/flipper/ios/ci_scripts/prepare_env_vars.sh
```

The required Xcode Cloud secret variables are:

```text
GOOGLE_SERVICE_INFO_PLIST_CONTENT
INDEX
SECRETS1
SECRETS2
FIREBASE1
FIREBASE2
AMPLIFY_CONFIG
AMPLIFY_TEAM_PROVIDER
```

Use Xcode Cloud for iOS verification/TestFlight once repository access is fixed. Use Shorebird release artifacts as the source of truth for production store submissions when you need over-the-air patches.

## Xcode Cloud: PhaseScriptExecution failed

`Command PhaseScriptExecution failed with a nonzero exit code` is a generic Xcode wrapper. The real error is always a few lines **above** it in the build log.

In App Store Connect → Xcode Cloud → failed build → **Logs** → expand the **xcodebuild** step, then search for:

| Log line | Failing script phase | Usual fix |
|----------|---------------------|-----------|
| `xcode_backend.sh: No such file or directory` | Run Script / Thin Binary | `ci_pre_xcodebuild.sh` refreshes `Generated.xcconfig`; Flutter must be installed in `ci_post_clone.sh` to `$HOME/flutter` |
| `The sandbox is not in sync with the Podfile.lock` | `[CP] Check Pods Manifest.lock` | Re-run `pod install` in `ci_post_clone.sh` or `ci_pre_xcodebuild.sh` |
| Dart compile errors (`secrets.dart`, `firebase_options.dart`) | Run Script (`xcode_backend.sh build`) | Set Xcode Cloud secrets: `SECRETS1`, `SECRETS2`, `FIREBASE1`, `FIREBASE2`, `GOOGLE_SERVICE_INFO_PLIST_CONTENT` |
| `upload-symbols` / Crashlytics | `[firebase_crashlytics] Crashlytics Upload Symbols` | Keep `firebase_app_id_file.json` (written from `GoogleService-Info.plist` in CI scripts) |

`apps/flipper/ios/ci_scripts/ci_pre_xcodebuild.sh` runs before `xcodebuild` to:

- validate secrets / Firebase files exist
- run `melos bootstrap`
- run `flutter build ios --release --no-codesign` (Dart errors show here, not as generic PhaseScriptExecution)
- run `pod install` and verify `Podfile.lock` matches `Pods/Manifest.lock`
- write `ios/Flutter/.ci_flutter_root` for Xcode Run Script phases

In App Store Connect, open the failed build → **Logs** → expand **Pre-Xcodebuild** and **xcodebuild** (not only the final summary). Search for `error:` or `PhaseScriptExecution`. Download the `.xcresult` artifact if needed.

## Predicting iOS success before pushing

You can predict most Xcode Cloud failures locally with:

```bash
apps/flipper/tool/xcode_cloud_preflight.sh
```

This checks:

- Git submodules are initialized.
- Required generated secret/config files exist.
- Shorebird is initialized and bundled.
- Melos bootstrap succeeds.
- Flutter can generate iOS release configuration.
- CocoaPods install succeeds.
- Xcode can compile the `Runner` scheme for iPhoneOS Release with code signing disabled.

This cannot prove Apple-side state: Xcode Cloud repository authorization, certificate/provisioning profile access, App Store Connect permissions, or TestFlight upload. Those are only fully proven by an Xcode Cloud run.

## Recommendation

Use Shorebird as the source of truth for mobile store builds:

- Android: `shorebird release android` then upload AAB to Play Console.
- iOS: `shorebird release ios` then upload IPA to App Store Connect with Transporter or App Store Connect API.
- Xcode Cloud: keep it for iOS verification if useful, but do not submit a plain Xcode Cloud archive as the production binary unless it was produced through Shorebird.

For a true "once and for all" Xcode Cloud fix, either keep all submodule repositories authorized forever or remove non-release submodules from this repo's iOS release path.
