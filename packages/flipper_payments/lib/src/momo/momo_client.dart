import 'dart:convert';

import 'package:flipper_payments/src/http/payments_http_client.dart';
import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/momo/momo_models.dart';
import 'package:flipper_payments/src/momo/momo_msisdn.dart';
import 'package:flipper_payments/src/payments_api.dart';

/// Hardened HTTP client for the data-connector Mobile Money gateway.
///
/// One place that knows the wire shapes, so every collection in the app —
/// subscription, POS sale, gig, credit purchase — gets the same guarantees:
///
/// * a payer number is validated before it can reach MTN;
/// * every request carries an **idempotency key**, so a double tap, a retried
///   POST or a lost response cannot debit the payer twice;
/// * a refusal keeps the gateway's own words instead of "Bad request";
/// * a status read distinguishes *pending*, *settled* and *refused* — a
///   payment MTN has already rejected stops the till waiting five minutes for
///   a PIN that will never be entered;
/// * pre-approval is a first-class object with a state, an expiry and an
///   authorised ceiling, not a boolean.
///
/// Routes (see `data-connector/MOMO_BILLING.md`):
///
/// * `POST /v2/api/payNow`
/// * `GET  /v2/api/requesttopay/status/{reference}/{branchId}`
/// * `POST /v2/api/preApprove`
/// * `GET  /v2/api/pre-approval-status/{id}`
class MomoClient {
  const MomoClient(this._http);

  final PaymentsHttpClient _http;

  /// MTN collection branch. The server resolves the real collection account
  /// from `MTN_COLLECTION_BRANCH_ID`, so this only has to be *consistent*
  /// between a payNow and the status reads that follow it.
  static const String defaultCollectionBranchId =
      '2f83b8b1-6d41-4d80-b0e7-de8ab36910af';

  static final RegExp _ansiSgr = RegExp('\u001B\\[[0-9;]*m');
  static final RegExp _uuid = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  /// Extracts the bare id used in the status URL path.
  ///
  /// The gateway has been seen echoing a reference wrapped in log formatting
  /// (ANSI colour codes included) and the status path only accepts the bare id.
  static String? sanitizeReference(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim().replaceAll(_ansiSgr, '');
    final match = _uuid.firstMatch(trimmed);
    if (match != null) return match.group(0);
    return trimmed.isEmpty ? null : trimmed;
  }

  /// payNow returns the id as `paymentReference`, and older builds as
  /// `externalId`; both carry the same MTN reference.
  static String? referenceFrom(Map<String, dynamic> json) {
    final primary = sanitizeReference(json['paymentReference']?.toString());
    if (primary != null && primary.isNotEmpty) return primary;
    return sanitizeReference(json['externalId']?.toString());
  }

  /// [json.decode] often yields a plain [Map] at runtime; always normalise.
  static Map<String, dynamic>? asJsonObject(dynamic decoded) =>
      decoded is Map ? Map<String, dynamic>.from(decoded) : null;

  // ── collections ──────────────────────────────────────────────────────────

