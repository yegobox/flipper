/// Discount + tax fields for a sale cart line (Capella POS + RRA itemList).
class SaleLinePricing {
  const SaleLinePricing({
    required this.dcRt,
    required this.dcAmt,
    required this.discount,
    required this.taxblAmt,
    required this.taxAmt,
    required this.totAmt,
    required this.subtotalNet,
  });

  final double dcRt;
  final double dcAmt;
  final double discount;
  final double taxblAmt;
  final double taxAmt;
  final double totAmt;

  /// Matches [previewCart] sale completion: `price * qty - dcAmt`.
  final double subtotalNet;

  static double _money(num value) => double.parse(value.toStringAsFixed(2));

  /// Net line amount for cart totals (`price * qty - dcAmt`, or derived from dcRt).
  static double subtotalNetForItem({
    required double unitPrice,
    required double qty,
    double? dcRt,
    double? dcAmt,
  }) {
    final gross = unitPrice * qty;
    final discount =
        dcAmt ??
        (dcRt != null && dcRt > 0 ? _money((gross * dcRt) / 100) : 0.0);
    return _money(gross - discount);
  }

  static SaleLinePricing compute({
    required double unitPrice,
    required double qty,
    double? dcRt,
    String? taxTyCd,
    double taxPercentage = 18.0,
  }) {
    final rate = dcRt ?? 0.0;
    final gross = unitPrice * qty;
    final dcAmt = _money((gross * rate) / 100);
    final afterDiscount = gross - dcAmt;
    final ty = taxTyCd ?? 'B';

    double taxAmt;
    double taxblAmt;
    double totAmt;

    if (ty == 'B') {
      taxAmt = _money(afterDiscount * taxPercentage / (100 + taxPercentage));
      taxblAmt = _money(afterDiscount - taxAmt);
      totAmt = _money(afterDiscount);
    } else {
      taxblAmt = _money(afterDiscount);
      taxAmt = _money(taxblAmt * taxPercentage / 100);
      totAmt = _money(taxblAmt + taxAmt);
    }

    return SaleLinePricing(
      dcRt: rate,
      dcAmt: dcAmt,
      discount: dcAmt,
      taxblAmt: taxblAmt,
      taxAmt: taxAmt,
      totAmt: totAmt,
      subtotalNet: _money(afterDiscount),
    );
  }
}
