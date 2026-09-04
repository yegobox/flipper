import 'dart:async';

/// Window used for per-line work on the Pay path.
///
/// Matches `_batchUpdateStocksConcurrency` in the Capella stock mixin: enough
/// parallelism that a 100-line cart costs a handful of round trips instead of a
/// hundred, small enough not to swamp the Ditto write queue (which the same
/// sale is already using for the stock decrement).
const int kSaleLineConcurrency = 8;

/// Runs [action] over [items], at most [concurrency] in flight at a time.
///
/// Ordering within a window is not guaranteed, so only use this where the work
/// per item is independent and idempotent. Like a sequential loop, the first
/// error propagates and the remaining windows are not started.
Future<void> forEachBounded<T>(
  Iterable<T> items,
  Future<void> Function(T item) action, {
  int concurrency = kSaleLineConcurrency,
}) async {
  final list = items is List<T> ? items : items.toList();
  if (list.isEmpty) return;
  if (list.length == 1) {
    await action(list.first);
    return;
  }

  final window = concurrency < 1 ? 1 : concurrency;
  for (var i = 0; i < list.length; i += window) {
    final end = (i + window < list.length) ? i + window : list.length;
    await Future.wait(
      [for (var j = i; j < end; j++) action(list[j])],
      eagerError: true,
    );
  }
}
