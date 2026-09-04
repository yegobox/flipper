import 'package:flipper_models/helperModels/talker.dart';

/// How many live store observers there are, and what each wake-up costs.
///
/// Every write wakes every observer whose query matches, and each one re-runs
/// its query and re-materialises the rows. That is what made a cart write slow:
/// the write itself was 15ms, and the next one queued behind the replay of
/// every row in the cart. The two root causes found this way — leaked
/// dashboard observers, and the parent-row write waking branch-wide
/// `SELECT * FROM transactions` — were both found by reading logs and guessing
/// at which observer was responsible.
///
/// This makes both visible: how many are open (a leak shows as a count that
/// only grows) and what each callback costs (a slow one names itself).
class DittoObserverStats {
  final Map<String, int> _liveByCollection = <String, int>{};
  final Map<String, int> _openedByName = <String, int>{};

  int get live =>
      _liveByCollection.values.fold(0, (sum, count) => sum + count);

  Map<String, int> get liveByCollection =>
      Map<String, int>.unmodifiable(_liveByCollection);

  /// How many observers with [name] are open — more than a handful is a leak.
  int liveFor(String name) => _openedByName[name] ?? 0;

  void opened({required String name, required String collection}) {
    _liveByCollection.update(collection, (n) => n + 1, ifAbsent: () => 1);
    _openedByName.update(name, (n) => n + 1, ifAbsent: () => 1);
  }

  void closed({required String name, required String collection}) {
    final byCollection = (_liveByCollection[collection] ?? 0) - 1;
    if (byCollection <= 0) {
      _liveByCollection.remove(collection);
    } else {
      _liveByCollection[collection] = byCollection;
    }
    final byName = (_openedByName[name] ?? 0) - 1;
    if (byName <= 0) {
      _openedByName.remove(name);
    } else {
      _openedByName[name] = byName;
    }
  }

  /// Live observers per collection, busiest first.
  String summary() {
    final entries = _liveByCollection.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => '${e.key}=${e.value}').join(' ');
  }
}

final DittoObserverStats dittoObserverStats = DittoObserverStats();

/// A callback slower than this is worth naming: at a few per cart write, this
/// is what a tap is queued behind.
const int kSlowObserverCallbackMs = 250;

/// A store observer that reports what it costs.
class TrackedDittoObserver {
  TrackedDittoObserver._(this._inner, this._name, this._collection);

  final dynamic _inner;
  final String _name;
  final String _collection;
  bool _cancelled = false;

  Future<void> cancel() async {
    if (_cancelled) return;
    _cancelled = true;
    dittoObserverStats.closed(name: _name, collection: _collection);
    try {
      await _inner?.cancel();
    } catch (_) {
      // Ditto already closed, or the observer is already torn down.
    }
  }
}

/// Registers a store observer that accounts for itself.
///
/// [name] identifies the call site — several observers can share a collection,
/// and the point is to know *which* one woke up and what it cost.
TrackedDittoObserver registerTrackedObserver({
  required dynamic ditto,
  required String name,
  required String collection,
  required String query,
  Map<String, dynamic>? arguments,
  required void Function(dynamic queryResult) onChange,
}) {
  dittoObserverStats.opened(name: name, collection: collection);
  final inner = ditto.store.registerObserver(
    query,
    arguments: arguments,
    onChange: (dynamic queryResult) {
      final sw = Stopwatch()..start();
      try {
        onChange(queryResult);
      } finally {
        final ms = sw.elapsedMilliseconds;
        if (ms >= kSlowObserverCallbackMs) {
          int? rows;
          try {
            rows = (queryResult.items as Iterable).length;
          } catch (_) {}
          talker.warning(
            '[ditto_observer] $name woke for ${ms}ms '
            '(rows=${rows ?? '?'}, live: ${dittoObserverStats.summary()})',
          );
        }
      }
    },
  );
  return TrackedDittoObserver._(inner, name, collection);
}
