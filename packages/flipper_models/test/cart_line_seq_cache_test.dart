import 'package:flipper_models/sync/utils/cart_line_seq_cache.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adding a line used to ask the store for the cart's highest itemSeq, so every
/// insert cost O(lines) and building a cart cost O(n²). This cache is what makes
/// an insert O(1), with a single seeding query per cart.
void main() {
  group('CartLineSeqCache', () {
    test('needs seeding once, then hands out seqs without asking again', () {
      final cache = CartLineSeqCache();

      // First insert on a cart: caller must seed from the store.
      expect(cache.nextFor('cart-1'), isNull);

      cache.record(transactionId: 'cart-1', seq: 1);
      // Every subsequent insert is answered from memory.
      for (var expected = 2; expected <= 60; expected++) {
        expect(cache.nextFor('cart-1'), expected);
        cache.record(transactionId: 'cart-1', seq: expected);
      }
      expect(cache.nextFor('cart-1'), 61);
    });

    test('seeds from a resumed cart high-water mark', () {
      final cache = CartLineSeqCache();
      // Caller queried the store and found 12 lines already there.
      cache.record(transactionId: 'resumed', seq: 13);
      expect(cache.nextFor('resumed'), 14);
    });

    test('keeps carts independent', () {
      final cache = CartLineSeqCache();
      cache.record(transactionId: 'sale', seq: 7);
      cache.record(transactionId: 'purchase', seq: 2);

      expect(cache.nextFor('sale'), 8);
      expect(cache.nextFor('purchase'), 3);
      expect(cache.nextFor('never-seen'), isNull);
    });

    test('never lowers a high-water mark', () {
      final cache = CartLineSeqCache();
      cache.record(transactionId: 'cart-1', seq: 9);
      // A stale caller must not rewind the counter onto used seqs.
      cache.record(transactionId: 'cart-1', seq: 3);
      expect(cache.nextFor('cart-1'), 10);
    });

    test('forgetting a cart forces a re-seed', () {
      final cache = CartLineSeqCache();
      cache.record(transactionId: 'cart-1', seq: 5);
      cache.forget('cart-1');
      expect(cache.nextFor('cart-1'), isNull);
    });

    test('evicts the least recently used cart, never the active one', () {
      final cache = CartLineSeqCache(maxTrackedCarts: 3);
      cache.record(transactionId: 'a', seq: 1);
      cache.record(transactionId: 'b', seq: 1);
      cache.record(transactionId: 'c', seq: 1);

      // Touch 'a' so 'b' becomes the least recently used.
      cache.record(transactionId: 'a', seq: 2);
      cache.record(transactionId: 'd', seq: 1);

      expect(cache.trackedCartCount, 3);
      expect(cache.nextFor('b'), isNull, reason: 'b was the LRU');
      expect(cache.nextFor('a'), 3);
      expect(cache.nextFor('c'), 2);
      expect(cache.nextFor('d'), 2);
    });

    test('stays bounded across many completed carts', () {
      final cache = CartLineSeqCache(maxTrackedCarts: 8);
      for (var i = 0; i < 500; i++) {
        cache.record(transactionId: 'cart-$i', seq: 1);
      }
      expect(cache.trackedCartCount, 8);
      expect(cache.nextFor('cart-499'), 2);
      expect(cache.nextFor('cart-0'), isNull);
    });

    test('ignores an empty transaction id', () {
      final cache = CartLineSeqCache();
      cache.record(transactionId: '', seq: 4);
      expect(cache.trackedCartCount, 0);
      expect(cache.nextFor(''), isNull);
    });
  });
}
