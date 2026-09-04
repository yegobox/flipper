import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;

/// Which Dodo account this build transacts against.
///
/// A debug build pays on Dodo's **test** account, so a developer can run a real
/// checkout with a test card and never move real money; a release build pays on
/// live. The connector serves both at once (`DODO_LIVE_*` / `DODO_TEST_*`), so
/// this is a per-request choice rather than a second deployment.
///
/// Only sent when *starting* a subscription. Every later operation takes its
/// mode from the stored row, so a subscription created in test can never be
/// charged in live.
///
/// Lives here rather than on `DodoClient` because `DodoHealth` needs it too, and
/// models is the leaf of this pair.
String get dodoBuildMode => kDebugMode ? 'test' : 'live';

/// Wire shapes for the data-connector Dodo Payments rail
/// (`data-connector/DODO_BILLING.md`).
///
/// Dodo is the **card** rail: the customer pays on a hosted checkout page that
/// Dodo owns, and Dodo holds the mandate and runs the renewals. That is the
/// mirror image of MTN MoMo, where we submit a request-to-pay and poll it — so
/// none of these types try to reuse the MoMo ones. The two rails meet only at
/// the `plans` row, which is why nothing downstream of a subscription has to
/// know which one paid.

/// The gateway refused something, and it said why.
class DodoException implements Exception {
  const DodoException(
    this.message, {
    this.statusCode,
    this.gatewayMessage,
  });

  final String message;
  final int? statusCode;

  /// The connector's own words, when it gave any. Worth showing: "no Dodo
  /// product is configured for tier X" is actionable, "Bad request" is not.
  final String? gatewayMessage;

  /// What a user should read. Prefers the gateway's explanation.
  String get displayMessage {
    final gateway = gatewayMessage?.trim();
    if (gateway != null && gateway.isNotEmpty) return gateway;
    return message;
  }

  @override
  String toString() => displayMessage;
}

/// What the client should do next.
///
/// The connector tells us this explicitly so that Dodo adding a *status* never
/// requires a Flipper release — we switch on the action, never on the status
/// string. [unknown] is the whole point of that: an action we have not seen
/// leaves the screen in a "we are waiting" state rather than guessing.
enum DodoNextAction {
  /// Send the customer to [DodoCheckout.paymentLink].
  openPaymentLink,

  /// A renewal failed. Ask the connector for a fresh link to attach a card —
  /// Dodo also collects the outstanding dues from it.
  updatePaymentMethod,

  /// Dodo has the money; the webhook has not landed yet. Keep polling.
  awaitingActivation,

  /// Terminal (cancelled / expired / failed). Start over.
  resubscribe,

  /// Nothing to do.
  none,

  /// An action this build does not know. Treated as "keep waiting".
  unknown;

  static DodoNextAction fromWire(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'open_payment_link' => DodoNextAction.openPaymentLink,
      'update_payment_method' => DodoNextAction.updatePaymentMethod,
      'awaiting_activation' => DodoNextAction.awaitingActivation,
      'resubscribe' => DodoNextAction.resubscribe,
      'none' => DodoNextAction.none,
      _ => DodoNextAction.unknown,
    };
  }

  /// True when there is a page to open.
  bool get needsCheckout =>
      this == DodoNextAction.openPaymentLink ||
      this == DodoNextAction.updatePaymentMethod;
}

/// A hosted-checkout handle.
class DodoCheckout {
  const DodoCheckout({
    this.paymentLink,
    this.paymentId,
    this.clientSecret,
    this.expiresOn,
  });

  final String? paymentLink;
  final String? paymentId;
  final String? clientSecret;
  final String? expiresOn;

  bool get hasLink => (paymentLink?.trim().isNotEmpty) ?? false;

  static const DodoCheckout empty = DodoCheckout();

  factory DodoCheckout.fromJson(Map<String, dynamic>? json) {
    if (json == null) return empty;
    return DodoCheckout(
      paymentLink: _string(json['payment_link']),
      paymentId: _string(json['payment_id']),
      clientSecret: _string(json['client_secret']),
      expiresOn: _string(json['expires_on']),
    );
  }

  @override
  String toString() =>
      'DodoCheckout(paymentId: $paymentId, hasLink: $hasLink, '
      'expiresOn: $expiresOn)';
}

/// `POST /api/dodo/subscriptions/start`.
class DodoStartResult {
  const DodoStartResult({
    required this.planId,
    required this.dodoSubscriptionId,
    required this.status,
    required this.nextAction,
    required this.checkout,
    this.businessId,
    this.totalPrice,
    this.currency,
    this.rule,
    this.recurringPreTaxAmount,
    this.nextBillingDate,
    this.reusedExisting = false,
    this.raw = const {},
  });

  final String planId;
  final String dodoSubscriptionId;

  /// Dodo's status verbatim. For logs and support, not for branching.
  final String status;

  final DodoNextAction nextAction;
  final DodoCheckout checkout;

  final String? businessId;

