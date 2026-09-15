import 'dart:convert';

import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http_;
import 'package:http/http.dart' as http;

/// Records every request and answers from a script, so the wire contract can
/// be pinned without a connector.
class _ScriptedHttp implements PaymentsHttpClient {
  _ScriptedHttp(this.responses);

  final List<http.Response> responses;
  final List<
    ({String method, Uri url, Map<String, String>? headers, Object? body})
  >
  calls = [];

  http.Response _next() =>
      responses.isEmpty ? http.Response('{}', 500) : responses.removeAt(0);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    calls.add((method: 'GET', url: url, headers: headers, body: null));
    return _next();
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    calls.add((method: 'POST', url: url, headers: headers, body: body));
    return _next();
  }
}

http.Response _json(Map<String, dynamic> body, {int status = 200}) =>
    http.Response(jsonEncode(body), status);

Map<String, dynamic> _view({
  String status = 'awaiting_approval',
  String nextAction = 'approve_on_phone',
  String rail = 'momo',
  Map<String, dynamic>? extra,
}) => {
  'id': 'cp-1',
  'business_id': 'biz-1',
  'plan_id': 'plan-1',
  'rail': rail,
  'amount': 25000,
  'currency': 'RWF',
  'rule': 'monthly',
  'status': status,
  'next_action': nextAction,
  'next_billing_date': '2026-09-14',
  'previous': {'rail': 'momo', 'total_price': 5100},
  ...?extra,
};

