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
  ///
  /// Pass [ratePercent] to reuse a rate the caller already resolved (e.g. the
  /// export's displayed TaxRate), so net profit matches that same rate.
  static double netProfitColumn(TransactionItem item, {double? ratePercent}) {
    return profitMade(item) - taxPayable(item, ratePercent: ratePercent);
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
  /// shown in the report's [TotalSales] column (price × qty). At the standard
  /// 18% rate this is `totalSales × 18/118`.
  ///
  /// The rate is either [ratePercent] — the effective rate a caller has already
  /// resolved for the row (e.g. the value shown in the export's TaxRate column),
  /// which lets VAT and net profit match that displayed rate and preserves a
  /// configured 0% — or, when not supplied, the line's own [taxRatePercent].
  /// A resolved rate of 0 yields 0 tax.
  ///
  /// Derived only from the rate and gross revenue (not the stored
  /// [taxAmt]/[totAmt]/[taxblAmt] fiscal fields, whose values were the source of
  /// the wrong figures), so the reported tax always matches the displayed
  /// [TotalSales] and [TaxRate]. Keep in lock step with
  /// [PluExcelFormulaBuilder.pluTaxPayableExcelFormula].
  static double taxPayable(TransactionItem item, {double? ratePercent}) {
    final totalSales = item.price.toDouble() * item.qty.toDouble();
    if (totalSales <= 0) return 0.0;

    final pct = ratePercent ?? taxRatePercent(item);
    if (pct <= 0) return 0.0;
    return double.parse(
      (totalSales * pct / (100 + pct)).toStringAsFixed(2),
    );
  }
}
