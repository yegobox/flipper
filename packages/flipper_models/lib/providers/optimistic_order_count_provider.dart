import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimistic_order_count_provider.g.dart';

/// A simple state provider to track the order count optimistically.
/// This increments immediately when an item is added, providing instant UI feedback.
/// The actual count from the stream will eventually sync and correct any discrepancies.
@Riverpod(keepAlive: true)
class OptimisticOrderCount extends _$OptimisticOrderCount {
  @override
  int build() => 0;

  /// Increment the count optimistically when an item is added
  void increment() {
    state = state + 1;
  }

  /// Decrement the count optimistically when an item is removed
  void decrement() {
    if (state > 0) {
      state = state - 1;
    }
  }

  /// Sync with the actual count from the database stream
  void syncWith(int actualCount) {
    state = actualCount;
  }

  /// Reset the count to zero
  void reset() {
    state = 0;
  }
}
