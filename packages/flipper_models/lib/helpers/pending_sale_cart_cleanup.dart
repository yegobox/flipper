/// Pure helpers for [clearPendingSaleCartsExcept] classification.
///
/// Resume must never hard-delete a pending sale that still has line items
/// (e.g. a sibling cart the operator built before Collect). Ghost rows with
/// only a stale [subTotal] or a typed [customerName]/[ticketName] must be
/// deleted — promoting them to PARKED is what made "mystery" tickets appear
/// after park / re-park / Collect.

String _trimmed(String? value) => value?.trim() ?? '';

/// True when either parked ticket name or denormalized customer name is set.
bool pendingSaleCartHasDisplayName({
  String? ticketName,
  String? customerName,
}) {
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

  final short =
      id.length >= 6 ? id.substring(0, 6).toUpperCase() : id.toUpperCase();
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

/// Split pending-sale candidates into delete vs re-park buckets.
///
/// Re-park **only** when [idsWithItems] contains the id. Everything else is
/// deleted — including stale subTotal / name-only ghosts.
PendingSaleCartCleanupPlan classifyPendingSaleCarts({
  required List<Map<String, dynamic>> candidates,
  required Set<String> idsWithItems,
  required bool deleteNonEmpty,
}) {
  final deleteIds = <String>[];
  final reparkRows = <Map<String, dynamic>>[];

  for (final row in candidates) {
    final id = row['id'] as String;
    if (deleteNonEmpty) {
      deleteIds.add(id);
      continue;
    }

    if (idsWithItems.contains(id)) {
      reparkRows.add(row);
    } else {
      deleteIds.add(id);
    }
  }

  return PendingSaleCartCleanupPlan(
    deleteIds: deleteIds,
    reparkRows: reparkRows,
  );
}
