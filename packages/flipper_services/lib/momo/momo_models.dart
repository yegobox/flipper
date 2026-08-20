import 'dart:convert';

/// Where a request-to-pay currently stands.
///
/// Ported from eduAI. The important rule is the default arm: **anything
/// unrecognised is pending, never failed**. A payment we cannot classify is a
/// payment still in flight as far as the user is concerned — polling resolves
/// it, and we never tell a cashier the money did not arrive because MTN sent a
/// status string we had not seen before.
enum MomoPaymentStatus {
  /// The push has been sent; the payer has not entered their PIN yet.
  pending,
  successful,
  failed;

  static MomoPaymentStatus fromWire(String? value) {
    return switch (value?.trim().toUpperCase()) {
      'SUCCESSFUL' => MomoPaymentStatus.successful,
      'FAILED' ||
      'REJECTED' ||
      'TIMEOUT' ||
      'EXPIRED' ||
      'CANCELLED' ||
      'NOT_FOUND' => MomoPaymentStatus.failed,
      _ => MomoPaymentStatus.pending,
    };
  }
}

/// One read of `GET /v2/api/requesttopay/status/{reference}/{branchId}`.
class MomoSettlement {
  const MomoSettlement({
    required this.reference,
    required this.status,
    this.httpStatus,
    this.financialTransactionId,
    this.externalId,
    this.settledAmountRwf,
    this.currency,
    this.reason,
    this.planId,
    this.source,
  });

  /// The request-to-pay id — the same value MTN calls `X-Reference-Id`.
  final String reference;

  final MomoPaymentStatus status;

  /// HTTP status of the poll itself, when there was one.
  final int? httpStatus;

  /// MTN's own transaction id, present once settled. This is the number the
  /// payer reads off their SMS receipt, and the only durable proof the money
  /// moved — always persist it.
  final String? financialTransactionId;

  final String? externalId;

  /// The amount MTN actually settled. Trusted over the requested amount.
  final int? settledAmountRwf;

  final String? currency;

  /// Gateway-supplied explanation, when it gives one. Present on failures and
  /// sometimes on a pending that will never resolve (a gateway that could not
  /// reach MTN reports PENDING with the transport error attached).
  final String? reason;

  final String? planId;

  /// `data-connector` when the reference is one we issued, `mtn` when the
  /// service had to proxy MTN directly for a reference it does not know.
  final String? source;

  bool get isSuccessful => status == MomoPaymentStatus.successful;
  bool get isPending => status == MomoPaymentStatus.pending;
  bool get isFailed => status == MomoPaymentStatus.failed;

  /// A verdict that will not change. Polling can stop.
  bool get isTerminal => !isPending;

  factory MomoSettlement.fromJson(
    String reference,
    Map<String, dynamic> json, {
    int? httpStatus,
  }) {
    final amount = json['amount'];
    return MomoSettlement(
      reference: reference,
      status: MomoPaymentStatus.fromWire(json['status']?.toString()),
      httpStatus: httpStatus,
      financialTransactionId: _string(json['financialTransactionId']),
      externalId: _string(json['externalId']),
      settledAmountRwf: amount is num
          ? amount.round()
          : int.tryParse(amount?.toString().trim() ?? ''),
      currency: _string(json['currency']),
      reason: _string(json['reason']) ?? _string(json['message']),
      planId: _string(json['planId']),
      source: _string(json['source']),
    );
  }

  /// A poll that could not be read as a verdict — the handset may simply be
  /// offline. Pending, so the caller keeps trying.
  factory MomoSettlement.unresolved(String reference, {int? httpStatus, String? reason}) {
    return MomoSettlement(
      reference: reference,
      status: MomoPaymentStatus.pending,
      httpStatus: httpStatus,
      reason: reason,
    );
  }

  @override
  String toString() =>
      'MomoSettlement($reference, $status, ftxId=$financialTransactionId, '
      'amount=$settledAmountRwf, reason=$reason)';
}

/// Where a pre-approval mandate stands. This is the consent that lets us debit
/// a payer on a schedule without prompting them for a PIN each time.
enum MomoMandateState {
  /// Approved, unexpired, and its authorised amount covers the charge.
  active,

  /// Requested; the payer has not entered their PIN yet.
  awaitingApproval,

  /// MTN refused, or the request never reached them.
  failed;

  static MomoMandateState fromWire(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'active' => MomoMandateState.active,
      'awaiting_approval' || 'awaitingapproval' => MomoMandateState.awaitingApproval,
      'failed' => MomoMandateState.failed,
      _ => MomoMandateState.awaitingApproval,
    };
  }
}

/// One pre-approval mandate as data-connector reports it.
///
/// flipper-turbo reduced this whole object to a boolean (`HTTP 200 == fine`),
/// which is how consent state drifted: a mandate that had expired, been
/// revoked, or been authorised for less than the new plan price still read as
/// "subscribed", and every subsequent debit failed with no visible reason.
class MomoMandate {
  const MomoMandate({
    required this.state,
    this.id,
    this.status,
    this.authorisedAmount,
    this.expiresAt,
    this.coversCurrentPrice = false,
    this.nextAction,
    this.error,
  });

  final MomoMandateState state;

  /// `preapprovalId` / `uuid` — poll `GET /v2/api/pre-approval-status/{id}`.
  final String? id;

