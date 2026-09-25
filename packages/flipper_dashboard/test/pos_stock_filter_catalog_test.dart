import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

typedef _Call = ({bool? inStock, String? name, int? page});

/// Records every catalog query and answers from [respond].
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  _FakeCapella(this.respond);

  final PagedVariants Function(_Call call) respond;
  final calls = <_Call>[];

  @override
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = true}) async =>
      null;

  @override
  Future<PagedVariants> variants({
    required String branchId,
    String? productId,
    int? page,
    String? variantId,
    String? name,
    String? bcd,
    String? pchsSttsCd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemSttsCd,
    bool forPurchaseScreen = false,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
    bool forImportScreen = false,
    bool? stockSynchronized,
    List<String>? taxTyCds,
    bool scanMode = false,
    String? itemTyCd,
    bool countTotal = true,
    bool? inStock,
  }) async {
    final call = (inStock: inStock, name: name, page: page);
    calls.add(call);
    return respond(call);
  }
}

Variant _variant(String id, {double? qty}) {
  final v = Variant(id: id, name: id, branchId: 'b1', stockId: 's-$id');
  if (qty != null) {
    v.stock = Stock(id: 's-$id', branchId: 'b1', currentStock: qty);
  }
  return v;
}

void main() {
  late MockSyncStrategy strategy;
  late ProviderContainer container;

  void useCapella(_FakeCapella capella) {
    when(() => strategy.current).thenReturn(capella);
    when(() => strategy.getStrategy(any())).thenReturn(capella);
  }

  setUpAll(() => registerFallbackValue(Strategy.capella));

  setUp(() async {
    await getIt.reset();
    strategy = MockSyncStrategy();
    getIt.registerSingleton<LocalStorage>(MockBox());
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  test('POS starts on in-stock items', () {
    expect(
      container.read(posCatalogStockFilterProvider),
      PosStockFilter.inStock,
    );
  });

  test('the default catalog stays unfiltered for every other screen', () async {
    final capella = _FakeCapella(
      (_) => PagedVariants(variants: [_variant('a')], totalCount: 1),
    );
    useCapella(capella);

    await container.read(outerVariantsProvider('b1').future);

    expect(capella.calls.single.inStock, isNull);
  });

  test(
    'the POS views ask the query for their side of the stock line',
    () async {
      final capella = _FakeCapella(
        (_) => PagedVariants(variants: [_variant('a')], totalCount: 1),
      );
      useCapella(capella);

      await container.read(
        outerVariantsProvider('b1', stockFilter: PosStockFilter.inStock).future,
      );
      await container.read(
        outerVariantsProvider(
          'b1',
          stockFilter: PosStockFilter.outOfStock,
        ).future,
      );

      expect(capella.calls.map((c) => c.inStock), [true, false]);
      expect(
        posStockFilteredCatalogs('b1'),
        isNot(contains(outerVariantsProvider('b1'))),
      );
    },
  );

  test('nothing in stock is an answer, not a sync still landing', () async {
    final capella = _FakeCapella(
      (_) => PagedVariants(variants: [], totalCount: 0, stockFilteredOut: 4),
    );
    useCapella(capella);
    final provider = outerVariantsProvider(
      'b1',
      stockFilter: PosStockFilter.inStock,
    );

    final sw = Stopwatch()..start();
    await container.read(provider.future);

    // No cold-start retries (they sleep 400/900/1500ms).
    expect(capella.calls, hasLength(1));
    expect(sw.elapsedMilliseconds, lessThan(400));
    expect(container.read(provider.notifier).isEmptyByStockFilter, isTrue);
  });

  test('an empty catalog still waits for sync, as before', () async {
    final capella = _FakeCapella(
      (_) => PagedVariants(variants: [], totalCount: 0),
    );
    useCapella(capella);
    final provider = outerVariantsProvider(
      'b1',
      stockFilter: PosStockFilter.inStock,
    );

    await container.read(provider.future);

    expect(capella.calls, hasLength(4));
    expect(container.read(provider.notifier).isEmptyByStockFilter, isFalse);
  });

  test('a search lists everything, so it is never "empty by filter"', () async {
    final capella = _FakeCapella(
      (call) => (call.name ?? '').isEmpty
          ? PagedVariants(variants: [], totalCount: 0, stockFilteredOut: 4)
          : PagedVariants(variants: [_variant('sold-out')], totalCount: 1),
    );
    useCapella(capella);
    final provider = outerVariantsProvider(
      'b1',
      stockFilter: PosStockFilter.inStock,
    );
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);

    container.read(searchStringProvider.notifier).emitString(value: 'sold');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(capella.calls.last.name, 'sold');
    expect(container.read(provider).value!.single.id, 'sold-out');
    expect(container.read(provider.notifier).isEmptyByStockFilter, isFalse);
    sub.close();
  });

  test('an in-place add keeps an in-stock view honest', () async {
    final capella = _FakeCapella(
      (_) => PagedVariants(variants: [_variant('old', qty: 3)], totalCount: 1),
    );
    useCapella(capella);
    final provider = outerVariantsProvider(
      'b1',
      stockFilter: PosStockFilter.inStock,
    );
    await container.read(provider.future);

    container.read(provider.notifier).addVariants([
      _variant('stocked', qty: 2),
      _variant('sold-out', qty: 0),
      _variant('unknown'),
      // An edit that sells the listed item out drops it from this view.
      _variant('old', qty: 0),
    ]);

    expect(container.read(provider).value!.map((v) => v.id), [
      'stocked',
      'unknown',
    ]);
  });

  test('the unfiltered catalog takes every add, as before', () async {
    final capella = _FakeCapella(
      (_) => PagedVariants(variants: [_variant('old', qty: 3)], totalCount: 1),
    );
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    await container.read(provider.future);

    container.read(provider.notifier).addVariants([
      _variant('sold-out', qty: 0),
    ]);

    expect(container.read(provider).value!.map((v) => v.id), [
      'sold-out',
      'old',
    ]);
  });
}
