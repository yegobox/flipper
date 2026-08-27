import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/dodo/dodo_client.dart';
import 'package:flipper_services/dodo/dodo_models.dart';
import 'package:flipper_services/dodo/dodo_subscription.dart';
import 'package:flipper_services/payment_rail.dart';
import 'package:flipper_services/payments_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// One canned reply.
class _Reply {
  const _Reply(this.status, this.body);
  final int status;
  final String body;
}

/// Records every request and answers from a per-path queue.
///
/// What went on the wire matters as much as the response handling here: the
/// single most expensive mistake on this rail would be sending a discounted
/// amount Dodo does not honour, so the tests assert the *absence* of a price
/// field as carefully as the presence of the ids.
class _FakeHttpClient implements HttpClientInterface {
  final List<http.Request> requests = [];
  final Map<String, List<_Reply>> _queued = {};
  _Reply fallback = const _Reply(200, '{}');

  void queue(String pathContains, List<_Reply> replies) =>
      _queued[pathContains] = [...replies];

  Iterable<http.Request> forPath(String pathContains) =>
      requests.where((r) => r.url.path.contains(pathContains));

  Map<String, dynamic> bodyOf(int index) =>
      jsonDecode(requests[index].body) as Map<String, dynamic>;

  _Reply _next(Uri url) {
    for (final entry in _queued.entries) {
      if (url.path.contains(entry.key)) {
        if (entry.value.isEmpty) return fallback;
        // The last queued reply repeats, so a poll loop keeps getting it.
        return entry.value.length == 1
            ? entry.value.first
            : entry.value.removeAt(0);
      }
    }
    return fallback;
  }

  http.Response _record(String method, Uri url, Object? body) {
    final request = http.Request(method, url);
    if (body is String) request.body = body;
    requests.add(request);
    final reply = _next(url);
    return http.Response(reply.body, reply.status);
  }

  @override
  Future<http.Response> post(Uri url,
          {Map<String, String>? headers,
          Object? body,
          Encoding? encoding}) async =>
      _record('POST', url, body);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async =>
      _record('GET', url, null);

  @override
  Future<http.Response> put(Uri url,
          {Map<String, String>? headers,
          Object? body,
          Encoding? encoding}) async =>
      _record('PUT', url, body);

  @override
  Future<http.Response> patch(Uri url,
          {Map<String, String>? headers,
          Object? body,
          Encoding? encoding}) async =>
      _record('PATCH', url, body);

  @override
  Future<http.Response> delete(Uri url,
          {Map<String, String>? headers,
          Object? body,
          Encoding? encoding}) async =>
      _record('DELETE', url, body);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      throw UnimplementedError();

  @override
  Future<http.Response> getUniversalProducts(Uri url,
          {Map<String, String>? headers,
          Object? body,
          Encoding? encoding}) =>
      throw UnimplementedError();
}

String _startOk({
  String planId = 'plan-1',
  String subscriptionId = 'sub_abc',
  String status = 'pending',
  String nextAction = 'open_payment_link',
  String? paymentLink = 'https://checkout.dodopayments.com/xyz',
  bool reusedExisting = false,
}) =>
    jsonEncode({
      'plan_id': planId,
      'business_id': 'biz-1',
      'dodo_subscription_id': subscriptionId,
      'status': status,
      'total_price': 5100,
      'currency': 'RWF',
      'rule': 'monthly',
      'recurring_pre_tax_amount': 5100,
      'next_action': nextAction,
      'reused_existing': reusedExisting,
      if (paymentLink != null)
        'checkout': {
          'payment_link': paymentLink,
          'payment_id': 'pay_1',
          'expires_on': '2026-08-26T11:00:00Z',
        },
    });

String _view({
  bool entitled = false,
  String status = 'pending',
  String nextAction = 'awaiting_activation',
  String? lastError,
}) =>
    jsonEncode({
      'plan_id': 'plan-1',
      'dodo_subscription_id': 'sub_abc',
      'status': status,
      'entitled': entitled,
      'currency': 'RWF',
      'recurring_pre_tax_amount': 5100,
      'plan_total_price': 5100,
      'next_action': nextAction,
      'cancel_at_next_billing_date': false,
      if (lastError != null) 'last_error': lastError,
      'recent_payments': [
        {
          'dodo_payment_id': 'pay_1',
          'status': entitled ? 'succeeded' : 'processing',
          'kind': 'first',
          'amount': 5100,
          'currency': 'RWF',
        }
      ],
    });

