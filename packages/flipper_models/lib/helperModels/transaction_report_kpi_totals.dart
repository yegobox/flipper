/// Period-wide KPI numbers for Transaction Reports (not limited to one grid page).
class TransactionReportKpiTotals {
  const TransactionReportKpiTotals({
    this.pluLineSales = 0,
    this.pluGrossProfit = 0,
    this.pluLineTax = 0,
    this.periodByHand = 0,
    this.periodCredit = 0,
    this.periodOwed = 0,
    this.periodSubtotal = 0,
  });

  /// Sum of PLU line revenue (price × qty) for non-expense sales in scope.
  final double pluLineSales;

  /// Sum of [TransactionItemPluMetrics.profitMade] for those lines.
  final double pluGrossProfit;

  /// Sum of [TransactionItemPluMetrics.taxPayable] for those lines.
  final double pluLineTax;

  /// Non-expense period totals from payment sums / cash received (cards "By Hand" aggregation).
  final double periodByHand;

  /// Non-expense period totals from CREDIT splits.
  final double periodCredit;

  /// Sum of unpaid balances (`remainingBalance`, clamped to subTotal) for
  /// non-expense sales in scope — i.e. money owed / "Balance Due".
  final double periodOwed;

  /// Sum of `subTotal` for non-expense sales in scope. Used as the headline
  /// "Total Sales" so the money cards partition cleanly:
  /// `periodSubtotal == collected + periodOwed`, where collected =
  /// `periodSubtotal - periodOwed`.
  final double periodSubtotal;
}
