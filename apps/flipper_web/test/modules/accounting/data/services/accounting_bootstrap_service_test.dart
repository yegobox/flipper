import 'dart:convert';

import 'package:flipper_web/modules/accounting/data/services/accounting_bootstrap_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AccountingBootstrapService', () {
    test('ensureBusinessReady posts businessId and parses response', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/accounting/bootstrap');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['businessId'], '550e8400-e29b-41d4-a716-446655440000');

        return http.Response(
          jsonEncode({
            'seeded': true,
            'alreadyReady': false,
            'coaCount': 24,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = AccountingBootstrapService(
        client: client,
        baseUrl: 'http://localhost:8084',
      );

      final result = await service.ensureBusinessReady(
        '550e8400-e29b-41d4-a716-446655440000',
      );
      expect(result.seeded, isTrue);
      expect(result.alreadyReady, isFalse);
      expect(result.coaCount, 24);
    });

    test('ensureBusinessReady throws on empty businessId', () async {
      final service = AccountingBootstrapService(
        client: MockClient((_) async => http.Response('', 200)),
        baseUrl: 'http://localhost:8084',
      );

      expect(
        () => service.ensureBusinessReady(''),
        throwsA(isA<AccountingBootstrapException>()),
      );
    });

    test('ensureBusinessReady marks network errors offline', () async {
      final service = AccountingBootstrapService(
        client: MockClient((_) async {
          throw Exception('connection refused');
        }),
        baseUrl: 'http://localhost:8084',
      );

      try {
        await service.ensureBusinessReady(
          '550e8400-e29b-41d4-a716-446655440000',
        );
        fail('expected exception');
      } on AccountingBootstrapException catch (e) {
        expect(e.isOffline, isTrue);
      }
    });

    test('ensureBusinessReady surfaces API error body', () async {
      final service = AccountingBootstrapService(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'error': 'businessId is required'}),
            400,
            headers: {'content-type': 'application/json'},
          ),
        ),
        baseUrl: 'http://localhost:8084',
      );

      expect(
        () => service.ensureBusinessReady(
          '550e8400-e29b-41d4-a716-446655440000',
        ),
        throwsA(
          predicate<AccountingBootstrapException>(
            (e) => e.message.contains('businessId is required'),
          ),
        ),
      );
    });
  });
}
