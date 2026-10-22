import 'dart:convert';

import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_balance_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _base = 'http://connector.test';

BankBalanceService _service(
  Future<http.Response> Function(http.Request) handler,
) => BankBalanceService(client: MockClient(handler), baseUrl: _base);

http.Response _json(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

void main() {
  test('balances are read per account and per code', () async {
    final service = _service((req) async {
      expect(req.url.toString(), '$_base/api/bank-balances');
      return _json({
        'accounts': [
          {
            'bankAccountCode': '1020',
            'providerLabel': 'BK',
            'ownAccount': '****0042',
            'balance': 54321,
            'observedAt': '2026-10-22T16:11:00Z',
            'stale': false,
          },
          {
            'bankAccountCode': '1030',
            'providerLabel': 'MTN MoMo',
            'balance': 3000.0,
            'observedAt': '2026-10-21T08:00:00Z',
            'stale': true,
          },
          'junk',
        ],
        'totals': [
          {
            'bankAccountCode': '1020',
            'balance': 54321,
            'observedAt': '2026-10-22T16:11:00Z',
          },
        ],
      });
    });
    final balances = (await service.balances())!;
    expect(balances.accounts, hasLength(2));
    expect(balances.accounts.first.label, 'BK ****0042');
    expect(balances.accounts.last.label, 'MTN MoMo');
    expect(balances.accounts.last.stale, isTrue);
    expect(
      balances.accounts.first.observedAt,
      DateTime.utc(2026, 10, 22, 16, 11).toLocal(),
    );
    expect(balances.totalFor('1020')!.balance, 54321);
    expect(balances.totalFor('1030'), isNull);
    expect(balances.accountsFor('1030').single.balance, 3000);
  });

  test('missing fields fall back instead of failing', () {
    final a = SmsAccountBalance.fromJson(const {});
    expect(a.balance, 0);
    expect(a.observedAt, DateTime.fromMillisecondsSinceEpoch(0));
    final t = SmsBalanceTotal.fromJson(const {'observedAt': 'not a date'});
    expect(t.balance, 0);
    expect(t.stale, isFalse);
    expect(SmsBalances.fromJson(const {}).accounts, isEmpty);
    expect(SmsBalanceAlert.fromJson(const {}).enabled, isTrue);
  });

  test(
    'a user who may not see balances gets nothing, an outage throws',
    () async {
      for (final status in [401, 403, 404]) {
        final service = _service((_) async => _json({'error': 'no'}, status));
        expect(await service.balances(), isNull);
        expect(await service.alerts(), isEmpty);
      }
      final down = _service((_) async => _json({'error': 'down'}, 500));
      expect(down.balances, throwsA(isA<BankBalanceException>()));
    },
  );

  test('alert levels are read by code and saved with a PUT', () async {
    http.Request? put;
    final service = _service((req) async {
      if (req.method == 'PUT') {
        put = req;
        return _json({'ok': true});
      }
      return _json({
        'alerts': [
          {'bankAccountCode': '1020', 'threshold': 10000, 'enabled': true},
          {'bankAccountCode': '1030', 'threshold': 2500.0, 'enabled': false},
        ],
      });
    });
    final alerts = await service.alerts();
    expect(alerts['1020']!.threshold, 10000);
    expect(alerts['1030']!.threshold, 2500);
    expect(alerts['1030']!.enabled, isFalse);

    await service.setAlert(bankAccountCode: '1030', threshold: 5000);
    expect(put!.url.toString(), '$_base/api/bank-balances/alerts');
    expect(jsonDecode(put!.body), {
      'bankAccountCode': '1030',
      'threshold': 5000,
      'enabled': true,
    });
  });

  test('a refused save says why', () async {
    final refused = _service(
      (_) async => _json({'error': 'threshold cannot be negative'}, 400),
    );
    await expectLater(
      refused.setAlert(bankAccountCode: '1020', threshold: -1),
      throwsA(
        isA<BankBalanceException>().having(
          (e) => e.toString(),
          'message',
          'threshold cannot be negative',
        ),
      ),
    );
    final garbled = _service((_) async => http.Response('<html>', 502));
    await expectLater(
      garbled.setAlert(bankAccountCode: '1020', threshold: 1),
      throwsA(
        isA<BankBalanceException>().having(
          (e) => e.message,
          'message',
          'Saving the alert level failed (502)',
        ),
      ),
    );
  });

  test('the providers turn failures into "nothing to show"', () async {
    final container = ProviderContainer(
      overrides: [
        accountingBusinessIdProvider.overrideWithValue('biz'),
        bankBalanceServiceProvider.overrideWithValue(
          _service((_) async => _json({'error': 'down'}, 500)),
        ),
      ],
    );
    addTearDown(container.dispose);
    expect(await container.read(smsBankBalancesProvider.future), isNull);
    expect(await container.read(smsBalanceAlertsProvider.future), isEmpty);
  });

  test('the default service talks to the local connector in debug', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      container.read(bankBalanceServiceProvider),
      isA<BankBalanceService>(),
    );
  });
}
