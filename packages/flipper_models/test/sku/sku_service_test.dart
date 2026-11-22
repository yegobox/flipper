import 'dart:async';

import 'package:flipper_models/sku/sku_allocator.dart';
import 'package:flipper_models/sku/sku_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_models/brick/models/all_models.dart';

// flutter test test/sku/sku_service_test.dart
//
// createProduct, bulk add, scan-to-add and the desktop variant editor all take
// a new SKU through assignNewSku / assignVariantSku. These tests pin what keeps
// those saves working offline: no network wait, no throw, SKU pending instead.
class _MemoryStore implements SkuAllocatorStore {
  String? value;
  @override
  String? read() => value;
  @override
  Future<void> write(String v) async => value = v;
}

class _Env implements SkuAllocatorEnv {
  _Env(this.reserveImpl);

  final Future<SkuNumberRange> Function() reserveImpl;
  int calls = 0;

  @override
  bool get isLocalMode => false;

  @override
  Future<int> localMax({required String businessId}) async => 0;

  @override
  Future<SkuNumberRange> reserve({
    required String businessId,
    required int size,
  }) {
    calls++;
    return reserveImpl();
  }
}

void main() {
  tearDown(() => debugSetSkuAllocator(null));

  group('connector unreachable: the save still succeeds as SKU pending', () {
    for (final (label, impl) in <(String, Future<SkuNumberRange> Function())>[
      ('connection refused', () async => throw Exception('connection refused')),
      ('server never answers', () => Completer<SkuNumberRange>().future),
    ]) {
      test(label, () async {
        final env = _Env(impl);
        debugSetSkuAllocator(
          SkuAllocator(
            store: _MemoryStore(),
            env: env,
            reserveTimeout: const Duration(milliseconds: 100),
          ),
        );

        final watch = Stopwatch()..start();
        final assignment = await assignNewSku(
          businessId: 'biz-1',
          categoryName: 'Beverages',
        );
        watch.stop();

        expect(assignment.pending, isTrue);
        expect(assignment.sku, isNull);
        expect(watch.elapsed, lessThan(const Duration(milliseconds: 100)));
        expect(env.calls, 1, reason: 'a refill was started, not awaited');

        // What createProduct writes for that variant: it sells as before and
        // carries the pending flag for data-connector to fill in.
        final variant = Variant(
          name: 'Fanta',
          sku: assignment.sku,
          skuPending: assignment.pending,
          branchId: 'branch-1',
        );
        final doc = variant.toFlipperJson();
        expect(doc['sku'], isNull);
        expect(doc['skuPending'], isTrue);
        expect(Variant.fromJson(doc).skuPending, isTrue);
      });
    }
  });

  test(
    'with no app services at all, assignNewSku is pending, not a crash',
    () async {
      // The default allocator reads the preference store through ProxyService,
      // which is not registered in this test.
      debugSetSkuAllocator(null);
      final assignment = await assignNewSku(businessId: 'biz-1');
      expect(assignment.pending, isTrue);
    },
  );

  test('with numbers reserved, a SKU in the category prefix', () async {
    final store = _MemoryStore();
    final env = _Env(() async => const SkuNumberRange(64, 113));
    final allocator = SkuAllocator(store: store, env: env);
    debugSetSkuAllocator(allocator);
    allocator.topUp(businessId: 'biz-1');
    await allocator.settle();

    final assignment = await assignNewSku(
      businessId: 'biz-1',
      categoryName: 'Beverages',
    );
    expect(assignment.sku, 'BEV-00064');
    expect(assignment.pending, isFalse);
    expect(
      (await assignNewSku(businessId: 'biz-1', skuPrefix: 'DRK')).sku,
      'DRK-00065',
    );
  });

  group('assignVariantSku', () {
    test('one more variant takes the next suffix and no number', () async {
      final env = _Env(() async => const SkuNumberRange(1, 50));
      final allocator = SkuAllocator(store: _MemoryStore(), env: env);
      debugSetSkuAllocator(allocator);
      final assignment = await assignVariantSku(
        businessId: 'biz-1',
        siblingSkus: ['BEV-00042', 'BEV-00042-02', null, '42'],
      );
      expect(assignment.sku, 'BEV-00042-03');
      expect(env.calls, 0);
    });

    test('without a generated sibling, a fresh SKU (or pending)', () async {
      final env = _Env(() async => throw Exception('offline'));
      debugSetSkuAllocator(SkuAllocator(store: _MemoryStore(), env: env));
      final assignment = await assignVariantSku(
        businessId: 'biz-1',
        siblingSkus: ['42', null],
      );
      expect(assignment.pending, isTrue);
    });
  });

  // A variant added while editing a product (bulkUpdateVariants) used to be
  // saved with neither a SKU nor skuPending.
  group('fillMissingVariantSkus', () {
    Variant variant(String id, {String? sku, bool? skuPending}) => Variant(
      id: id,
      name: id,
      sku: sku,
      skuPending: skuPending,
      branchId: 'branch-1',
    );

    test('a new variant takes the next suffix of its siblings', () async {
      final env = _Env(() async => const SkuNumberRange(1, 50));
      debugSetSkuAllocator(SkuAllocator(store: _MemoryStore(), env: env));
      final kept = variant('a', sku: 'BEV-00042');
      final added = variant('b');
      final another = variant('c', sku: '  ');
      await fillMissingVariantSkus(
        [kept, added, another],
        otherSkus: ['BEV-00042-02'],
        assign: (siblings) =>
            assignVariantSku(businessId: 'biz-1', siblingSkus: siblings),
      );
      expect(kept.sku, 'BEV-00042', reason: 'a SKU it has is left alone');
      expect(kept.skuPending, isNull);
      expect(added.sku, 'BEV-00042-03');
      expect(added.skuPending, isFalse);
      expect(another.sku, 'BEV-00042-04');
      expect(env.calls, 0);
    });

    test('no number available: saved as SKU pending', () async {
      final added = variant('b');
      final pending = variant('p', skuPending: true);
      var calls = 0;
      await fillMissingVariantSkus(
        [added, pending],
        assign: (_) async {
          calls++;
          return const SkuAssignment.pending();
        },
      );
      expect(added.sku, isNull);
      expect(added.skuPending, isTrue);
      expect(calls, 1, reason: 'an already pending variant is left alone');
    });
  });

  group('SkuReserveClient', () {
    test('posts the contract body and reads the inclusive range', () async {
      late http.Request sent;
      final client = SkuReserveClient(
        baseUrl: 'https://connector.example',
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response('{"start": 64, "end": 113}', 200);
        }),
      );
      final range = await client.reserve(businessId: 'biz-1', size: 50);
      expect(sent.method, 'POST');
      expect(sent.url.toString(), 'https://connector.example/api/skus/reserve');
      expect(sent.body, '{"businessId":"biz-1","size":50}');
      expect((range.start, range.end), (64, 113));
    });

    test('a non-200 answer is an error (the allocator swallows it)', () async {
      final client = SkuReserveClient(
        baseUrl: 'https://connector.example/',
        httpClient: MockClient((_) async => http.Response('nope', 503)),
      );
      expect(
        () => client.reserve(businessId: 'biz-1', size: 50),
        throwsException,
      );
    });
  });
}
