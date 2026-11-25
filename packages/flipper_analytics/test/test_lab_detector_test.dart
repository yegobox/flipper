import 'dart:async';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/test_lab_detector_test.dart

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('rw.flipper/device_env');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void answer(Future<Object?>? Function(MethodCall call) handler) =>
      messenger.setMockMethodCallHandler(channel, handler);

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  /// What a Play-installed customer phone answers.
  const realPhone = <String, Object?>{
    'testLabSystem': null,
    'testLabGlobal': null,
    'testHarness': false,
    'monkey': false,
    'adbEnabled': false,
    'installer': 'com.android.vending',
  };

  Future<DeviceEnvironment> read(Map<String, Object?> answerMap) async {
    answer((call) async {
      expect(call.method, 'environment');
      return answerMap;
    });
    return readDeviceEnvironment(isAndroid: true);
  }

  group('a test device is flagged', () {
    test('by the documented Test Lab setting', () async {
      final env = await read({...realPhone, 'testLabSystem': 'true'});

      expect(env.isAutomatedTest, isTrue);
      expect(env.testLabSetting, 'true');
    });

    test('by the Test Lab setting kept in Settings.Global', () async {
      final env = await read({...realPhone, 'testLabGlobal': 'true'});

      expect(env.isAutomatedTest, isTrue);
    });

    test('by any Test Lab value but an explicit false', () async {
      expect(
        (await read({...realPhone, 'testLabSystem': '1'})).isAutomatedTest,
        isTrue,
      );
      expect(
        (await read({...realPhone, 'testLabSystem': 'false'})).isAutomatedTest,
        isFalse,
      );
      expect(
        (await read({...realPhone, 'testLabSystem': '0'})).isAutomatedTest,
        isFalse,
      );
      expect(
        (await read({...realPhone, 'testLabSystem': '  '})).isAutomatedTest,
        isFalse,
      );
    });

    test('in Test Harness Mode', () async {
      final env = await read({...realPhone, 'testHarness': true});

      expect(env.isAutomatedTest, isTrue);
    });

    test('under the monkey', () async {
      final env = await read({...realPhone, 'monkey': true});

      expect(env.isAutomatedTest, isTrue);
    });
  });

  test('a customer phone is not a test device', () async {
    final env = await read(realPhone);

    expect(env.isAutomatedTest, isFalse);
    expect(env.reported, isTrue);
    expect(env.analyticsProperties, {
      'device_installer': 'com.android.vending',
      'device_adb_enabled': false,
    });
  });

  test('USB debugging alone does not flag a developer\'s phone', () async {
    final env = await read({...realPhone, 'adbEnabled': true});

    expect(env.isAutomatedTest, isFalse);
    expect(env.analyticsProperties['device_adb_enabled'], isTrue);
  });

  test('an app installed outside Play says so', () async {
    final env = await read({...realPhone, 'installer': null});

    expect(env.analyticsProperties['device_installer'], 'none');
  });

  test('missing or mistyped signals count as absent', () async {
    final env = await read({
      'testHarness': 'yes',
      'monkey': 1,
      'adbEnabled': 'true',
      'installer': 42,
    });

    expect(env.isAutomatedTest, isFalse);
    expect(env.analyticsProperties, {'device_installer': 'none'});
  });

  test('only Android asks, and sends no device properties', () async {
    var asked = false;
    answer((call) async {
      asked = true;
      return {'testLabSystem': 'true'};
    });

    final env = await readDeviceEnvironment(isAndroid: false);

    expect(env, DeviceEnvironment.unknown);
    expect(env.isAutomatedTest, isFalse);
    expect(env.analyticsProperties, isEmpty);
    expect(asked, isFalse);
  });

  test('a missing channel keeps analytics on', () async {
    final env = await readDeviceEnvironment(isAndroid: true);

    expect(env, DeviceEnvironment.unknown);
  });

  test('a null answer keeps analytics on', () async {
    answer((call) async => null);

    expect(
      await readDeviceEnvironment(isAndroid: true),
      DeviceEnvironment.unknown,
    );
  });

  test('an error keeps analytics on', () async {
    answer((call) async => throw PlatformException(code: 'boom'));

    expect(
      await readDeviceEnvironment(isAndroid: true),
      DeviceEnvironment.unknown,
    );
  });

  test('a slow answer keeps analytics on', () async {
    answer((call) => Completer<Object?>().future);

    expect(
      await readDeviceEnvironment(
        isAndroid: true,
        timeout: const Duration(milliseconds: 20),
      ),
      DeviceEnvironment.unknown,
    );
  });

  test('equal environments compare equal and describe themselves', () {
    final a = DeviceEnvironment.fromMap(realPhone);
    final b = DeviceEnvironment.fromMap(Map.of(realPhone));

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(DeviceEnvironment.unknown));
    expect(a.toString(), contains('com.android.vending'));
  });
}
