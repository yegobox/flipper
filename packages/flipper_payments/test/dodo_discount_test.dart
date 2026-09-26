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
}