void main() {
  setUp(() {
    setPaymentsApiBaseUrlOverride('https://connector.test');
  });

  tearDown(() {
    setPaymentsApiBaseUrlOverride(null);
    resetPaymentsApiBaseUrlCache();
  });

  group('CustomPaymentClient.create', () {
    test(
      'sends the staff token and the snake_case body the connector expects',
      () async {
        final http = _ScriptedHttp([_json(_view())]);
        final client = CustomPaymentClient(http, staffToken: ' tok-123 ');

        final view = await client.create(
          businessId: 'biz-1',
          amount: 25000,
          cadence: CustomPaymentCadence.monthly,
          rail: CustomPaymentRail.momo,
          phoneNumber: '0788123456',
          note: 'agreed',
        );

        final call = http.calls.single;
        expect(call.method, 'POST');
        expect(
          call.url.toString(),
          'https://connector.test/api/billing/custom-payments',
        );
        expect(call.headers?['Authorization'], 'Bearer tok-123');
        final body = jsonDecode(call.body as String) as Map<String, dynamic>;
        expect(body['business_id'], 'biz-1');
        expect(body['amount'], 25000);
        expect(body['rule'], 'monthly');
        expect(body['rail'], 'momo');
        expect(body['phone_number'], '0788123456');
        expect(body['note'], 'agreed');
        expect(
          body.containsKey('mode'),
          isFalse,
          reason: 'mode is a card-only field',
        );
        expect(
          body.containsKey('email'),
          isFalse,
          reason: 'absent optionals are omitted',
        );

        expect(view.id, 'cp-1');
        expect(view.status, CustomPaymentStatus.awaitingApproval);
        expect(view.nextAction, CustomPaymentNextAction.approveOnPhone);
        expect(view.previous.totalPrice, 5100);
      },
    );

    test('a card request names this build\'s Dodo mode', () async {
      final http = _ScriptedHttp([
        _json(
          _view(
            rail: 'card',
            status: 'awaiting_checkout',
            nextAction: 'open_payment_link',
            extra: {
              'checkout': {'payment_link': 'https://checkout.example/x'},
              'dodo_subscription_id': 'sub_1',
            },
          ),
        ),
      ]);
      final view = await CustomPaymentClient(http, staffToken: 't').create(
        businessId: 'biz-1',
        amount: 25000,
        cadence: CustomPaymentCadence.yearly,
        rail: CustomPaymentRail.card,
        email: 'owner@shop.rw',
      );
      final body = jsonDecode(http.calls.single.body as String) as Map;
      expect(body['mode'], dodoBuildMode);
      expect(body['rule'], 'yearly');
      expect(view.paymentLink, 'https://checkout.example/x');
      expect(view.dodoSubscriptionId, 'sub_1');
    });

    test(
      'refuses a MoMo request without a phone before touching the network',
      () async {
        final http = _ScriptedHttp([]);
        await expectLater(
          CustomPaymentClient(http, staffToken: 't').create(
            businessId: 'biz-1',
            amount: 100,
            cadence: CustomPaymentCadence.monthly,
            rail: CustomPaymentRail.momo,
          ),
          throwsA(isA<CustomPaymentException>()),
        );
        expect(http.calls, isEmpty);
      },
    );

    test(
      'a 401 reads as "not authorised", keeping the connector\'s words',
      () async {
        final http = _ScriptedHttp([
          http_.Response(
            '{"error":"this account is not authorised for staff payments"}',
            401,
          ),
        ]);
        try {
          await CustomPaymentClient(http, staffToken: 'bad').create(
            businessId: 'biz-1',
            amount: 100,
            cadence: CustomPaymentCadence.monthly,
            rail: CustomPaymentRail.momo,
            phoneNumber: '0788',
          );
          fail('expected a CustomPaymentException');
        } on CustomPaymentException catch (e) {
          expect(e.isUnauthorised, isTrue);
          expect(e.displayMessage, contains('not authorised'));
        }
      },
    );

    test('a 409 carries the payment already in flight', () async {
      final http = _ScriptedHttp([
        _json({
          'error': 'a card checkout is still open for this business',
          'in_flight': _view(
            rail: 'card',
            status: 'awaiting_checkout',
            nextAction: 'open_payment_link',
          ),
        }, status: 409),
      ]);
      try {
        await CustomPaymentClient(http, staffToken: 't').create(
          businessId: 'biz-1',
          amount: 100,
          cadence: CustomPaymentCadence.monthly,
          rail: CustomPaymentRail.momo,
          phoneNumber: '0788',
        );
        fail('expected a CustomPaymentException');
      } on CustomPaymentException catch (e) {
        expect(e.isConflict, isTrue);
        expect(e.inFlight?.id, 'cp-1');
      }
    });
  });

  group('CustomPaymentClient.status', () {
    test('adds sync=true only when asked', () async {
      final http = _ScriptedHttp([_json(_view()), _json(_view())]);
      final client = CustomPaymentClient(http, staffToken: 't');
      await client.status('cp-1');
      await client.status('cp-1', sync: true);
      expect(
        http.calls[0].url.toString(),
        'https://connector.test/api/billing/custom-payments/cp-1',
      );
      expect(
        http.calls[1].url.toString(),
        'https://connector.test/api/billing/custom-payments/cp-1?sync=true',
      );
    });
  });

  group('CustomPaymentView.fromJson', () {
    test('tolerates missing optionals and unknown statuses', () {
      final view = CustomPaymentView.fromJson({
        'id': 'cp-2',
        'business_id': 'biz',
        'rail': 'momo',
        'amount': '1500',
        'rule': 'monthly',
        'status': 'something_new',
        'next_action': 'dance',
      });
      expect(view.amount, 1500);
      expect(view.status, CustomPaymentStatus.unknown);
      expect(
        view.isTerminal,
        isFalse,
        reason: 'an unknown status must keep polling, never read as paid',
      );
      expect(view.nextAction, CustomPaymentNextAction.unknown);
      expect(view.paymentLink, isNull);
      expect(view.currency, 'RWF');
    });
  });

  group('CustomPaymentWatcher', () {
    test('stops on the first terminal status and reports each poll', () async {
      final http = _ScriptedHttp([
        _json(_view(status: 'awaiting_approval')),
        _json(_view(status: 'pending', nextAction: 'awaiting_settlement')),
        _json(_view(status: 'settled', nextAction: 'none')),
        _json(_view(status: 'settled', nextAction: 'none')),
      ]);
      final seen = <CustomPaymentStatus>[];
      final result =
          await CustomPaymentWatcher(
            CustomPaymentClient(http, staffToken: 't'),
          ).awaitSettlement(
            'cp-1',
            rail: CustomPaymentRail.momo,
            pollInterval: Duration.zero,
            onStatus: (v) => seen.add(v.status),
          );
      expect(result?.isSettled, isTrue);
      expect(seen, [
        CustomPaymentStatus.awaitingApproval,
        CustomPaymentStatus.pending,
        CustomPaymentStatus.settled,
      ]);
      expect(http.calls.length, 3, reason: 'no poll after the terminal status');
    });

    test(
      'a failing poll is retried rather than abandoning the payment',
      () async {
        final http = _ScriptedHttp([
          http_.Response('boom', 500),
          _json(_view(status: 'failed', nextAction: 'retry')),
        ]);
        final result =
            await CustomPaymentWatcher(
              CustomPaymentClient(http, staffToken: 't'),
            ).awaitSettlement(
              'cp-1',
              rail: CustomPaymentRail.momo,
              pollInterval: Duration.zero,
            );
        expect(result?.status, CustomPaymentStatus.failed);
      },
    );

    test('honours cancellation and the deadline', () async {
      final http = _ScriptedHttp(
        List.generate(
          50,
          (_) => _json(
            _view(status: 'pending', nextAction: 'awaiting_settlement'),
          ),
        ),
      );
      var polls = 0;
      final result =
          await CustomPaymentWatcher(
            CustomPaymentClient(http, staffToken: 't'),
          ).awaitSettlement(
            'cp-1',
            rail: CustomPaymentRail.momo,
            pollInterval: Duration.zero,
            onStatus: (_) => polls++,
            isCancelled: () => polls >= 2,
          );
      expect(result?.status, CustomPaymentStatus.pending);
      expect(polls, 2);

      final timedOut =
          await CustomPaymentWatcher(
            CustomPaymentClient(http, staffToken: 't'),
          ).awaitSettlement(
            'cp-1',
            rail: CustomPaymentRail.momo,
            pollInterval: Duration.zero,
            timeout: Duration.zero,
          );
      expect(
        timedOut,
        isNull,
        reason: 'the deadline is checked before the first poll',
      );
    });

    test('card polls ask the connector to sync every third time', () async {
      final http = _ScriptedHttp(
        List.generate(
          3,
          (_) => _json(
            _view(
              rail: 'card',
              status: 'awaiting_checkout',
              nextAction: 'open_payment_link',
            ),
          ),
        ),
      );
      var polls = 0;
      await CustomPaymentWatcher(
        CustomPaymentClient(http, staffToken: 't'),
      ).awaitSettlement(
        'cp-1',
        rail: CustomPaymentRail.card,
        pollInterval: Duration.zero,
        onStatus: (_) => polls++,
        isCancelled: () => polls >= 3,
      );
      expect(http.calls.map((c) => c.url.query), ['', '', 'sync=true']);
    });
  });

  group('DodoHealth on-demand fields', () {
    test('reads on_demand_enabled and the per-mode readiness map', () {
      final health = DodoHealth.fromJson({
        'enabled': true,
        'ready': true,
        'modes_available': ['live', 'test'],
        'on_demand_enabled': true,
        'on_demand_ready': {'live': true, 'test': dodoBuildMode == 'test'},
      });
      expect(health.onDemandEnabled, isTrue);
      expect(health.onDemandReadyForThisBuild, isTrue);

      final off = DodoHealth.fromJson({'enabled': true, 'ready': true});
      expect(off.onDemandEnabled, isFalse);
      expect(
        off.onDemandReadyForThisBuild,
        isFalse,
        reason: 'an older connector cannot create on-demand subscriptions',
      );
    });
  });
}