  /// What Flipper charges for the tier, in major units (RWF francs).
  final int? totalPrice;
  final String? currency;
  final String? rule;

  /// What Dodo bills each cycle, in the currency's lowest denomination. Equal
  /// to [totalPrice] for RWF, which is zero-decimal — compared only for display.
  final int? recurringPreTaxAmount;

  final String? nextBillingDate;

  /// True when this landed on a subscription that already existed, so nothing
  /// new was created. A double tap gets the *same* checkout link back rather
  /// than a second subscription on the customer's card.
  final bool reusedExisting;

  final Map<String, dynamic> raw;

  factory DodoStartResult.fromJson(Map<String, dynamic> json) {
    return DodoStartResult(
      planId: _string(json['plan_id']) ?? '',
      dodoSubscriptionId: _string(json['dodo_subscription_id']) ?? '',
      status: _string(json['status']) ?? 'unknown',
      nextAction: DodoNextAction.fromWire(_string(json['next_action'])),
      checkout: DodoCheckout.fromJson(_object(json['checkout'])),
      businessId: _string(json['business_id']),
      totalPrice: _int(json['total_price']),
      currency: _string(json['currency']),
      rule: _string(json['rule']),
      recurringPreTaxAmount: _int(json['recurring_pre_tax_amount']),
      nextBillingDate: _string(json['next_billing_date']),
      reusedExisting: json['reused_existing'] == true,
      raw: json,
    );
  }

  @override
  String toString() =>
      'DodoStartResult($status, action=${nextAction.name}, '
      'sub=$dodoSubscriptionId, reused=$reusedExisting)';
}

/// One read of `GET /api/dodo/subscriptions/{plan_id}` (or `…/sync`).
class DodoSubscriptionStatus {
  const DodoSubscriptionStatus({
    required this.dodoSubscriptionId,
    required this.status,
    required this.entitled,
    required this.nextAction,
    required this.checkout,
    this.planId,
    this.businessId,
    this.currency,
    this.recurringPreTaxAmount,
    this.planTotalPrice,
    this.selectedPlan,
    this.nextBillingDate,
    this.cancelAtNextBillingDate = false,
    this.lastError,
    this.lastSyncedAt,
    this.raw = const {},
  });

  final String dodoSubscriptionId;
  final String status;

  /// **The field to gate features on.** True for `active`, and also for a
  /// cancelled or paused subscription still inside a period the customer paid
  /// for — cutting access the instant someone taps cancel takes away something
  /// they already bought.
  final bool entitled;

  final DodoNextAction nextAction;
  final DodoCheckout checkout;

  final String? planId;
  final String? businessId;
  final String? currency;
  final int? recurringPreTaxAmount;
  final int? planTotalPrice;
  final String? selectedPlan;
  final String? nextBillingDate;
  final bool cancelAtNextBillingDate;
  final String? lastError;
  final String? lastSyncedAt;

  final Map<String, dynamic> raw;

  /// Payments the connector knows about, newest first.
  List<DodoPayment> get recentPayments {
    final list = raw['recent_payments'];
    if (list is! List) return const [];
    return list
        .map(_object)
        .whereType<Map<String, dynamic>>()
        .map(DodoPayment.fromJson)
        .toList();
  }

  /// A verdict polling cannot improve on. Note that [DodoNextAction.unknown]
  /// is deliberately **not** terminal: an action we do not recognise means keep
  /// waiting, not give up.
  bool get isTerminal =>
      entitled ||
      nextAction == DodoNextAction.resubscribe ||
      nextAction == DodoNextAction.updatePaymentMethod;

  factory DodoSubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return DodoSubscriptionStatus(
      dodoSubscriptionId: _string(json['dodo_subscription_id']) ?? '',
      status: _string(json['status']) ?? 'unknown',
      entitled: json['entitled'] == true,
      nextAction: DodoNextAction.fromWire(_string(json['next_action'])),
      checkout: DodoCheckout.fromJson(_object(json['checkout'])),
      planId: _string(json['plan_id']),
      businessId: _string(json['business_id']),
      currency: _string(json['currency']),
      recurringPreTaxAmount: _int(json['recurring_pre_tax_amount']),
      planTotalPrice: _int(json['plan_total_price']),
      selectedPlan: _string(json['selected_plan']),
      nextBillingDate: _string(json['next_billing_date']),
      cancelAtNextBillingDate: json['cancel_at_next_billing_date'] == true,
      lastError: _string(json['last_error']),
      lastSyncedAt: _string(json['last_synced_at']),
      raw: json,
    );
  }

  @override
  String toString() =>
      'DodoSubscriptionStatus($status, entitled=$entitled, '
      'action=${nextAction.name})';
}

/// One row of `recent_payments`.
class DodoPayment {
  const DodoPayment({
    required this.dodoPaymentId,
    required this.status,
    this.kind,
    this.amount,
    this.currency,
    this.settledAt,
    this.failureReason,
  });

  final String dodoPaymentId;
  final String status;

