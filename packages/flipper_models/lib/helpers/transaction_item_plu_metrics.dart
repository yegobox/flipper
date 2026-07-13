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

  /// The line's own configured VAT rate (percent). Uses the rate carried on the
  /// item — copied from its variant / tax configuration, so whatever a tax type
  /// is configured to (18, a reduced rate, …) flows through per item — and only
  /// falls back to 18% when the item records no rate at all.
  ///
  /// This is the single rate used for both the report's [TaxRate] column and
  /// [taxPayable], so the two never disagree.
  static double taxRatePercent(TransactionItem item) {
    final p = item.taxPercentage?.toDouble();
    if (p != null && p > 0) return p;
    return 18.0;
  }

  /// VAT payable on the line, extracted (tax-inclusive) from the gross revenue
  /// shown in the report's [TotalSales] column (price × qty) at the line's own
  /// [taxRatePercent] — so lines with different configured rates are handled
  /// individually (a line whose configured rate is 0 comes out as 0). At the
  /// standard 18% rate this is `totalSales × 18/118`.
  ///
  /// Derived only from the item's rate and gross revenue (not the stored
  /// [taxAmt]/[totAmt]/[taxblAmt] fiscal fields, whose values were the source of
  /// the wrong figures), so the reported tax always matches the displayed
  /// [TotalSales] and [TaxRate]. Keep in lock step with
  /// [PluExcelFormulaBuilder.pluTaxPayableExcelFormula].
  static double taxPayable(TransactionItem item) {
    final totalSales = item.price.toDouble() * item.qty.toDouble();
    if (totalSales <= 0) return 0.0;

    final pct = taxRatePercent(item);
    if (pct <= 0) return 0.0;
    return double.parse(
      (totalSales * pct / (100 + pct)).toStringAsFixed(2),
    );
  }
}