void main() {
  setUpAll(() => setPaymentsApiBaseUrlOverride('https://connector.test'));
  tearDownAll(() => setPaymentsApiBaseUrlOverride(null));

  group('payment rails', () {
    test('the wire values are the connector\'s, not ours', () {
      // Dodo's webhook stamps `DODO` on the plan when it projects a
      // subscription. Writing anything else would make the row disagree with
      // itself the moment the first webhook landed.
      expect(PaymentRail.card.wireValue, 'DODO');
      expect(PaymentRail.mtnMomo.wireValue, 'MTNMOMO');
    });

    test('every legacy payment_method reads back as Mobile Money', () {
      // MoMo is the rail every existing plan is on, so it is the only safe
      // default — including for the retired Paystack flow's `CARD` / `Card`,
      // which must NOT be mistaken for the Dodo card rail.
      for (final legacy in ['CARD', 'Card', 'MTNMOMO', 'paystack', '', null]) {
        expect(
          PaymentRail.fromWire(legacy),
          PaymentRail.mtnMomo,
          reason: 'legacy value "$legacy" must stay on Mobile Money',
        );
      }
      expect(PaymentRail.fromWire('DODO'), PaymentRail.card);
      expect(PaymentRail.fromWire('dodo'), PaymentRail.card);
    });
  });

  group('health gates the card option', () {
    test('ready only when enabled and holding an API key', () async {
      final http = _FakeHttpClient()
        ..queue('/api/dodo/health', [
          _Reply(
              200,
              jsonEncode({
                'status': 'ok',
                'enabled': true,
                'ready': true,
                'mode': 'live',
                'currency': 'RWF',
              })),
        ]);

      final health = await DodoClient(http).health();
      expect(health.ready, isTrue);
      expect(health.isTestMode, isFalse);
    });

    test('an unreachable connector hides the option instead of failing',
        () async {
      // A payment screen must not fail to load because a *second* rail could
      // not be probed. Mobile Money is unaffected either way.
      final http = _FakeHttpClient()
        ..queue('/api/dodo/health', [const _Reply(503, 'Bad Gateway')]);

      final health = await DodoClient(http).health();
      expect(health.ready, isFalse);
      expect(health.enabled, isFalse);
    });
  });

  group('starting a subscription', () {
    test('sends the tier and never a price', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [_Reply(200, _startOk())]);

      await DodoClient(http).startSubscription(
        businessId: 'biz-1',
        planId: 'plan-1',
        selectedPlan: 'Mobile',
        addons: const ['tax_reporting'],
        isYearlyPlan: false,
        email: 'owner@shop.rw',
      );

      final body = http.bodyOf(0);
      expect(body['business_id'], 'biz-1');
      expect(body['plan_id'], 'plan-1');
      expect(body['selected_plan'], 'Mobile');
      expect(body['addons'], ['tax_reporting']);
      expect(body['email'], 'owner@shop.rw');
      // The connector prices the tier from the catalogue and Dodo bills the
      // price fixed on its product. Sending a figure — a discounted one
      // especially — would only make plans.total_price disagree with the card.
      expect(body.containsKey('total_price'), isFalse);
      expect(body.containsKey('amount'), isFalse);
    });

    test('absent optionals are omitted, never sent as null', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [_Reply(200, _startOk())]);

      await DodoClient(http).startSubscription(businessId: 'biz-1');

      final body = http.bodyOf(0);
      for (final key in const [
        'branch_id',
        'plan_id',
        'selected_plan',
        'email',
        'country',
        'return_url',
        'addons',
      ]) {
        expect(body.containsKey(key), isFalse, reason: '$key must be omitted');
      }
    });

    test('a reply with no ids is not reported as a plain failure', () async {
      // The subscription may well exist upstream; a caller that treats this as
      // "nothing happened" and retries is relying on the reuse rule to save it.
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [_Reply(200, jsonEncode({}))]);

      expect(
        () => DodoClient(http).startSubscription(businessId: 'biz-1'),
        throwsA(isA<DodoException>().having(
          (e) => e.message,
          'message',
          contains('no reference'),
        )),
      );
    });

    test('a disabled rail says so in words a user can act on', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [
          _Reply(503, jsonEncode({'error': 'Dodo billing is disabled'})),
        ]);

      await expectLater(
        DodoClient(http).startSubscription(businessId: 'biz-1'),
        throwsA(isA<DodoException>()
            .having((e) => e.statusCode, 'statusCode', 503)
            .having((e) => e.displayMessage, 'displayMessage',
                contains('disabled'))),
      );
    });
  });

  group('next_action drives the client, not status', () {
    test('an unknown action keeps waiting rather than guessing', () {
      final status = DodoSubscriptionStatus.fromJson(
        jsonDecode(_view(nextAction: 'some_future_action'))
            as Map<String, dynamic>,
      );
      expect(status.nextAction, DodoNextAction.unknown);
      // Not terminal: an action we do not recognise means keep polling, and it
      // must never be read as entitlement.
      expect(status.isTerminal, isFalse);
      expect(status.entitled, isFalse);
      expect(
        DodoCardCheckout.outcomeFor(status),
        DodoCheckoutOutcome.awaitingPayment,
      );
    });

    test('a terminal subscription asks for a re-subscribe', () {
      final status = DodoSubscriptionStatus.fromJson(
        jsonDecode(_view(status: 'cancelled', nextAction: 'resubscribe'))
            as Map<String, dynamic>,
      );
      expect(
        DodoCardCheckout.outcomeFor(status),
        DodoCheckoutOutcome.resubscribeRequired,
      );
    });

    test('a failed renewal asks for a card, not a new subscription', () {
      final status = DodoSubscriptionStatus.fromJson(
        jsonDecode(_view(status: 'on_hold', nextAction: 'update_payment_method'))
            as Map<String, dynamic>,
      );
      expect(
        DodoCardCheckout.outcomeFor(status),
        DodoCheckoutOutcome.needsPaymentMethod,
      );
    });
  });

  group('checkout hand-off', () {
    test('opens the link the connector returned', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [_Reply(200, _startOk())]);
      final opened = <Uri>[];

      final result = await DodoCardCheckout(
        DodoClient(http),
        openLink: (uri) async {
          opened.add(uri);
          return true;
        },
      ).start(businessId: 'biz-1', planId: 'plan-1');

      expect(result.outcome, DodoCheckoutOutcome.awaitingPayment);
      expect(result.launched, isTrue);
      expect(opened.single.toString(),
          'https://checkout.dodopayments.com/xyz');
    });

    test('a browser that will not open is not a charge failure', () async {
      // Nothing has been charged, so the useful next step is Mobile Money or
      // another device — never a retry that fails identically.
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [_Reply(200, _startOk())]);

      final result = await DodoCardCheckout(
        DodoClient(http),
        openLink: (_) async => false,
      ).start(businessId: 'biz-1', planId: 'plan-1');

      expect(result.outcome, DodoCheckoutOutcome.couldNotOpenLink);
      expect(result.checkout?.hasLink, isTrue);
    });

    test('a double tap reuses the pending subscription', () async {
      // The connector returns *that* subscription and its existing link, so no
      // second subscription lands on the customer's card.
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start',
            [_Reply(200, _startOk(reusedExisting: true))]);

      final result = await DodoCardCheckout(
        DodoClient(http),
        openLink: (_) async => true,
      ).start(businessId: 'biz-1', planId: 'plan-1');

      expect(result.start!.reusedExisting, isTrue);
      expect(result.outcome, DodoCheckoutOutcome.awaitingPayment);
    });

    test('a terminal subscription never opens a browser', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [
          _Reply(200, _startOk(status: 'cancelled', nextAction: 'resubscribe')),
        ]);
      var opens = 0;

      final result = await DodoCardCheckout(
        DodoClient(http),
        openLink: (_) async {
          opens++;
          return true;
        },
      ).start(businessId: 'biz-1', planId: 'plan-1');

      expect(result.outcome, DodoCheckoutOutcome.resubscribeRequired);
      expect(opens, 0);
    });
  });

  group('waiting for the money', () {
    test('stops as soon as the subscription is entitled', () async {
      final http = _FakeHttpClient()
        ..queue('/api/dodo/subscriptions/plan-1', [
          _Reply(200, _view()),
          _Reply(200, _view(status: 'active', entitled: true, nextAction: 'none')),
        ]);

      final seen = <String>[];
      final status = await DodoCardCheckout(DodoClient(http)).awaitEntitlement(
        'plan-1',
        pollInterval: const Duration(milliseconds: 1),
        timeout: const Duration(seconds: 2),
        onStatus: (s) => seen.add(s.status),
      );

      expect(status!.entitled, isTrue);
      expect(seen, ['pending', 'active']);
    });

    test('forces a read-through to Dodo when the webhook is late', () async {
      // Webhooks are primary; a delivery that never lands would otherwise leave
      // a paying customer waiting on the connector's 15-minute sweep.
      final http = _FakeHttpClient()
        ..queue('/sync', [_Reply(200, _view())])
        ..queue('/api/dodo/subscriptions/plan-1', [_Reply(200, _view())]);

      await DodoCardCheckout(DodoClient(http)).awaitEntitlement(
        'plan-1',
        pollInterval: const Duration(milliseconds: 1),
        timeout: const Duration(milliseconds: 60),
      );

      expect(http.forPath('/sync'), isNotEmpty,
          reason: 'a forced sync must happen without a webhook');
    });

    test('a connector blip does not end the wait', () async {
      // A failed read says nothing about whether the customer paid.
      final http = _FakeHttpClient()
        ..queue('/api/dodo/subscriptions/plan-1', [
          const _Reply(500, 'boom'),
          _Reply(200, _view(status: 'active', entitled: true, nextAction: 'none')),
        ]);

      final status = await DodoCardCheckout(DodoClient(http)).awaitEntitlement(
        'plan-1',
        pollInterval: const Duration(milliseconds: 1),
        timeout: const Duration(seconds: 2),
      );

      expect(status?.entitled, isTrue);
    });

    test('gives up on a subscription Dodo has failed', () async {
      final http = _FakeHttpClient()
        ..queue('/api/dodo/subscriptions/plan-1', [
          _Reply(200, _view(status: 'cancelled', nextAction: 'resubscribe')),
        ]);

      final status = await DodoCardCheckout(DodoClient(http)).awaitEntitlement(
        'plan-1',
        pollInterval: const Duration(milliseconds: 1),
        timeout: const Duration(seconds: 2),
      );

      expect(status!.nextAction, DodoNextAction.resubscribe);
      expect(status.entitled, isFalse);
    });

    test('a cancelled subscription inside a paid period is still entitled', () {
      // Cutting access the instant someone taps cancel takes away something
      // they already bought.
      final status = DodoSubscriptionStatus.fromJson(
        jsonDecode(_view(
          status: 'cancelled',
          entitled: true,
          nextAction: 'resubscribe',
        )) as Map<String, dynamic>,
      );
      expect(status.entitled, isTrue);
      expect(DodoCardCheckout.outcomeFor(status), DodoCheckoutOutcome.entitled);
    });
  });

  group('error messages keep the connector\'s own words', () {
    test('a misconfigured tier is reported, not swallowed', () async {
      final http = _FakeHttpClient()
        ..queue('/subscriptions/start', [
          _Reply(
              400,
              jsonEncode({
                'error': 'no Dodo product is configured for tier "enterprise"',
              })),
        ]);

      await expectLater(
        DodoClient(http).startSubscription(businessId: 'biz-1'),
        throwsA(isA<DodoException>().having(
          (e) => e.displayMessage,
          'displayMessage',
          contains('no Dodo product is configured'),
        )),
      );
    });

    test('non-JSON from a proxy still yields one readable line', () {
      expect(
        dodoGatewayMessage('502 Bad Gateway\nnginx'),
        '502 Bad Gateway',
      );
    });
  });
}
