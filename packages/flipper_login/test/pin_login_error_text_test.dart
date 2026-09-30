import 'dart:async';

import 'package:flipper_login/pin_login_error_text.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pinLoginErrorText', () {
    test('host lookup failure says the internet is off or limited', () {
      final text = pinLoginErrorText(Exception(
        'Unknown error: ClientException with SocketException: '
        "Failed host lookup: 'apihub.yegobox.com'",
      ));
      expect(text, endsWith('(DNS)'));
    });

    test('socket failures say the server could not be reached', () {
      final text = pinLoginErrorText(
        Exception('Failed to connect: Network is unreachable'),
      );
      expect(text, endsWith('(NET)'));
    });

    test('TLS failures point at the phone clock', () {
      final text = pinLoginErrorText(Exception(
        'Failed to connect: HandshakeException: CERTIFICATE_VERIFY_FAILED',
      ));
      expect(text, contains('date and time'));
      expect(text, endsWith('(TLS)'));
    });

    test('timeouts are reported as slow connection', () {
      expect(
        pinLoginErrorText(TimeoutException('slow')),
        endsWith('(TIMEOUT)'),
      );
    });

    test('unknown PIN is not reported as a network problem', () {
      expect(
        pinLoginErrorText(NeedSignUpException(term: 'x')),
        endsWith('(PIN-404)'),
      );
      // flipper-turbo /v2/api/login/pin 404s only when no PIN row matches.
      expect(
        pinLoginErrorText(
          Exception('Failed to request OTP (HTTP 404): not found'),
        ),
        endsWith('(PIN-404)'),
      );
    });

    test('other 404s are not reported as a missing account', () {
      final text = pinLoginErrorText(
        Exception('Failed to verify OTP (HTTP 404): not found'),
      );
      expect(text, endsWith('(HTTP-404)'));
      expect(text, isNot(contains('No account')));
    });

    test('server errors carry the HTTP status', () {
      expect(
        pinLoginErrorText(PinError(term: 'HTTP 503')),
        endsWith('(HTTP-503)'),
      );
      expect(
        pinLoginErrorText(Exception('Failed to request OTP (HTTP 429)')),
        endsWith('(HTTP-429)'),
      );
    });

    test('malformed server responses get a stable message', () {
      final text = pinLoginErrorText(
        const FormatException('Unexpected character', '<html>secret body'),
      );
      expect(text, endsWith('(BAD-RESPONSE)'));
      expect(text, isNot(contains('secret body')));
    });

    test('offline sign-in without a saved user explains the fix', () {
      expect(
        pinLoginErrorText(
          Exception('Cannot authenticate offline without a saved user id'),
        ),
        endsWith('(OFFLINE-FIRST)'),
      );
    });

    test('unmapped failures never show raw exception text', () {
      const internal = 'StateError: repository closed at /data/app/x.db';
      final text = pinLoginErrorText(Exception(internal));
      expect(text, 'Sign-in failed. Try again. (UNKNOWN)');
      expect(pinLoginErrorText(Object()), endsWith('(UNKNOWN)'));
    });
  });
}
