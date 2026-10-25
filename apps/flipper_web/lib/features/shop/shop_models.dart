/// What the public shop routes of the data-connector return
/// (`GET /api/shop/<slug>`, the order routes). No auth, no business ids:
/// only what a customer may see.
library;

class ShopPayment {
  const ShopPayment({
    this.momo = false,
    this.momoPayCode,
    this.momoNumber,
    this.airtelNumber,
  });

  final bool momo;
  final String? momoPayCode;
  final String? momoNumber;
  final String? airtelNumber;

  factory ShopPayment.fromJson(Map<String, dynamic> json) => ShopPayment(
    momo: json['momo'] == true,
    momoPayCode: _str(json['momoPayCode']),
    momoNumber: _str(json['momoNumber']),
    airtelNumber: _str(json['airtelNumber']),
  );
}

class ShopInfo {
  const ShopInfo({
    required this.slug,
    required this.name,
    this.description,
    this.logoUrl,
    this.contactPhone,
    this.whatsapp,
    this.pickup = true,
    this.delivery = false,
    this.deliveryNote,
    this.currency = 'RWF',
    this.payment = const ShopPayment(),
  });

  final String slug;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? contactPhone;
  final String? whatsapp;
  final bool pickup;
  final bool delivery;
  final String? deliveryNote;
  final String currency;
  final ShopPayment payment;

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'];
    return ShopInfo(
      slug: _str(json['slug']) ?? '',
      name: _str(json['name']) ?? '',
      description: _str(json['description']),
      logoUrl: _str(json['logoUrl']),
      contactPhone: _str(json['contactPhone']),
      whatsapp: _str(json['whatsapp']),
      pickup: json['pickup'] != false,
      delivery: json['delivery'] == true,
      deliveryNote: _str(json['deliveryNote']),
      currency: _str(json['currency']) ?? 'RWF',
      payment: payment is Map
          ? ShopPayment.fromJson(Map<String, dynamic>.from(payment))
          : const ShopPayment(),
    );
  }
}

class ShopCategory {
  const ShopCategory({required this.id, required this.name});

  final String id;
  final String name;
}

class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.inStock = true,
    this.stock,
    this.soldByMeasure = false,
  });

  /// The variant id; what an order line sends back.
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;
  final bool inStock;

  /// Units left, only when the shop shows stock levels.
  final double? stock;

  /// Sold by weight or volume (kg, litres), so a fraction may be ordered.
  /// Anything else is whole units only; the server refuses 1.5 of it.
  final bool soldByMeasure;

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
    id: _str(json['id']) ?? '',
    name: _str(json['name']) ?? '',
    price: _num(json['price']) ?? 0,
    imageUrl: _str(json['imageUrl']),
    categoryId: _str(json['categoryId']),
    categoryName: _str(json['categoryName']),
    inStock: json['inStock'] != false,
    stock: _num(json['stock']),
    soldByMeasure: json['soldByMeasure'] == true,
  );

  /// Most a customer can put in the cart: the stock when shown (whole units
  /// of a counted item), else no cap.
  double? get maxQty =>
      stock == null || soldByMeasure ? stock : stock!.floorToDouble();

  /// Whether [qty] of this item can be ordered: above 0, whole unless sold by
  /// measure (three decimals at most), and worth at least 1 RWF, as the
  /// server checks.
  bool allowsQty(double qty) {
    if (!qty.isFinite || qty <= 0) return false;
    if (!soldByMeasure && qty != qty.roundToDouble()) return false;
    final rounded = (qty * 1000).round() / 1000;
    return (rounded * price).round() >= 1;
  }
}

class ShopCatalog {
  const ShopCatalog({
    required this.shop,
    this.categories = const [],
    this.items = const [],
  });

  final ShopInfo shop;
  final List<ShopCategory> categories;
  final List<ShopItem> items;

  factory ShopCatalog.fromJson(Map<String, dynamic> json) {
    final shop = json['shop'];
    final categories = json['categories'];
    final items = json['items'];
    return ShopCatalog(
      shop: ShopInfo.fromJson(
        shop is Map ? Map<String, dynamic>.from(shop) : const {},
      ),
      categories: categories is List
          ? [
              for (final c in categories)
                if (c is Map && _str(c['id']) != null)
                  ShopCategory(id: _str(c['id'])!, name: _str(c['name']) ?? ''),
            ]
          : const [],
      items: items is List
          ? [
              for (final i in items)
                if (i is Map) ShopItem.fromJson(Map<String, dynamic>.from(i)),
            ].where((i) => i.id.isNotEmpty).toList()
          : const [],
    );
  }

