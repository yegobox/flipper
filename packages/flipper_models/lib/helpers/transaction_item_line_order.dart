import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Sort key for POS cart, detailed report grid, and PLU export — newest touch first.
DateTime transactionItemLineSortKey(TransactionItem item) {
  return item.updatedAt ?? item.lastTouched ?? item.createdAt ?? DateTime(2000);
}

/// Newest line first: [updatedAt] (same as QuickSellingView / optimistic cart).
/// Re-tap bumps [updatedAt]; checkout must not overwrite it (see Capella
/// [updateTransactionItem]). [createdAt] / [id] are weak tie-breaks only —
/// never sort by [itemSeq] (catalog / RRA field, not cart touch order).
int compareTransactionItemLinesNewestFirst(
  TransactionItem a,
  TransactionItem b,
) {
  final byTouch = transactionItemLineSortKey(
    b,
  ).compareTo(transactionItemLineSortKey(a));
  if (byTouch != 0) return byTouch;

  final ac = a.createdAt;
  final bc = b.createdAt;
  if (ac != null && bc != null) {
    final byCreated = bc.compareTo(ac);
    if (byCreated != 0) return byCreated;
  } else if (ac == null && bc != null) {
    return 1;
  } else if (ac != null && bc == null) {
    return -1;
  }

  return a.id.compareTo(b.id);
}

List<TransactionItem> sortTransactionItemLinesNewestFirst(
  List<TransactionItem> items,
) {
  final sorted = List<TransactionItem>.from(items);
  sorted.sort(compareTransactionItemLinesNewestFirst);
  return sorted;
}
