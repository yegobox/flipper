import 'dart:async';
import 'dart:io';

import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Just enough of a Ditto handle for [registerTrackedObserver]: it keeps the
/// callback so a test can fire it.
class _FakeStore {
  _FakeStore({this.registerDelay = Duration.zero});

  /// How long registering blocks, like a real Ditto busy syncing.
  final Duration registerDelay;
  void Function(dynamic)? onChange;

  Object registerObserver(
    String query, {
    Map<String, dynamic>? arguments,
    required void Function(dynamic) onChange,
  }) {
    if (registerDelay > Duration.zero) sleep(registerDelay);
    this.onChange = onChange;
    return Object();
  }
}

class _FakeDitto {
  _FakeDitto({Duration registerDelay = Duration.zero})
    : store = _FakeStore(registerDelay: registerDelay);

  final _FakeStore store;
}

/// Like ditto_live's `StoreObserver`: every result also lands on [changes],
/// a single-subscription stream that buffers until someone listens.
class _ObserverWithChanges {
  final results = StreamController<dynamic>();
  Stream<dynamic> get changes => results.stream;
  bool cancelled = false;
  Future<void> cancel() async => cancelled = true;
}

class _StoreWithChanges {
  final observer = _ObserverWithChanges();

  _ObserverWithChanges registerObserver(
    String query, {
    Map<String, dynamic>? arguments,
    required void Function(dynamic) onChange,
  }) => observer;
}

class _DittoWithChanges {
  final store = _StoreWithChanges();
}

class _FakeResult {
  final items = const [1, 2];
}

