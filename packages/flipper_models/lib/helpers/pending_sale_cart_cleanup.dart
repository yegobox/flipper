/// Pure helpers for [clearPendingSaleCartsExcept] classification.
///
/// Resume must never hard-delete a pending sale that still has line items
/// (e.g. a sibling cart the operator built before Collect), nor a resumed
/// ticket ([isResumedPendingTicketRow]). Ghost rows with
/// only a stale [subTotal] or a typed [customerName]/[ticketName] must be
/// deleted — promoting them to PARKED is what made "mystery" tickets appear
/// after park / re-park / Collect.

String _trimmed(String? value) => value?.trim() ?? '';

// DQL shared with `pending_sale_cart_cleanup_ditto_test.dart`, which runs these
// exact strings on a strict-mode store. Arrays bind as `IN :ids` — the
// parenthesised `IN (:ids)` silently matches nothing.

/// Sibling pending sale carts of one agent on this device (cleanup scope).
/// Device-scoped: another till's cart may not have replicated its lines here
/// yet, and classifying it from this store would delete it.
const String pendingSaleCartSiblingsDql =
    'SELECT * FROM transactions WHERE branchId = :branchId '
    'AND status = :status AND agentId = :agentId AND deviceId = :deviceId '
    'AND (isExpense = :isExpense OR isExpense IS NULL) '
    'AND isOriginalTransaction = :isOriginal AND id != :excludeId';

/// This device's PENDING sale rows with a subtotal — candidates for the
/// startup re-park of resumed tickets (names are checked in Dart).
const String resumedTicketSweepDql =
    'SELECT * FROM transactions WHERE branchId = :branchId '
    'AND status = :status AND deviceId = :deviceId '
    'AND (isExpense = :isExpense OR isExpense IS NULL) '
    'AND isOriginalTransaction = :isOriginal AND subTotal > 0';

/// Which of `:ids` own at least one line.
const String cartIdsWithLinesDql =
    'SELECT transactionId FROM transaction_items WHERE transactionId IN :ids';

const String deleteCartLinesDql =
    'DELETE FROM transaction_items WHERE transactionId IN :ids';

/// Rows may carry their id in `_id` only, so match both.
const String deleteCartsDql =
    'DELETE FROM transactions WHERE _id IN :ids OR id IN :ids';

/// True when either parked ticket name or denormalized customer name is set.
bool pendingSaleCartHasDisplayName({String? ticketName, String? customerName}) {
  return _trimmed(ticketName).isNotEmpty || _trimmed(customerName).isNotEmpty;
}

/// A pending cart is wipeable when it has no line items.
///
/// Stale [subTotal] and display names alone do **not** keep the row — those
/// fields routinely survive handoff onto the next empty cart and used to be
/// re-parked as mysterious till tickets.
bool isEmptyPendingSaleCart({
  required double subTotal,
  String? ticketName,
  String? customerName,
  required bool hasItems,
}) {
  return !hasItems;
}

/// Every sibling candidate needs an item-existence check before re-park.
///
/// Kept as a predicate so callers can still batch lookups; always returns
/// true so valued/named ghosts are not promoted without lines.
bool pendingSaleCartNeedsItemLookup({
  required double subTotal,
  String? ticketName,
  String? customerName,
}) {
  return true;
}

/// Label to stamp when re-parking an orphan pending cart that **has items**.
///
/// Prefer the parked [ticketName], then the checkout [customerName] the UI
/// already showed, then a till-style ref.
String pendingSaleCartReparkTicketName({
  required String id,
  String? ticketName,
  String? customerName,
  Object? reference,
  Object? transactionNumber,
}) {
  final existing = _trimmed(ticketName);
  if (existing.isNotEmpty) return existing;

  final customer = _trimmed(customerName);
  if (customer.isNotEmpty) return customer;

  final ref = _trimmed(reference?.toString());
  if (ref.isNotEmpty) return 'Till · $ref';

  final txnNo = _trimmed(transactionNumber?.toString());
  if (txnNo.isNotEmpty) return 'Till · $txnNo';

  final short = id.length >= 6
      ? id.substring(0, 6).toUpperCase()
      : id.toUpperCase();
  return 'Till · $short';
}

/// Result of classifying sibling pending sale carts for cleanup.
class PendingSaleCartCleanupPlan {
  const PendingSaleCartCleanupPlan({
    required this.deleteIds,
    required this.reparkRows,
  });

  final List<String> deleteIds;
  final List<Map<String, dynamic>> reparkRows;
}

double _subTotalOf(Map<String, dynamic> row) {
  final value = row['subTotal'];
  return value is num ? value.toDouble() : 0.0;
}

/// True for a PENDING row that is a resumed ticket rather than a plain cart.
///
/// Park is the only writer of `ticketName` and refuses a zero subtotal, and
/// resume keeps both, so a pending row carrying a name *and* a subtotal is a
/// ticket someone resumed. Either field alone is the stale-ghost shape
/// described above.
bool isResumedPendingTicketRow(Map<String, dynamic> row) {
  return _trimmed(row['ticketName'] as String?).isNotEmpty &&
      _subTotalOf(row) > 0;
}

/// Split pending-sale candidates into delete / re-park / leave-alone buckets.
///
/// - Lines present: re-park. With [deleteNonEmpty] (user switch) only a
///   resumed ticket is re-parked; a plain cart with lines is left for its
///   owner to come back to.
/// - No local lines but [isResumedPendingTicketRow]: leave alone. Its lines may
///   still be replicating from the till that took it, so deleting it loses the
///   ticket and re-parking it makes an empty "mystery" ticket.
/// - Everything else (empty carts, name-only or subtotal-only ghosts): delete.
///
/// A resumed ticket is never deleted, whatever [deleteNonEmpty] says.
PendingSaleCartCleanupPlan classifyPendingSaleCarts({
  required List<Map<String, dynamic>> candidates,
  required Set<String> idsWithItems,
  required bool deleteNonEmpty,
}) {
  final deleteIds = <String>[];
  final reparkRows = <Map<String, dynamic>>[];

  for (final row in candidates) {
    final id = row['id'] as String;
    final resumed = isResumedPendingTicketRow(row);

    if (idsWithItems.contains(id)) {
      if (!deleteNonEmpty || resumed) reparkRows.add(row);
      continue;
    }
    if (resumed) continue;
    deleteIds.add(id);
  }

  return PendingSaleCartCleanupPlan(
    deleteIds: deleteIds,
    reparkRows: reparkRows,
  );
}