  /// Submits a request-to-pay and returns the reference to poll.
  ///
  /// [idempotencyKey] is the single most important argument here. The server
  /// keys on it: a retried tap returns the payment it already created instead
  /// of prompting the payer twice. Derive it from something stable about *this*
  /// collection — the transaction id, the plan id plus billing cycle — never
  /// from a clock or a fresh uuid, which would defeat the whole point. Two
  /// genuinely separate sales for the same amount need different keys, so
  /// prefer an id the caller already persists.
  ///
  /// [customerPaymentId] / [transactionId] tell the server which
  /// `customer_payments` row to settle. Send at least one for a POS or credit
  /// collection: without them the server falls back to matching the MoMo
  /// reference against `transaction_id`, and if the client wrote its own value
  /// there the row is never found — the money moves and the sale sits at
  /// "pending" forever.
  Future<MomoInitiation> payNow({
    required String phoneNumber,
    required int amount,
    required String paymentType,
    required String payerMessage,
    required String payeeNote,
    String? branchId,
    Object? businessId,
    String? planId,
    String? externalId,
    String? idempotencyKey,
    String? customerPaymentId,
    String? transactionId,
    String? customerId,
    String currency = 'RWF',
  }) async {
    if (amount <= 0) {
      throw const MomoException('Enter an amount greater than zero.');
    }
    final partyId = MomoMsisdn.toPartyId(phoneNumber);
    if (partyId == null) {
      throw const MomoException(
        'Enter a valid Mobile Money number, e.g. 0788123456.',
      );
    }
    if (!MomoMsisdn.isRwandaMobile(phoneNumber)) {
      // Not fatal — Flipper has businesses outside Rwanda — but the collection
      // account is MTN Rwanda, so this is worth seeing in a support log.
      payLogWarning(
        'MoMo: ${MomoMsisdn.masked(phoneNumber)} is not a Rwandan mobile; '
        'the gateway may refuse it',
      );
    }

    final payload = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'payer': {'partyIdType': 'MSISDN', 'partyId': partyId},
      'payerMessage': payerMessage,
      'payeeNote': payeeNote,
      'branchId': branchId ?? defaultCollectionBranchId,
      'paymentType': paymentType,
      if (businessId != null) 'businessId': '$businessId',
      if (planId != null) 'planId': planId,
      if (externalId != null) 'externalId': externalId,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      if (customerPaymentId != null) 'customerPaymentId': customerPaymentId,
      if (transactionId != null) 'transactionId': transactionId,
      if (customerId != null) 'customerId': customerId,
    };

    payLogInfo(
      'MoMo payNow: $paymentType $amount $currency to '
      '${MomoMsisdn.masked(phoneNumber)} (idempotencyKey=$idempotencyKey)',
    );

