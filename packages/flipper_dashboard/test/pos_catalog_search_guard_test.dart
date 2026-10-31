import 'dart:async';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// Answers each catalog query with whatever [respond] returns for its search
/// term, so a test can hold a query open.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  _FakeCapella(this.respond);

  final Future<PagedVariants> Function(String name) respond;
  final names = <String>[];

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
  }) {
    names.add(name ?? '');
    return respond(name ?? '');
  }
}

PagedVariants _page(String id) => PagedVariants(
  variants: [Variant(id: id, name: id, branchId: 'b1')],
  totalCount: 1,
);

Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late MockSyncStrategy strategy;
  late ProviderContainer container;
  late List<String> reported;
  final defaultTimeout = OuterVariants.searchTimeout;

  setUpAll(() => registerFallbackValue(Strategy.capella));

  setUp(() async {
    await getIt.reset();
    strategy = MockSyncStrategy();
    getIt.registerSingleton<LocalStorage>(MockBox());
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
    container = ProviderContainer();
    reported = [];
    PerfOpTrail.instance.useReporter((event, _) => reported.add(event));
  });

  tearDown(() {
    container.dispose();
    OuterVariants.searchTimeout = defaultTimeout;
    PerfOpTrail.instance.useReporter(null);
  });

  void useCapella(_FakeCapella capella) {
    when(() => strategy.current).thenReturn(capella);
    when(() => strategy.getStrategy(any())).thenReturn(capella);
  }

  test('a search that never answers leaves the grid as it was', () async {
    OuterVariants.searchTimeout = const Duration(milliseconds: 30);
    final capella = _FakeCapella(
      (name) => name.isEmpty
          ? Future.value(_page('shown'))
          : Completer<PagedVariants>().future,
    );
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);

    container.read(searchStringProvider.notifier).emitString(value: 'i');
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final state = container.read(provider);
    expect(state.hasError, isFalse);
    expect(state.value!.single.id, 'shown');
    expect(reported, ['search_timeout']);

    // The slot is free again: the next term runs and paints.
    capella.names.clear();
    final next = _FakeCapella((_) => Future.value(_page('found')));
    useCapella(next);
    container.read(searchStringProvider.notifier).emitString(value: 'in');
    await _settle();
    expect(next.names, ['in']);
    expect(container.read(provider).value!.single.id, 'found');
    sub.close();
  });

  test('terms typed during a search wait, and only the newest runs', () async {
    final held = Completer<PagedVariants>();
    final capella = _FakeCapella((name) {
      if (name.isEmpty) return Future.value(_page('all'));
      if (name == 'a') return held.future;
      return Future.value(_page(name));
    });
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);

    final search = container.read(searchStringProvider.notifier);
    search.emitString(value: 'a');
    await _settle();
    search.emitString(value: 'ab');
    await _settle();
    search.emitString(value: 'abc');
    await _settle();
    expect(capella.names, ['', 'a']);

    held.complete(_page('a'));
    await _settle();

    expect(capella.names, ['', 'a', 'abc']);
    expect(container.read(provider).value!.single.id, 'abc');
    sub.close();
  });

  test('a failing search still shows its error and frees the slot', () async {
    final capella = _FakeCapella(
      (name) => name.isEmpty
          ? Future.value(_page('all'))
          : Future.error(StateError('store closed')),
    );
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);

    container.read(searchStringProvider.notifier).emitString(value: 'x');
    await _settle();
    expect(container.read(provider).hasError, isTrue);

    container.read(searchStringProvider.notifier).emitString(value: 'xy');
    await _settle();
    expect(capella.names, ['', 'x', 'xy']);
    sub.close();
  });
}
