/// An order placed on the business's public online shop
/// (`https://useflipper.com/shop/<slug>`).
///
/// Read from the Ditto `online_orders` collection, which only the
/// data-connector writes. Flipper never writes these docs: every change goes
/// through `PATCH /api/online-orders/<id>` ([OnlineOrderAction]).
library;

/// The Ditto collection the connector mirrors orders into.
const String kOnlineOrdersCollection = 'online_orders';

/// Where an order is in its life. Unknown values read as [unknown] so a newer
/// server cannot crash an older till.
enum OnlineOrderStatus {
  newOrder('new'),
  accepted('accepted'),
  rejected('rejected'),
  ready('ready'),
  completed('completed'),
  cancelled('cancelled'),
  expired('expired'),
  unknown('');

  const OnlineOrderStatus(this.wire);
  final String wire;

  static OnlineOrderStatus parse(Object? value) {
    for (final s in values) {
      if (s != unknown && s.wire == value) return s;
    }
    return unknown;
  }

  /// Still needs staff attention: not finished, rejected or dead.
  bool get isOpen => this == newOrder || this == accepted || this == ready;
}

enum OnlineOrderPaymentStatus {
  unpaid('unpaid'),
  needsReview('needs_review'),
  paid('paid'),
  voided('void');

  const OnlineOrderPaymentStatus(this.wire);
  final String wire;

  static OnlineOrderPaymentStatus parse(Object? value) {
    for (final s in values) {
      if (s.wire == value) return s;
    }
    return unpaid;
  }
}

/// What staff can do to an order. [wire] is the PATCH `action` value.
enum OnlineOrderAction {
  accept('accept'),
  reject('reject'),
  ready('ready'),
  complete('complete'),
  confirmPayment('confirm_payment'),
  dismissSuggestion('dismiss_suggestion'),
  linkTicket('link_ticket'),
  markPaid('mark_paid');

  const OnlineOrderAction(this.wire);
  final String wire;
}