    final response = await _http.post(
      Uri.parse('${await paymentsApiBaseUrl()}/v2/api/payNow'),
      headers: const {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    final status = response.statusCode;
    _throwForStatus(status, response.body, 'payNow');
    if (status != 200 && status != 202) {
      throw MomoException(
        'The payment could not be started (HTTP $status).',
        statusCode: status,
        gatewayMessage: momoGatewayMessage(response.body),
      );
    }

    final decoded = _decodeObject(response.body);
    if (decoded == null) {
      throw MomoException(
        'The payment gateway sent an unreadable reply (HTTP $status).',
        statusCode: status,
      );
    }
    final reference = referenceFrom(decoded);
    if (reference == null || reference.isEmpty) {
      // Never treat this as a plain failure: the request may well have reached
      // MTN, so a caller that retries without an idempotency key debits twice.
      payLogError('MoMo payNow: HTTP $status with no reference. ${response.body}');
      throw MomoException(
        'The payment started but no reference came back — check the MoMo '
        'statement before trying again.',
        statusCode: status,
      );
    }

    return MomoInitiation(
      reference: reference,
      amount: _intOf(decoded['amount']) ?? amount,
      outcome: decoded['outcome']?.toString(),
      planId: decoded['planId']?.toString(),
      preapprovalId: decoded['preapprovalId']?.toString(),
      message: decoded['message']?.toString(),
      raw: decoded,
    );
  }

  /// One read of a request-to-pay.
  ///
  /// A non-2xx here means "no verdict yet", not "failed" — the caller keeps
  /// polling until its deadline rather than telling the user it went wrong.
  /// Polling this route makes the server re-check MTN, so it is authoritative
  /// and a till gets its answer without waiting for the background sweep.
  Future<MomoSettlement> requestToPayStatus(
    String reference, {
    String? branchId,
  }) async {
    final id = sanitizeReference(reference);
    if (id == null || id.isEmpty) {
      throw const MomoException('Missing payment reference.');
    }
    final branch = (branchId != null && branchId.trim().isNotEmpty)
        ? branchId.trim()
        : defaultCollectionBranchId;

    final response = await _http.get(
      Uri.parse(
        '${await paymentsApiBaseUrl()}/v2/api/requesttopay/status/$id/$branch',
      ),
    );
    final decoded = _decodeObject(response.body);
    if (decoded == null) {
      return MomoSettlement.unresolved(id, httpStatus: response.statusCode);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return MomoSettlement.unresolved(
        id,
        httpStatus: response.statusCode,
        reason: momoGatewayMessage(response.body),
      );
    }
    final settlement =
        MomoSettlement.fromJson(id, decoded, httpStatus: response.statusCode);
    payLogInfo('MoMo status $id → $settlement');
    return settlement;
  }

  // ── pre-approval ─────────────────────────────────────────────────────────

  /// Requests (or reuses) the recurring-payment mandate.
  ///
  /// Idempotent server-side: a payer who already consented is not prompted
  /// again, so this is safe to call before every subscription charge. The
  /// mandate is re-issued automatically when the plan gets more expensive than
  /// the amount the payer authorised.
  Future<MomoMandate> ensurePreapproval({
    required String phoneNumber,
    required int amount,
    String? planId,
    Object? businessId,
    String? branchId,
    int? validitySeconds,
    String payerMessage = 'Flipper Subscription',
    String currency = 'RWF',
  }) async {
    final partyId = MomoMsisdn.toPartyId(phoneNumber);
    if (partyId == null) {
      throw const MomoException(
        'Enter a valid Mobile Money number, e.g. 0788123456.',
      );
    }

    final response = await _http.post(
      Uri.parse('${await paymentsApiBaseUrl()}/v2/api/preApprove'),
      headers: const {'Content-Type': 'application/json'},
      body: json.encode({
        'payer': {'partyIdType': 'MSISDN', 'partyId': partyId},
        'payerCurrency': currency,
        'payerMessage': payerMessage,
        if (validitySeconds != null) 'validityTime': validitySeconds,
        'amount': amount,
        'branchId': branchId ?? defaultCollectionBranchId,
        if (planId != null) 'planId': planId,
        if (businessId != null) 'businessId': '$businessId',
      }),
    );

    final decoded = _decodeObject(response.body);
    if (response.statusCode != 200 || decoded == null) {
      final detail = momoGatewayMessage(response.body);
      payLogWarning(
        'MoMo preApprove for ${MomoMsisdn.masked(phoneNumber)} failed: '
        'HTTP ${response.statusCode} ${detail ?? response.body}',
      );
      // A failed mandate is a state, not an exception: the caller decides
      // whether to fall back to a PIN prompt or refuse to charge.
      return MomoMandate(
        state: MomoMandateState.failed,
        nextAction: 'retry_preapproval',
        error: detail ?? 'Pre-approval failed (HTTP ${response.statusCode}).',
      );
    }
    final mandate = MomoMandate.fromJson(decoded);
    payLogInfo('MoMo preApprove ${MomoMsisdn.masked(phoneNumber)} → $mandate');
    return mandate;
  }

  /// Re-reads a mandate, refreshed from MTN. This is the call that turns
  /// "we asked" into "they consented".
  Future<MomoMandate?> preapprovalStatus(String preapprovalId) async {
    final id = sanitizeReference(preapprovalId);
    if (id == null || id.isEmpty) return null;
    final response = await _http.get(
      Uri.parse('${await paymentsApiBaseUrl()}/v2/api/pre-approval-status/$id'),
    );
    final decoded = _decodeObject(response.body);
    if (response.statusCode != 200 || decoded == null) {
      payLogWarning(
        'MoMo pre-approval-status $id: HTTP ${response.statusCode} ${response.body}',
      );
      return null;
    }
    return MomoMandate.fromJson(decoded);
  }

  /// Waits for the payer to approve the mandate on their handset.
  ///
  /// Returns as soon as the mandate covers [amount], the mandate is refused, or
  /// [timeout] elapses. A read that fails is not a refusal — it keeps polling.
  Future<MomoMandate> awaitPreapproval(
    MomoMandate mandate, {
    required int amount,
    Duration interval = const Duration(seconds: 5),
    Duration timeout = const Duration(seconds: 90),
    void Function(MomoMandate mandate)? onUpdate,
  }) async {
    if (mandate.covers(amount)) return mandate;
    final id = mandate.id;
    if (id == null || id.isEmpty || mandate.isFailed) return mandate;

    final deadline = DateTime.now().add(timeout);
    var latest = mandate;
    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);
      final refreshed = await preapprovalStatus(id);
      if (refreshed == null) continue;
      latest = refreshed.id == null
          // The status alias does not always echo the id back; keep ours so the
          // caller can still poll or revoke this mandate.
          ? MomoMandate(
              state: refreshed.state,
              id: id,
              status: refreshed.status,
              authorisedAmount: refreshed.authorisedAmount,
              expiresAt: refreshed.expiresAt,
              coversCurrentPrice: refreshed.coversCurrentPrice,
              nextAction: refreshed.nextAction,
              error: refreshed.error,
            )
          : refreshed;
      onUpdate?.call(latest);
      if (latest.covers(amount) || latest.isFailed) return latest;
    }
    return latest;
  }

  // ── plumbing ─────────────────────────────────────────────────────────────

  void _throwForStatus(int status, String body, String label) {
    final fallback = switch (status) {
      400 => 'The payment request was rejected.',
      401 || 403 => 'This device is not authorised to take payments.',
      404 => 'The payment service could not be found.',
      409 => 'That payment has already been submitted.',
      500 ||
      502 ||
      503 ||
      504 => 'Mobile Money is unavailable right now. Please try again shortly.',
      _ => null,
    };
    if (fallback == null) return;

    // Lead with what the gateway said; keep the generic sentence only as a
    // fallback for an empty or unreadable body.
    final detail = momoGatewayMessage(body);
    payLogError('MoMo $label: HTTP $status ${detail ?? body}');
    throw MomoException(
      detail == null ? fallback : '$fallback $detail',
      statusCode: status,
      gatewayMessage: detail,
    );
  }

  Map<String, dynamic>? _decodeObject(String body) {
    if (body.isEmpty) return null;
    try {
      return asJsonObject(json.decode(body));
    } catch (_) {
      return null;
    }
  }

  static int? _intOf(dynamic value) {
    if (value is num) return value.round();
    final text = value?.toString().trim();
    return (text == null || text.isEmpty) ? null : int.tryParse(text);
  }
}

