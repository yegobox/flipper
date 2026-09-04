import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';

/// Mirrors dashboard export helpers — excludes cash-book utility PLU rows.
bool transactionReportCashMovementPluLine(TransactionItem item) {
  final code = item.itemCd;
  if (code != null && code.isNotEmpty) {
    final compact = code.toUpperCase().replaceAll(' ', '');
    if (compact.startsWith('CASH-OUT') || compact.startsWith('CASH-IN')) {
      return true;
    }
  }
  final trimmed = item.name.trim();
  if (trimmed == TransactionType.cashOut || trimmed == TransactionType.cashIn) {
    return true;
  }
  return false;
}

/// True when [item] belongs to one of [saleIds]. Ditto rows are uuid-string
/// tolerant (hyphenated / compact / mixed case), so compare both forms.
bool transactionReportLineMatchesSale(
  TransactionItem item,
  Set<String> saleIds,
) {
  final tid = item.transactionId?.toString().trim();
  if (tid == null || tid.isEmpty) return false;
  if (saleIds.contains(tid)) return true;
  final compact = tid.replaceAll('-', '').toLowerCase();
  if (compact.isEmpty) return false;
  for (final id in saleIds) {
    if (id.replaceAll('-', '').toLowerCase() == compact) return true;
  }
  return false;
}

/// Period PLU rollup for Transaction Reports.
class TransactionReportPluTotals {
  const TransactionReportPluTotals({
    this.lineSales = 0,
    this.grossProfit = 0,
    this.lineTax = 0,
  });

  final double lineSales;
  final double grossProfit;
  final double lineTax;
}

/// Sums PLU metrics over only the lines that belong to [saleIds] — the sales
/// the report itself is showing.
///
/// The join is the whole point: `transaction_items` is queried branch-wide by
/// date with no parent-status filter, so it also carries lines from pending
/// carts, purchases and expense transactions. Those lines have a supply cost
/// and no sale price, which makes [TransactionItemPluMetrics.profitMade]
/// negative — that is how the KPI strip used to report a negative Net Profit
/// over a period whose grid was empty. Passing an empty [saleIds] therefore
/// yields zeros, never a stray total.
TransactionReportPluTotals sumReportScopedPluLines({
  required Iterable<TransactionItem> lines,
  required Set<String> saleIds,
}) {
  if (saleIds.isEmpty) return const TransactionReportPluTotals();

  var lineSales = 0.0;
  var grossProfit = 0.0;
  var lineTax = 0.0;

  for (final item in lines) {
    // A single malformed line (e.g. null price/qty arriving from Ditto into a
    // non-nullable field) must not crash the whole KPI computation.
    try {
      if (transactionReportCashMovementPluLine(item)) continue;
      if (!transactionReportLineMatchesSale(item, saleIds)) continue;
      lineSales += TransactionItemPluMetrics.lineNetSales(item);
      grossProfit += TransactionItemPluMetrics.profitMade(item);
      lineTax += TransactionItemPluMetrics.taxPayable(item);
    } catch (e) {
      talker.warning('Skipping malformed PLU line in KPI totals: $e');
    }
  }

  return TransactionReportPluTotals(
    lineSales: lineSales,
    grossProfit: grossProfit,
    lineTax: lineTax,
  );
}
