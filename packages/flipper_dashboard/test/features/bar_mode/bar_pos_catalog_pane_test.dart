import 'package:flipper_dashboard/features/bar_mode/widgets/bar_pos_catalog_pane.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

/// Records the stock side of every catalog query the pane triggers.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  final inStockArgs = <bool?>[];

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
    inStockArgs.add(inStock);
    // Not empty: an empty catalog reads as a sync still landing and retries.
    final v = Variant(id: 'v1', name: 'Primus', branchId: branchId)
      ..stock = Stock(id: 's1', branchId: branchId, currentStock: 3);
    return PagedVariants(variants: [v], totalCount: 1);
  }
}

void main() {
  late _FakeCapella capella;

  setUpAll(() => registerFallbackValue(Strategy.capella));

  setUp(() async {
    await getIt.reset();
    capella = _FakeCapella();
    final strategy = MockSyncStrategy();
    when(() => strategy.current).thenReturn(capella);
    when(() => strategy.getStrategy(any())).thenReturn(capella);
    getIt.registerSingleton<LocalStorage>(MockBox());
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
  });

  Future<void> pumpPane(WidgetTester tester, {PosStockFilter? filter}) async {
    final container = ProviderContainer(
      overrides: [
        for (final f in PosStockFilter.values)
          stocksForVisibleVariantsProvider(
            'b1',
            stockFilter: f,
          ).overrideWith((ref) => Stream.value(const {})),
      ],
    );
    addTearDown(container.dispose);
    if (filter != null) {
      container.read(posCatalogStockFilterProvider.notifier).set(filter);
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: BarPosCatalogPane(branchId: 'b1', onAdd: (_) async {}),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('bar lists in-stock items by default, like the POS grid', (
    tester,
  ) async {
    await pumpPane(tester);

    expect(capella.inStockArgs, isNotEmpty);
    expect(capella.inStockArgs.toSet(), {true});
  });

  testWidgets('bar follows the POS stock view when it is switched', (
    tester,
  ) async {
    await pumpPane(tester, filter: PosStockFilter.all);

    expect(capella.inStockArgs, isNotEmpty);
    expect(capella.inStockArgs.toSet(), {null});
  });
}
