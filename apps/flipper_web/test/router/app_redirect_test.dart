import 'package:flipper_web/router/app_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? go(String path, {bool? auth, bool nativeLogin = false}) =>
      appRedirect(
        path: path,
        authenticated: auth,
        opensOnLoginScreen: nativeLogin,
      );

  group('shop routes are public', () {
    const paths = [
      '/shop/kigali-mart',
      '/shop/kigali-mart/checkout',
      '/shop/kigali-mart/order/o1',
    ];

    test('signed out: not sent to login', () {
      for (final p in paths) {
        expect(go(p, auth: false), isNull, reason: p);
        expect(go(p, auth: false, nativeLogin: true), isNull, reason: p);
      }
    });

    test('signed in: not bounced to the app', () {
      for (final p in paths) {
        expect(go(p, auth: true), isNull, reason: p);
      }
    });

    test('while auth loads nothing redirects', () {
      expect(go('/shop/x'), isNull);
    });
  });

  test('protected routes still need a sign-in', () {
    for (final p in kProtectedPaths) {
      expect(go(p, auth: false), '/login', reason: p);
      expect(go(p, auth: true), isNull, reason: p);
    }
  });

  test('login and root behave as before', () {
    expect(go('/login', auth: true), '/business-selection');
    expect(go('/', auth: true), isNull);
    expect(go('/', auth: false), isNull);
    expect(go('/', auth: false, nativeLogin: true), '/login');
    expect(go('/apps', auth: false), isNull);
  });

  group('shopDeepLinkLocation', () {
    test('a plain shop path becomes the first location, query kept', () {
      expect(
        shopDeepLinkLocation(Uri.parse('https://useflipper.com/shop/kigali')),
        '/shop/kigali',
      );
      expect(
        shopDeepLinkLocation(
          Uri.parse('https://useflipper.com/shop/kigali/order/o1?t=abc'),
        ),
        '/shop/kigali/order/o1?t=abc',
      );
    });

    test('hash routes and other paths are left to the router', () {
      expect(
        shopDeepLinkLocation(Uri.parse('https://useflipper.com/#/accounting')),
        isNull,
      );
      expect(
        shopDeepLinkLocation(
          Uri.parse('https://useflipper.com/shop/kigali#/shop/kigali'),
        ),
        isNull,
      );
      expect(
        shopDeepLinkLocation(Uri.parse('https://useflipper.com/')),
        isNull,
      );
    });
  });
}
