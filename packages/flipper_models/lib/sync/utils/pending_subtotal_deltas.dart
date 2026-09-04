import 'dart:async';

/// Gathers cart subtotal deltas so a burst of taps costs one parent-row write.
///
/// Writing the parent `transactions` document per cart line cost 2.5s of every
/// 5.2s tap: the collection has no index, so the read-modify-write walks it,
/// and the write then wakes every branch-wide `SELECT * FROM transactions`
/// observer, each of which walks it again.
///
/// Nothing needs that field per line — the cart total on screen is computed
/// from the items, park and send-to-till overwrite it with the live total
/// before persisting, and completion recomputes it from the finished lines.
///
/// A delta is a *relative* correction to a cart being built, so any path that
/// writes an absolute subtotal must [discard] first: landing a delta on top of
/// a total computed from the finished lines would count those lines twice.
class PendingSubtotalDeltas {
  PendingSubtotalDeltas({
    this.window = const Duration(milliseconds: 600),
  });

  /// How long to keep gathering before writing the parent row once.
  final Duration window;

  final Map<String, double> _deltas = <String, double>{};
  final Map<String, Timer> _timers = <String, Timer>{};

  /// Adds [delta] to what is owed for [transactionId], restarting the window.
  ///
  /// [onFlush] runs once the taps stop, with the summed delta.
  void add({
    required String transactionId,
    required double delta,
    required Future<void> Function(String transactionId, double delta) onFlush,
  }) {
    if (delta == 0 || transactionId.isEmpty) return;
    _deltas.update(
      transactionId,
      (pending) => pending + delta,
      ifAbsent: () => delta,
    );
    _timers[transactionId]?.cancel();
    _timers[transactionId] = Timer(window, () {
      unawaited(flush(transactionId: transactionId, onFlush: onFlush));
    });
  }

  /// Writes what is owed for [transactionId] now, if anything.
  Future<void> flush({
    required String transactionId,
    required Future<void> Function(String transactionId, double delta) onFlush,
  }) async {
    _timers.remove(transactionId)?.cancel();
    final delta = _deltas.remove(transactionId);
    if (delta == null || delta == 0) return;
    await onFlush(transactionId, delta);
  }

  /// Drops what is owed for [transactionId] without writing it.
  void discard(String transactionId) {
    _timers.remove(transactionId)?.cancel();
    _deltas.remove(transactionId);
  }

  /// What is currently owed for [transactionId] — diagnostics and tests.
  double pendingFor(String transactionId) => _deltas[transactionId] ?? 0;
}