  ShopItem? item(String id) {
    for (final i in items) {
      if (i.id == id) return i;
    }
    return null;
  }
}

class ShopOrderLine {
  const ShopOrderLine({
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
}

/// How to pay: the shop's MoMo details and, when there is a pay code, the
/// exact USSD string to dial (e.g. `*182*8*1*12345*4997#`).
class ShopOrderPay {
  const ShopOrderPay({
    this.momoPayCode,
    this.momoNumber,
    this.airtelNumber,
    this.ussd,
  });

  final String? momoPayCode;
  final String? momoNumber;
  final String? airtelNumber;
  final String? ussd;

  /// `tel:` link that opens the dialer with [ussd]; `#` must be `%23`.
  Uri? get ussdUri => ussd == null ? null : shopTelUri(ussd!);
}

/// `tel:` URI for a phone number or USSD code. `#` would start a URI
/// fragment, so it is percent-encoded; `*` is left as is.
Uri shopTelUri(String number) =>
    Uri.parse('tel:${number.replaceAll('#', '%23')}');

/// An order as the customer sees it.
class ShopOrderView {
  const ShopOrderView({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.total,
    required this.amountDue,
    this.currency = 'RWF',
    this.payBy,
    this.fulfilment = 'pickup',
    this.createdAt,
    this.claimPending = false,
    this.items = const [],
    this.pay = const ShopOrderPay(),
    this.token,
  });

  final String id;
  final int orderNumber;

  /// new / accepted / rejected / ready / completed / cancelled / expired.
  final String status;

  /// unpaid / needs_review / paid / void.
  final String paymentStatus;

  /// momo / on_delivery.
  final String paymentMethod;
  final double total;

  /// The exact amount to send; it is how the shop matches the payment.
  final double amountDue;
  final String currency;
  final DateTime? payBy;
  final String fulfilment;
  final DateTime? createdAt;

  /// The customer sent a transaction id that staff have not checked yet.
  final bool claimPending;
  final List<ShopOrderLine> items;
  final ShopOrderPay pay;

  /// Only on the create response: proves the customer owns the order.
  final String? token;

  bool get isPaid => paymentStatus == 'paid';
  bool get paysByMomo => paymentMethod == 'momo';

  /// No more changes to wait for: stop polling.
  bool get isFinal =>
      const {'rejected', 'completed', 'cancelled', 'expired'}.contains(status);

  /// Offer "Paste your transaction ID": the server could not match the
  /// payment by itself, or the pay-by time passed without one.
  bool canClaim(DateTime now) =>
      paysByMomo &&
      !isPaid &&
      !isFinal &&
      (paymentStatus == 'needs_review' ||
          (payBy != null && now.isAfter(payBy!)));

  factory ShopOrderView.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    final pay = json['pay'];
    final payMap = pay is Map ? Map<String, dynamic>.from(pay) : const {};
    return ShopOrderView(
      id: _str(json['id']) ?? '',
      orderNumber: (_num(json['orderNumber']) ?? 0).toInt(),
      status: _str(json['status']) ?? 'new',
      paymentStatus: _str(json['paymentStatus']) ?? 'unpaid',
      paymentMethod: _str(json['paymentMethod']) ?? 'momo',
      total: _num(json['total']) ?? 0,
      amountDue: _num(json['amountDue']) ?? _num(json['total']) ?? 0,
      currency: _str(json['currency']) ?? 'RWF',
      payBy: _date(json['payBy']),
      fulfilment: _str(json['fulfilment']) ?? 'pickup',
      createdAt: _date(json['createdAt']),
      claimPending: json['claimPending'] == true,
      items: items is List
          ? [
              for (final i in items)
                if (i is Map)
                  ShopOrderLine(
                    variantId: _str(i['variantId']) ?? '',
                    name: _str(i['name']) ?? '',
                    qty: _num(i['qty']) ?? 0,
                    unitPrice: _num(i['unitPrice']) ?? 0,
                    lineTotal:
                        _num(i['lineTotal']) ??
                        (_num(i['qty']) ?? 0) * (_num(i['unitPrice']) ?? 0),
                  ),
            ]
          : const [],
      pay: ShopOrderPay(
        momoPayCode: _str(payMap['momoPayCode']),
        momoNumber: _str(payMap['momoNumber']),
        airtelNumber: _str(payMap['airtelNumber']),
        ussd: _str(payMap['ussd']),
      ),
      token: _str(json['token']),
    );
  }
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

DateTime? _date(Object? v) =>
    v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;
