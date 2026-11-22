import 'dart:async';

import 'package:flipper_models/sku/sku_allocator.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/sku/sku_allocator_test.dart
class _MemoryStore implements SkuAllocatorStore {
  String? value;

  /// Set to make the next writes fail (disk full, file locked).
  Object? failWith;

  @override
  String? read() => value;

  @override
  Future<void> write(String v) async {
    if (failWith != null) throw failWith!;
    value = v;
  }
}

/// A server with a row-locked counter, like `reserve_sku_block`.
class _FakeEnv implements SkuAllocatorEnv {
  _FakeEnv({this.isLocalMode = false, this.localMaxValue = 0});

  @override
  bool isLocalMode;
  int localMaxValue;
  int nextOnServer = 1;
  int reserveCalls = 0;
  int localMaxCalls = 0;

  /// Set to make the connector unreachable.
  Object? failWith;

  /// Set to make the connector hang (never answers).
  bool hang = false;

  @override
  Future<SkuNumberRange> reserve({
    required String businessId,
    required int size,
  }) async {
    reserveCalls++;
    if (hang) return Completer<SkuNumberRange>().future;
    if (failWith != null) throw failWith!;
    final start = nextOnServer;
    nextOnServer += size;
    return SkuNumberRange(start, start + size - 1);
  }

  @override
  Future<int> localMax({required String businessId}) async {
    localMaxCalls++;
    return localMaxValue;
  }
}

