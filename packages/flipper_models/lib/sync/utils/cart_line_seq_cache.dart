/// Remembers the highest `itemSeq` handed out per cart, so adding a line does
/// not have to ask the store what the highest one is.
///
/// Adds are serialised behind the cart persist lock, so within a device this is
/// simply a counter. Seeding it costs one query per cart (on the first insert,
/// when a fresh cart has no rows at all), after which every further insert is
/// O(1) — making a whole cart O(n) instead of O(n²).
///
/// `itemSeq` orders lines locally; it is not what RRA receives, since
/// `saveSales` renumbers from the list index (`itemSeq: entry.key + 1`). A
/// collision with a line replicated from elsewhere therefore ties display order
/// rather than corrupting a receipt — the same exposure the previous
/// read-then-write had.
class CartLineSeqCache {
  CartLineSeqCache({this.maxTrackedCarts = 32})
      : assert(maxTrackedCarts > 0);

  /// Carts are short-lived, so a small bound keeps completed ones from
  /// accumulating for the life of the process.
  final int maxTrackedCarts;

  final Map<String, int> _highestByTransactionId = <String, int>{};

  /// The seq to hand out next, or null when this cart has not been seeded.
  int? nextFor(String transactionId) {
    final highest = _highestByTransactionId[transactionId];
    return highest == null ? null : highest + 1;
  }

  /// Records [seq] as handed out for [transactionId].
  ///
  /// Never lowers a cart's high-water mark; a lower seq means a stale caller,
  /// not a rewind.
  void record({required String transactionId, required int seq}) {
    if (transactionId.isEmpty) return;
    final existing = _highestByTransactionId.remove(transactionId);
    _highestByTransactionId[transactionId] =
        (existing != null && existing > seq) ? existing : seq;

    // Dart maps keep insertion order, and the line above re-inserts on every
    // touch, so the first key is always the least recently used cart.
    while (_highestByTransactionId.length > maxTrackedCarts) {
      _highestByTransactionId.remove(_highestByTransactionId.keys.first);
    }
  }

  /// Drops a cart, so the next insert re-seeds from the store.
  void forget(String transactionId) =>
      _highestByTransactionId.remove(transactionId);

  int get trackedCartCount => _highestByTransactionId.length;
}
