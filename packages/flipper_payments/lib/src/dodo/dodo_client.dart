import 'dart:async';
import 'dart:convert';


import 'package:flipper_payments/src/http/payments_http_client.dart';
import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/dodo/dodo_models.dart';
import 'package:flipper_payments/src/payments_api.dart';
import 'package:http/http.dart' as http;

/// HTTP client for the data-connector Dodo Payments rail — the card side of
/// subscription billing.
///
/// One place that knows the wire shapes, mirroring [MomoClient] for the other
/// rail, so both get the same guarantees:
///
/// * a refusal keeps the connector's own words instead of "Bad request";
/// * `next_action` is decoded into a closed enum with an explicit *unknown*
///   arm, so a Dodo status we have never seen leaves the screen waiting rather
///   than guessing;
/// * the base URL resolves the same way MoMo's does, so a branch pointed at a
///   staging connector gets both rails there, never one of each.
///
/// **Nothing here needs an idempotency key**, and that is not an oversight:
/// `POST …/start` is idempotent server-side. A second tap while the first
/// subscription is still `pending` returns *that* subscription and its existing
/// link (`reused_existing: true`) instead of putting a second subscription on
/// the customer's card. See `data-connector/DODO_BILLING.md` §3.3.
///
/// Routes (`data-connector/src/api/dodo.rs`):
///
/// * `GET  /api/dodo/health`
/// * `POST /api/dodo/subscriptions/start`
/// * `GET  /api/dodo/subscriptions/{plan_id}`
/// * `POST /api/dodo/subscriptions/{plan_id}/sync`
/// * `POST /api/dodo/subscriptions/{plan_id}/cancel`
/// * `POST /api/dodo/subscriptions/{plan_id}/payment-method`
/// * `POST /api/dodo/subscriptions/{plan_id}/portal`
/// * `GET  /api/dodo/businesses/{business_id}/subscription`
class DodoClient {
  const DodoClient(this._http, {String? authToken}) : _authToken = authToken;

  final PaymentsHttpClient _http;

  /// Sent as `Authorization: Bearer …` when set.
  ///
  /// The connector's Dodo routes are open unless `DODO_API_TOKEN` (or
  /// `BILLING_API_TOKEN`) is configured on it — the same posture as the MoMo
  /// routes — so this is normally null. It exists so a deployment that turns
  /// the token on does not need a client change.
  final String? _authToken;

  /// Every call is bounded.
  ///
  /// Without this, an unreachable connector produced the worst possible
  /// failure: `_http.post` never completed, so the screen's `_isLoading` stayed
  /// true, the button span "Opening…" forever, and *no* log line appeared after
  /// the pre-flight one — because the code that logs success and the code that
  /// throws are both after the await. A timeout converts that into a visible,
  /// named error.
  ///
  /// 25s is generous for the connector, which does one Dodo round trip inside
  /// `POST /start`.
  static const Duration _timeout = Duration(seconds: 25);

