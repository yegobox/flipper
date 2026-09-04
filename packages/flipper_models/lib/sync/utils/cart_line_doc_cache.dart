/// Remembers the persisted line of each variant in a cart, so adding to that
/// cart does not have to ask the store whether the line already exists.
///
/// Sibling of [CartLineSeqCache], for the same reason and with the same shape.
/// The lookup it replaces cost 2,000–4,600ms per tap on a 60-line cart — more
/// than reading the *entire* 5,793-row collection (611ms), so it was never scan
/// cost: cart writes, the observer re-materialising every row after each one,
/// and replication were all contending for the store, and this query waited its
/// turn. An index cannot fix waiting; not asking can.
///
/// Seeding is one query per cart, on the first write, after which every further
/// tap is O(1).
///
/// Adds are serialised behind the cart persist lock, and the rows recorded here
/// are the ones this device just wrote, so within a device this is exact. A
/// line written for the same cart by *another* device is not seen until the
/// cart is re-seeded, which would split that variant across two rows rather
/// than raising its qty. Completion reads the persisted lines back and
/// reconciles, and money is computed from those rows, so the exposure is a
/// duplicated display line — the same class of exposure the seq cache accepts.
/// The cache the cart add path reads and every cart mutation must keep honest.
///
/// Shared, because the paths that change a cart line live in five different
/// mixins: the add path here, the qty stepper, bar-mode tabs, line deletes and
/// the move-lines-between-carts path. A private instance meant a delete could
/// leave a row cached that no longer exists — the next tap on that product then
/// updated a deleted document and the line never came back.
final CartLineDocCache cartLineDocCache = CartLineDocCache();

class CartLineDocCache {
  CartLineDocCache({this.maxTrackedCarts = 8}) : assert(maxTrackedCarts > 0);

  /// Carts are short-lived; a small bound keeps finished ones from
  /// accumulating for the life of the process. Lower than the seq cache's
  /// because each entry holds every line of a cart, not one integer.
  final int maxTrackedCarts;

  final Map<String, Map<String, Map<String, dynamic>>> _linesByCart = {};

  /// Whether [transactionId] has been seeded and can answer for itself.
  bool isSeeded(String transactionId) =>
      _linesByCart.containsKey(transactionId);

  /// Adopts [rows] as the complete set of persisted lines for [transactionId].
  void seed({
    required String transactionId,
    required Iterable<Map<String, dynamic>> rows,
  }) {
    if (transactionId.isEmpty) return;
    final lines = <String, Map<String, dynamic>>{};
    for (final row in rows) {
      final variantId = row['variantId']?.toString();
      if (variantId == null || variantId.isEmpty) continue;
      lines[variantId] = Map<String, dynamic>.from(row);
    }
    _touch(transactionId, lines);
  }

  /// The persisted line for [variantId], or null when there is none.
  ///
  /// Only meaningful once [isSeeded] is true for the cart.
  Map<String, dynamic>? lineFor({
    required String transactionId,
    required String variantId,
  }) {
    return _linesByCart[transactionId]?[variantId];
  }

  /// Records the row this device just wrote for [variantId].
  void record({
    required String transactionId,
    required String variantId,
    required Map<String, dynamic> row,
  }) {
    if (transactionId.isEmpty || variantId.isEmpty) return;
    final lines = _linesByCart[transactionId] ?? <String, Map<String, dynamic>>{};
    lines[variantId] = Map<String, dynamic>.from(row);
    _touch(transactionId, lines);
  }

  /// Drops a cart, so the next write re-seeds from the store.
  ///
  /// Anything that changes a line behind this cache — a qty edit, a removal,
  /// completion — must call this, or the cache answers with a row that no
  /// longer matches the store.
  void forget(String transactionId) => _linesByCart.remove(transactionId);

  void forgetAll() => _linesByCart.clear();

  int get trackedCartCount => _linesByCart.length;

  void _touch(String transactionId, Map<String, Map<String, dynamic>> lines) {
    // Dart maps keep insertion order, so removing before inserting makes the
    // first key the least recently used cart.
    _linesByCart.remove(transactionId);
    _linesByCart[transactionId] = lines;
    while (_linesByCart.length > maxTrackedCarts) {
      _linesByCart.remove(_linesByCart.keys.first);
    }
  }
}
