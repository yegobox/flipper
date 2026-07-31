/// Dual-field stock qty: register doubles (`currentStock`) + Ditto COUNTER milli-units.
///
/// Scale supports fractional POS qty (e.g. 2.5 kg → 2500). Never put milli into an
/// untyped `INSERT … DOCUMENTS` map — that would create a register, not a COUNTER.
const int stockQtyMilliScale = 1000;

/// Ditto field name for the settable COUNTER (new clients only).
const String stockCurrentStockMilliField = 'currentStockMilli';

/// `qty * 1000`, rounded to nearest int (3 decimal places of stock qty).
int toMilli(num qty) => (qty.toDouble() * stockQtyMilliScale).round();

/// Counter int → display/RRA double.
double fromMilli(int milli) => milli / stockQtyMilliScale;

/// Parse a Ditto SELECT value for [stockCurrentStockMilliField] (COUNTER → int).
int? parseStockMilli(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.round();
  // Some SDKs surface counters as `{ value: N }` / nested maps.
  if (value is Map) {
    final inner = value['value'] ?? value['counter'] ?? value['amount'];
    return parseStockMilli(inner);
  }
  return null;
}

/// What a new client must do before INCREMENT/RESTART with business intent.
enum StockMilliPrepAction {
  /// Counter matches register milli — proceed.
  none,

  /// Field missing — seed with [APPLY … RESTART WITH registerMilli].
  seed,

  /// Mixed fleet: register diverged — restart counter from register (register wins).
  reconcileFromRegister,
}

/// Coexistence prep: old tills only SET registers; new tills seed/reconcile then op.
StockMilliPrepAction stockMilliPrepAction({
  required int? milli,
  required double registerQty,
}) {
  final registerMilli = toMilli(registerQty);
  if (milli == null) return StockMilliPrepAction.seed;
  if (milli != registerMilli) return StockMilliPrepAction.reconcileFromRegister;
  return StockMilliPrepAction.none;
}

/// Effective on-hand milli after prep (always equals register milli under coexistence).
int stockMilliAfterPrep({
  required int? milli,
  required double registerQty,
}) =>
    toMilli(registerQty);

/// Clamp a positive deduct so on-hand does not go below zero.
int clampDeductMilli({required int availableMilli, required int deductMilli}) {
  if (deductMilli <= 0) return 0;
  if (availableMilli <= 0) return 0;
  return deductMilli > availableMilli ? availableMilli : deductMilli;
}

// --- DQL (STRICT_MODE requires COLLECTION + COUNTER declaration) ---

String stockSelectWithMilliDql({required String whereClause}) =>
    'SELECT * FROM COLLECTION stocks ($stockCurrentStockMilliField COUNTER) '
    'WHERE $whereClause';

String stockRestartMilliDql() =>
    'UPDATE COLLECTION stocks ($stockCurrentStockMilliField COUNTER) '
    'APPLY $stockCurrentStockMilliField RESTART WITH :milli '
    'WHERE _id = :stockId OR id = :stockId';

String stockIncrementMilliDql() =>
    'UPDATE COLLECTION stocks ($stockCurrentStockMilliField COUNTER) '
    'APPLY $stockCurrentStockMilliField INCREMENT BY :delta '
    'WHERE _id = :stockId OR id = :stockId';

String stockDualWriteRegistersDql() =>
    'UPDATE stocks SET currentStock = :currentStock, rsdQty = :rsdQty '
    'WHERE _id = :stockId OR id = :stockId';

/// Seed or absolute-set the milli COUNTER after a register-only DOCUMENTS insert.
///
/// Never put [stockCurrentStockMilliField] in an untyped JSON upsert — that creates
/// a register. Pass Capella `ditto.store`.
Future<void> applyStockMilliRestartOnStore(
  dynamic store, {
  required String stockId,
  required double qty,
}) async {
  await store.execute(
    stockRestartMilliDql(),
    arguments: {'stockId': stockId, 'milli': toMilli(qty)},
  );
}

/// Seed milli only when the COUNTER field is absent (safe for re-upsert sync paths).
Future<void> seedStockMilliIfAbsentOnStore(
  dynamic store, {
  required String stockId,
  required double qty,
}) async {
  final result = await store.execute(
    stockSelectWithMilliDql(
      whereClause: '_id = :stockId OR id = :stockId LIMIT 1',
    ),
    arguments: {'stockId': stockId},
  );
  if (result.items.isEmpty) {
    await applyStockMilliRestartOnStore(store, stockId: stockId, qty: qty);
    return;
  }
  final data = Map<String, dynamic>.from(result.items.first.value);
  if (parseStockMilli(data[stockCurrentStockMilliField]) == null) {
    final register = data['currentStock'];
    final seedQty = register is num ? register.toDouble() : qty;
    await applyStockMilliRestartOnStore(
      store,
      stockId: stockId,
      qty: seedQty,
    );
  }
}
