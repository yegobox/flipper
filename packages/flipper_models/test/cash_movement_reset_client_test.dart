import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/cash_movement_reset_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late List<http.Request> sent;

  CashMovementResetClient client(int status, Object body) {
    sent = [];
    return CashMovementResetClient(
      baseUrl: () async => 'https://connector.test',
      httpClient: MockClient((request) async {
        sent.add(request);
        return http.Response(jsonEncode(body), status);
      }),
    );
  }

  const preview = {
    'business_id': 'b1',
    'business_name': 'Kigali Shop',
    'dry_run': true,
    'deleted': false,
    'transactions': 3,
    'items': 3,
    'journal_entries': 2,
    'total_amount': 1750.0,
    'by_kind': {
      'cash_out': {'count': 2, 'amount': 1250.0},
      'cash_in': {'count': 1, 'amount': 500},
    },
  };

  test('preview posts a dry run for the chosen kinds only', () async {
    final summary = await client(
      200,
      preview,
    ).preview({CashMovementKind.cashOut});

    expect(
      sent.single.url.toString(),
      'https://connector.test/api/cash-movements/reset',
    );
    expect(jsonDecode(sent.single.body), {
      'kinds': ['cash_out'],
      'dry_run': true,
    });
    expect(summary.businessName, 'Kigali Shop');
    expect(summary.transactions, 3);
    expect(summary.journalEntries, 2);
    expect(summary.totalsFor(CashMovementKind.cashOut).amount, 1250);
    expect(summary.totalsFor(CashMovementKind.cashIn).count, 1);
  });

  test('reset sends the trimmed confirmation and dry_run false', () async {
    await client(200, {...preview, 'dry_run': false, 'deleted': true}).reset({
      CashMovementKind.cashIn,
      CashMovementKind.cashOut,
    }, confirm: '  Kigali Shop ');

    final body = jsonDecode(sent.single.body) as Map<String, dynamic>;
    expect(body['dry_run'], isFalse);
    expect(body['confirm'], 'Kigali Shop');
    expect(body['kinds'], unorderedEquals(['cash_in', 'cash_out']));
    expect(
      body.containsKey('business_id'),
      isFalse,
      reason: 'the connector takes the business from the device token',
    );
  });

  test('a server error surfaces its message and status', () async {
    final c = client(400, {'error': 'type the business name'});
    await expectLater(
      c.reset({CashMovementKind.cashOut}, confirm: 'nope'),
      throwsA(
        isA<CashResetException>()
            .having((e) => e.message, 'message', 'type the business name')
            .having((e) => e.statusCode, 'statusCode', 400),
      ),
    );
  });

  test('no kinds is refused before any request', () async {
    final c = client(200, preview);
    await expectLater(c.preview({}), throwsA(isA<CashResetException>()));
    expect(sent, isEmpty);
  });

  group('a server that never answers', () {
    CashMovementResetClient hanging() => CashMovementResetClient(
      baseUrl: () async => 'https://connector.test',
      httpClient: MockClient((_) => Completer<http.Response>().future),
      timeout: const Duration(milliseconds: 20),
    );

    test('a preview timeout says nothing was deleted', () async {
      await expectLater(
        hanging().preview({CashMovementKind.cashIn}),
        throwsA(
          isA<CashResetException>().having(
            (e) => e.message,
            'message',
            contains('nothing was deleted'),
          ),
        ),
      );
    });

    test('a reset timeout says the outcome is unknown', () async {
      await expectLater(
        hanging().reset({CashMovementKind.cashIn}, confirm: 'Kigali Shop'),
        throwsA(
          isA<CashResetException>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('may still have completed'),
              isNot(contains('nothing')),
            ),
          ),
        ),
      );
    });
  });
}
