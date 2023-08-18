import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class Crash {
  Future<void> initializeFlutterFire();
  Future<void> testAsyncErrorOnInit();
  Future<void> log(dynamic data);
  void reportError(dynamic error, dynamic stackTrace);
}

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = false;
// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

class FirebaseCrashlyticServiceUnsupportedDevice implements Crash {
  @override
  Future<void> initializeFlutterFire() async {}

  @override
  Future<void> testAsyncErrorOnInit() async {}

  @override
  Future<void> log(data) async {}

  @override
  void reportError(error, stackTrace) {}
}

class FirebaseCrashlyticService implements Crash {
  @override
  Future<void> initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError as Function;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await testAsyncErrorOnInit();
    }
  }

  @override
  Future<void> testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  @override
  Future<void> log(data) async {
    FirebaseCrashlytics.instance.log(data.toString());
  }

  @override
  void reportError(dynamic error, dynamic stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
