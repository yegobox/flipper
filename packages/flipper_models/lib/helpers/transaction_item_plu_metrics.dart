import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// PLU / line-level metrics shared by transaction reports, exports, and dashboard gauge
/// so totals stay consistent.
class TransactionItemPluMetrics {
  TransactionItemPluMetrics._();

  /// Same as the on-screen "profit Made" / [TotalSales] column: selling value minus supply cost.
  static double profitMade(TransactionItem item) {
    return item.price.toDouble() * item.qty.toDouble() -
        (item.splyAmt?.toDouble() ?? 0.0);
  }

  /// Per-line net before expenses: [profitMade] minus line tax.
  static double netProfitColumn(TransactionItem item) {
    return profitMade(item) - taxPayable(item);
  }

  static double currentStockDisplay(TransactionItem item) {
    return item.remainingStock?.toDouble() ?? 0.0;
  }

  static String barcodeForReport(TransactionItem item) {
    String? nonEmpty(String? s) {
      if (s == null) return null;
      final t = s.trim();
      return t.isEmpty ? null : t;
    }

    return nonEmpty(item.bcd) ?? nonEmpty(item.sku) ?? '';
  }

  static double taxRatePercent(TransactionItem item) {
    final p = item.taxPercentage?.toDouble();
    if (p != null && p > 0) return p;
    return 18.0;
  }

  static double taxPayable(TransactionItem item) {
    final rawTax = item.taxAmt;
    if (rawTax != null && rawTax > 0) return rawTax.toDouble();

    final tot = item.totAmt?.toDouble();
    final taxbl = item.taxblAmt?.toDouble();
    if (tot != null && taxbl != null && tot > taxbl + 0.0001) {
      return double.parse((tot - taxbl).toStringAsFixed(2));
    }

    var ty = item.taxTyCd?.trim();
    if (ty == null || ty.isEmpty) ty = 'B';
    if (ty == 'D') return 0.0;

    final lineGross = item.price.toDouble() * item.qty.toDouble();
    final base = lineGross - item.discount.toDouble();
    if (base <= 0) return 0.0;

    final pct = taxRatePercent(item);
    if (ty == 'B' || ty == 'C') {
      return double.parse((base * pct / (100 + pct)).toStringAsFixed(2));
    }
    return double.parse((base * pct / 100).toStringAsFixed(2));
  }
}
