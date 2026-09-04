import 'package:flipper_models/sync/utils/cart_line_doc_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartLineDocCache cache;

  setUp(() => cache = CartLineDocCache());

  test('a cart answers for itself only once seeded', () {
    expect(cache.isSeeded('txn-1'), isFalse);

    cache.seed(transactionId: 'txn-1', rows: const []);

    expect(cache.isSeeded('txn-1'), isTrue);
    expect(
      cache.lineFor(transactionId: 'txn-1', variantId: 'v1'),
      isNull,
      reason: 'an empty cart must answer "no line", not "ask the store"',
    );
  });

  test('seeding adopts the persisted lines', () {
    cache.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1', 'qty': 3},
      {'variantId': 'v2', '_id': 'doc-2', 'qty': 1},
    ]);

    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1')?['qty'], 3);
    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v2')?['_id'],
        'doc-2');
  });

  test('seeding replaces — a partial snapshot silently drops other lines', () {
    cache.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1', 'qty': 3},
      {'variantId': 'v2', '_id': 'doc-2', 'qty': 1},
    ]);

    // What the cart's observer supplies: its query is filtered (active /
    // doneWithTransaction / branchId), so a line the filter excludes — or one
    // another device added — simply is not in the rows it seeds with.
    cache.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1', 'qty': 3},
    ]);

    expect(
      cache.lineFor(transactionId: 'txn-1', variantId: 'v2'),
      isNull,
      reason: 'a miss here can be a lie, so the add path must confirm one '
          'against the store before inserting — otherwise v2 gets a second row',
    );
    expect(cache.isSeeded('txn-1'), isTrue);
  });

  test('rows without a variant id are not indexable and are skipped', () {
    cache.seed(transactionId: 'txn-1', rows: [
      {'_id': 'doc-1', 'qty': 3},
      {'variantId': '', '_id': 'doc-2'},
      {'variantId': 'v3', '_id': 'doc-3'},
    ]);

    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v3'), isNotNull);
    expect(cache.lineFor(transactionId: 'txn-1', variantId: ''), isNull);
  });

  test('a recorded write is what the next tap reads', () {
    cache.seed(transactionId: 'txn-1', rows: const []);
    cache.record(
      transactionId: 'txn-1',
      variantId: 'v1',
      row: {'_id': 'doc-1', 'qty': 1},
    );

    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1')?['qty'], 1);

    cache.record(
      transactionId: 'txn-1',
      variantId: 'v1',
      row: {'_id': 'doc-1', 'qty': 2},
    );

    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1')?['qty'], 2);
  });

  test('a recorded row is copied, not aliased', () {
    final row = <String, dynamic>{'_id': 'doc-1', 'qty': 1};
    cache.record(transactionId: 'txn-1', variantId: 'v1', row: row);

    row['qty'] = 99;

    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1')?['qty'], 1);
  });

  test('forgetting a cart sends the next write back to the store', () {
    cache.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1', 'qty': 3},
    ]);

    cache.forget('txn-1');

    expect(cache.isSeeded('txn-1'), isFalse);
    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1'), isNull);
  });

  test('carts do not read each other', () {
    cache.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1', 'qty': 3},
    ]);
    cache.seed(transactionId: 'txn-2', rows: const []);

    expect(cache.lineFor(transactionId: 'txn-2', variantId: 'v1'), isNull);
    expect(cache.lineFor(transactionId: 'txn-1', variantId: 'v1'), isNotNull);
    cache.forget('txn-2');
    expect(cache.isSeeded('txn-1'), isTrue);
  });

  test('finished carts do not accumulate for the life of the process', () {
    final bounded = CartLineDocCache(maxTrackedCarts: 3);
    for (var i = 0; i < 10; i++) {
      bounded.seed(transactionId: 'txn-$i', rows: [
        {'variantId': 'v1', '_id': 'doc-$i'},
      ]);
    }

    expect(bounded.trackedCartCount, 3);
    expect(bounded.isSeeded('txn-9'), isTrue);
    expect(bounded.isSeeded('txn-0'), isFalse,
        reason: 'the least recently used cart is evicted first');
  });

  test('an evicted cart re-seeds rather than answering wrongly', () {
    final bounded = CartLineDocCache(maxTrackedCarts: 1);
    bounded.seed(transactionId: 'txn-1', rows: [
      {'variantId': 'v1', '_id': 'doc-1'},
    ]);
    bounded.seed(transactionId: 'txn-2', rows: const []);

    expect(bounded.isSeeded('txn-1'), isFalse);
    expect(bounded.lineFor(transactionId: 'txn-1', variantId: 'v1'), isNull);
  });

  test('touching a cart keeps it from being evicted', () {
    final bounded = CartLineDocCache(maxTrackedCarts: 2);
    bounded.seed(transactionId: 'txn-1', rows: const []);
    bounded.seed(transactionId: 'txn-2', rows: const []);
    // txn-1 is the least recently used until it is written to again.
    bounded.record(
      transactionId: 'txn-1',
      variantId: 'v1',
      row: {'_id': 'doc-1'},
    );
    bounded.seed(transactionId: 'txn-3', rows: const []);

    expect(bounded.isSeeded('txn-1'), isTrue);
    expect(bounded.isSeeded('txn-2'), isFalse);
  });
}
