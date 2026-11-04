import 'dart:async';

/// Sync subscriptions held per key (e.g. one `branches` subscription per
/// requester branch) for the life of an observer stream.
///
/// Each key is registered once while it stays in the observed result. Keys
/// that leave the result are cancelled, and [cancelAll] drops the rest when
/// the stream closes. Ditto's `SyncSubscription.cancel` is passed in as the
/// returned callback so this stays testable without a live Ditto.
class KeyedSyncSubscriptions {
  KeyedSyncSubscriptions(this._register);

  /// Registers the subscription for a key and returns its cancel callback.
  final void Function() Function(String key) _register;
  final _cancels = <String, void Function()>{};
  bool _closed = false;

  /// Keys with a live subscription.
  Iterable<String> get keys => _cancels.keys;

  /// Registers [key] unless it already has a subscription. A no-op once
  /// [cancelAll] ran, so late observer work cannot leak a subscription.
  void ensure(String key) {
    if (_closed) return;
    _cancels.putIfAbsent(key, () => _register(key));
  }

  /// Cancels every subscription whose key is not in [keys].
  void retainOnly(Set<String> keys) {
    _cancels.removeWhere((key, cancel) {
      if (keys.contains(key)) return false;
      cancel();
      return true;
    });
  }

  void cancelAll() {
    _closed = true;
    for (final cancel in _cancels.values) {
      cancel();
    }
    _cancels.clear();
  }
}

/// An observer stream whose rows each may need a keyed sync subscription and
/// an async lookup (e.g. the branch on each stock request).
///
/// Only the newest emission is delivered and prunes subscriptions; an older
/// one that finishes late is dropped, so it can neither replace a newer list
/// nor drop a key the newer one still needs. Every key of an emission is
/// subscribed before its first await, so a superseded emission never
/// subscribes a key after a newer one pruned it. Closing the stream cancels
/// the observer, the stream's own subscription and every keyed one.
class KeyedObserverFeed<T> {
  KeyedObserverFeed({
    required this.subscriptions,
    required this.keyOf,
    required this.resolve,
    void Function()? cancelSubscription,
    this.onError,
  }) : _cancelSubscription = cancelSubscription {
    _controller.onCancel = close;
  }

  final KeyedSyncSubscriptions subscriptions;

  /// The key a row needs subscribed, or null for none.
  final String? Function(T row) keyOf;

  /// Fills in a keyed row (e.g. attaches its branch). Runs one row at a time.
  final Future<void> Function(T row, String key) resolve;

  final void Function(Object error)? onError;
  final void Function()? _cancelSubscription;
  final _controller = StreamController<List<T>>.broadcast();
  int _emission = 0;

  /// Cancels the store observer feeding [emit]; set once it is registered.
  FutureOr<void> Function()? cancelObserver;

  Stream<List<T>> get stream => _controller.stream;

  /// One observer emission. [readRows] converts the raw result.
  Future<void> emit(List<T> Function() readRows) async {
    if (_controller.isClosed) return;
    final thisEmission = ++_emission;
    bool current() => thisEmission == _emission && !_controller.isClosed;

    final List<T> rows;
    final keys = <String>{};
    try {
      rows = readRows();
      for (final row in rows) {
        final key = keyOf(row);
        if (key != null) keys.add(key);
      }
    } catch (e) {
      onError?.call(e);
      return;
    }
    keys.forEach(subscriptions.ensure);

    try {
      for (final row in rows) {
        if (!current()) return;
        final key = keyOf(row);
        if (key != null) await resolve(row, key);
      }
      if (!current()) return;
      subscriptions.retainOnly(keys);
      _controller.add(rows);
    } catch (e) {
      // The keys are this emission's whole result, so pruning stays right.
      if (current()) subscriptions.retainOnly(keys);
      onError?.call(e);
    }
  }

  Future<void> close() async {
    await cancelObserver?.call();
    _cancelSubscription?.call();
    subscriptions.cancelAll();
    await _controller.close();
  }
}
