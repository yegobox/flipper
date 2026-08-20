import 'dart:convert';

import 'package:flipper_hr/features/billing/data/hr_msisdn.dart';
import 'package:http/http.dart' as http;

/// Where a request-to-pay stands.
enum HrMomoStatus {
  /// The push has been sent; the payer has not entered their PIN yet.
  pending,
  successful,
  failed;

  /// MTN reports `SUCCESSFUL` / `PENDING` / `FAILED` / `REJECTED` / `TIMEOUT`.
  /// Anything unrecognised is treated as still pending rather than failed:
  /// polling can then resolve it, and nobody is told their money vanished
  /// because of an unfamiliar status string.
  static HrMomoStatus fromWire(String? value) =>
      switch (value?.trim().toUpperCase()) {
        'SUCCESSFUL' => HrMomoStatus.successful,
        'FAILED' || 'REJECTED' || 'TIMEOUT' || 'EXPIRED' => HrMomoStatus.failed,
        _ => HrMomoStatus.pending,
      };
}

/// One poll of `GET /v2/api/requesttopay/status/{reference}/{branchId}`.
class HrMomoSettlement {
  const HrMomoSettlement({
    required this.reference,
    required this.status,
    this.financialTransactionId,
    this.reason,
  });

  final String reference;
  final HrMomoStatus status;

  /// MTN's own transaction id, present once settled — the number on the payer's
  /// SMS receipt.
  final String? financialTransactionId;

  /// The gateway's failure reason, when it gives one.
  final String? reason;

  bool get isSuccessful => status == HrMomoStatus.successful;
  bool get isPending => status == HrMomoStatus.pending;

  factory HrMomoSettlement.fromJson(
    String reference,
    Map<String, dynamic> json,
  ) {
    return HrMomoSettlement(
      reference: reference,
      status: HrMomoStatus.fromWire(json['status']?.toString()),
      financialTransactionId: json['financialTransactionId']?.toString(),
      reason: json['reason']?.toString(),
    );
  }
}

/// Submits the subscription charge and reads its status. Faked in tests.
abstract class HrMomoGateway {
  /// Charges [planId] and returns the reference to poll.
  ///
  /// The amount is **not** sent as an instruction: data-connector recomputes it
  /// from the plan row (`plans.total_price`, written server-side by
  /// `hr_start_subscription`) and only echoes the client's figure back for
  /// comparison. It is passed for that comparison and for the payer's message.
  Future<String> payPlan({
    required String planId,
    required String businessId,
    required String phoneNumber,
    required int amountRwf,
  });

  Future<HrMomoSettlement> status(String reference);

  /// Best-effort nudge after MTN reported SUCCESSFUL, so the plan row flips
  /// without waiting for the backend's own sweep. The server still verifies
  /// against MTN — the client's word never settles a charge.
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  });
}

/// HTTP client for the data-connector Mobile Money gateway.
///
/// Same endpoints Books pays through (`flipper_services/lib/momo/momo_client.dart`,
/// `data-connector/MOMO_BILLING.md`):
///
/// * `POST /v2/api/payNow`            — with `paymentType: Subscription`
/// * `GET  /v2/api/requesttopay/status/{reference}/{branchId}`
/// * `POST /v2/api/payment/finalize-on-success`
class HttpHrMomoGateway implements HrMomoGateway {
  const HttpHrMomoGateway(
    this._client, {
    this.baseUrl = defaultBaseUrl,
    this.collectionBranchId = defaultCollectionBranchId,
    this.apiToken = defaultApiToken,
  });

  /// data-connector, which owns Mobile Money for every Flipper product.
  static const String defaultBaseUrl = String.fromEnvironment(
    'MOMO_API_URL',
    defaultValue: 'https://data-connector.yegobox.com',
  );

  /// The MTN collection account the charge is booked against. The server
  /// resolves the real account from its own configuration, so this only has to
  /// be *consistent* between the payNow and the status reads that follow it.
  static const String defaultCollectionBranchId = String.fromEnvironment(
    'MOMO_BRANCH_ID',
    defaultValue: '2f83b8b1-6d41-4d80-b0e7-de8ab36910af',
  );

  /// Only needed where data-connector runs with `BILLING_API_TOKEN` set.
  static const String defaultApiToken = String.fromEnvironment(
    'BILLING_API_TOKEN',
  );

  static const Duration _timeout = Duration(seconds: 30);

  static final RegExp _uuid = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  final http.Client _client;
  final String baseUrl;
  final String collectionBranchId;
  final String apiToken;

  Map<String, String> get _headers => {
    'content-type': 'application/json',
    if (apiToken.isNotEmpty) 'authorization': 'Bearer $apiToken',
  };

