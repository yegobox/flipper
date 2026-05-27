import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';

/// LocalStorage key prefix for stocking levels at POS sale-completion time,
/// keyed by Ditto [`Stock`] id (`stockId`).
const String kRraSaleStockSnapshotPrefix = 'rra_sale_stock_snapshot_';

String rraSaleStockSnapshotBoxKey(String transactionId) =>
    '$kRraSaleStockSnapshotPrefix$transactionId';

/// Parses [JSON-encoded] `{ stockId -> qty }` from [LocalStorage.writeString].
Map<String, double>? decodeRraSaleStockSnapshot(String? encoded) {
  if (encoded == null || encoded.isEmpty) return null;
  try {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) return null;
    final out = <String, double>{};
    decoded.forEach((k, v) {
      final key = k is String ? k : '$k';
      final n = (v as num?)?.toDouble();
      if (n != null) out[key] = n;
    });
    return out;
  } catch (_) {
    return null;
  }
}

/// Computes per transaction line how many units should be reported to RRA stock
/// movement (`stock/saveStockItems`) given on-hand qty at sale start per [stockId].
///
/// When [allowSellingBelowStock] is false or [snapshotByStockId] is null/empty,
/// each non-service line uses its full sale [TransactionItem.qty].
///
/// Service lines ([itemTyCd] == `"3"`) get allocation `null` — callers should
/// omit them before building RRA payloads (same as legacy filters).
///
/// Ordering: preserves [items] iteration while consuming a remaining budget per
/// [Variant.stockId] from [snapshotByStockId] (values floored at `0`).
Map<String, num> rraAllocatedQtyByTransactionItemId({
  required List<TransactionItem> items,
  required Map<String, Variant> variantsByVariantId,
  required Map<String, double>? snapshotByStockId,
  required bool allowSellingBelowStock,
}) {
  final useCap =
      allowSellingBelowStock &&
      snapshotByStockId != null &&
      snapshotByStockId.isNotEmpty;

  final remainingBudget = useCap
      ? snapshotByStockId.map(
          (k, v) => MapEntry(k, v <= 0 ? 0.0 : v.toDouble()),
        )
      : <String, double>{};

  final out = <String, num>{};
  for (final item in items) {
    if (item.variantId == null || item.variantId!.isEmpty) {
      continue;
    }
    if (item.itemTyCd == '3') {
      out[item.id] = 0;
      continue;
    }
    if (!useCap) {
      out[item.id] = item.qty;
      continue;
    }

    final variant = variantsByVariantId[item.variantId!];
    final sid = variant?.stockId;
    if (sid == null || sid.isEmpty || !remainingBudget.containsKey(sid)) {
      out[item.id] = item.qty;
      continue;
    }

    final budget = remainingBudget[sid] ?? 0.0;
    final lineQty = item.qty.toDouble();
    final take = lineQty < budget ? lineQty : budget;
    remainingBudget[sid] = budget - take;
    out[item.id] = take;
  }
  return out;
}

/// Builds non-service [`TransactionItem`] rows for [`saveStockItems`] with qty set to the
/// RRA-reported movement (possibly less than sold qty when overselling).
List<TransactionItem> movementItemsWithRraCapAllocation(
  List<TransactionItem> items,
  Map<String, num> allocations,
) {
  final capped = <TransactionItem>[];
  for (final item in items) {
    if (item.itemTyCd == '3') continue;
    final vid = item.variantId;
    if (vid == null || vid.isEmpty) continue;
    final allocated = allocations[item.id];
    if (allocated == null || allocated <= 0) continue;
    if (allocated == item.qty) {
      capped.add(item);
    } else {
      capped.add(item.copyWith(qty: allocated));
    }
  }
  return capped;
}
