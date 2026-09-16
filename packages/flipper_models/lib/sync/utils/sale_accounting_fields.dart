import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';

/// The ledger-relevant fields of a sale, derived from the lines that justify
/// them — shared by every surface that finalizes a ticket (POS, bar tabs,
/// hotel folios).
///
/// Accounting entries are posted server-side by `data-connector`, which sweeps
/// the `transactions` collection and knows nothing about which surface rang the
/// sale. It books revenue as `subTotal - taxAmount`, so a completion that
/// leaves `taxAmount` unset posts **the whole sale to revenue and nothing to
/// VAT payable**. That is the bug this file exists to make impossible: the
/// fields the ledger reads are derived in exactly one place, so a new mode
/// cannot quietly regress them.
///
/// Deliberately pure — no `ProxyService`, no Ditto — so it is unit-testable and
/// cannot pick up POS-specific box state (the last-picked tender, say, which
/// would be wrong for a bar or hotel settle).

/// Totals a ticket's lines without mutating anything.
({double netSubTotal, double tax, double discount, int itemCount})
saleAccountingTotals(Iterable<TransactionItem> lines) {
  final list = lines.toList(growable: false);
  final netSubTotal = SaleLinePricing.cartNetSubtotal([
    for (final item in list)
      (
        unitPrice: item.price.toDouble(),
        qty: item.qty.toDouble(),
        dcAmt: item.dcAmt?.toDouble(),
        dcRt: item.dcRt?.toDouble(),
      ),
  ]);
  final discount = list.fold<double>(
    0,
    (sum, item) => sum + (item.dcAmt?.toDouble() ?? 0),
  );
  return (
    netSubTotal: netSubTotal,
    tax: ticketTaxBreakdown(list).tax,
    discount: discount,
    itemCount: list.length,
  );
}

/// Stamps [transaction] with the monetary fields the ledger reads.
///
/// Only the amounts. `isIncome`/`isExpense`/`transactionType` are the
/// caller's: every surface already sets them when it mints the ticket, and
/// forcing them here would reclassify an expense as a sale.
///
/// [updateSubTotal] recomputes `subTotal` net of line discounts. The POS passes
/// true (it already did this). Bar and hotel pass false: their settle screens
/// total a ticket with [ticketLineTotal] — gross of discount — and charge the
/// guest that, so recomputing here would silently change the amount taken at
/// the till rather than just the way it is booked. Making the two agree is a
/// real fix, but a pricing one, not an accounting one.
void applySaleAccountingFields({
  required ITransaction transaction,
  required List<TransactionItem> lines,
  bool updateSubTotal = false,
}) {
  final totals = saleAccountingTotals(lines);

  transaction.taxAmount = totals.tax;
  transaction.discountAmount = totals.discount;
  transaction.numberOfItems = totals.itemCount;
  if (updateSubTotal) {
    transaction.subTotal = totals.netSubTotal;
  }
}
