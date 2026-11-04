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

  final Future<PagedVariants> Function(String name, int page) respond;
  final names = <String>[];

  /// Every query as `term@page`.
  final calls = <String>[];

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
    calls.add('${name ?? ''}@${page ?? 0}');
    return respond(name ?? '', page ?? 0);
  }
}

PagedVariants _page(String id, {int totalCount = 1}) => PagedVariants(
  variants: [Variant(id: id, name: id, branchId: 'b1')],
  totalCount: totalCount,
);

int _runningSearches() => PerfOpTrail.instance
    .running()
    .where((op) => op.startsWith('pos_search('))
    .length;

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
      (name, _) => name.isEmpty
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
    final next = _FakeCapella((_, __) => Future.value(_page('found')));
    useCapella(next);
    container.read(searchStringProvider.notifier).emitString(value: 'in');
    await _settle();
    expect(next.names, ['in']);
    expect(container.read(provider).value!.single.id, 'found');
    sub.close();
  });

  test('after a timeout, scrolling pages the search still on screen', () async {
    OuterVariants.searchTimeout = const Duration(milliseconds: 30);
    final capella = _FakeCapella((name, page) {
      if (name.isEmpty) return Future.value(_page('all$page', totalCount: 40));
      return Completer<PagedVariants>().future;
    });
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);
    final searchesBefore = _runningSearches();

    container.read(searchStringProvider.notifier).emitString(value: 'i');
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(reported, ['search_timeout']);
    // The query still runs, so a stall or a kill still names it.
    expect(_runningSearches(), searchesBefore + 1);

    unawaited(container.read(provider.notifier).loadMore());
    await _settle();

    expect(capella.calls, ['@0', 'i@0', '@1']);
    expect(container.read(provider).value!.map((v) => v.id), ['all0', 'all1']);
    sub.close();
  });

  test('a second timed-out query keeps the slot until it ends', () async {
    OuterVariants.searchTimeout = const Duration(milliseconds: 30);
    final held = <String, Completer<PagedVariants>>{};
    final capella = _FakeCapella((name, _) {
      if (name.isEmpty) return Future.value(_page('all'));
      if (name == 'abc') return Future.value(_page('abc'));
      return (held[name] = Completer<PagedVariants>()).future;
    });
    useCapella(capella);
    final provider = outerVariantsProvider('b1');
    final sub = container.listen(provider, (_, __) {});
    await container.read(provider.future);
    final search = container.read(searchStringProvider.notifier);

    // The first one to time out is let go: the next term still runs.
    search.emitString(value: 'a');
    await Future<void>.delayed(const Duration(milliseconds: 80));
    search.emitString(value: 'ab');
    await _settle();
    expect(capella.names, ['', 'a', 'ab']);

    // With 'a' still running, 'ab' timing out holds the slot.
    await Future<void>.delayed(const Duration(milliseconds: 80));
    search.emitString(value: 'abc');
    await _settle();
    expect(capella.names, ['', 'a', 'ab']);

    held['ab']!.complete(_page('ab'));
    await _settle();
    expect(capella.names, ['', 'a', 'ab', 'abc']);
    expect(container.read(provider).value!.single.id, 'abc');
    sub.close();
  });

  test('terms typed during a search wait, and only the newest runs', () async {
    final held = Completer<PagedVariants>();
    final capella = _FakeCapella((name, _) {
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
      (name, _) => name.isEmpty
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
