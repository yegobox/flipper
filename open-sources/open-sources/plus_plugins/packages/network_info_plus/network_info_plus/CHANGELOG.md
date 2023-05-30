## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(network_info_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(network_info_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1777).
 - **REFACTOR**(network_info_plus): Rewrite Windows implementation in Dart (#1780).

## 3.0.5

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.0.4

 - **FIX**(network_info_plus): Type cast for Linux when calling getWifiIP() (#1717).
 - **FIX**(network_info_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1703).

## 3.0.3

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(network_info_plus): import original `getgateway.*` from libnatpmp (#1592).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.0.2

 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.0

> Note: This release has breaking changes.

 - **FIX**: lint warnings - add missing dependency for tests (#1233).
 - **FIX**: Get SSID on Android 12 and newer (#1231).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1235).

## 2.3.2

 - **FIX**: Mark iOS-specific permission methods as deprecated and update docs (#1155).

## 2.3.1

 - **CHORE**: Version tagging using melos.

## 2.3.0

- Android: Use new APIs to get network info on devices with with Android 12 (SDK 31) and newer. Due
  to this change on such devices be sure to add `ACCESS_NETWORK_STATE` permission into your
  `AndroidManifest.xml` file.

## 2.2.0

- Android: Migrate to Kotlin
- Android: Bump targetSDK to 33 (Android 13)
- Android: Update dependencies, build config updates
- Android: Fixed getWifiBroadcast to not add redundant `/` symbol
- Update Flutter dependencies

## 2.1.4+1

- Add issue_tracker link.

## 2.1.4

- Android: Plugin no longer removes `"` from SSID name.

## 2.1.3

- Update nm dependency to be compatible with fresh versions of other Plus plugins
- Set min Flutter version to 1.20.0 for all platforms

## 2.1.2

- Update Flutter dependencies

## 2.1.1

- Fix issue with getWifiInterface on iOS. See PR #605 for more info.

## 2.1.0

- macOS: Add submask, broadcast, gateway info

## 2.0.2

- Upgrade Android compile SDK version
- Several code improvements
- Remove remaining embedding v1 components

## 2.0.1

- Add IP v6 to MacOS

## 2.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 1.3.0

- IOS: Use `NEHotspotNetwork` on iOS 14+ to get SSID/BSSID.

## 1.2.1

- IOS: Fix issue failed to build on iOS emulator

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.0

- Android, IOS: Adding IPv6 information
- Android, IOS: Adding gateway ip address information
- Android, IOS: Adding broadcast information
- Android, IOS: Adding subnet mask information

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Migrate to null-safety.

## 0.1.2

- Address pub score.

## 0.1.1+1

- Provide longer package description to address pub score.

## 0.1.1

- Added a stub plugin for Web that throws unsupported exceptions, because the functionality is not
  supported on Web.

## 0.1.0

- Initial release
