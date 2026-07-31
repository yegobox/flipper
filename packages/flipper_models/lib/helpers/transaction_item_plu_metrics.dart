import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// PLU / line-level metrics shared by transaction reports, exports, and dashboard gauge
/// so totals stay consistent.
class TransactionItemPluMetrics {
  TransactionItemPluMetrics._();

  /// Net line revenue after discount (`price * qty - dcAmt`, or from `dcRt`).
  static double lineNetSales(TransactionItem item) {
    return SaleLinePricing.subtotalNetForItem(
      unitPrice: item.price.toDouble(),
      qty: item.qty.toDouble(),
      dcAmt: item.dcAmt?.toDouble(),
      dcRt: item.dcRt?.toDouble(),
    );
  }

  /// Same as the on-screen "profit Made" / [TotalSales] column: net selling value
  /// minus supply cost.
  static double profitMade(TransactionItem item) {
    return lineNetSales(item) - (item.splyAmt?.toDouble() ?? 0.0);
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

  /// VAT payable on the line, extracted (tax-inclusive) from net line revenue
  /// ([lineNetSales]). At the standard 18% rate this is `netSales × 18/118`.
  ///
  /// The rate is either [ratePercent] — the effective rate a caller has already
  /// resolved for the row (e.g. the value shown in the export's TaxRate column),
  /// which lets VAT and net profit match that displayed rate and preserves a
  /// configured 0% — or, when not supplied, the line's own [taxRatePercent].
  /// A resolved rate of 0 yields 0 tax.
  static double taxPayable(TransactionItem item, {double? ratePercent}) {
    final totalSales = lineNetSales(item);
    if (totalSales <= 0) return 0.0;

    final pct = ratePercent ?? taxRatePercent(item);
    if (pct <= 0) return 0.0;
    return double.parse(
      (totalSales * pct / (100 + pct)).toStringAsFixed(2),
    );
  }
}
