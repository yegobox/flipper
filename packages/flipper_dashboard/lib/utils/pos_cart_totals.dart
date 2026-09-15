import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';

/// Display-only breakdown for the checkout summary block.
///
/// Reuses [SaleLinePricing] so the numbers match sale completion; the
/// [grandTotal] is computed exactly like `TransactionItemTable.grandTotal`
/// (same per-line net, same per-line rounding on [currencyDecimal]) so the
/// dominant figure never disagrees with what Pay charges.
class PosCartTotals {
  const PosCartTotals({
    required this.subtotalGross,
    required this.discount,
    required this.vatIncluded,
    required this.grandTotal,
  });

  /// Σ unit price × qty before any line discount.
  final double subtotalGross;

  /// Σ line discounts (dcAmt, or derived from dcRt). Zero when none.
  final double discount;

  /// VAT already contained in [grandTotal] (prices are tax-inclusive), or 0
  /// when the branch is not VAT-enabled. Informational only.
  final double vatIncluded;

  /// What the customer pays.
  final double grandTotal;

  bool get hasDiscount => discount > 0.009;

  static const empty = PosCartTotals(
    subtotalGross: 0,
    discount: 0,
    vatIncluded: 0,
    grandTotal: 0,
  );

  static double _money(num v) => double.parse(v.toStringAsFixed(2));

  /// [displayQty] supplies the (possibly optimistic) quantity per line;
  /// [unitPriceOf] the effective unit price (composite price wins).
  static PosCartTotals compute(
    Iterable<TransactionItem> lines, {
    required double Function(TransactionItem item) displayQty,
    required bool currencyDecimal,
    required bool vatEnabled,
    num Function(TransactionItem item)? unitPriceOf,
  }) {
    var gross = 0.0;
    var discount = 0.0;
    var vat = 0.0;
    num total = 0;

    for (final item in lines) {
      final price = unitPriceOf != null
          ? unitPriceOf(item).toDouble()
          : (((item.compositePrice ?? 0) != 0)
                ? item.compositePrice!.toDouble()
                : item.price.toDouble());
      final qty = displayQty(item);
      final lineGross = price * qty;
      final lineNet = SaleLinePricing.subtotalNetForItem(
        unitPrice: price,
        qty: qty,
        dcRt: item.dcRt?.toDouble() ?? 0.0,
        dcAmt: item.dcAmt?.toDouble(),
      );

      gross += lineGross;
      discount += lineGross - lineNet;

      // Mirrors TransactionItemTable.grandTotal rounding.
      if (currencyDecimal) {
        total += lineNet.roundToTwoDecimalPlaces();
      } else {
        total += lineNet.roundToDouble();
      }

      if (vatEnabled) {
        final pricing = SaleLinePricing.compute(
          unitPrice: price,
          qty: qty,
          dcRt: item.dcRt?.toDouble(),
          taxTyCd: item.taxTyCd,
          taxPercentage: item.taxPercentage?.toDouble() ?? 18.0,
        );
        vat += pricing.taxAmt;
      }
    }

    return PosCartTotals(
      subtotalGross: _money(gross),
      discount: _money(discount < 0 ? 0 : discount),
      vatIncluded: _money(vat),
      grandTotal: total.toDouble(),
    );
  }
}