  /// `first` | `renewal` | `change` | `manual`.
  final String? kind;
  final int? amount;
  final String? currency;
  final String? settledAt;
  final String? failureReason;

  bool get isSucceeded => status.trim().toLowerCase() == 'succeeded';

  factory DodoPayment.fromJson(Map<String, dynamic> json) => DodoPayment(
        dodoPaymentId: _string(json['dodo_payment_id']) ?? '',
        status: _string(json['status']) ?? 'unknown',
        kind: _string(json['kind']),
        amount: _int(json['amount']),
        currency: _string(json['currency']),
        settledAt: _string(json['settled_at']),
        failureReason: _string(json['failure_reason']),
      );

  @override
  String toString() => 'DodoPayment($dodoPaymentId, $status, $kind)';
}

/// `GET /api/dodo/health`.
///
/// The one call that decides whether the card option is offered at all. A
/// connector without `DODO_ENABLED` or `DODO_API_KEY` reports itself
/// unconfigured, and offering a rail that 503s on the first tap is worse than
/// not offering it.
class DodoHealth {
  const DodoHealth({
    required this.enabled,
    required this.ready,
    this.status,
    this.mode,
    this.dryRun = false,
    this.currency,
    this.authRequired = false,
    this.webhookSecretConfigured = false,
    this.returnUrlConfigured = false,
    this.modesAvailable = const [],
  });

  final bool enabled;

  /// Enabled **and** at least one mode holding an API key.
  ///
  /// Not the gate for showing the card option — [readyForThisBuild] is, because
  /// a connector can be ready on live while the mode *this build* transacts in
  /// has no key. Offering Card then would fail at the first tap.
  final bool ready;

  final String? status;

  /// The connector's **default** mode (`DODO_MODE`), which is what a request
  /// gets when it names none. Not necessarily the mode this build uses — see
  /// [dodoBuildMode].
  final String? mode;

  /// Modes the connector can actually transact in, e.g. `['live', 'test']`.
  final List<String> modesAvailable;

  final bool dryRun;
  final String? currency;
  final bool authRequired;
  final bool webhookSecretConfigured;
  final bool returnUrlConfigured;

  /// Nothing configured, or the connector could not be reached.
  static const DodoHealth unavailable = DodoHealth(enabled: false, ready: false);

  /// True when the mode *this build* asks for is configured on the connector.
  ///
  /// A debug build transacts on test. If the connector only has live
  /// credentials, the card option must stay hidden rather than fail on the
  /// first tap with "Dodo test mode is not configured".
  bool get readyForThisBuild {
    if (!ready) return false;
    // An older connector predates the per-mode list; fall back to its single
    // declared mode so this cannot wrongly hide a working card option.
    if (modesAvailable.isEmpty) {
      return mode == null || mode!.trim().toLowerCase() == dodoBuildMode;
    }
    return modesAvailable.contains(dodoBuildMode);
  }

  /// Whether this build is transacting against Dodo's test account — which is
  /// what a "test mode" banner should key on, not the connector's default.
  bool get isTestMode => dodoBuildMode == 'test';

  factory DodoHealth.fromJson(Map<String, dynamic> json) => DodoHealth(
        enabled: json['enabled'] == true,
        ready: json['ready'] == true,
        status: _string(json['status']),
        mode: _string(json['mode']),
        modesAvailable: (json['modes_available'] as List<dynamic>?)
                ?.map((m) => '$m'.trim().toLowerCase())
                .where((m) => m.isNotEmpty)
                .toList() ??
            const [],
        dryRun: json['dry_run'] == true,
        currency: _string(json['currency']),
        authRequired: json['auth_required'] == true,
        webhookSecretConfigured: json['webhook_secret_configured'] == true,
        returnUrlConfigured: json['return_url_configured'] == true,
      );

  @override
  String toString() =>
      'DodoHealth(ready: $ready, enabled: $enabled, default: $mode, '
      'available: $modesAvailable, thisBuild: $dodoBuildMode, '
      'dryRun: $dryRun)';
}

/// Pulls the connector's explanation out of an error body.
///
/// The Dodo routes answer `{"error": "..."}`; a proxy in front of them may
/// answer plain text. Both are more useful than the status code alone.
String? dodoGatewayMessage(String? body) {
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
    // Not JSON — keep the text, it is still the best thing we have.
  }
  final text = body.trim();
  if (text.isEmpty) return null;
  // One line, so it fits a snackbar and a log line.
  final firstLine = text.split('\n').first.trim();
  return firstLine.length > 300 ? firstLine.substring(0, 300) : firstLine;
}

Map<String, dynamic>? _object(dynamic decoded) =>
    decoded is Map ? Map<String, dynamic>.from(decoded) : null;

String? _string(dynamic value) {
  final text = value?.toString().trim();
  return (text == null || text.isEmpty || text == 'null') ? null : text;
}

int? _int(dynamic value) {
  if (value is num) return value.round();
  final text = _string(value);
  return text == null ? null : int.tryParse(text) ?? double.tryParse(text)?.round();
}