  /// Run [request], failing with a [DodoException] that names [url] if it hangs
  /// or the host is unreachable.
  Future<http.Response> _send(
    String what,
    Uri url,
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      payLogError('Dodo $what: no response from $url within ${_timeout.inSeconds}s');
      throw DodoException(
        'The payments service did not respond. Check your connection and try '
        'again.',
        gatewayMessage: 'No response from $url after ${_timeout.inSeconds}s.',
      );
    } catch (e) {
      // A socket error carries the host, which is the one fact worth surfacing:
      // a build pointed at a connector that is not there looks identical to a
      // broken payment otherwise.
      payLogError('Dodo $what: could not reach $url — $e');
      throw DodoException(
        'Could not reach the payments service. Check your connection and try '
        'again.',
        gatewayMessage: 'Could not reach $url: $e',
      );
    }
  }

  Map<String, String> get _headers {
    final token = _authToken?.trim();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── availability ─────────────────────────────────────────────────────────

  /// Is the card rail sellable on this connector?
  ///
  /// Never throws: an unreachable connector is [DodoHealth.unavailable], which
  /// hides the card option and leaves Mobile Money exactly as it was. A payment
  /// screen must not fail to load because a *second* rail could not be probed.
  Future<DodoHealth> health() async {
    try {
      final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/health');
      final response = await _send(
        'GET',
        url,
        () => _http.get(url, headers: _headers),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        payLogWarning(
          'Dodo health: HTTP ${response.statusCode}; card payment stays hidden',
        );
        return DodoHealth.unavailable;
      }
      final decoded = _decodeObject(response.body);
      if (decoded == null) return DodoHealth.unavailable;
      final health = DodoHealth.fromJson(decoded);
      payLogInfo('Dodo health: $health');
      return health;
    } catch (e) {
      payLogWarning('Dodo health check failed ($e); card payment stays hidden');
      return DodoHealth.unavailable;
    }
  }

  // ── subscriptions ────────────────────────────────────────────────────────

  /// Creates (or reuses) the Dodo subscription and returns the checkout link.
  ///
  /// [totalPrice] is deliberately **not** a parameter. Dodo bills the price
  /// fixed on its product, so sending a client-side figure — a discounted one
  /// especially — would only make `plans.total_price` disagree with what the
  /// card is actually charged. The connector prices the tier from the catalogue.
  ///
  /// [email] is optional here but required *somewhere*: the connector falls back
  /// to `businesses.email` and fails if neither has one, rather than inventing
  /// an address Dodo would send invoices to.
  Future<DodoStartResult> startSubscription({
    required String businessId,
    String? branchId,
    String? planId,
    String? planTemplateId,
    String? selectedPlan,
    List<String> addons = const [],
    bool isYearlyPlan = false,
    String? email,
    String? customerName,
    String? phoneNumber,
    String? country,
    String? returnUrl,
    int? additionalDevices,
    Map<String, String>? metadata,
  }) async {
    if (businessId.trim().isEmpty) {
      throw const DodoException('A business is required to start a card subscription.');
    }

    final payload = <String, dynamic>{
      'business_id': businessId,
      'is_yearly_plan': isYearlyPlan,
      if (_present(branchId)) 'branch_id': branchId!.trim(),
      if (_present(planId)) 'plan_id': planId!.trim(),
      if (_present(planTemplateId)) 'plan_template_id': planTemplateId!.trim(),
      if (_present(selectedPlan)) 'selected_plan': selectedPlan!.trim(),
      if (addons.isNotEmpty) 'addons': addons,
      if (_present(email)) 'email': email!.trim(),
      if (_present(customerName)) 'customer_name': customerName!.trim(),
      if (_present(phoneNumber)) 'phone_number': phoneNumber!.trim(),
      if (_present(country)) 'country': country!.trim(),
      if (_present(returnUrl)) 'return_url': returnUrl!.trim(),
      if (additionalDevices != null) 'additional_devices': additionalDevices,
      if (metadata != null && metadata.isNotEmpty) 'metadata': metadata,
      'mode': dodoBuildMode,
    };

    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/start');

    // The host is in the line because "nothing happened" is almost always a
    // build pointed somewhere there is no connector, and that is invisible
    // otherwise.
    payLogInfo(
      'Dodo start [$dodoBuildMode] → $url  business=$businessId plan=$planId '
      'tier=$selectedPlan yearly=$isYearlyPlan addons=${addons.length}',
    );

    final response = await _send(
      'POST',
      url,
      () => _http.post(url, headers: _headers, body: json.encode(payload)),
    );

    final decoded = _requireObject(response, 'start a card subscription');
    final result = DodoStartResult.fromJson(decoded);

    if (result.planId.isEmpty || result.dodoSubscriptionId.isEmpty) {
      // The subscription may well exist upstream, so this is never reported as
      // a plain failure — a caller that "retries" a start it thinks failed is
      // relying on the connector's reuse rule to save it.
      payLogError('Dodo start: HTTP ${response.statusCode} with no ids. ${response.body}');
      throw DodoException(
        'The card subscription started but the connector sent no reference. '
        'Check the billing screen before trying again.',
        statusCode: response.statusCode,
      );
    }

    payLogInfo('Dodo start → $result');
    return result;
  }

  /// Reads the connector's view of a plan's subscription. Cheap; no Dodo call.
  Future<DodoSubscriptionStatus> subscriptionForPlan(String planId) async {
    final id = _requireId(planId, 'plan');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/$id');
    final response = await _send(
      'GET',
      url,
      () => _http.get(url, headers: _headers),
    );
    return DodoSubscriptionStatus.fromJson(
      _requireObject(response, 'read the card subscription'),
    );
  }

  /// Same view, by business rather than plan.
  Future<DodoSubscriptionStatus> subscriptionForBusiness(String businessId) async {
    final id = _requireId(businessId, 'business');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/businesses/$id/subscription');
    final response = await _send(
      'GET',
      url,
      () => _http.get(url, headers: _headers),
    );
    return DodoSubscriptionStatus.fromJson(
      _requireObject(response, 'read the card subscription'),
    );
  }

  /// Forces a read-through to Dodo and returns the refreshed view.
  ///
  /// This is what a client just back from the checkout page calls: it does not
  /// have to wait for the webhook or the connector's 15-minute reconcile sweep
  /// to learn that the money landed.
  Future<DodoSubscriptionStatus> syncSubscription(String planId) async {
    final id = _requireId(planId, 'plan');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/$id/sync');
    final response = await _send(
      'POST',
      url,
      () => _http.post(url, headers: _headers, body: '{}'),
    );
    final status = DodoSubscriptionStatus.fromJson(
      _requireObject(response, 'refresh the card subscription'),
    );
    payLogInfo('Dodo sync $id → $status');
    return status;
  }

  /// A checkout link to attach a new card.
  ///
  /// On an `on_hold` subscription Dodo also collects the outstanding dues from
  /// it — this is the documented way out of a failed renewal, not a cosmetic
  /// "update card" screen.
  Future<DodoCheckout> updatePaymentMethod(String planId) async {
    final id = _requireId(planId, 'plan');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/$id/payment-method');
    final response = await _send(
      'POST',
      url,
      () => _http.post(url, headers: _headers, body: '{}'),
    );
    final decoded = _requireObject(response, 'get a new card link');
    final checkout = DodoCheckout.fromJson(
      decoded['checkout'] is Map
          ? Map<String, dynamic>.from(decoded['checkout'] as Map)
          : null,
    );
    if (!checkout.hasLink) {
      throw DodoException(
        'The connector did not return a link to update the card.',
        statusCode: response.statusCode,
      );
    }
    return checkout;
  }

  /// A Dodo customer-portal link: invoices, payment methods, self-serve cancel.
  Future<String> customerPortalLink(String planId) async {
    final id = _requireId(planId, 'plan');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/$id/portal');
    final response = await _send(
      'POST',
      url,
      () => _http.post(url, headers: _headers, body: '{}'),
    );
    final decoded = _requireObject(response, 'open the billing portal');
    final link = decoded['portal_link']?.toString().trim();
    if (link == null || link.isEmpty) {
      throw DodoException(
        'The connector did not return a billing portal link.',
        statusCode: response.statusCode,
      );
    }
    return link;
  }

  /// Cancels the subscription. [atPeriodEnd] defaults to true on the connector:
  /// the customer keeps what they already paid for.
  Future<Map<String, dynamic>> cancelSubscription(
    String planId, {
    bool atPeriodEnd = true,
  }) async {
    final id = _requireId(planId, 'plan');
    final url = Uri.parse('${await paymentsApiBaseUrl()}/api/dodo/subscriptions/$id/cancel');
    final response = await _send(
      'POST',
      url,
      () => _http.post(url, headers: _headers, body: json.encode({'at_period_end': atPeriodEnd})),
    );
    return _requireObject(response, 'cancel the card subscription');
  }

  // ── internals ────────────────────────────────────────────────────────────

  static bool _present(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _requireId(String raw, String what) {
    final id = raw.trim();
    if (id.isEmpty) {
      throw DodoException('Missing $what id.');
    }
    return id;
  }

  /// Turns a response into a JSON object, or into a [DodoException] carrying
  /// the connector's explanation.
  ///
  /// The connector already maps its failures onto meaningful codes — a Dodo 404
  /// stays a 404, a tier with no product configured is a 400, a disabled rail is
  /// a 503 — so the status is worth keeping alongside the message.
  static Map<String, dynamic> _requireObject(
    http.Response response,
    String what,
  ) {
    final status = response.statusCode;
    final gateway = dodoGatewayMessage(response.body);

    if (status == 401 || status == 403) {
      throw DodoException(
        'Card payment is not authorised on this connector.',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }
    if (status == 503) {
      throw DodoException(
        'Card payment is not available right now. Use Mobile Money, or try again later.',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }
    if (status < 200 || status >= 300) {
      throw DodoException(
        'Could not $what (HTTP $status).',
        statusCode: status,
        gatewayMessage: gateway,
      );
    }

    final decoded = _decodeObject(response.body);
    if (decoded == null) {
      throw DodoException(
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
