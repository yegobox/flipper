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
      expect(
        pinLoginErrorText(
          Exception('Failed to request OTP (HTTP 404): not found'),
        ),
        endsWith('(PIN-404)'),
      );
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

    test('anything else keeps the original detail, trimmed', () {
      expect(
        pinLoginErrorText(Exception('Cannot authenticate offline')),
        'Sign-in failed: Cannot authenticate offline',
      );
      expect(
        pinLoginErrorText(Object()),
        endsWith('(UNKNOWN)'),
      );
    });
  });
}