void main() {
  const biz = 'biz-1';

  SkuAllocator allocator(
    _FakeEnv env, {
    _MemoryStore? store,
    int blockSize = 50,
    int refillBelow = 10,
  }) => SkuAllocator(
    store: store ?? _MemoryStore(),
    env: env,
    blockSize: blockSize,
    refillBelow: refillBelow,
    reserveTimeout: const Duration(milliseconds: 200),
  );

  test('defaults: blocks of 50, refill below 10', () {
    final a = SkuAllocator(store: _MemoryStore(), env: _FakeEnv());
    expect(a.blockSize, 50);
    expect(a.refillBelow, 10);
  });

  group('offline safety', () {
    test('an empty block returns null at once and never waits', () async {
      final env = _FakeEnv()..hang = true;
      final a = allocator(env);
      final watch = Stopwatch()..start();
      final number = await a.next(businessId: biz);
      watch.stop();
      expect(number, isNull, reason: 'saved as SKU pending');
      expect(watch.elapsed, lessThan(const Duration(milliseconds: 100)));
      // The refill was started in the background, not awaited.
      expect(env.reserveCalls, 1);
    });

    test('an unreachable connector never throws into the save', () async {
      final env = _FakeEnv()..failWith = Exception('connection refused');
      final errors = <Object>[];
      final a = allocator(env)..onRefillError = errors.add;
      expect(await a.next(businessId: biz), isNull);
      await a.settle();
      expect(errors, hasLength(1));
      expect(a.remaining(businessId: biz), 0);
    });

    test('a hanging connector times out in the background', () async {
      final env = _FakeEnv()..hang = true;
      final errors = <Object>[];
      final a = allocator(env)..onRefillError = errors.add;
      expect(await a.next(businessId: biz), isNull);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(errors.single, isA<TimeoutException>());
    });

    test('the block is spent offline, without the server', () async {
      final env = _FakeEnv();
      final a = allocator(env, blockSize: 50, refillBelow: 10);
      a.topUp(businessId: biz);
      await a.settle();
      expect(a.remaining(businessId: biz), 50);

      env.failWith = Exception('offline');
      final numbers = <int?>[];
      for (var i = 0; i < 50; i++) {
        numbers.add(await a.next(businessId: biz));
      }
      await a.settle();
      expect(numbers, [for (var i = 1; i <= 50; i++) i]);
      // Exhausted while offline: the next item is SKU pending.
      expect(await a.next(businessId: biz), isNull);
    });
  });

  group('refill', () {
    test(
      'starts in the background when fewer than refillBelow remain',
      () async {
        final env = _FakeEnv();
        final a = allocator(env, blockSize: 20, refillBelow: 10);
        a.topUp(businessId: biz);
        await a.settle();
        expect(env.reserveCalls, 1);

        for (var i = 0; i < 10; i++) {
          await a.next(businessId: biz);
        }
        await a.settle();
        // 10 left: not below the threshold yet.
        expect(env.reserveCalls, 1);

        await a.next(businessId: biz);
        await a.settle();
        expect(env.reserveCalls, 2);
        expect(a.remaining(businessId: biz), 9 + 20);
      },
    );

    test('rolls over to the queued block with no gap in use', () async {
      final env = _FakeEnv();
      final a = allocator(env, blockSize: 3, refillBelow: 2);
      a.topUp(businessId: biz);
      await a.settle();
      final got = <int?>[];
      for (var i = 0; i < 6; i++) {
        got.add(await a.next(businessId: biz));
        await a.settle();
      }
      expect(got, [1, 2, 3, 4, 5, 6]);
    });

    test('topUp does nothing when enough numbers remain', () async {
      final env = _FakeEnv();
      final a = allocator(env);
      a.topUp(businessId: biz);
      await a.settle();
      a.topUp(businessId: biz);
      await a.settle();
      expect(env.reserveCalls, 1);
    });

    test('concurrent refills share one request', () async {
      final env = _FakeEnv();
      final a = allocator(env);
      a.topUp(businessId: biz);
      a.topUp(businessId: biz);
      await a.next(businessId: biz);
      await a.settle();
      expect(env.reserveCalls, 1);
    });

    test('blocks are kept per business', () async {
      final env = _FakeEnv();
      final a = allocator(env, blockSize: 5);
      a.topUp(businessId: 'a');
      await a.settle();
      a.topUp(businessId: 'b');
      await a.settle();
      expect(await a.next(businessId: 'a'), 1);
      expect(await a.next(businessId: 'b'), 6);
    });
  });

  test('two saves at once never get the same number', () async {
    final env = _FakeEnv();
    final a = allocator(env);
    a.topUp(businessId: biz);
    await a.settle();
    final results = await Future.wait([
      for (var i = 0; i < 30; i++) a.next(businessId: biz),
    ]);
    expect(results.toSet(), hasLength(30));
    expect(results.contains(null), isFalse);
  });

  test('state survives a restart (store reread)', () async {
    final store = _MemoryStore();
    final env = _FakeEnv();
    final first = allocator(env, store: store);
    first.topUp(businessId: biz);
    await first.settle();
    expect(await first.next(businessId: biz), 1);

    final second = allocator(env, store: store);
    expect(await second.next(businessId: biz), 2);
  });

  test('a corrupt store is treated as empty, not a crash', () async {
    final store = _MemoryStore()..value = '{not json';
    final env = _FakeEnv()..failWith = Exception('offline');
    final a = allocator(env, store: store);
    expect(await a.next(businessId: biz), isNull);
  });

  group('peek', () {
    test('shows the next number without taking it', () async {
      final env = _FakeEnv();
      final a = allocator(env);
      expect(a.peek(businessId: biz), isNull);
      a.topUp(businessId: biz);
      await a.settle();
      expect(a.peek(businessId: biz), 1);
      expect(a.peek(businessId: biz), 1);
      expect(await a.next(businessId: biz), 1);
      expect(a.peek(businessId: biz), 2);
    });
  });

  group('Local Mode', () {
    test('counts locally from the highest existing SKU, no network', () async {
      final env = _FakeEnv(isLocalMode: true, localMaxValue: 63);
      final a = allocator(env);
      a.topUp(businessId: biz);
      expect(await a.next(businessId: biz), 64);
      expect(await a.next(businessId: biz), 65);
      await a.settle();
      expect(env.reserveCalls, 0);
      expect(env.localMaxCalls, 1, reason: 'seeded once, then counted');
      expect(a.peek(businessId: biz), 66);
    });

    test('a store with no SKUs starts at 1', () async {
      final env = _FakeEnv(isLocalMode: true);
      final a = allocator(env);
      expect(await a.next(businessId: biz), 1);
      expect(env.reserveCalls, 0);
    });

    test('numbers used in Local Mode never come back from a block', () async {
      final env = _FakeEnv();
      final store = _MemoryStore();
      final a = allocator(env, store: store);
      a.topUp(businessId: biz);
      await a.settle();
      expect(a.peek(businessId: biz), 1, reason: 'block 1..50 reserved');

      // Local Mode counts from the items on this device, so it reuses the
      // reserved range.
      env.isLocalMode = true;
      final local = [
        for (var i = 0; i < 12; i++) (await a.next(businessId: biz))!,
      ];
      expect(local.first, 1);

      env.isLocalMode = false;
      final server = [
        for (var i = 0; i < 45; i++) await a.next(businessId: biz),
      ];
      await a.settle();
      final issued = server.whereType<int>().toList();
      expect(issued.toSet().intersection(local.toSet()), isEmpty);
      expect(issued.first, 13, reason: 'the block skips past Local Mode');
      expect(issued.toSet(), hasLength(issued.length));
    });

    test('a queued block below the local counter is dropped', () async {
      final env = _FakeEnv(isLocalMode: true, localMaxValue: 120);
      final store = _MemoryStore()
        ..value =
            '{"$biz":{"next":10,"end":59,"queuedStart":100,"queuedEnd":149}}';
      final a = allocator(env, store: store);
      expect(await a.next(businessId: biz), 121);

      env.isLocalMode = false;
      expect(a.remaining(businessId: biz), 28, reason: '122..149');
      expect(a.peek(businessId: biz), 122);
      expect(await a.next(businessId: biz), 122);
    });

    test(
      'Local Mode, online, Local Mode again never repeats a number',
      () async {
        final env = _FakeEnv(isLocalMode: true);
        final a = allocator(env);
        expect(await a.next(businessId: biz), 1);

        env.isLocalMode = false;
        a.topUp(businessId: biz);
        await a.settle();
        expect(await a.next(businessId: biz), 2, reason: 'block skips 1');

        env.isLocalMode = true;
        expect(await a.next(businessId: biz), 3, reason: '2 went online');
      },
    );

    test(
      'a refill replaces blocks that fell behind the local counter',
      () async {
        // Both stored blocks are below localNext: nothing is usable, and the
        // refill must not keep them and discard the new block.
        final env = _FakeEnv()..nextOnServer = 500;
        final store = _MemoryStore()
          ..value =
              '{"$biz":{"next":10,"end":59,"queuedStart":100,"queuedEnd":149,'
              '"localNext":300}}';
        final a = allocator(env, store: store);

        expect(await a.next(businessId: biz), isNull, reason: 'nothing usable');
        await a.settle();
        expect(env.reserveCalls, 1);
        expect(await a.next(businessId: biz), 500);
        expect(a.remaining(businessId: biz), 49);
      },
    );
  });

  group('a cursor that cannot be stored', () {
    test('hands out no number: the item saves as SKU pending', () async {
      final env = _FakeEnv();
      final store = _MemoryStore();
      final errors = <Object>[];
      final a = allocator(env, store: store)..onWriteError = errors.add;
      a.topUp(businessId: biz);
      await a.settle();

      store.failWith = const _WriteFailure('disk full');
      expect(await a.next(businessId: biz), isNull);
      expect(errors, hasLength(1));

      // Once the disk is writable again, numbers resume from the stored
      // cursor: the number that was never handed out is used now.
      store.failWith = null;
      expect(await a.next(businessId: biz), 1);
      expect(await a.next(businessId: biz), 2);
    });

    test('in Local Mode too', () async {
      final env = _FakeEnv(isLocalMode: true, localMaxValue: 4);
      final store = _MemoryStore()..failWith = const _WriteFailure('locked');
      final a = allocator(env, store: store);
      expect(await a.next(businessId: biz), isNull);
      store.failWith = null;
      expect(await a.next(businessId: biz), 5);
    });
  });
}

class _WriteFailure implements Exception {
  const _WriteFailure(this.message);
  final String message;
}
