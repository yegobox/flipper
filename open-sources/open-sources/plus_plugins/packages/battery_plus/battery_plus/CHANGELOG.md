## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(battery_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(battery_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1783).
 - **REFACTOR**(battery_plus): Update example app to use Material 3.
 - **FIX**(battery_plus): Close StreamController on Web and Linux when done (#1744).

## 3.0.6

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.0.5

 - **FIX**(battery_plus): Huawei power save mode check (#1708).
 - **FIX**(battery_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1700).

## 3.0.4

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.0.3

 - **FIX**: broadcast stream (#1479).
 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.2

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.1

 - **FIX**: lint warnings - add missing dependency for tests (#1233).

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: platform implementation refactor into a single package (#1169).

## 2.2.2

 - **FIX**: batteryState always return unknown on API < 26 (#1120).

## 2.2.1

- Fix: batteryState always return unknown on API < 26

## 2.2.0

- Android: Migrate to Kotlin
- Android: Bump targetSDK to 33 (Android 13)
- Android: Update dependencies, build config updates
- Update Flutter dependencies

## 2.1.4+1

- Add issue_tracker link.

## 2.1.4

- Update flutter_lints to 2.0.1
- Update dev dependencies

## 2.1.3

- Update battery_plus_linux dependency
- Set min Flutter version to 1.20.0 for all platforms

## 2.1.2

- Fix embedding issue in example
- (Android) Update Kotlin and Gradle plugin

## 2.1.1

- (Android) Fix null pointer exception in `isInBatterySaveMode()` on Samsung devices with One UI

## 2.1.0

- Add batteryState getter

## 2.0.2

- Update Flutter dependencies

## 2.0.1

- Upgrade Android compile SDK version
- Several code improvements

## 2.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.1

- Fix: Add break statements for unknown battery state in Android and iOS implementations

## 1.1.0

- Android, iOS, Windows : add getter for power save mode state

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Migrate to null safety

## 0.10.1

- Address pub score

## 0.10.0

- Added "unknown" battery state for batteryless systems.

## 0.9.1

- Send initial battery status for Android

## 0.9.0

- Add Linux support (`battery_plus_linux`)
- Add macOS support (`battery_plus_macos`)
- Add Windows support (`battery_plus_windows`)
- Rename method channel to avoid conflicts

## 0.8.0

- Transfer to plus-plugins monorepo

## 0.7.0

- Battery Plus supports web.

## 0.6.0

- Implement Battery Plus based on new `BatteryPlatformInterface`.

## 0.5.4

- Transfer package to Flutter Community under new name `batter_plus`.

## 0.5.3

- Update package:e2e to use package:integration_test

## 0.5.2

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.1

- Update lower bound of dart dependency to 2.1.0.

## 0.3.1+10

- Update minimum Flutter version to 1.12.13+hotfix.5
- Fix CocoaPods podspec lint warnings.

## 0.3.1+9

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.3.1+8

- Make the pedantic dev_dependency explicit.

## 0.3.1+7

- Clean up various Android workarounds no longer needed after framework v1.12.

## 0.3.1+6

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.3.1+5

- Fix pedantic linter errors.

## 0.3.1+4

- Update and migrate iOS example project.

## 0.3.1+3

- Remove AndroidX warning.

## 0.3.1+2

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.3.1+1

- Android: Use android.arch.lifecycle instead of androidx.lifecycle:lifecycle in `build.gradle` to support apps that has not been migrated to AndroidX.

## 0.3.1

- Support the v2 Android embedder.

## 0.3.0+6

- Define clang module for iOS.

## 0.3.0+5

- Fix Gradle version.

## 0.3.0+4

- Update Dart code to conform to current Dart formatter.

## 0.3.0+3

- Fix `batteryLevel` usage example in README

## 0.3.0+2

- Bump the minimum Flutter version to 1.2.0.
- Add template type parameter to `invokeMethod` calls.

## 0.3.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.3.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.2.3

- Updated mockito dependency to 3.0.0 to get Dart 2 support.
- Update test package dependency to 1.3.0, and fixed tests to match.

## 0.2.2

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.1

- Fixed Dart 2 type error.
- Removed use of deprecated parameter in example.

## 0.2.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.1.1

- Fixed warnings from the Dart 2.0 analyzer.
- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.2

- Add FLT prefix to iOS types.

## 0.0.1+1

- Updated README

## 0.0.1

- Initial release
