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
