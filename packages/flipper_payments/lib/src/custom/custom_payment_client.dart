import 'dart:async';
import 'dart:convert';

import 'package:flipper_payments/src/custom/custom_payment_models.dart';
import 'package:flipper_payments/src/dodo/dodo_models.dart' show dodoBuildMode;
import 'package:flipper_payments/src/http/payments_http_client.dart';
import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/payments_api.dart';
import 'package:http/http.dart' as http;

/// HTTP client for the connector's staff-only negotiated-price payments
/// (`data-connector/CUSTOM_PAYMENTS.md`).
///
/// Unlike [DodoClient] and [MomoClient], a token is **required**: these routes
/// fail closed on the connector, because they are the only ones that can set a
/// plan's price to an arbitrary number. The token is the staff member's own
/// `billing_staff.staff_token`, which the host app reads from Supabase under
/// RLS — never a compile-time secret.
///
/// Routes (`data-connector/src/api/custom_payments.rs`):
///
/// * `POST /api/billing/custom-payments`
/// * `GET  /api/billing/custom-payments/{id}?sync=`
/// * `GET  /api/billing/custom-payments?business_id=`
class CustomPaymentClient {
  const CustomPaymentClient(this._http, {required String staffToken})
    : _staffToken = staffToken;

  final PaymentsHttpClient _http;
  final String _staffToken;

  /// Bounded like the other clients: a connector that never answers must
  /// surface as a named error, not a spinner that spins forever.
  static const Duration _timeout = Duration(seconds: 25);

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_staffToken.trim()}',
  };

  Future<http.Response> _send(
    String what,
    Uri url,
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      payLogError(
        'Custom payment $what: no response from $url within ${_timeout.inSeconds}s',
      );
      throw CustomPaymentException(
        'The payments service did not respond. Check your connection and try again.',
        gatewayMessage: 'No response from $url after ${_timeout.inSeconds}s.',
      );
    } on CustomPaymentException {
      rethrow;
    } catch (e) {
      payLogError('Custom payment $what: could not reach $url — $e');
      throw CustomPaymentException(
        'Could not reach the payments service. Check your connection and try again.',
        gatewayMessage: 'Could not reach $url: $e',
      );
    }
  }

  /// Start a negotiated payment.
  ///
  /// [amount] is the price per period in major units (RWF francs). For
  /// [CustomPaymentRail.momo] a [phoneNumber] is required; for
  /// [CustomPaymentRail.card] the connector needs an [email] (or one on the
  /// business row) and transacts in this build's [dodoBuildMode].
  Future<CustomPaymentView> create({
    required String businessId,
    required int amount,
    required CustomPaymentCadence cadence,
    required CustomPaymentRail rail,
    String? phoneNumber,
    String? email,
    String? customerName,
    String? branchId,
    String? note,
    String? returnUrl,
  }) async {
    if (businessId.trim().isEmpty) {
      throw const CustomPaymentException('Choose a business first.');
    }
    if (amount <= 0) {
      throw const CustomPaymentException('Amount must be greater than zero.');
    }
    if (rail.isMomo && (phoneNumber == null || phoneNumber.trim().isEmpty)) {
      throw const CustomPaymentException(
        "The customer's Mobile Money number is required.",
      );
    }

    final url = Uri.parse(
      '${await paymentsApiBaseUrl()}/api/billing/custom-payments',
    );
    final body = <String, dynamic>{
      'business_id': businessId.trim(),
      'amount': amount,
      'rule': cadence.wireValue,
      'rail': rail.wireValue,
      if (_present(phoneNumber)) 'phone_number': phoneNumber!.trim(),
      if (_present(email)) 'email': email!.trim(),
      if (_present(customerName)) 'customer_name': customerName!.trim(),
      if (_present(branchId)) 'branch_id': branchId!.trim(),
      if (_present(note)) 'note': note!.trim(),
      if (_present(returnUrl)) 'return_url': returnUrl!.trim(),
      if (rail.isCard) 'mode': dodoBuildMode,
    };
    payLogInfo(
      'Custom payment: POST $url business=$businessId ${rail.wireValue} '
      '$amount ${cadence.wireValue}',
    );
    final response = await _send(
      'POST create',
      url,
      () => _http.post(url, headers: _headers, body: jsonEncode(body)),
    );
    final decoded = _requireObject(response, 'start the custom payment');
    final view = CustomPaymentView.fromJson(decoded);
    payLogInfo('Custom payment: started $view');
    return view;
  }

  /// Current state. [sync] asks the connector to re-read the Dodo subscription
  /// first (card only) — for a client just back from the checkout page.
  Future<CustomPaymentView> status(String id, {bool sync = false}) async {
    final clean = id.trim();
    if (clean.isEmpty) {
      throw const CustomPaymentException('Missing custom payment id.');
    }
    final url = Uri.parse(
      '${await paymentsApiBaseUrl()}/api/billing/custom-payments/'
      '${Uri.encodeComponent(clean)}${sync ? '?sync=true' : ''}',
    );
    final response = await _send(
      'GET status',
      url,
      () => _http.get(url, headers: _headers),
    );
    return CustomPaymentView.fromJson(
      _requireObject(response, 'read the custom payment'),
    );
  }

  /// Recent custom payments for one business, newest first.
  Future<List<CustomPaymentView>> recentForBusiness(
    String businessId, {
    int limit = 20,
  }) async {
    final url = Uri.parse(
      '${await paymentsApiBaseUrl()}/api/billing/custom-payments'
      '?business_id=${Uri.encodeQueryComponent(businessId.trim())}&limit=$limit',
    );
    final response = await _send(
      'GET history',
      url,
      () => _http.get(url, headers: _headers),
    );
    final decoded = _requireObject(response, 'list custom payments');
    final items = decoded['custom_payments'];
    if (items is! List) return const [];
    return items
        .whereType<Map>()
        .map((m) => CustomPaymentView.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  // ── internals ──

  static bool _present(String? value) =>
      value != null && value.trim().isNotEmpty;

  static Map<String, dynamic> _requireObject(
    http.Response response,
    String what,
  ) {
    final status = response.statusCode;
    final gateway = customPaymentGatewayMessage(response.body);
    final decoded = _decodeObject(response.body);

    if (status == 401 || status == 403) {
      throw CustomPaymentException(
        'This account is not authorised for staff payments.',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }
    if (status == 409) {
      final inFlight = decoded?['in_flight'];
      throw CustomPaymentException(
        'Something is already collecting from this business.',
        statusCode: status,
        gatewayMessage: gateway,
        inFlight: inFlight is Map
            ? CustomPaymentView.fromJson(Map<String, dynamic>.from(inFlight))
            : null,
      );
    }
    if (status == 503) {
      throw CustomPaymentException(
        'Staff payments are not configured on this connector.',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }
    if (status < 200 || status >= 300) {
      throw CustomPaymentException(
        'Could not $what (HTTP $status).',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }
    if (decoded == null) {
      throw CustomPaymentException(
        'The billing service sent an unreadable reply (HTTP $status).',
        statusCode: status,
      );
    }
    return decoded;
  }

  static Map<String, dynamic>? _decodeObject(String? body) {
    if (body == null || body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }
}
