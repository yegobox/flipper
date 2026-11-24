import 'dart:async';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// The POS grid on a 2 GB phone (PostHog `ui_stall`, Infinix X657): every
/// page fetch walked the whole catalog, and every repaint re-registered the
/// page's stock observer — synchronous Ditto calls on the UI thread.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  _FakeCapella(this.pages);

  /// Page index -> variants on it.
  final Map<int, List<Variant>> pages;
  final countTotals = <bool>[];
  final watched = <List<String>>[];

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
    List<String>? excludeVariantIds,
  }) async {
    countTotals.add(countTotal);
    return PagedVariants(
      variants: pages[page ?? 0] ?? const [],
      totalCount: countTotal ? 30 : null,
    );
  }

  @override
  Stream<Map<String, Stock?>> watchStocksByIds(List<String> stockIds) {
    watched.add(stockIds);
    return const Stream.empty();
  }
}

Variant _variant(String id) =>
    Variant(id: id, name: id, branchId: 'b1', stockId: 's-$id');

List<Variant> _page(int page) => [
  for (var i = 0; i < 15; i++) _variant('p$page-$i'),
];

void main() {
  late MockSyncStrategy strategy;
  late ProviderContainer container;
  late _FakeCapella capella;

  setUpAll(() => registerFallbackValue(Strategy.capella));

  setUp(() async {
    await getIt.reset();
    strategy = MockSyncStrategy();
    getIt.registerSingleton<LocalStorage>(MockBox());
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
    capella = _FakeCapella({0: _page(0), 1: _page(1)});
    when(() => strategy.current).thenReturn(capella);
    when(() => strategy.getStrategy(any())).thenReturn(capella);
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  final catalog = outerVariantsProvider(
    'b1',
    stockFilter: PosStockFilter.inStock,
  );
  final stocks = stocksForVisibleVariantsProvider(
    'b1',
    stockFilter: PosStockFilter.inStock,
  );

  test(
    'scrolling for more keeps the total, so the catalog is walked once',
    () async {
      await container.read(catalog.future);
      expect(capella.countTotals, [true]);

      await container.read(catalog.notifier).loadMore();

      // countTotal: false is what lets variants() page through the walk it
      // already did instead of decoding the whole catalog again.
      expect(capella.countTotals, [true, false]);
      expect(container.read(catalog).value, hasLength(30));
    },
  );

  test('a page has one stock observer, re-opened only for new rows', () async {
    final sub = container.listen(stocks, (_, __) {});
    await container.read(catalog.future);
    await pumpEventQueue();

    expect(capella.watched, hasLength(1));
    expect(capella.watched.single, hasLength(15));

    // Repaints with the same rows: a cached page swapped back in, an edit
    // that re-adds a listed variant.
    final notifier = container.read(catalog.notifier);
    await notifier.fetchPage(0);
    notifier.addVariants([_variant('p0-0')]);
    await pumpEventQueue();
    expect(capella.watched, hasLength(1));

    // New rows on screen: one new observer for the whole page.
    await notifier.loadMore();
    await pumpEventQueue();
    expect(capella.watched, hasLength(2));
    expect(capella.watched.last, hasLength(30));
    sub.close();
  });

  test('an empty page opens no observer', () async {
    capella.pages.clear();
    final sub = container.listen(stocks, (_, __) {});
    await container.read(catalog.future);
    await pumpEventQueue();

    expect(capella.watched, isEmpty);
    expect(container.read(stocks).value, isEmpty);
    sub.close();
  });
}
