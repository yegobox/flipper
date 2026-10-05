import 'dart:async';

import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

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
      expect(keeps(SessionException(term: 'No user in local storage')), isFalse);
      expect(keeps(PinError(term: 'pin')), isFalse);
      expect(keeps(LoginChoicesException(term: 'Branch ID not set')), isFalse);
    });

    test('online behaviour is unchanged', () {
      expect(
        keeps(Exception('requirements failed'), online: true),
        isFalse,
      );
      expect(
        keeps(BusinessNotFoundException(term: 'missing'), online: true),
        isFalse,
      );
    });

    test('a device with no session on it is never let in', () {
      expect(
        keeps(Exception('requirements failed'), hasCachedSession: false),
        isFalse,
      );
    });
  });
}
