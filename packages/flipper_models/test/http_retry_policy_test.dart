import 'dart:io';

import 'package:flipper_models/http_retry_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isRetryableTransportError', () {
    test('a dropped TLS handshake retries for every method', () {
      final dropped = HandshakeException(
        'Connection terminated during handshake',
      );
      for (final method in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']) {
        expect(
          isRetryableTransportError(dropped, method: method),
          isTrue,
          reason: method,
        );
      }
    });

    test('socket errors retry reads only', () {
      const reset = SocketException('Connection reset by peer');
      expect(isRetryableTransportError(reset, method: 'GET'), isTrue);
      expect(isRetryableTransportError(reset, method: 'HEAD'), isTrue);
      expect(isRetryableTransportError(reset, method: 'POST'), isFalse);
    });

    test('other errors do not retry', () {
      expect(
        isRetryableTransportError(const FormatException('x'), method: 'GET'),
        isFalse,
      );
    });
  });
}
