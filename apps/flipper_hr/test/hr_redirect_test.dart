import 'package:flipper_hr/router/hr_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('unauthenticated', () {
    test('login and signup are reachable', () {
      for (final path in hrPublicPaths) {
        expect(
          hrRedirectLocation(isAuthenticated: false, path: path),
          isNull,
          reason: '$path should stay put',
        );
      }
    });

    test('root and HR pages fall back to login', () {
      for (final path in [
        '/',
        '/overview',
        '/people',
        '/attendance',
        '/leave',
        '/my-time',
        '/approvals',
        '/business-selection',
        '/unknown',
      ]) {
        expect(
          hrRedirectLocation(isAuthenticated: false, path: path),
          '/login',
          reason: '$path should redirect to login',
        );
      }
    });
  });

  group('authenticated', () {
    test('login and signup send the session to business selection', () {
      for (final path in hrPublicPaths) {
        expect(
          hrRedirectLocation(isAuthenticated: true, path: path),
          '/business-selection',
        );
      }
    });

    test('root is left to HrAuthGate', () {
      expect(hrRedirectLocation(isAuthenticated: true, path: '/'), isNull);
    });

    test('HR pages stay put', () {
      // The self-service pages included: an invited employee never picks a
      // business, so a redirect through the selector would strand them.
      for (final path in [
        '/overview',
        '/people',
        '/attendance',
        '/leave',
        '/my-time',
        '/approvals',
        '/business-selection',
      ]) {
        expect(hrRedirectLocation(isAuthenticated: true, path: path), isNull);
      }
    });
  });
}
