/// Pure helpers for [clearPendingSaleCartsExcept] classification.
///
/// Resume must never hard-delete a non-empty pending sale (e.g. a ticket that
/// was already resumed on this device). Only wipe empty operator carts.
bool isEmptyPendingSaleCart({
  required double subTotal,
  String? ticketName,
  required bool hasItems,
}) {
  final name = ticketName?.trim() ?? '';
  return !hasItems && subTotal <= 0.01 && name.isEmpty;
}

/// Whether a pending cart row can be empty without checking line items.
///
/// Named or valued carts are never treated as wipeable empty carts, so callers
/// can skip an item-existence lookup for them.
bool pendingSaleCartNeedsItemLookup({
  required double subTotal,
  String? ticketName,
}) {
  final name = ticketName?.trim() ?? '';
  return subTotal <= 0.01 && name.isEmpty;
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
/// [idsWithItems] should cover every id that [pendingSaleCartNeedsItemLookup]
/// selected; other rows are classified from subTotal/ticketName alone.
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

    final subTotal = (row['subTotal'] as num?)?.toDouble() ?? 0.0;
    final ticketName = (row['ticketName'] as String?)?.trim() ?? '';

    if (!pendingSaleCartNeedsItemLookup(
      subTotal: subTotal,
      ticketName: ticketName,
    )) {
      reparkRows.add(row);
      continue;
    }

    final hasItems = idsWithItems.contains(id);
    if (isEmptyPendingSaleCart(
      subTotal: subTotal,
      ticketName: ticketName,
      hasItems: hasItems,
    )) {
      deleteIds.add(id);
    } else {
      reparkRows.add(row);
    }
  }

  return PendingSaleCartCleanupPlan(
    deleteIds: deleteIds,
    reparkRows: reparkRows,
  );
}
