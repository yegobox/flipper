import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What the Android app can tell about the device it runs on: the signals of
/// an automated test device, plus where the app was installed from.
///
/// Google runs every build Flipper uploads to Play on its own devices: the
/// pre-launch report's Firebase Test Lab emulators, and a OnePlus8Pro farm on
/// Google's network that none of these signals is known to flag yet. They
/// install the app and open it for a few minutes; on Android they
/// outnumbered real users. Analytics stays off on every device that
/// [isAutomatedTest] flags, and [analyticsProperties] mark the rest so a
/// robot that slips through can still be found.
@immutable
class DeviceEnvironment {
  const DeviceEnvironment({
    this.testLabSetting,
    this.testHarness = false,
    this.monkey = false,
    this.adbEnabled,
    this.installer,
    this.reported = false,
  });

  /// The answer on a platform that has none of these signals, or when the
  /// app could not ask: a real device.
  static const unknown = DeviceEnvironment();

  /// Reads the `rw.flipper/device_env` channel's `environment` answer.
  /// Anything missing or of the wrong type counts as absent.
  factory DeviceEnvironment.fromMap(Map<Object?, Object?> map) {
    String? text(String key) {
      final value = map[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    bool? flag(String key) {
      final value = map[key];
      return value is bool ? value : null;
    }

    // Test Lab documents `Settings.System`; `Settings.Global` is read too,
    // in case a device keeps it there. Either one being on flags the device,
    // so an explicit false in one cannot hide a true in the other.
    final system = text('testLabSystem');
    final global = text('testLabGlobal');
    final testLab = _isOn(system)
        ? system
        : _isOn(global)
        ? global
        : system ?? global;

    return DeviceEnvironment(
      testLabSetting: testLab,
      testHarness: flag('testHarness') ?? false,
      monkey: flag('monkey') ?? false,
      adbEnabled: flag('adbEnabled'),
      installer: text('installer'),
      reported: true,
    );
  }

  /// The `firebase.test.lab` setting, which Firebase Test Lab sets on its
  /// devices (documented value: `true`). No real phone has it.
  final String? testLabSetting;

  /// Android 10+ Test Harness Mode, meant for device farms; turning it on
  /// wipes the phone, so no customer runs in it.
  final bool testHarness;

  /// Driven by the `monkey` UI exerciser.
  final bool monkey;

  /// USB debugging. Not a test signal on its own (developers have it on);
  /// reported so undetected robots can be told apart in the data.
  final bool? adbEnabled;

  /// The package that installed the app (`com.android.vending` for Play), or
  /// null when it was installed some other way.
  final String? installer;

  /// Whether the app answered at all (Android); false for [unknown].
  final bool reported;

  /// Whether this is a test robot, not a person. Any value of the Test Lab
  /// setting counts except an explicit false, because only Test Lab sets it.
  bool get isAutomatedTest => _isOn(testLabSetting) || testHarness || monkey;

  static bool _isOn(String? value) =>
      value != null && value != 'false' && value != '0';

  /// Sent with every event of a device that is not flagged, so a robot that
  /// gets through can be recognised in the data and added to the checks.
  /// Empty when the app did not answer (any platform but Android).
  Map<String, Object> get analyticsProperties => {
    if (reported) 'device_installer': installer ?? 'none',
    if (adbEnabled != null) 'device_adb_enabled': adbEnabled!,
  };

  @override
  bool operator ==(Object other) =>
      other is DeviceEnvironment &&
      other.testLabSetting == testLabSetting &&
      other.testHarness == testHarness &&
      other.monkey == monkey &&
      other.adbEnabled == adbEnabled &&
      other.installer == installer &&
      other.reported == reported;

  @override
  int get hashCode => Object.hash(
    testLabSetting,
    testHarness,
    monkey,
    adbEnabled,
    installer,
    reported,
  );

  @override
  String toString() =>
      'DeviceEnvironment(testLab: $testLabSetting, testHarness: $testHarness, '
      'monkey: $monkey, adb: $adbEnabled, installer: $installer)';
}

/// Asks the Android app about the device ([DeviceEnvironment]).
///
/// Android only; everywhere else, and on any error or delay, the answer is
/// [DeviceEnvironment.unknown]: a real till must never be dropped from
/// analytics by mistake.
Future<DeviceEnvironment> readDeviceEnvironment({
  @visibleForTesting
  MethodChannel channel = const MethodChannel('rw.flipper/device_env'),
  @visibleForTesting bool? isAndroid,
  @visibleForTesting Duration timeout = const Duration(seconds: 2),
}) async {
  final android =
      isAndroid ?? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);
  if (!android) return DeviceEnvironment.unknown;
  try {
    final result = await channel
        .invokeMapMethod<Object?, Object?>('environment')
        .timeout(timeout);
    return result == null
        ? DeviceEnvironment.unknown
        : DeviceEnvironment.fromMap(result);
  } catch (_) {
    return DeviceEnvironment.unknown;
  }
}
