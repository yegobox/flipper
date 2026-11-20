import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_login/signup_error_text.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupFlipperAppLocalizations(const Locale('en'));

  group('signupKnownErrorText', () {
    test('a login linked to another account gets its own message', () {
      expect(
        signupKnownErrorText(const LoginLinkedToOtherAccountException(), l10n),
        l10n.signupErrorLoginLinkedToOtherAccount,
      );
    });

    test('other errors fall back to the caller', () {
      expect(signupKnownErrorText(Exception('boom'), l10n), isNull);
    });
  });

  group('LoginLinkedToOtherAccountException.matches', () {
    const body =
        '{"error":"already linked","code":"login_linked_to_other_account"}';

    test('matches the server 409 with its code', () {
      expect(LoginLinkedToOtherAccountException.matches(409, body), isTrue);
    });

    test('ignores other statuses and other 409s', () {
      expect(LoginLinkedToOtherAccountException.matches(500, body), isFalse);
      expect(
        LoginLinkedToOtherAccountException.matches(409, '{"error":"x"}'),
        isFalse,
      );
    });
  });
}
