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

  test('a Test Lab device says so', () async {
    answer((call) async {
      expect(call.method, 'isTestLab');
      return true;
    });

    expect(await isFirebaseTestLab(isAndroid: true), isTrue);
  });

  test('a real phone is not Test Lab', () async {
    answer((call) async => false);

    expect(await isFirebaseTestLab(isAndroid: true), isFalse);
  });

  test('only Android asks', () async {
    var asked = false;
    answer((call) async {
      asked = true;
      return true;
    });

    expect(await isFirebaseTestLab(isAndroid: false), isFalse);
    expect(asked, isFalse);
  });

  test('a missing channel keeps analytics on', () async {
    expect(await isFirebaseTestLab(isAndroid: true), isFalse);
  });

  test('an error keeps analytics on', () async {
    answer((call) async => throw PlatformException(code: 'boom'));

    expect(await isFirebaseTestLab(isAndroid: true), isFalse);
  });

  test('a slow answer keeps analytics on', () async {
    answer((call) => Completer<Object?>().future);

    expect(
      await isFirebaseTestLab(
        isAndroid: true,
        timeout: const Duration(milliseconds: 20),
      ),
      isFalse,
    );
  });
}