void main() {
  late DittoObserverStats stats;

  setUp(() => stats = DittoObserverStats());

  test('counts live observers per collection', () {
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.opened(name: 'transactionsStream', collection: 'transactions');
    stats.opened(name: 'transactionsStream', collection: 'transactions');

    expect(stats.live, 3);
    expect(stats.liveByCollection, {'transaction_items': 1, 'transactions': 2});
  });

  test('a leak shows as a count that only grows', () {
    for (var i = 0; i < 12; i++) {
      stats.opened(name: 'dashboardGauge', collection: 'transaction_items');
    }

    expect(stats.liveFor('dashboardGauge'), 12);
  });

  test('cancelling brings the count back down', () {
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.closed(name: 'cartItems', collection: 'transaction_items');

    expect(stats.liveFor('cartItems'), 1);
    expect(stats.liveByCollection, {'transaction_items': 1});
  });

  test('a collection with nothing live disappears from the summary', () {
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.closed(name: 'cartItems', collection: 'transaction_items');

    expect(stats.live, 0);
    expect(stats.liveByCollection, isEmpty);
    expect(stats.summary(), isEmpty);
  });

  test('closing more than was opened never goes negative', () {
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.closed(name: 'cartItems', collection: 'transaction_items');
    stats.closed(name: 'cartItems', collection: 'transaction_items');

    expect(stats.live, 0);
    expect(stats.liveFor('cartItems'), 0);
  });

  test('the summary names the busiest collection first', () {
    stats.opened(name: 'a', collection: 'transactions');
    stats.opened(name: 'b', collection: 'transactions');
    stats.opened(name: 'c', collection: 'transactions');
    stats.opened(name: 'd', collection: 'transaction_items');
    stats.opened(name: 'e', collection: 'variants');

    expect(stats.summary(), startsWith('transactions=3'));
  });

  test('a slow callback lands in the perf trail by name', () {
    final ditto = _FakeDitto();
    registerTrackedObserver(
      ditto: ditto,
      name: 'barTabs',
      collection: 'transactions',
      query: 'SELECT * FROM transactions',
      onChange: (_) =>
          sleep(const Duration(milliseconds: kSlowObserverCallbackMs + 10)),
    );

    ditto.store.onChange!(_FakeResult());

    expect(PerfOpTrail.instance.recent().last, startsWith('obs:barTabs('));
  });

  group('with a coalescing window', () {
    const window = Duration(milliseconds: 30);

    test('a slow delivery from the window\'s timer is timed too', () async {
      final ditto = _FakeDitto();
      var calls = 0;
      final observer = registerTrackedObserver(
        ditto: ditto,
        name: 'throttledStocks',
        collection: 'stocks',
        query: 'SELECT * FROM stocks',
        coalesce: window,
        onChange: (_) {
          calls++;
          // Only the delivery the timer makes is slow.
          if (calls == 2) {
            sleep(const Duration(milliseconds: kSlowObserverCallbackMs + 10));
          }
        },
      );
      bool named() => PerfOpTrail.instance.recent().any(
        (op) => op.startsWith('obs:throttledStocks('),
      );

      ditto.store.onChange!(_FakeResult()); // delivered at once, fast
      ditto.store.onChange!(_FakeResult()); // held for the window
      ditto.store.onChange!(_FakeResult()); // replaces it
      expect(calls, 1);
      expect(named(), isFalse);

      await Future<void>.delayed(window * 3);
      expect(calls, 2);
      expect(named(), isTrue);
      expect(
        PerfOpTrail.instance.recent().last,
        startsWith('obs:throttledStocks('),
      );
      await observer.cancel();
    });

    test('a slow first delivery is named once', () {
      final ditto = _FakeDitto();
      registerTrackedObserver(
        ditto: ditto,
        name: 'throttledFirst',
        collection: 'stocks',
        query: 'SELECT * FROM stocks',
        coalesce: window,
        onChange: (_) =>
            sleep(const Duration(milliseconds: kSlowObserverCallbackMs + 10)),
      );

      ditto.store.onChange!(_FakeResult());

      expect(
        PerfOpTrail.instance.recent().where(
          (op) => op.startsWith('obs:throttledFirst('),
        ),
        hasLength(1),
      );
    });

    test('cancelling drops a held delivery', () async {
      final ditto = _FakeDitto();
      var calls = 0;
      final observer = registerTrackedObserver(
        ditto: ditto,
        name: 'throttledCancel',
        collection: 'stocks',
        query: 'SELECT * FROM stocks',
        coalesce: window,
        onChange: (_) => calls++,
      );

      ditto.store.onChange!(_FakeResult());
      ditto.store.onChange!(_FakeResult());
      await observer.cancel();
      await Future<void>.delayed(window * 3);

      expect(calls, 1);
    });
  });

  test('results queued on `changes` are drained, not kept alive', () async {
    final ditto = _DittoWithChanges();
    final observer = registerTrackedObserver(
      ditto: ditto,
      name: 'stocks_by_ids',
      collection: 'stocks',
      query: 'SELECT * FROM stocks',
      onChange: (_) {},
    );
    final inner = ditto.store.observer;
    expect(inner.results.hasListener, isTrue);

    await observer.cancel();
    expect(inner.results.hasListener, isFalse);
    expect(inner.cancelled, isTrue);
  });

  test('cancel stops the live query at once, before any await', () async {
    final ditto = _DittoWithChanges();
    final observer = registerTrackedObserver(
      ditto: ditto,
      name: 'features',
      collection: 'business_features',
      query: 'SELECT * FROM business_features',
      onChange: (_) {},
    );

    // Call sites cancel without awaiting and close their controller next.
    final done = observer.cancel();
    expect(ditto.store.observer.cancelled, isTrue);

    await done;
    expect(ditto.store.observer.results.hasListener, isFalse);
  });

  test('a double without `changes` still registers', () async {
    final observer = registerTrackedObserver(
      ditto: _FakeDitto(),
      name: 'plain',
      collection: 'stocks',
      query: 'SELECT * FROM stocks',
      onChange: (_) {},
    );
    await observer.cancel();
  });

  test('a slow registration lands in the perf trail by name', () {
    // Opening an observer is synchronous on the UI thread; when Ditto is busy
    // it blocks there, and the stall report must say which one it was.
    registerTrackedObserver(
      ditto: _FakeDitto(
        registerDelay: const Duration(
          milliseconds: kSlowObserverRegisterMs + 20,
        ),
      ),
      name: 'categories',
      collection: 'categories',
      query: 'SELECT * FROM categories',
      onChange: (_) {},
    );

    expect(
      PerfOpTrail.instance.recent().last,
      startsWith('obs-open:categories('),
    );
  });

  test('a fast registration leaves the perf trail alone', () {
    final before = PerfOpTrail.instance.recent();

    registerTrackedObserver(
      ditto: _FakeDitto(),
      name: 'quickOne',
      collection: 'categories',
      query: 'SELECT * FROM categories',
      onChange: (_) {},
    );

    expect(PerfOpTrail.instance.recent(), before);
  });

  test('the slow-callback threshold is the documented one', () {
    // At a few observer wake-ups per cart write, this is what a tap queues
    // behind — keep it low enough to name them.
    expect(kSlowObserverCallbackMs, 250);
  });
}
