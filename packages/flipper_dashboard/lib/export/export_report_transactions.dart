import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';

/// Whether [tx] should drive **sales** Excel/PDF (summary + PLU), not the Expenses sheet.
///
/// Cash book completions should set [IT.isExpense] and [IT.receiptType], but some rows
/// (sync/legacy) only have one of them — treat Cash In / Cash Out receipts as non-sale.
bool transactionIsReportExportSale(ITransaction tx) {
  if (tx.isExpense == true) return false;
  final rt = tx.receiptType;
  if (rt == TransactionType.cashIn || rt == TransactionType.cashOut) {
    return false;
  }
  return true;
}

/// Transaction Reports on-screen data includes expenses (cash out, etc.).
/// Excel/PDF **sales** sheets and PLU detail must use only real sale transactions.
List<ITransaction> exportSalesTransactionsOnly(
  List<ITransaction> reportTransactions,
) {
  return reportTransactions.where(transactionIsReportExportSale).toList();
}

/// Restrict payment-sum map to [transactions] (e.g. sales-only subset).
Map<String, TransactionPaymentSums> exportPaymentSumsSubsetForTransactions(
  Map<String, TransactionPaymentSums>? full,
  List<ITransaction> transactions,
) {
  if (full == null || full.isEmpty) return {};
  final ids = {for (final t in transactions) t.id.toString()};
  return {
    for (final e in full.entries)
      if (ids.contains(e.key)) e.key: e.value,
  };
}

/// True when this PLU row is a cash book utility line (not product sale).
bool isCashMovementPluLine(TransactionItem item) {
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

/// Drop cash In/Out utility lines (e.g. grid fallback when txn flags are incomplete).
List<TransactionItem> stripCashMovementPluLines(List<TransactionItem> items) {
  return items.where((i) => !isCashMovementPluLine(i)).toList();
}

/// Detailed PLU lines belonging to sale transactions only.
List<TransactionItem> exportPluItemsSalesOnly(
  List<TransactionItem> items,
  List<ITransaction> exportSales,
) {
  final ids = {for (final t in exportSales) t.id.toString()};
  return items.where((i) {
    if (isCashMovementPluLine(i)) return false;
    final tid = i.transactionId?.toString();
    return tid != null && ids.contains(tid);
  }).toList();
}
