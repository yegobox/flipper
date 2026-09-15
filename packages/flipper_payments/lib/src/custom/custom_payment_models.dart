import 'dart:convert';

import 'package:flipper_payments/src/dodo/dodo_models.dart' show DodoCheckout;

/// Wire shapes for the connector's staff-only negotiated-price payments
/// (`data-connector/CUSTOM_PAYMENTS.md`).
///
/// A custom payment is neither a MoMo nor a Dodo object: it is the connector's
/// own record of "staff charged this business this amount on this rail", and
/// the id of that record is what staff hand to support. The rails' own ids
/// (charge, subscription, payment) ride along for cross-reference.

/// The rail a custom payment collects on. Deliberately **not** [PaymentRail]:
/// that enum's wire values are `plans.payment_method` (`MTNMOMO` / `DODO`),
/// whereas the custom-payment API speaks `momo` / `card`. Conflating them is
/// how a rail string ends up written to the wrong column.
enum CustomPaymentRail {
  momo('momo'),
  card('card');

  const CustomPaymentRail(this.wireValue);

  final String wireValue;

  static CustomPaymentRail fromWire(String? value) =>
      value?.trim().toLowerCase() == 'card'
      ? CustomPaymentRail.card
      : CustomPaymentRail.momo;

  bool get isCard => this == CustomPaymentRail.card;
  bool get isMomo => this == CustomPaymentRail.momo;

  String get label => switch (this) {
    CustomPaymentRail.momo => 'Mobile Money',
    CustomPaymentRail.card => 'Card',
  };
}

/// Only the two cadences a negotiated deal can be struck at. Daily plans are a
/// POS trial mechanism, not something sales negotiate.
enum CustomPaymentCadence {
  monthly('monthly'),
  yearly('yearly');

  const CustomPaymentCadence(this.wireValue);

  final String wireValue;

  static CustomPaymentCadence fromWire(String? value) =>
      switch (value?.trim().toLowerCase()) {
        'yearly' || 'annual' || 'annually' => CustomPaymentCadence.yearly,
        _ => CustomPaymentCadence.monthly,
      };

  String get label => switch (this) {
    CustomPaymentCadence.monthly => 'Monthly',
    CustomPaymentCadence.yearly => 'Yearly',
  };
}

/// `custom_payments.status`, with an explicit *unknown* arm so a status the
/// connector adds later reads as "still waiting", never as paid.
enum CustomPaymentStatus {
  pending('pending'),
  awaitingApproval('awaiting_approval'),
  awaitingCheckout('awaiting_checkout'),
  settled('settled'),
  failed('failed'),
  expired('expired'),
  unknown('unknown');

  const CustomPaymentStatus(this.wireValue);

  final String wireValue;

  static CustomPaymentStatus fromWire(String? value) {
    final needle = value?.trim().toLowerCase();
    for (final status in CustomPaymentStatus.values) {
      if (status.wireValue == needle) return status;
    }
    return CustomPaymentStatus.unknown;
  }

  bool get isSettled => this == CustomPaymentStatus.settled;

  /// Nothing more will happen to this payment; stop polling.
  bool get isTerminal =>
      this == CustomPaymentStatus.settled ||
      this == CustomPaymentStatus.failed ||
      this == CustomPaymentStatus.expired;
}

/// What the client should do next. Switched on instead of [CustomPaymentStatus]
/// so the connector can add a status without a client release.
enum CustomPaymentNextAction {
  approveOnPhone('approve_on_phone'),
  openPaymentLink('open_payment_link'),
  awaitingSettlement('awaiting_settlement'),
  none('none'),
  retry('retry'),
  unknown('unknown');

  const CustomPaymentNextAction(this.wireValue);

  final String wireValue;

  static CustomPaymentNextAction fromWire(String? value) {
    final needle = value?.trim().toLowerCase();
    for (final action in CustomPaymentNextAction.values) {
      if (action.wireValue == needle) return action;
    }
    return CustomPaymentNextAction.unknown;
  }
}

/// What the business was on before the custom payment replaced it.
class CustomPaymentPrevious {
  const CustomPaymentPrevious({
    this.rail,
    this.totalPrice,
    this.nextBillingDate,
    this.cancelledDodoSubscriptionId,
    this.revokedPreapprovalId,
  });

  final String? rail;
  final int? totalPrice;
  final String? nextBillingDate;

  /// The Dodo subscription the connector cancelled so it stops auto-renewing.
  final String? cancelledDodoSubscriptionId;

  /// The MTN mandate the connector revoked (MoMo → card only).
  final String? revokedPreapprovalId;

  factory CustomPaymentPrevious.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CustomPaymentPrevious();
    return CustomPaymentPrevious(
      rail: _string(json['rail']),
      totalPrice: _int(json['total_price']),
      nextBillingDate: _string(json['next_billing_date']),
      cancelledDodoSubscriptionId: _string(
        json['cancelled_dodo_subscription_id'],
      ),
      revokedPreapprovalId: _string(json['revoked_preapproval_id']),
    );
  }
}