class OnlineOrderItem {
  const OnlineOrderItem({
    required this.variantId,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  final String variantId;
  final String name;
  final double qty;
  final double unitPrice;
  final double lineTotal;

  factory OnlineOrderItem.fromJson(Map<String, dynamic> json) {
    final qty = _num(json['qty']) ?? 0;
    final unit = _num(json['unitPrice']) ?? 0;
    return OnlineOrderItem(
      variantId: _str(json['variantId']) ?? '',
      name: _str(json['name']) ?? '',
      qty: qty,
      unitPrice: unit,
      lineTotal: _num(json['lineTotal']) ?? qty * unit,
    );
  }
}

/// An SMS the server thinks may be this order's payment, waiting for staff
/// to confirm it ("Possible payment … Confirm / Not this one").
class OnlineOrderSuggestedPayment {
  const OnlineOrderSuggestedPayment({
    required this.smsId,
    required this.amount,
    this.counterpartyName,
    this.counterpartyTail,
    this.observedAt,
  });

  final String smsId;
  final double amount;
  final String? counterpartyName;

  /// Last digits of the payer's phone, as the SMS shows them.
  final String? counterpartyTail;
  final DateTime? observedAt;

  static OnlineOrderSuggestedPayment? tryParse(Object? value) {
    if (value is! Map) return null;
    final json = Map<String, dynamic>.from(value);
    final smsId = _str(json['smsId']);
    if (smsId == null || smsId.isEmpty) return null;
    return OnlineOrderSuggestedPayment(
      smsId: smsId,
      amount: _num(json['amount']) ?? 0,
      counterpartyName: _str(json['counterpartyName']),
      counterpartyTail: _str(json['counterpartyTail']),
      observedAt: _date(json['observedAt']),
    );
  }
}

class OnlineOrder {
  const OnlineOrder({
    required this.id,
    required this.branchId,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.fulfilment,
    required this.items,
    required this.total,
    required this.amountDue,
    required this.status,
    required this.paymentStatus,
    this.businessId,
    this.shopId,
    this.deliveryAddress,
    this.note,
    this.currency = 'RWF',
    this.paymentMethod = 'momo',
    this.payerPhone,
    this.paidAt,
    this.paymentSmsId,
    this.suggestedPayment,
    this.payBy,
    this.ticketTransactionId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String branchId;
  final String? businessId;
  final String? shopId;
  final int orderNumber;
  final String customerName;
  final String customerPhone;

  /// `pickup` or `delivery`.
  final String fulfilment;
  final String? deliveryAddress;
  final String? note;
  final List<OnlineOrderItem> items;
  final double total;

  /// What the customer must send: the total minus a few RWF, unique among the
  /// branch's open orders, so the server can match the MoMo SMS to the order.
  final double amountDue;
  final String currency;

  /// `momo` or `on_delivery`.
  final String paymentMethod;
  final String? payerPhone;
  final OnlineOrderStatus status;
  final OnlineOrderPaymentStatus paymentStatus;
  final DateTime? paidAt;
  final String? paymentSmsId;
  final OnlineOrderSuggestedPayment? suggestedPayment;
  final DateTime? payBy;

  /// The parked POS ticket made when the order was accepted.
  final String? ticketTransactionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isDelivery => fulfilment == 'delivery';
  bool get isPaid => paymentStatus == OnlineOrderPaymentStatus.paid;
  bool get paysOnDelivery => paymentMethod == 'on_delivery';
  bool get hasTicket =>
      ticketTransactionId != null && ticketTransactionId!.isNotEmpty;

  /// Parses a Ditto doc or a connector response. Returns an order with an
  /// empty [id] for junk input; callers drop those.
  factory OnlineOrder.fromDitto(Map<String, dynamic> doc) {
    final rawItems = doc['items'];
    return OnlineOrder(
      id: _str(doc['id']) ?? _str(doc['_id']) ?? '',
      branchId: _str(doc['branchId']) ?? '',
      businessId: _str(doc['businessId']),
      shopId: _str(doc['shopId']),
      orderNumber: (_num(doc['orderNumber']) ?? 0).toInt(),
      customerName: _str(doc['customerName']) ?? '',
      customerPhone: _str(doc['customerPhone']) ?? '',
      fulfilment: _str(doc['fulfilment']) ?? 'pickup',
      deliveryAddress: _str(doc['deliveryAddress']),
      note: _str(doc['note']),
      items: rawItems is List
          ? [
              for (final i in rawItems)
                if (i is Map)
                  OnlineOrderItem.fromJson(Map<String, dynamic>.from(i)),
            ]
          : const [],
      total: _num(doc['total']) ?? 0,
      amountDue: _num(doc['amountDue']) ?? _num(doc['total']) ?? 0,
      currency: _str(doc['currency']) ?? 'RWF',
      paymentMethod: _str(doc['paymentMethod']) ?? 'momo',
      payerPhone: _str(doc['payerPhone']),
      status: OnlineOrderStatus.parse(doc['status']),
      paymentStatus: OnlineOrderPaymentStatus.parse(doc['paymentStatus']),
      paidAt: _date(doc['paidAt']),
      paymentSmsId: _str(doc['paymentSmsId']),
      suggestedPayment: OnlineOrderSuggestedPayment.tryParse(
        doc['suggestedPayment'],
      ),
      payBy: _date(doc['payBy']),
      ticketTransactionId: _str(doc['ticketTransactionId']),
      createdAt: _date(doc['createdAt']),
      updatedAt: _date(doc['updatedAt']),
    );
  }

  /// The actions staff can take now, in the order the card shows them.
  /// The server enforces the same rules (409 otherwise); this only decides
  /// which buttons to draw.
  List<OnlineOrderAction> get availableActions {
    final actions = <OnlineOrderAction>[];
    switch (status) {
      case OnlineOrderStatus.newOrder:
        actions.addAll([OnlineOrderAction.accept, OnlineOrderAction.reject]);
      case OnlineOrderStatus.accepted:
        actions.addAll([OnlineOrderAction.ready, OnlineOrderAction.reject]);
      case OnlineOrderStatus.ready:
        actions.add(OnlineOrderAction.complete);
      default:
        break;
    }
    if (status.isOpen) {
      if (suggestedPayment != null && !isPaid) {
        actions.addAll([
          OnlineOrderAction.confirmPayment,
          OnlineOrderAction.dismissSuggestion,
        ]);
      }
      if (!isPaid && paymentStatus != OnlineOrderPaymentStatus.voided) {
        actions.add(OnlineOrderAction.markPaid);
      }
    }
    return actions;
  }

  /// An accepted order whose ticket was never made (the park failed after the
  /// accept went through). The card offers to make it again.
  bool get needsTicket =>
      !hasTicket &&
      (status == OnlineOrderStatus.accepted ||
          status == OnlineOrderStatus.ready);

  /// `Online #12 – Aline`: the parked ticket's name.
  String get ticketName => 'Online #$orderNumber – $customerName'.trim();
}

String? _str(Object? v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

double? _num(Object? v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _date(Object? v) {
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  return null;
}
