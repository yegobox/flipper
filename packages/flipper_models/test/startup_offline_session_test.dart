import 'dart:async';
import 'dart:io';

import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/startup_route_log.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePaths(this.dir);

  final String? dir;

  @override
  Future<String?> getApplicationSupportPath() async => dir;
}

/// Pins the rule that reopening the app offline keeps a signed-in session.
///
/// The regression this guards: a device that logged in with its PIN and was
/// then reopened with no network went back to the login screen. The startup
/// requirement check could not find the branch without going online (Ditto
/// never replicates `branches` down), threw, and the catch-all handler called
/// `logOut()` — although the user never signed out.
void main() {
  group('StartupViewModel.keepsCachedSessionAfter', () {
    bool keeps(
      Object error, {
      bool hasCachedSession = true,
      bool online = false,
    }) => StartupViewModel.keepsCachedSessionAfter(
      error,
      hasCachedSession: hasCachedSession,
      online: online,
    );

    test('offline with a cached session, an unverifiable check keeps it', () {
      for (final error in <Object>[
        Exception('requirements failed for having branches saved locally'),
        BusinessNotFoundException(term: 'Business not found locally or online'),
        TimeoutException('requirements check'),
        StateError('Ditto not initialized'),
      ]) {
        expect(keeps(error), isTrue, reason: '$error must not log out');
      }
    });

    test('errors that say the session is bad still log out', () {
      expect(
        keeps(SessionException(term: 'No user in local storage')),
        isFalse,
      );
      expect(keeps(PinError(term: 'pin')), isFalse);
      expect(keeps(LoginChoicesException(term: 'Branch ID not set')), isFalse);
    });

    test('online, a failure that says nothing about the session keeps it', () {
      // Windows tills reopened online used to land on login every time: any
      // startup error fell through to logOut().
      for (final error in <Object>[
        Exception('requirements failed for having branches saved locally'),
        TimeoutException('appInit'),
        StateError('Ditto not initialized'),
      ]) {
        expect(
          keeps(error, online: true),
          isTrue,
          reason: '$error must not log out',
        );
      }
    });

    test('online, a business the server says is gone still logs out', () {
      expect(
        keeps(BusinessNotFoundException(term: 'missing'), online: true),
        isFalse,
      );
    });

    test('session errors log out online too', () {
      expect(keeps(SessionException(term: 'x'), online: true), isFalse);
      expect(keeps(PinError(term: 'pin'), online: true), isFalse);
      expect(
        keeps(LoginChoicesException(term: 'Branch ID not set'), online: true),
        isFalse,
      );
    });

    test('a device with no session on it is never let in', () {
      expect(
        keeps(Exception('requirements failed'), hasCachedSession: false),
        isFalse,
      );
      expect(
        keeps(
          Exception('requirements failed'),
          hasCachedSession: false,
          online: true,
        ),
        isFalse,
      );
    });
  });

  group('StartupViewModel.fetchOnlineOrNotFound', () {
    test('returns what the server found', () async {
      expect(
        await StartupViewModel.fetchOnlineOrNotFound<String>(() async => 'biz'),
        'biz',
      );
    });

    test('only a server "none" is a missing business', () {
      expect(
        StartupViewModel.fetchOnlineOrNotFound<String>(() async => null),
        throwsA(isA<BusinessNotFoundException>()),
      );
    });

    test('a timeout stays a timeout, so the session is kept', () {
      expect(
        StartupViewModel.fetchOnlineOrNotFound<String>(
          () => Completer<String?>().future,
          timeout: const Duration(milliseconds: 10),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('a transport error is rethrown as is', () {
      expect(
        StartupViewModel.fetchOnlineOrNotFound<String>(
          () async => throw const SocketException('down'),
        ),
        throwsA(isA<SocketException>()),
      );
    });
  });

  group('StartupRouteLog.record', () {
    late Directory dir;
    late PathProviderPlatform original;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('startup_route_log_');
      original = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _FakePaths(dir.path);
    });

    tearDown(() {
      PathProviderPlatform.instance = original;
      dir.deleteSync(recursive: true);
    });

    File log() => File('${dir.path}/${StartupRouteLog.fileName}');

    test('creates the log, then appends to it', () async {
      await StartupRouteLog.record('first', StateError('a'));
      await StartupRouteLog.record('second');

      final text = log().readAsStringSync();
      expect(text, contains('first\nStateError: Bad state: a\n'));
      expect(text, contains('second\n'));
      expect(text.indexOf('first'), lessThan(text.indexOf('second')));
    });

    test('starts over once the log reaches 256 KB', () async {
      log().writeAsStringSync('x' * (256 * 1024));

      await StartupRouteLog.record('fresh');

      final text = log().readAsStringSync();
      expect(text, isNot(contains('x')));
      expect(text, contains('fresh\n'));
    });

    test('a failed write never throws', () async {
      // No support directory: path_provider throws, record swallows it.
      PathProviderPlatform.instance = _FakePaths(null);
      await expectLater(StartupRouteLog.record('lost'), completes);
    });
  });

  group('StartupRouteLog.format', () {
    test('records when, why and the error behind it', () {
      final text = StartupRouteLog.format(
        DateTime.utc(2026, 11, 3, 9),
        'logged out',
        StateError('Ditto not initialized'),
        StackTrace.fromString('#0 main'),
      );
      expect(text, startsWith('=== 2026-11-03T09:00:00.000Z logged out\n'));
      expect(text, contains('StateError: Bad state: Ditto not initialized'));
      expect(text, contains('#0 main'));
    });

    test('a reason alone is one line', () {
      expect(
        StartupRouteLog.format(DateTime.utc(2026), 'no userId'),
        '=== 2026-01-01T00:00:00.000Z no userId\n',
      );
    });
  });

  group('StartupViewModel.fastStartupFor', () {
    test('only a cached signed-in session opens the home first', () {
      expect(
        StartupViewModel.fastStartupFor(
          hasCachedSession: true,
          freshSignup: false,
        ),
        isTrue,
      );
      expect(
        StartupViewModel.fastStartupFor(
          hasCachedSession: false,
          freshSignup: false,
        ),
        isFalse,
      );
    });

    test('a fresh signup keeps the blocking path to LoginChoices', () {
      // CoreSync.signup caches both ids before it sets freshSignup.
      expect(
        StartupViewModel.fastStartupFor(
          hasCachedSession: true,
          freshSignup: true,
        ),
        isFalse,
      );
    });
  });
}
