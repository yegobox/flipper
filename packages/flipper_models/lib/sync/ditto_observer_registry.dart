import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/sync/utils/latest_throttle.dart';

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

  int get live => _liveByCollection.values.fold(0, (sum, count) => sum + count);

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
  TrackedDittoObserver._(
    this._inner,
    this._name,
    this._collection,
    this._drain,
    this._throttle,
  );

  final dynamic _inner;
  final String _name;
  final String _collection;
  final StreamSubscription<dynamic>? _drain;
  final LatestThrottle<dynamic>? _throttle;
  bool _cancelled = false;

  Future<void> cancel() async {
    if (_cancelled) return;
    _cancelled = true;
    dittoObserverStats.closed(name: _name, collection: _collection);
    _throttle?.close();
    // The live query stops now, synchronously, as `StoreObserver.cancel()`
    // does: call sites cancel without awaiting and close their controller
    // straight after, so no result may arrive once this returns.
    try {
      final dynamic stopped = _inner?.cancel();
      if (stopped is Future) unawaited(stopped.catchError((Object _) {}));
    } catch (_) {
      // Ditto already closed, or the observer is already torn down.
    }
    try {
      await _drain?.cancel();
    } catch (_) {}
  }
}

final RegExp _fromCollection = RegExp(
  r'\bFROM\s+`?(\w+)',
  caseSensitive: false,
);

/// The collection a `SELECT` reads, for call sites that take the query as a
/// parameter. `unknown` when there is no `FROM <name>`.
String dqlCollection(String query) =>
    _fromCollection.firstMatch(query)?.group(1) ?? 'unknown';

/// Registers a store observer that accounts for itself.
///
/// [name] identifies the call site — several observers can share a collection,
/// and the point is to know *which* one woke up and what it cost.
///
/// Pass the Ditto handle as [ditto], or its store as [store] where a caller
/// only holds the store. [R] keeps a call site's callback typed
/// (`(QueryResult result) {...}`). An untyped callback's parameter is
/// inferred as `Object?`, so type it whenever the callback reads the result.
/// No [arguments] registers the query with none, as `registerObserver` does.
///
/// With [coalesce], a burst of results reaches [onChange] at most once per
/// window (the first at once, then only the newest; see [LatestThrottle]).
/// Every call to [onChange] is timed, including the ones the window's timer
/// makes after Ditto's callback has returned.
TrackedDittoObserver registerTrackedObserver<R>({
  dynamic ditto,
  dynamic store,
  required String name,
  required String collection,
  required String query,
  Map<String, dynamic>? arguments,
  Duration? coalesce,
  required void Function(R queryResult) onChange,
}) {
  assert(ditto != null || store != null, 'pass ditto or store');
  final dynamic target = store ?? ditto.store;
  void timed(dynamic queryResult) => _timeObserverCallback(
    name,
    queryResult,
    (dynamic result) => onChange(result as R),
  );
  final throttle = coalesce == null
      ? null
      : LatestThrottle<dynamic>(coalesce, timed);
  final inner = target.registerObserver(
    query,
    arguments: arguments ?? const <String, dynamic>{},
    onChange: throttle?.add ?? timed,
  );
  // Counted once it exists: a registration that throws opened nothing.
  dittoObserverStats.opened(name: name, collection: collection);
  return TrackedDittoObserver._(
    inner,
    name,
    collection,
    _drainChanges(inner),
    throttle,
  );
}

/// Runs [onChange] and names it in the perf trail and the log when it takes
/// [kSlowObserverCallbackMs] or more.
void _timeObserverCallback(
  String name,
  dynamic queryResult,
  void Function(dynamic queryResult) onChange,
) {
  final sw = Stopwatch()..start();
  try {
    onChange(queryResult);
  } finally {
    final ms = sw.elapsedMilliseconds;
    if (ms >= kSlowObserverCallbackMs) {
      PerfOpTrail.instance.note('obs:$name', took: Duration(milliseconds: ms));
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
}

/// Reads and drops the results ditto_live queues on `observer.changes`.
///
/// `StoreObserver` adds every result to that single-subscription stream as
/// well as passing it to `onChange`. A stream nobody listens to buffers, so
/// without this each result (and the native memory behind it) stays alive
/// for as long as the observer does — a long-lived observer over a busy
/// collection grows the heap all session, which a 2 GB phone pays for in
/// garbage-collection pauses.
StreamSubscription<dynamic>? _drainChanges(dynamic observer) {
  try {
    final Stream<dynamic> changes = observer.changes;
    return changes.listen((_) {});
  } catch (_) {
    // A test double without `changes`.
    return null;
  }
}
