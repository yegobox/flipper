import 'package:flipper_models/models/personal_goal.dart';

/// Same value as [COMPLETE] in `flipper_services/constants.dart` (Ditto/Capella status).
const String kCompletedTransactionStatus = 'completed';

/// Same value as [TransactionType.sale] in `flipper_services/constants.dart`.
const String kSaleTransactionType = 'Sale';

/// Minimal line snapshot for gross-profit math (keeps tests free of Brick models).
class SaleLineForProfit {
  const SaleLineForProfit({
    required this.price,
    required this.qty,
    this.supplyPriceAtSale,
    this.supplyPrice,
    this.ignoreForReport = false,
    this.partOfComposite = false,
  });

  final double price;
  final double qty;
  final double? supplyPriceAtSale;
  final double? supplyPrice;
  final bool ignoreForReport;
  final bool partOfComposite;
}

/// Whether we should attempt a profit-based personal-goal sweep for this payment.
bool shouldAttemptPersonalGoalSaleSweep({
  required String? completionStatus,
  required bool isIncome,
  required bool isProformaMode,
  required bool isTrainingMode,
  required String? transactionType,
  required bool hasProductLineItems,
}) {
  if (!isIncome) return false;
  if (isProformaMode || isTrainingMode) return false;
  final cs = completionStatus?.toLowerCase();
  if (cs == null || cs != kCompletedTransactionStatus.toLowerCase()) {
    return false;
  }
  final tt = transactionType?.trim().toLowerCase();
  if (tt == null || tt.isEmpty) return false;
  if (tt != kSaleTransactionType.toLowerCase()) return false;
  if (!hasProductLineItems) return false;
  return true;
}

/// Cash book / keypad utility movement ([completeCashMovement] → [collectPayment]):
/// allocate a percent of the **recorded movement amount** (line totals), not SKU margin.
bool shouldAttemptPersonalGoalUtilityCashInSweep({
  required String? completionStatus,
  required bool isIncome,
  required bool isProformaMode,
  required bool isTrainingMode,
  required bool isUtilityCashbookMovement,
  required double movementSubTotal,
}) {
  if (!isUtilityCashbookMovement || !isIncome) return false;
  if (isProformaMode || isTrainingMode) return false;
  final cs = completionStatus?.toLowerCase();
  if (cs == null || cs != kCompletedTransactionStatus.toLowerCase()) {
    return false;
  }
  if (movementSubTotal <= 0) return false;
  return true;
}

/// Gross profit from line items: revenue (price × qty) minus cost (supply at sale × qty).
/// Skips lines ignored for reporting and composite component rows to avoid double counting.
double computeSaleGrossProfitFromSaleLines(List<SaleLineForProfit> lines) {
  var total = 0.0;
  for (final item in lines) {
    if (item.ignoreForReport) continue;
    if (item.partOfComposite) continue;
    final qty = item.qty;
    final revenue = item.price * qty;
    final unitCost = item.supplyPriceAtSale ?? item.supplyPrice ?? 0;
    final cost = unitCost * qty;
    total += revenue - cost;
  }
  return total;
}

/// Same line filters as [computeSaleGrossProfitFromSaleLines]; sums **line revenue**
/// (price × qty) only. Used when gross profit is ≤ 0 so `%` goals still allocate from
/// the sale total merchants care about (supply price often equals retail or is unset).
double computeSaleLineRevenueForPersonalGoals(List<SaleLineForProfit> lines) {
  var total = 0.0;
  for (final item in lines) {
    if (item.ignoreForReport) continue;
    if (item.partOfComposite) continue;
    total += item.price * item.qty;
  }
  return total;
}

double _roundMoney(double v) => (v * 100).round() / 100.0;

/// For each goal with [PersonalGoal.autoAllocationPercent], take that percent of [allocationBase]
/// (gross line profit for sales, or cash movement total for utility cash-in).
List<({String goalId, double amount})> computeAutoAllocationContributions({
  required double allocationBase,
  required List<PersonalGoal> goals,
}) {
  if (allocationBase <= 0) return const [];
  final out = <({String goalId, double amount})>[];
  for (final g in goals) {
    final pct = g.autoAllocationPercent;
    if (pct == null || pct <= 0) continue;
    final raw = allocationBase * pct / 100.0;
    final amount = _roundMoney(raw);
    if (amount > 0) {
      out.add((goalId: g.id, amount: amount));
    }
  }
  return out;
}