/// What `payNow` returned. The reference is the only field a caller must keep:
/// it is how the payment is polled, reconciled and refunded.
class MomoInitiation {
  const MomoInitiation({
    required this.reference,
    required this.amount,
    this.outcome,
    this.planId,
    this.preapprovalId,
    this.message,
    this.raw = const {},
  });

  final String reference;

  /// What the server actually charged. For a subscription this is the amount
  /// the *plan* owes, which may differ from what the client asked for —
  /// flipper-turbo used to reject the whole payment over a franc of rounding.
  final int amount;

  /// `submitted` · `already_in_flight` · `already_paid` · `not_due`.
  final String? outcome;

  final String? planId;
  final String? preapprovalId;
  final String? message;
  final Map<String, dynamic> raw;

  /// The gateway recognised this as a repeat of a payment already in flight or
  /// already settled — no second debit happened.
  bool get isDeduplicated =>
      outcome == 'already_in_flight' || outcome == 'already_paid';

  @override
  String toString() =>
      'MomoInitiation($reference, amount=$amount, outcome=$outcome)';
}

/// Deterministic idempotency keys.
///
/// The server deduplicates on this value, so it has to be **stable across
/// retries of the same collection and different between two genuine ones**.
/// Derive it from something already persisted — a transaction id, a plan id
/// plus its billing cycle. Never a clock reading or a fresh uuid: those change
/// on every tap, which is exactly the case the key exists to stop.
abstract final class MomoIdempotency {
  /// A POS or gig sale. Two taps on the same ticket collapse to one debit;
  /// two identical sales to the same customer are different transactions and
  /// so keep separate keys.
  static String forTransaction(String transactionId, int amount) =>
      'txn_${transactionId}_$amount';

  /// A subscription cycle. The plan plus the cycle it pays for: retrying today
  /// is the same payment, next month's is not.
  static String forPlanCycle(String planId, String cycleDate, int amount) =>
      'plan_${planId}_${cycleDate}_$amount';

  /// A credit purchase, keyed on the local row the client already created.
  static String forCreditPurchase(String paymentRowId, int amount) =>
      'credit_${paymentRowId}_$amount';
}