  /// MTN's own word: `PENDING`, `APPROVED`, `REJECTED`, `EXPIRED`, `REVOKED`.
  final String? status;

  /// The ceiling the payer consented to. A debit above it is refused by MTN.
  final int? authorisedAmount;

  final DateTime? expiresAt;

  /// Whether [authorisedAmount] covers the price the server priced this plan
  /// at. False after an upgrade, until consent is re-issued.
  final bool coversCurrentPrice;

  /// `none` · `approve_preapproval_on_phone` · `retry_preapproval`.
  final String? nextAction;

  final String? error;

  bool get isActive => state == MomoMandateState.active;
  bool get isAwaitingApproval => state == MomoMandateState.awaitingApproval;
  bool get isFailed => state == MomoMandateState.failed;

  /// True when the payer must be told to look at their handset.
  bool get needsPayerAction => nextAction == 'approve_preapproval_on_phone';

  factory MomoMandate.fromJson(Map<String, dynamic> json) {
    // `state` is data-connector's own vocabulary; `status` is MTN's. Prefer
    // `state` and fall back to deriving it, so an older response shape (or the
    // `/v2/api/pre-approval-status` alias, which only guarantees `status`)
    // still classifies.
    final rawState = _string(json['state']);
    final rawStatus = _string(json['status']);
    final state = rawState != null
        ? MomoMandateState.fromWire(rawState)
        : _stateFromMtnStatus(rawStatus);
    return MomoMandate(
      state: state,
      id: _string(json['preapprovalId']) ?? _string(json['uuid']) ?? _string(json['id']),
      status: rawStatus,
      authorisedAmount: _int(json['authorisedAmount'] ?? json['amount']),
      expiresAt: _dateTime(json['expiresAt']),
      coversCurrentPrice: json['coversCurrentPrice'] == true,
      nextAction: _string(json['nextAction']),
      error: _string(json['error']),
    );
  }

  static MomoMandateState _stateFromMtnStatus(String? status) {
    return switch (status?.trim().toUpperCase()) {
      'APPROVED' => MomoMandateState.active,
      'REJECTED' ||
      'EXPIRED' ||
      'REVOKED' ||
      'SUPERSEDED' ||
      'NOT_FOUND' => MomoMandateState.failed,
      _ => MomoMandateState.awaitingApproval,
    };
  }

  /// The mandate is good enough to debit [amount] without a PIN prompt.
  ///
  /// Both halves matter. flipper-turbo checked neither: it ignored the
  /// authorised amount entirely, so raising a plan's price made every recurring
  /// debit fail silently.
  bool covers(int amount) {
    if (!isActive) return false;
    final expiry = expiresAt;
    if (expiry != null && !expiry.isAfter(DateTime.now())) return false;
    final authorised = authorisedAmount;
    if (authorised == null) return coversCurrentPrice;
    return authorised >= amount;
  }

  @override
  String toString() =>
      'MomoMandate($id, state=$state, status=$status, authorised=$authorisedAmount, '
      'expires=$expiresAt, covers=$coversCurrentPrice)';
}

/// Mobile Money is not reachable from this build (no gateway configured).
class MomoUnavailable implements Exception {
  const MomoUnavailable([this.message = 'Mobile Money is not set up on this device yet.']);

  final String message;

  @override
  String toString() => message;
}

/// The gateway was reached but refused or failed the request.
class MomoException implements Exception {
  const MomoException(this.message, {this.statusCode, this.gatewayMessage});

  final String message;
  final int? statusCode;

  /// Exactly what the gateway said, when it said anything. Kept separate from
  /// [message] so logs and support tickets can quote the server verbatim
  /// without the surrounding client-side wording.
  final String? gatewayMessage;

  @override
  String toString() => message;
}

/// The gateway's own explanation for a refusal, when it gave one.
///
/// data-connector answers every failure as `{"error": "…"}` and wraps *any*
/// engine error into a 400 with the real cause in that field — a missing MTN
/// credential, an amount over the configured ceiling, a cycle already paid
/// ("paid through 2026-09-13"), MTN's own rejection. Dropping it and showing
/// "Bad request" threw away the only description of what went wrong, which is
/// exactly what made a failed payment impossible to debug from the app.
String? momoGatewayMessage(String? body) {
  if (body == null || body.isEmpty) return null;
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map) {
      for (final key in const ['error', 'message', 'detail', 'reason']) {
        final value = decoded[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
      return null;
    }
  } catch (_) {
    // Not JSON — a proxy or a framework-level rejection. The text itself is
    // still the most useful thing we have.
  }
  final text = body.trim();
  if (text.isEmpty) return null;
  // Keep it to one line so it fits a snackbar and a log line.
  final firstLine = text.split('\n').first.trim();
  return firstLine.length > 300 ? firstLine.substring(0, 300) : firstLine;
}

String? _string(dynamic value) {
  final text = value?.toString().trim();
  return (text == null || text.isEmpty || text == 'null') ? null : text;
}

int? _int(dynamic value) {
  if (value is num) return value.round();
  final text = _string(value);
  return text == null ? null : int.tryParse(text) ?? double.tryParse(text)?.round();
}

DateTime? _dateTime(dynamic value) {
  final text = _string(value);
  return text == null ? null : DateTime.tryParse(text)?.toUtc();
}
