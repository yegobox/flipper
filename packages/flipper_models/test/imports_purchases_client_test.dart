import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/imports_purchases_client.dart';
import 'package:flipper_models/imports_purchases_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/variant.model.dart';

Future<String> _requestBody(http.BaseRequest request) async {
  if (request is http.Request) {
    return request.body;
  }
  final bytes = await request.finalize().fold<List<int>>(
    [],
    (previous, element) => previous..addAll(element),
  );
  return utf8.decode(bytes);
}

class _MockClient extends http.BaseClient {
  _MockClient(this.handler);

  final Future<http.Response> Function(http.BaseRequest request) handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
      request: request,
    );
  }
}

ImportPurchaseContext _ctx() => const ImportPurchaseContext(
  tinNumber: '999909695',
  bhfId: '00',
  branchId: 'branch-1',
  businessId: 'biz-1',
  taxServerUrl: 'https://tax.example/',
  vatEnabled: true,
);

void main() {
  group('ImportsPurchasesClient', () {
    test('syncImports posts context and returns 202 job', () async {
      Map<String, dynamic>? capturedBody;
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084',
        logHttp: false,
        httpClient: _MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/imports/sync');
          capturedBody =
              jsonDecode(await _requestBody(request)) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'jobId': 'imp_pur_1',
              'operation': 'syncImports',
              'status': 'queued',
            }),
            202,
          );
        }),
      );

      final accepted = await client.syncImports(_ctx());
      expect(accepted.jobId, 'imp_pur_1');
      expect(capturedBody?['branchId'], 'branch-1');
      expect(capturedBody?['vatEnabled'], true);
    });

    test('approvePurchase serializes itemMapper', () async {
      Map<String, dynamic>? capturedBody;
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084/',
        logHttp: false,
        httpClient: _MockClient((request) async {
          capturedBody =
              jsonDecode(await _requestBody(request)) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'jobId': 'imp_pur_2',
              'operation': 'approvePurchase',
              'status': 'queued',
            }),
            202,
          );
        }),
      );

      await client.approvePurchase(
        _ctx(),
        purchaseId: 'purchase-1',
        itemMapper: {
          'target-a': ['line-1', 'line-2'],
        },
      );

      expect(capturedBody?['purchaseId'], 'purchase-1');
      expect(capturedBody?['itemMapper'], {
        'target-a': ['line-1', 'line-2'],
      });
    });

    test('pollJobUntilTerminal returns on success', () async {
      var polls = 0;
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084',
        logHttp: false,
        httpClient: _MockClient((request) async {
          polls++;
          final status = polls < 2 ? 'processing' : 'success';
          return http.Response(
            jsonEncode({
              'jobId': 'imp_pur_3',
              'operation': 'syncImports',
              'status': status,
              'fetched': 3,
            }),
            200,
          );
        }),
      );

      final result = await client.pollJobUntilTerminal(
        'imp_pur_3',
        interval: Duration.zero,
        timeout: const Duration(seconds: 5),
      );
      expect(result.isSuccess, isTrue);
      expect(result.fetched, 3);
      expect(polls, 2);
    });

    test('pollJobUntilTerminal throws on timeout', () async {
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084',
        logHttp: false,
        httpClient: _MockClient((request) async {
          return http.Response(
            jsonEncode({'jobId': 'imp_pur_4', 'status': 'processing'}),
            200,
          );
        }),
      );

      expect(
        () => client.pollJobUntilTerminal(
          'imp_pur_4',
          interval: Duration.zero,
          timeout: const Duration(milliseconds: 10),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('listImports parses nested stock', () async {
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084',
        logHttp: false,
        httpClient: _MockClient((request) async {
          expect(request.url.queryParameters['branchId'], 'branch-1');
          return http.Response(
            jsonEncode({
              'branchId': 'branch-1',
              'count': 1,
              'imports': [
                {
                  'id': 'var-1',
                  'name': 'Widget',
                  'branchId': 'branch-1',
                  'itemNm': 'Widget',
                  'imptItemSttsCd': '2',
                  'stock': {
                    'id': 'stock-1',
                    'branchId': 'branch-1',
                    'currentStock': 5,
                  },
                },
              ],
            }),
            200,
          );
        }),
      );

      final items = await client.listImports('branch-1');
      expect(items, hasLength(1));
      expect(items.first.id, 'var-1');
      expect(items.first.stock?.id, 'stock-1');
      expect(items.first.stock?.currentStock, 5);
    });

    test('listPurchases throws ImportsPurchasesApiException on 404', () async {
      final client = ImportsPurchasesClient(
        baseUrl: 'http://127.0.0.1:8084',
        logHttp: false,
        httpClient: _MockClient((request) async {
          expect(request.url.path, '/purchases');
          return http.Response('', 404);
        }),
      );

      expect(
        () => client.listPurchases('branch-1'),
        throwsA(
          isA<ImportsPurchasesApiException>().having(
            (e) => e.isNotFound,
            'isNotFound',
            isTrue,
          ),
        ),
      );
    });
  });

  group('imports_purchases_map', () {
    test('buildPurchaseItemMapper maps variant ids', () {
      final line1 = Variant(id: 'line-1', name: 'A', branchId: 'b');
      final line2 = Variant(id: 'line-2', name: 'B', branchId: 'b');
      final mapper = buildPurchaseItemMapper({
        'target-x': [line1, line2],
      });
      expect(mapper, {
        'target-x': ['line-1', 'line-2'],
      });
    });

    test('status api params', () {
      expect(importStatusApiParam('pending'), '2');
      expect(purchaseStatusApiParam('pending'), '01');
      expect(importStatusApiParam('all'), isNull);
    });
  });
}
