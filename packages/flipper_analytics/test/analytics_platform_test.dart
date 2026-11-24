import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a browser build is web whatever the OS', () {
    expect(
      analyticsPlatformName(isWeb: true, platform: TargetPlatform.windows),
      'web',
    );
  });

  test('a native build names its OS', () {
    const expected = {
      TargetPlatform.android: 'android',
      TargetPlatform.iOS: 'ios',
      TargetPlatform.macOS: 'macos',
      TargetPlatform.windows: 'windows',
      TargetPlatform.linux: 'linux',
      TargetPlatform.fuchsia: 'fuchsia',
    };
    expected.forEach((platform, name) {
      expect(analyticsPlatformName(isWeb: false, platform: platform), name);
    });
  });
}
