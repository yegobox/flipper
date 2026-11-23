import 'package:flutter/foundation.dart';

/// The `platform` property: `web` in a browser, else the OS a build runs on.
/// Books and HR also ship as native apps, so a hard-coded `web` mislabelled
/// their desktop users.
String analyticsPlatformName({
  @visibleForTesting bool? isWeb,
  @visibleForTesting TargetPlatform? platform,
}) {
  if (isWeb ?? kIsWeb) return 'web';
  return switch (platform ?? defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.iOS => 'ios',
    TargetPlatform.macOS => 'macos',
    TargetPlatform.windows => 'windows',
    TargetPlatform.linux => 'linux',
    TargetPlatform.fuchsia => 'fuchsia',
  };
}