/// One custom payment as the connector reports it.
class CustomPaymentView {
  const CustomPaymentView({
    required this.id,
    required this.businessId,
    required this.rail,
    required this.amount,
    required this.currency,
    required this.cadence,
    required this.status,
    required this.nextAction,
    this.planId,
    this.nextBillingDate,
    this.anchoredNextBillingDate,
    this.previous = const CustomPaymentPrevious(),
    this.phoneNumber,
    this.chargeId,
    this.preapprovalId,
    this.financialTransactionId,
    this.dodoSubscriptionId,
    this.dodoPaymentId,
    this.checkout,
    this.mode,
    this.message,
    this.staffLabel,
    this.note,
    this.settledAt,
    this.createdAt,
    this.raw = const {},
  });

  /// `custom_payments.id` — the reference staff quote to support.
  final String id;
  final String businessId;
  final String? planId;
  final CustomPaymentRail rail;

  /// Negotiated price per period, major units (RWF francs).
  final int amount;
  final String currency;
  final CustomPaymentCadence cadence;
  final CustomPaymentStatus status;
  final CustomPaymentNextAction nextAction;

  /// The plan's billing date *now* — advances once the payment settles.
  final String? nextBillingDate;

  /// The date the connector charged from: today for an expired plan, the
  /// paid-through date for a paid-up one.
  final String? anchoredNextBillingDate;
  final CustomPaymentPrevious previous;

  /// Masked MSISDN (MoMo).
  final String? phoneNumber;

  // MoMo cross-references.
  final String? chargeId;
  final String? preapprovalId;
  final String? financialTransactionId;

  // Card cross-references.
  final String? dodoSubscriptionId;
  final String? dodoPaymentId;
  final DodoCheckout? checkout;

  /// `test` | `live` (card).
  final String? mode;

  /// The connector's last word on it — a failure reason, usually.
  final String? message;
  final String? staffLabel;
  final String? note;
  final String? settledAt;
  final String? createdAt;
  final Map<String, dynamic> raw;

  bool get isSettled => status.isSettled;
  bool get isTerminal => status.isTerminal;

  /// The link to hand the customer, when there is a live one.
  String? get paymentLink {
    final link = checkout?.paymentLink?.trim();
    return (link == null || link.isEmpty) ? null : link;
  }

  factory CustomPaymentView.fromJson(Map<String, dynamic> json) {
    final checkout = json['checkout'];
    return CustomPaymentView(
      id: _string(json['id']) ?? '',
      businessId: _string(json['business_id']) ?? '',
      planId: _string(json['plan_id']),
      rail: CustomPaymentRail.fromWire(_string(json['rail'])),
      amount: _int(json['amount']) ?? 0,
      currency: _string(json['currency']) ?? 'RWF',
      cadence: CustomPaymentCadence.fromWire(_string(json['rule'])),
      status: CustomPaymentStatus.fromWire(_string(json['status'])),
      nextAction: CustomPaymentNextAction.fromWire(
        _string(json['next_action']),
      ),
      nextBillingDate: _string(json['next_billing_date']),
      anchoredNextBillingDate: _string(json['anchored_next_billing_date']),
      previous: CustomPaymentPrevious.fromJson(
        json['previous'] is Map
            ? Map<String, dynamic>.from(json['previous'] as Map)
            : null,
      ),
      phoneNumber: _string(json['phone_number']),
      chargeId: _string(json['charge_id']),
      preapprovalId: _string(json['preapproval_id']),
      financialTransactionId: _string(json['financial_transaction_id']),
      dodoSubscriptionId: _string(json['dodo_subscription_id']),
      dodoPaymentId: _string(json['dodo_payment_id']),
      checkout: checkout is Map
          ? DodoCheckout.fromJson(Map<String, dynamic>.from(checkout))
          : null,
      mode: _string(json['mode']),
      message: _string(json['message']),
      staffLabel: _string(json['staff_label']),
      note: _string(json['note']),
      settledAt: _string(json['settled_at']),
      createdAt: _string(json['created_at']),
      raw: json,
    );
  }

  @override
  String toString() =>
      'CustomPaymentView($id, ${rail.wireValue} $currency $amount '
      '${cadence.wireValue}, ${status.wireValue} → ${nextAction.wireValue})';
}

/// The connector refused, and said why.
class CustomPaymentException implements Exception {
  const CustomPaymentException(
    this.message, {
    this.statusCode,
    this.gatewayMessage,
    this.inFlight,
  });

  final String message;
  final int? statusCode;

  /// The connector's own words — "no Dodo product is configured…" is
  /// actionable, "Bad request" is not.
  final String? gatewayMessage;

  /// On a 409: the custom payment already collecting from this business, when
  /// it was one of ours. The page can show its reference instead of a dead end.
  final CustomPaymentView? inFlight;

  bool get isUnauthorised => statusCode == 401 || statusCode == 403;
  bool get isConflict => statusCode == 409;

  String get displayMessage {
    final gateway = gatewayMessage?.trim();
    if (gateway != null && gateway.isNotEmpty) return gateway;
    return message;
  }

  @override
  String toString() => displayMessage;
}

/// Pulls the connector's explanation out of an error body.
String? customPaymentGatewayMessage(String? body) {
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
    // Not JSON — the text is still the best thing we have.
  }
  final text = body.trim();
  if (text.isEmpty) return null;
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
  return text == null
      ? null
      : int.tryParse(text) ?? double.tryParse(text)?.round();
}
