import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/momo/momo_client.dart';
import 'package:flipper_services/momo/momo_collection.dart';
import 'package:flipper_services/momo/momo_models.dart';
import 'package:flipper_services/momo/momo_msisdn.dart';
import 'package:flipper_services/momo/momo_subscription.dart';
import 'package:flipper_services/payments_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// One canned reply.
class _Reply {
  const _Reply(this.status, this.body);
  final int status;
  final String body;
}

/// Records every request and answers from a per-path queue, so a test can
/// assert what actually went on the wire — which body fields were sent matters
/// as much as the response handling here.
class _FakeHttpClient implements HttpClientInterface {
  final List<http.Request> requests = [];
  final Map<String, List<_Reply>> _queued = {};
  _Reply fallback = const _Reply(200, '{}');

  void queue(String pathContains, List<_Reply> replies) =>
      _queued[pathContains] = [...replies];

  int get postCount =>
      requests.where((r) => r.method == 'POST').length;

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
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      _record('POST', url, body);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async =>
      _record('GET', url, null);

  @override
  Future<http.Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      _record('PUT', url, body);

  @override
  Future<http.Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      _record('PATCH', url, body);

  @override
  Future<http.Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      _record('DELETE', url, body);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      throw UnimplementedError();

  @override
  Future<http.Response> getUniversalProducts(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      throw UnimplementedError();
}

String _payNowOk({String reference = 'ref-1', int amount = 5000, String? outcome}) =>
    jsonEncode({
      'status': 'success',
      'paymentReference': reference,
      'externalId': reference,
      'amount': amount,
      if (outcome != null) 'outcome': outcome,
    });

String _status(String status, {String? reason, int? amount, String? ftx}) =>
    jsonEncode({
      'status': status,
      if (reason != null) 'reason': reason,
      if (amount != null) 'amount': amount,
      if (ftx != null) 'financialTransactionId': ftx,
    });

void main() {
  setUpAll(() => setPaymentsApiBaseUrlOverride('https://gateway.test'));
  tearDownAll(() => setPaymentsApiBaseUrlOverride(null));

  group('MomoMsisdn', () {
    test('canonicalises every spelling of one Rwandan number to one partyId', () {
      // Mandates are matched by MSISDN, so three spellings of one number must
      // not look like three payers who each need their own consent.
      for (final input in [
        '0788123456',
        '788123456',
        '+250788123456',
        '250 788 123 456',
        '250-788-123-456',
      ]) {
        expect(MomoMsisdn.toPartyId(input), '250788123456', reason: input);
      }
    });

    test('accepts MTN and Airtel prefixes, rejects landline and typos', () {
      expect(MomoMsisdn.isRwandaMobile('0788123456'), isTrue); // MTN
      expect(MomoMsisdn.isRwandaMobile('0790123456'), isTrue); // MTN
      expect(MomoMsisdn.isRwandaMobile('0720123456'), isTrue); // Airtel
      expect(MomoMsisdn.isRwandaMobile('0730123456'), isTrue); // Airtel
      expect(MomoMsisdn.isRwandaMobile('0250123456'), isFalse);
      expect(MomoMsisdn.isRwandaMobile('078812345'), isFalse); // one short
      expect(MomoMsisdn.isRwandaMobile(''), isFalse);
    });

    test('lets a non-Rwandan MSISDN through untouched', () {
      // Flipper bills businesses outside Rwanda; blocking them here would be
      // worse than the gateway refusing the odd number.
      expect(MomoMsisdn.toPartyId('+254712345678'), '254712345678');
      expect(MomoMsisdn.isRwandaMobile('+254712345678'), isFalse);
    });

    test('refuses what can never be dialled', () {
      expect(MomoMsisdn.toPartyId(''), isNull);
      expect(MomoMsisdn.toPartyId('12345'), isNull);
      expect(MomoMsisdn.toPartyId('not a phone'), isNull);
      expect(MomoMsisdn.toPartyId('1234567890123456789'), isNull);
    });

    test('masks to the last three digits for logs', () {
      expect(MomoMsisdn.masked('+250788123456'), '…456');
      expect(MomoMsisdn.masked('12'), '…');
    });
  });

  group('MomoPaymentStatus', () {
    test('an unrecognised status is pending, never failed', () {
      // The rule that stops a cashier being told the money did not arrive
      // because MTN sent a word we had not seen before.
      expect(MomoPaymentStatus.fromWire('ONGOING'), MomoPaymentStatus.pending);
      expect(MomoPaymentStatus.fromWire(null), MomoPaymentStatus.pending);
      expect(MomoPaymentStatus.fromWire(''), MomoPaymentStatus.pending);
      expect(MomoPaymentStatus.fromWire('PENDING'), MomoPaymentStatus.pending);
    });

    test('classifies the terminal words, case-insensitively', () {
      expect(MomoPaymentStatus.fromWire('successful'), MomoPaymentStatus.successful);
      expect(MomoPaymentStatus.fromWire(' SUCCESSFUL '), MomoPaymentStatus.successful);
      for (final failed in ['FAILED', 'REJECTED', 'TIMEOUT', 'EXPIRED', 'NOT_FOUND']) {
        expect(MomoPaymentStatus.fromWire(failed), MomoPaymentStatus.failed,
            reason: failed);
      }
    });
  });

  group('MomoSettlement', () {
    test('reads the amount whether MTN sends a number or a string', () {
      expect(
        MomoSettlement.fromJson('r', {'status': 'SUCCESSFUL', 'amount': 5000})
            .settledAmountRwf,
        5000,
      );
      expect(
        MomoSettlement.fromJson('r', {'status': 'SUCCESSFUL', 'amount': '5000'})
            .settledAmountRwf,
        5000,
      );
    });

    test('an unreadable poll is pending, not a verdict', () {
      final settlement = MomoSettlement.unresolved('r', httpStatus: 502);
      expect(settlement.isPending, isTrue);
      expect(settlement.isTerminal, isFalse);
    });
  });

  group('MomoMandate.covers', () {
    MomoMandate mandate({
      MomoMandateState state = MomoMandateState.active,
      int? authorised = 5000,
      Duration? expiresIn = const Duration(days: 30),
    }) =>
        MomoMandate(
          state: state,
          id: 'm1',
          authorisedAmount: authorised,
          expiresAt: expiresIn == null ? null : DateTime.now().toUtc().add(expiresIn),
        );

    test('an approved mandate covers up to its authorised amount', () {
      expect(mandate().covers(5000), isTrue);
      expect(mandate().covers(4999), isTrue);
    });

    test('a price rise above the authorised amount is not covered', () {
      // The upgrade trap: consent taken out for 200 must not silently authorise
      // a 300 debit. flipper-turbo ignored the amount entirely, so every debit
      // after a price rise failed with no reason.
      expect(mandate(authorised: 200).covers(300), isFalse);
    });

    test('an expired mandate covers nothing', () {
      expect(
        mandate(expiresIn: const Duration(days: -1)).covers(100),
        isFalse,
      );
    });

    test('a pending or refused mandate covers nothing', () {
      expect(mandate(state: MomoMandateState.awaitingApproval).covers(1), isFalse);
      expect(mandate(state: MomoMandateState.failed).covers(1), isFalse);
    });

    test('MTN status alone is enough to classify the mandate', () {
      // `/v2/api/pre-approval-status/{id}` only guarantees `status`.
      expect(MomoMandate.fromJson({'status': 'APPROVED'}).isActive, isTrue);
      expect(MomoMandate.fromJson({'status': 'REJECTED'}).isFailed, isTrue);
      expect(MomoMandate.fromJson({'status': 'EXPIRED'}).isFailed, isTrue);
      expect(
        MomoMandate.fromJson({'status': 'PENDING'}).isAwaitingApproval,
        isTrue,
      );
    });
  });

  group('MomoIdempotency', () {
    test('is stable for one collection and different between two', () {
      expect(
        MomoIdempotency.forTransaction('txn-1', 5000),
        MomoIdempotency.forTransaction('txn-1', 5000),
      );
      expect(
        MomoIdempotency.forTransaction('txn-1', 5000),
        isNot(MomoIdempotency.forTransaction('txn-2', 5000)),
      );
      // Two sales of the same amount on the same ticket would be a mistake;
      // a different amount is a different collection.
      expect(
        MomoIdempotency.forTransaction('txn-1', 5000),
        isNot(MomoIdempotency.forTransaction('txn-1', 6000)),
      );
    });
  });

  group('MomoClient.sanitizeReference', () {
    test('digs the id out of a reference wrapped in log formatting', () {
      const id = '2f83b8b1-6d41-4d80-b0e7-de8ab36910af';
      expect(MomoClient.sanitizeReference('[32m$id[0m'), id);
      expect(MomoClient.sanitizeReference('  $id  '), id);
    });

    test('falls back to paymentReference then externalId', () {
      expect(MomoClient.referenceFrom({'paymentReference': 'a'}), 'a');
      expect(MomoClient.referenceFrom({'externalId': 'b'}), 'b');
      expect(
        MomoClient.referenceFrom({'paymentReference': '', 'externalId': 'b'}),
        'b',
      );
    });
  });

  group('MomoClient.payNow', () {
    late _FakeHttpClient http;
    late MomoClient client;

    setUp(() {
      http = _FakeHttpClient();
      client = MomoClient(http);
    });

    test('sends the idempotency key and the row ids the server settles against',
        () async {
      http.fallback = _Reply(200, _payNowOk());

      await client.payNow(
        phoneNumber: '0788123456',
        amount: 5000,
        paymentType: 'PaymentNormal',
        payerMessage: 'Pay for Goods',
        payeeNote: 'Pay for Goods',
        idempotencyKey: 'txn_abc_5000',
        customerPaymentId: 'row-1',
        transactionId: 'txn-abc',
      );

      final body = http.bodyOf(0);
      expect(body['idempotencyKey'], 'txn_abc_5000');
      expect(body['customerPaymentId'], 'row-1');
      expect(body['transactionId'], 'txn-abc');
      expect(body['payer']['partyId'], '250788123456');
      expect(body['amount'], 5000);
    });

    test('refuses a malformed number without calling the gateway', () async {
      await expectLater(
        client.payNow(
          phoneNumber: '12345',
          amount: 5000,
          paymentType: 'PaymentNormal',
          payerMessage: 'x',
          payeeNote: 'x',
          idempotencyKey: 'k',
        ),
        throwsA(isA<MomoException>()),
      );
      expect(http.requests, isEmpty);
    });

    test('refuses a zero or negative amount without calling the gateway', () async {
      for (final amount in [0, -1]) {
        await expectLater(
          client.payNow(
            phoneNumber: '0788123456',
            amount: amount,
            paymentType: 'PaymentNormal',
            payerMessage: 'x',
            payeeNote: 'x',
            idempotencyKey: 'k',
          ),
          throwsA(isA<MomoException>()),
        );
      }
      expect(http.requests, isEmpty);
    });

    test('keeps the gateway\'s own explanation for a refusal', () async {
      // "Bad request" hid the one description of what went wrong.
      http.fallback = const _Reply(400, '{"error":"paid through 2026-09-13"}');

      await expectLater(
        client.payNow(
          phoneNumber: '0788123456',
          amount: 5000,
          paymentType: 'Subscription',
          payerMessage: 'x',
          payeeNote: 'x',
        ),
        throwsA(
          isA<MomoException>()
              .having((e) => e.gatewayMessage, 'gatewayMessage',
                  'paid through 2026-09-13')
              .having((e) => e.message, 'message',
                  contains('paid through 2026-09-13')),
        ),
      );
    });

    test('a 200 with no reference is an error, not a silent success', () async {
      // The request may well have reached MTN, so the caller must not be told
      // it simply did not happen.
      http.fallback = const _Reply(200, '{"status":"success"}');

      await expectLater(
        client.payNow(
          phoneNumber: '0788123456',
          amount: 5000,
          paymentType: 'PaymentNormal',
          payerMessage: 'x',
          payeeNote: 'x',
          idempotencyKey: 'k',
        ),
        throwsA(isA<MomoException>()),
      );
    });

    test('reports the amount the server charged, not the one we asked for', () async {
      // For a subscription the server prices the cycle itself.
      http.fallback = _Reply(200, _payNowOk(amount: 300));

      final initiation = await client.payNow(
        phoneNumber: '0788123456',
        amount: 200,
        paymentType: 'Subscription',
        payerMessage: 'x',
        payeeNote: 'x',
      );
      expect(initiation.amount, 300);
    });

    test('flags a deduplicated submission so no second debit is assumed', () async {
      http.fallback = _Reply(200, _payNowOk(outcome: 'already_in_flight'));

      final initiation = await client.payNow(
        phoneNumber: '0788123456',
        amount: 5000,
        paymentType: 'PaymentNormal',
        payerMessage: 'x',
        payeeNote: 'x',
        idempotencyKey: 'k',
      );
      expect(initiation.isDeduplicated, isTrue);
    });
  });

  group('MomoClient.requestToPayStatus', () {
    test('a non-2xx poll is pending, not failed', () async {
      final http = _FakeHttpClient()..fallback = const _Reply(503, '{}');
      final settlement =
          await MomoClient(http).requestToPayStatus('ref-1');
      expect(settlement.isPending, isTrue);
      expect(settlement.isTerminal, isFalse);
    });

    test('carries the reason attached to a pending status', () async {
      final http = _FakeHttpClient()
        ..fallback = _Reply(200, _status('PENDING', reason: 'mtn unreachable'));
      final settlement = await MomoClient(http).requestToPayStatus('ref-1');
      expect(settlement.isPending, isTrue);
      expect(settlement.reason, 'mtn unreachable');
    });
  });

  group('MomoCollection', () {
    late _FakeHttpClient http;
    late MomoCollection collection;

    setUp(() {
      http = _FakeHttpClient();
      collection = MomoCollection(MomoClient(http));
    });

    /// The window is generous on purpose: every test here except the timeout
    /// one asserts that the loop *stops early* on a terminal status, so a tight
    /// deadline would only make them flaky under load without testing anything.
    Future<MomoCollectionResult> collect({
      Duration pollTimeout = const Duration(seconds: 5),
    }) =>
        collection.collect(
          phoneNumber: '0788123456',
          amount: 5000,
          paymentType: 'PaymentNormal',
          payerMessage: 'Pay for Goods',
          payeeNote: 'Pay for Goods',
          idempotencyKey: 'txn_1_5000',
          pollInterval: const Duration(milliseconds: 1),
          pollTimeout: pollTimeout,
        );

    test('settles on SUCCESSFUL and trusts the settled amount', () async {
      http.queue('payNow', [_Reply(200, _payNowOk())]);
      http.queue('requesttopay', [
        _Reply(200, _status('PENDING')),
        _Reply(200, _status('SUCCESSFUL', amount: 4990, ftx: 'ftx-1')),
      ]);

      final result = await collect();
      expect(result.outcome, MomoCollectionOutcome.settled);
      expect(result.settledAmount, 4990);
      expect(result.financialTransactionId, 'ftx-1');
    });

    test('stops the moment MTN refuses instead of waiting out the window',
        () async {
      http.queue('payNow', [_Reply(200, _payNowOk())]);
      http.queue('requesttopay',
          [_Reply(200, _status('REJECTED', reason: 'payer declined'))]);

      final result = await collect();
      expect(result.outcome, MomoCollectionOutcome.refused);
      expect(result.message, 'payer declined');
      // One poll, not the whole ladder.
      expect(
        http.requests.where((r) => r.method == 'GET').length,
        1,
      );
    });

    test('a payment still in flight times out rather than reporting failure',
        () async {
      http.queue('payNow', [_Reply(200, _payNowOk())]);
      http.queue('requesttopay', [_Reply(200, _status('PENDING'))]);

      final result = await collect(pollTimeout: const Duration(milliseconds: 30));
      expect(result.outcome, MomoCollectionOutcome.timedOut);
      expect(result.isSettled, isFalse);
      // Not terminal: the till must not re-charge on the strength of a timeout.
      expect(result.isTerminal, isFalse);
      expect(result.reference, isNotNull);
    });

    test('a refused submission never reaches the polling stage', () async {
      http.queue('payNow', [const _Reply(400, '{"error":"amount too large"}')]);

      final result = await collect();
      expect(result.outcome, MomoCollectionOutcome.notStarted);
      expect(result.message, contains('amount too large'));
      expect(result.reference, isNull);
      expect(http.requests.where((r) => r.method == 'GET'), isEmpty);
    });

    test('hands the reference back before polling starts', () async {
      http.queue('payNow', [_Reply(200, _payNowOk(reference: 'ref-7'))]);
      http.queue('requesttopay', [_Reply(200, _status('SUCCESSFUL'))]);

      String? seen;
      await collection.collect(
        phoneNumber: '0788123456',
        amount: 5000,
        paymentType: 'PaymentNormal',
        payerMessage: 'x',
        payeeNote: 'x',
        idempotencyKey: 'k',
        pollInterval: const Duration(milliseconds: 1),
        pollTimeout: const Duration(milliseconds: 20),
        onReference: (r) => seen = r,
      );
      expect(seen, 'ref-7');
    });

    test('a gateway error on the status route is not a failed payment', () async {
      http.queue('payNow', [_Reply(200, _payNowOk())]);
      http.queue('requesttopay', [
        const _Reply(500, 'gateway down'),
        _Reply(200, _status('SUCCESSFUL')),
      ]);

      final result = await collect();
      expect(result.outcome, MomoCollectionOutcome.settled);
    });
  });

  group('MomoSubscriptionCharger', () {
    late _FakeHttpClient http;
    late MomoSubscriptionCharger charger;

    setUp(() {
      http = _FakeHttpClient();
      charger = MomoSubscriptionCharger(MomoClient(http));
    });

    Future<MomoSubscriptionResult> charge({
      bool requirePreapproval = true,
      bool awaitApproval = false,
    }) =>
        charger.charge(
          phoneNumber: '0788123456',
          amount: 5000,
          planId: 'plan-1',
          requirePreapproval: requirePreapproval,
          awaitApproval: awaitApproval,
        );

    test('does not charge when the payer refuses the mandate', () async {
      // The whole point of the gate: consent declined means no debit is even
      // attempted, rather than falling through to a PIN prompt.
      http.queue('preApprove', [
        const _Reply(200, '{"state":"failed","status":"REJECTED","error":"payer declined"}')
      ]);

      final result = await charge();
      expect(result.outcome, MomoSubscriptionOutcome.preapprovalRefused);
      expect(result.message, 'payer declined');
      expect(
        http.requests.where((r) => r.url.path.contains('payNow')),
        isEmpty,
      );
    });

    test('a pre-approval the gateway could not answer is treated as refused',
        () async {
      http.queue('preApprove', [const _Reply(502, '{"error":"mtn unreachable"}')]);

      final result = await charge();
      expect(result.outcome, MomoSubscriptionOutcome.preapprovalRefused);
      expect(
        http.requests.where((r) => r.url.path.contains('payNow')),
        isEmpty,
      );
    });

    test('charges silently on a mandate that covers the amount', () async {
      http.queue('preApprove', [
        _Reply(
          200,
          jsonEncode({
            'state': 'active',
            'status': 'APPROVED',
            'preapprovalId': 'm-1',
            'authorisedAmount': 10000,
            'expiresAt':
                DateTime.now().toUtc().add(const Duration(days: 30)).toIso8601String(),
            'coversCurrentPrice': true,
          }),
        )
      ]);
      http.queue('payNow', [_Reply(200, _payNowOk(reference: 'charge-1'))]);

      final result = await charge();
      expect(result.outcome, MomoSubscriptionOutcome.charged);
      expect(result.reference, 'charge-1');
      expect(result.chargedOnPinPrompt, isFalse);
    });

    test('a mandate authorised for less than the price falls back to a PIN prompt',
        () async {
      // Legitimate for a first payment or an upgrade — the prompt is itself the
      // consent — but the result has to say so, so unattended billing can refuse.
      http.queue('preApprove', [
        _Reply(
          200,
          jsonEncode({
            'state': 'active',
            'status': 'APPROVED',
            'preapprovalId': 'm-1',
            'authorisedAmount': 200,
            'expiresAt':
                DateTime.now().toUtc().add(const Duration(days: 30)).toIso8601String(),
          }),
        )
      ]);
      http.queue('payNow', [_Reply(200, _payNowOk(reference: 'charge-2'))]);

      final result = await charge();
      expect(result.outcome, MomoSubscriptionOutcome.charged);
      expect(result.chargedOnPinPrompt, isTrue);
    });

    test('surfaces a rejected charge instead of reporting a payment in flight',
        () async {
      http.queue('preApprove', [
        const _Reply(200, '{"state":"active","status":"APPROVED","coversCurrentPrice":true}')
      ]);
      http.queue('payNow', [const _Reply(400, '{"error":"not due"}')]);

      final result = await charge();
      expect(result.outcome, MomoSubscriptionOutcome.chargeRejected);
      expect(result.message, contains('not due'));
      expect(result.reference, isNull);
    });

    test('with the gate off, a refused mandate still charges on a PIN prompt',
        () async {
      http.queue('preApprove', [
        const _Reply(200, '{"state":"failed","status":"REJECTED"}')
      ]);
      http.queue('payNow', [_Reply(200, _payNowOk(reference: 'charge-3'))]);

      final result = await charge(requirePreapproval: false);
      expect(result.outcome, MomoSubscriptionOutcome.charged);
      expect(result.chargedOnPinPrompt, isTrue);
    });
  });
}
