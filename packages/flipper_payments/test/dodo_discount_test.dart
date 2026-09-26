import 'dart:convert';

import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Records every request and answers from a script.
class _ScriptedHttp implements PaymentsHttpClient {
  _ScriptedHttp(this.responses);

  final List<http.Response> responses;
  final List<({String method, Uri url, Object? body})> calls = [];

  http.Response _next() =>
      responses.isEmpty ? http.Response('{}', 500) : responses.removeAt(0);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    calls.add((method: 'GET', url: url, body: null));
    return _next();
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    calls.add((method: 'POST', url: url, body: body));
    return _next();
  }
}

Map<String, dynamic> _start({Map<String, dynamic>? discount}) => {
  'plan_id': 'plan-1',
  'business_id': 'biz-1',
  'dodo_subscription_id': 'sub_1',
  'status': 'pending',
  'total_price': 4080,
  'currency': 'RWF',
  'rule': 'monthly',
  'recurring_pre_tax_amount': 4080,
  'next_action': 'open_payment_link',
  'checkout': {'payment_link': 'https://checkout.test/1'},
  'mode': 'test',
  'reused_existing': false,
  if (discount != null) 'discount': discount,
};

http.Response _ok(Map<String, dynamic> body) =>
    http.Response(jsonEncode(body), 200);

void main() {
  setUp(() => setPaymentsApiBaseUrlOverride('https://connector.test'));
  tearDown(() {
    setPaymentsApiBaseUrlOverride(null);
    resetPaymentsApiBaseUrlCache();
  });

  test('a discount code is sent as the code alone, never as a price', () async {
    final client = _ScriptedHttp([_ok(_start())]);
    await DodoClient(client).startSubscription(
      businessId: 'biz-1',
      planId: 'plan-1',
      selectedPlan: 'Mobile',
      discountCode: ' save20 ',
    );

    final body = jsonDecode(client.calls.single.body as String) as Map;
    expect(body['flipper_discount_code'], 'SAVE20');
    expect(
      body.containsKey('discount_code'),
      isFalse,
      reason: 'discount_code is a Dodo code and means something else',
    );
    expect(body.containsKey('total_price'), isFalse);
  });

  test('no code, no field', () async {
    final client = _ScriptedHttp([_ok(_start())]);
    await DodoClient(client).startSubscription(businessId: 'biz-1');
    final body = jsonDecode(client.calls.single.body as String) as Map;
    expect(body.containsKey('flipper_discount_code'), isFalse);
  });

  test('the applied discount is parsed from the start response', () {
    final result = DodoStartResult.fromJson(
      _start(
        discount: {
          'code': 'SAVE20',
          'discount_code_id': 'dc-1',
          'original_price': 5100,
          'discount_amount': 1020,
          'final_price': 4080,
          'custom_payment_id': 'cp-1',
        },
      ),
    );
    expect(result.totalPrice, 4080);
    expect(result.discount?.code, 'SAVE20');
    expect(result.discount?.originalPrice, 5100);
    expect(result.discount?.finalPrice, 4080);
    expect(result.discount?.customPaymentId, 'cp-1');
  });

  test('a full-price start has no discount', () {
    expect(DodoStartResult.fromJson(_start()).discount, isNull);
  });

  group('per-plan calls carry this build\'s mode', () {
    Map<String, dynamic> status() => {
      'plan_id': 'plan-1',
      'dodo_subscription_id': 'sub_1',
      'status': 'pending',
      'next_action': 'open_payment_link',
    };

    test('read, sync and the business lookup', () async {
      final client = _ScriptedHttp([
        _ok(status()),
        _ok(status()),
        _ok(status()),
      ]);
      final dodo = DodoClient(client);
      await dodo.subscriptionForPlan('plan-1');
      await dodo.syncSubscription('plan-1');
      await dodo.subscriptionForBusiness('biz-1');

      for (final call in client.calls) {
        expect(
          call.url.queryParameters['mode'],
          dodoBuildMode,
          reason:
              '${call.method} ${call.url.path} must not read the other Dodo account',
        );
      }
      expect(client.calls[0].url.path, '/api/dodo/subscriptions/plan-1');
      expect(client.calls[1].url.path, '/api/dodo/subscriptions/plan-1/sync');
      expect(
        client.calls[2].url.path,
        '/api/dodo/businesses/biz-1/subscription',
      );
    });

    test('payment-method, portal and cancel', () async {
      final client = _ScriptedHttp([
        _ok({
          'checkout': {'payment_link': 'https://checkout.test/2'},
        }),
        _ok({'portal_link': 'https://portal.test'}),
        _ok({'status': 'cancelled'}),
      ]);
      final dodo = DodoClient(client);
      await dodo.updatePaymentMethod('plan-1');
      await dodo.customerPortalLink('plan-1');
      await dodo.cancelSubscription('plan-1');
      expect(
        client.calls.map((c) => c.url.queryParameters['mode']),
        everyElement(dodoBuildMode),
      );
    });
  });

  test('health reports whether the connector bills discount codes on card', () {
    final base = {
      'enabled': true,
      'ready': true,
      'modes_available': [dodoBuildMode],
    };
    expect(
      DodoHealth.fromJson(base).discountCodesForThisBuild,
      isFalse,
      reason: 'an older connector ignores the code, so the card must say so',
    );
    expect(
      DodoHealth.fromJson({
        ...base,
        'flipper_discount_codes': true,
      }).discountCodesForThisBuild,
      isTrue,
    );
    expect(
      DodoHealth.fromJson({
        ...base,
        'ready': false,
        'flipper_discount_codes': true,
      }).discountCodesForThisBuild,
      isFalse,
    );
  });
}
