// ignore_for_file: avoid_print
import 'lock_mechanism.dart';

/// Thrown when a store directory stays held by this process, so a second
/// open would fail with Ditto's "File already locked".
class DittoStoreHeldException implements Exception {
  DittoStoreHeldException(this.directory, {required this.closeFailed});

  final String directory;

  /// True when a retried close failed; false when the wait timed out.
  final bool closeFailed;

  @override
  String toString() => closeFailed
      ? 'DittoStoreHeldException: $directory is still open and its close failed again'
      : 'DittoStoreHeldException: $directory is still held after the wait';
}

/// Stores this process is opening, has open, or failed to close, by
/// persistence directory. A file lock keeps only other processes out, so
/// this keeps a second open off a directory a store in this process holds.
///
/// [S] is the store type: Ditto in the app, a fake in tests.
class DittoStoreHolds<S extends Object> {
  DittoStoreHolds({
    required Future<void> Function(S store) closeStore,
    this.waitTimeout = const Duration(seconds: 10),
    this.pollInterval = const Duration(milliseconds: 100),
  }) : _closeStore = closeStore;

  final Future<void> Function(S store) _closeStore;

  /// How long [open] waits for another holder of the directory to close.
  final Duration waitTimeout;
  final Duration pollInterval;

  final Map<String, _Hold<S>> _holds = {};

  bool isHeld(String directory) => _holds.containsKey(directory);

  /// Holds [directory], takes [lock] (when given) and runs [open].
  ///
  /// Waits while the directory is held, and first retries the close of a
  /// store whose earlier close failed. Throws [DittoStoreHeldException] when
  /// it stays held. Returns null, holding nothing, when [lock] is taken by
  /// another process or [stillWanted] turns false; a store opened for an
  /// unwanted init is closed here, since nobody else will.
  Future<S?> open(
    String directory, {
    required Future<S> Function() open,
    required bool Function() stillWanted,
    LockMechanism? lock,
  }) async {
    await _awaitFree(directory);
    if (!stillWanted()) return null;
    final hold = _holds[directory] = _Hold<S>();
    final S store;
    try {
      if (lock != null) {
        if (!await lock.acquire('$directory/.ditto_lock')) {
          print('❌ Ditto lock for $directory is taken by another process');
          _holds.remove(directory);
          return null;
        }
        hold.lock = lock;
      }
      store = await open();
    } catch (_) {
      await release(directory);
      rethrow;
    }
    if (!stillWanted()) {
      print('⏭️ Closing store opened by an aborted init');
      await close(directory, store);
      return null;
    }
    return store;
  }

  /// Closes [store] and frees [directory]. When the close throws, the store
  /// may still be open, so the directory stays held, with its file lock,
  /// until the next [open] of it retries the close.
  Future<bool> close(
    String directory,
    S store, {
    Duration settle = const Duration(milliseconds: 500),
  }) async {
    try {
      await _closeStore(store);
    } catch (e) {
      print('⚠️ Error closing Ditto store: $e — keeping its lock');
      (_holds[directory] ??= _Hold<S>()).unclosed = store;
      return false;
    }
    await Future<void>.delayed(settle);
    await release(directory);
    return true;
  }

  /// Frees [directory] and releases its file lock.
  Future<void> release(String directory) async {
    final lock = _holds.remove(directory)?.lock;
    if (lock != null) {
      await lock.release();
      print('🔓 Released Ditto lock');
    }
  }

  Future<void> _awaitFree(String directory) async {
    final deadline = DateTime.now().add(waitTimeout);
    while (true) {
      final hold = _holds[directory];
      if (hold == null) return;
      final unclosed = hold.unclosed;
      if (unclosed != null) {
        if (!await close(directory, unclosed)) {
          throw DittoStoreHeldException(directory, closeFailed: true);
        }
        continue;
      }
      if (!DateTime.now().isBefore(deadline)) {
        throw DittoStoreHeldException(directory, closeFailed: false);
      }
      await Future<void>.delayed(pollInterval);
    }
  }
}

class _Hold<S> {
  LockMechanism? lock;

  /// Set when close failed: the store may still hold the directory.
  S? unclosed;
}
