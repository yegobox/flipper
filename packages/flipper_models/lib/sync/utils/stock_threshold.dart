/// Low-stock alert settings on a `stocks` document: the "Low stock / reorder at"
/// level set on a product. Read by the app's Stock report and by the
/// data-connector daily report email's low-stock section.
library;

/// Writes only `lowStock` / `showLowStockAlert` on an existing stock document.
///
/// Touches no qty register (`currentStock`, `rsdQty`) and no `currentStockMilli`
/// COUNTER, so unlike a `DOCUMENTS` re-upsert it cannot resurrect stock a
/// concurrent sale already deducted. No-op when both values are null. Pass
/// Capella `ditto.store`.
Future<void> updateStockThresholdOnStore(
  dynamic store, {
  required String stockId,
  double? lowStock,
  bool? showLowStockAlert,
}) async {
  if (stockId.isEmpty) return;
  final fields = <String, dynamic>{
    'lowStock': ?lowStock,
    'showLowStockAlert': ?showLowStockAlert,
  };
  if (fields.isEmpty) return;
  fields['lastTouched'] = DateTime.now().toUtc().toIso8601String();
  await store.execute(
    'UPDATE stocks SET ${fields.keys.map((k) => '$k = :$k').join(', ')} '
    'WHERE _id = :stockId OR id = :stockId',
    arguments: {...fields, 'stockId': stockId},
  );
}
