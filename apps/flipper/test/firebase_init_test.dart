import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flipper_rw/firebase_init.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FirebaseException duplicateApp() => FirebaseException(
        plugin: 'core',
        code: 'duplicate-app',
        message: 'A Firebase App named "[DEFAULT]" already exists',
      );

  group('reuseExistingAppOnDuplicate', () {
    test('returns the new app when initialization succeeds', () async {
      var existingCalls = 0;
      final app = await reuseExistingAppOnDuplicate<String>(
        () async => 'created',
        () {
          existingCalls++;
          return 'existing';
        },
      );

      expect(app, 'created');
      expect(existingCalls, 0);
    });

    test('reuses the existing app on duplicate-app', () async {
      final app = await reuseExistingAppOnDuplicate<String>(
        () async => throw duplicateApp(),
        () => 'existing',
      );

      expect(app, 'existing');
    });

    test('rethrows any other Firebase error', () async {
      final error = FirebaseException(plugin: 'core', code: 'not-initialized');

      await expectLater(
        reuseExistingAppOnDuplicate<String>(
          () async => throw error,
          () => 'existing',
        ),
        throwsA(same(error)),
      );
    });

    test('rethrows non-Firebase errors', () async {
      await expectLater(
        reuseExistingAppOnDuplicate<String>(
          () async => throw StateError('boom'),
          () => 'existing',
        ),
        throwsStateError,
      );
    });
  });

  group('isDuplicateAppError', () {
    test('matches only core/duplicate-app', () {
      expect(isDuplicateAppError(duplicateApp()), isTrue);
      expect(
        isDuplicateAppError(
          FirebaseException(plugin: 'core', code: 'no-app'),
        ),
        isFalse,
      );
      expect(
        isDuplicateAppError(
          FirebaseException(plugin: 'firebase_auth', code: 'duplicate-app'),
        ),
        isFalse,
      );
    });
  });

  // The core mocks start with a native [DEFAULT] app (apiKey '123'), the way
  // google-services.json creates one on Android before Dart runs.
  group('initializeDefaultFirebaseApp', () {
    setUpAll(setupFirebaseCoreMocks);

    test('reuses the native default app when Dart options differ', () async {
      const dartOptions = FirebaseOptions(
        apiKey: 'dart-side-key',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
      );

      // firebase_core itself throws here; the helper must not.
      await expectLater(
        Firebase.initializeApp(options: dartOptions),
        throwsA(
          isA<FirebaseException>()
              .having((e) => e.code, 'code', 'duplicate-app'),
        ),
      );

      final app = await initializeDefaultFirebaseApp(dartOptions);

      expect(app.name, defaultFirebaseAppName);
      expect(app.options.apiKey, '123');
      expect(Firebase.apps, hasLength(1));
    });

    test('returns the same app when the options match', () async {
      const matching = FirebaseOptions(
        apiKey: '123',
        appId: '123',
        messagingSenderId: '123',
        projectId: '123',
      );

      final first = await initializeDefaultFirebaseApp(matching);
      final second = await initializeDefaultFirebaseApp(matching);

      expect(second, first);
      expect(Firebase.apps, hasLength(1));
    });
  });
}
