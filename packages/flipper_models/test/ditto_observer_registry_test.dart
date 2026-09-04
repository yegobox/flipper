import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DittoObserverStats stats;

  setUp(() => stats = DittoObserverStats());

  test('counts live observers per collection', () {
    stats.opened(name: 'cartItems', collection: 'transaction_items');
    stats.opened(name: 'transactionsStream', collection: 'transactions');
    stats.opened(name: 'transactionsStream', collection: 'transactions');

    expect(stats.live, 3);
    expect(stats.liveByCollection, {
      'transaction_items': 1,
      'transactions': 2,
    });
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

  test('the slow-callback threshold is the documented one', () {
    // At a few observer wake-ups per cart write, this is what a tap queues
    // behind — keep it low enough to name them.
    expect(kSlowObserverCallbackMs, 250);
  });
}
