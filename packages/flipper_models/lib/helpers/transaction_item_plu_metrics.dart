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

  /// VAT payable on the line, extracted from the tax-inclusive gross revenue
  /// shown in the report's [TotalSales] column (price × qty). At the standard
  /// 18% rate this is `totalSales × 18 / 118`.
  ///
  /// Applied uniformly to every line — VAT or non-VAT taxpayer, any tax type —
  /// and independent of the stored fiscal fields ([taxAmt], [totAmt]/[taxblAmt]),
  /// so the reported tax always matches the displayed sales. Keep this in lock
  /// step with [PluExcelFormulaBuilder.pluTaxPayableExcelFormula].
  static double taxPayable(TransactionItem item) {
    final totalSales = item.price.toDouble() * item.qty.toDouble();
    if (totalSales <= 0) return 0.0;

    final pct = taxRatePercent(item);
    return double.parse(
      (totalSales * pct / (100 + pct)).toStringAsFixed(2),
    );
  }
}