  /// The gateway has been seen echoing a reference wrapped in log formatting,
  /// and the status path only accepts the bare id.
  static String? sanitizeReference(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
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

  @override
  Future<String> payPlan({
    required String planId,
    required String businessId,
    required String phoneNumber,
    required int amountRwf,
  }) async {
    final partyId = HrMsisdn.toPartyId(phoneNumber);
    if (partyId == null) {
      throw const HrMomoException(
        'Enter a valid MTN or Airtel number, e.g. 0788123456.',
      );
    }

    final response = await _client
        .post(
          Uri.parse('$baseUrl/v2/api/payNow'),
          headers: _headers,
          body: jsonEncode({
            'amount': amountRwf,
            'currency': 'RWF',
            'payer': {'partyIdType': 'MSISDN', 'partyId': partyId},
            'payerMessage': 'Flipper subscription',
            'payeeNote': 'Flipper subscription',
            'paymentType': 'Subscription',
            'planId': planId,
            'businessId': businessId,
            'branchId': collectionBranchId,
            // Keyed on the plan, not on a clock: a double tap or a retried POST
            // returns the charge already in flight instead of debiting twice.
            'idempotencyKey': 'hr_sub_$planId',
          }),
        )
        .timeout(_timeout);

    _throwForStatus(response.statusCode, response.body);
    final decoded = _decode(response.body);
    if (decoded == null) {
      throw const HrMomoException(
        'The payment gateway sent an unreadable reply.',
      );
    }

    final reference = referenceFrom(decoded);
    if (reference == null || reference.isEmpty) {
      throw const HrMomoException(
        'The payment started but no reference came back — check your Mobile '
        'Money statement before trying again.',
      );
    }
    return reference;
  }

  @override
  Future<HrMomoSettlement> status(String reference) async {
    final id = sanitizeReference(reference);
    if (id == null || id.isEmpty) {
      throw const HrMomoException('Missing payment reference.');
    }

    final response = await _client
        .get(
          Uri.parse(
            '$baseUrl/v2/api/requesttopay/status/$id/$collectionBranchId',
          ),
          headers: _headers,
        )
        .timeout(_timeout);

    final decoded = _decode(response.body);
    if (decoded == null) {
      throw const HrMomoException(
        'The payment gateway sent an unreadable reply.',
      );
    }
    // A non-2xx here means "no verdict yet", not "failed": the caller keeps
    // polling rather than telling somebody their payment went wrong.
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return HrMomoSettlement(
        reference: id,
        status: HrMomoStatus.pending,
        reason: decoded['message']?.toString(),
      );
    }
    return HrMomoSettlement.fromJson(id, decoded);
  }

  @override
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  }) async {
    try {
      await _client
          .post(
            Uri.parse('$baseUrl/v2/api/payment/finalize-on-success'),
            headers: _headers,
            body: jsonEncode({
              'planId': planId,
              'paymentReference': reference,
            }),
          )
          .timeout(_timeout);
    } catch (_) {
      // Best effort by definition: the money has already moved and the backend
      // sweeps unsettled charges on its own. A failure here must never turn a
      // successful payment into an error on screen.
    }
  }

  void _throwForStatus(int status, String body) {
    if (status == 200 || status == 202) return;

    final fallback = switch (status) {
      400 => 'The payment request was rejected as invalid.',
      401 || 403 => 'This account is not authorised to take payments.',
      404 => 'The payment service could not be found.',
      409 => 'That payment has already been submitted.',
      >= 500 =>
        'Mobile Money is unavailable right now. Please try again shortly.',
      _ => 'The payment could not be started (HTTP $status).',
    };

    // Lead with what the gateway said. data-connector answers every failure as
    // `{"error": "…"}` with the real cause in that field — a missing MTN
    // credential, an amount over the ceiling, MTN's own refusal — and dropping
    // it is what made a failed payment impossible to debug from the app.
    final detail = gatewayMessage(body);
    throw HrMomoException(detail == null ? fallback : '$fallback $detail');
  }

  /// The gateway's own explanation for a refusal, when it gave one.
  static String? gatewayMessage(String body) {
    if (body.isEmpty) return null;
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
    final firstLine = body.trim().split('\n').first.trim();
    if (firstLine.isEmpty) return null;
    return firstLine.length > 300 ? firstLine.substring(0, 300) : firstLine;
  }

  Map<String, dynamic>? _decode(String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }
}

/// The gateway was reached but refused or failed the request.
class HrMomoException implements Exception {
  const HrMomoException(this.message);

  final String message;

  @override
  String toString() => message;
}
