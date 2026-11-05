// The Orders badge must not follow the POS search. Keying
// stockRequestsProvider by the search term rebuilt the provider and its Ditto
// observer on every term a cashier typed (Muhazi "Not Responding" on search).
// Covers both hosts: the desktop top bar (IconRow) and SearchField's toolbar.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/orders_badge_search_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'dart:async';

import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart' show Branch;
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/sync/utils/pos_catalog_search.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart'
    show Override, ProviderListenable, ProviderOrFamily;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

class _MockRouterService extends Mock implements RouterService {}

class _MockSettingsService extends Mock implements SettingsService {}

class _MockLanguage extends Mock implements Language {}

class _MockKeyPadService extends Mock implements KeyPadService {}

class _MockProductService extends Mock implements ProductService {}

class _MockAppService extends Mock implements AppService {}

class _FakeStockRequests extends StockRequests {
  static int builds = 0;
  static String? lastStatus;

  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) {
    builds++;
    lastStatus = status;
    return Stream.value([
      InventoryRequest(branchId: 'branch-1'),
      InventoryRequest(branchId: 'branch-1'),
    ]);
  }
}

/// Records which branch each stock-request stream was opened for, and which
/// are still listened to.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  final openedFor = <String>[];
  final live = <String>[];

  Stream<List<InventoryRequest>> _open(String branchId) {
    openedFor.add(branchId);
    late final StreamController<List<InventoryRequest>> requests;
    requests = StreamController<List<InventoryRequest>>(
      onListen: () {
        live.add(branchId);
        requests.add([
          InventoryRequest(id: 'req-$branchId', branchId: branchId),
        ]);
      },
      onCancel: () => live.remove(branchId),
    );
    return requests.stream;
  }

  @override
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) => _open(branchId);

  @override
  Stream<List<InventoryRequest>> requestsStreamOutgoing({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) => _open(branchId);
}

/// Incoming and outgoing requests take the same branch-switch path.
typedef _Orders = ({
  String name,
  ProviderListenable<AsyncValue<List<InventoryRequest>>> watch,
  ProviderListenable<Future<List<InventoryRequest>>> future,
  ProviderOrFamily self,
});

final _ordersProviders = <_Orders>[
  (
    name: 'incoming',
    watch: stockRequestsProvider(status: RequestStatus.pending),
    future: stockRequestsProvider(status: RequestStatus.pending).future,
    self: stockRequestsProvider(status: RequestStatus.pending),
  ),
  (
    name: 'outgoing',
    watch: outgoingStockRequestsProvider(status: RequestStatus.pending),
    future: outgoingStockRequestsProvider(status: RequestStatus.pending).future,
    self: outgoingStockRequestsProvider(status: RequestStatus.pending),
  ),
];

const _terms = ['r', 'ri', 'ric', 'rice'];

Future<void> _settle() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => registerFallbackValue(Strategy.capella));

  setUp(() async {
    await getIt.reset();
    final mockBox = MockBox();
    getIt.registerSingleton<LocalStorage>(mockBox);
    // SearchField builds a CoreViewModel, which looks these up on creation.
    getIt
      ..registerSingleton<SettingsService>(_MockSettingsService())
      ..registerSingleton<Language>(_MockLanguage())
      ..registerSingleton<KeyPadService>(_MockKeyPadService())
      ..registerSingleton<ProductService>(_MockProductService())
      ..registerSingleton<AppService>(_MockAppService());
    when(() => mockBox.getBranchId()).thenReturn('branch-1');
    when(() => mockBox.isProformaMode()).thenReturn(false);
    when(() => mockBox.isTrainingMode()).thenReturn(false);
    when(() => mockBox.readBool(key: any(named: 'key'))).thenReturn(null);
    when(
      () => mockBox.onProformaModeChanged,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockBox.onTrainingModeChanged,
    ).thenAnswer((_) => const Stream.empty());
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
    locator.registerSingleton<RouterService>(_MockRouterService());
    _FakeStockRequests.builds = 0;
    _FakeStockRequests.lastStatus = null;
  });

  tearDown(() async {
    if (locator.isRegistered<RouterService>()) {
      locator.unregister<RouterService>();
    }
    await getIt.reset();
  });

  Future<ProviderContainer> pumpHost(
    WidgetTester tester,
    Widget child, {
    required List<Override> overrides,
  }) async {
    final container = ProviderContainer(
      overrides: [
        onlineShopAvailableProvider.overrideWithValue(false),
        ...overrides,
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(body: Center(child: child)),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  Future<void> typeTerms(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    for (final term in _terms) {
      container.read(searchStringProvider.notifier).emitString(value: term);
      await tester.pump();
    }
  }

  testWidgets('typing a search keeps the Orders badge on one provider', (
    tester,
  ) async {
    final container = await pumpHost(
      tester,
      const IconRow(),
      overrides: [
        // Only the unsearched instance is faked: a badge still keyed by the
        // term would build a real one and lose the count.
        stockRequestsProvider(
          status: RequestStatus.pending,
        ).overrideWith(_FakeStockRequests.new),
      ],
    );
    expect(find.text('2'), findsOneWidget);

    await typeTerms(tester, container);

    expect(find.text('2'), findsOneWidget);
    expect(_FakeStockRequests.builds, 1);
  });

  testWidgets('typing a search keeps SearchField\'s Orders watch on one '
      'provider', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpHost(
      tester,
      SearchField(
        controller: controller,
        showOrderButton: true,
        showIncomingButton: false,
        showAddButton: false,
        showDatePicker: false,
        showNoticesButton: false,
      ),
      overrides: [
        // Every family member is faked, so a watch keyed by the term would
        // build one per term.
        stockRequestsProvider.overrideWith(_FakeStockRequests.new),
        featureAccessProvider(
          featureName: AppFeature.Orders,
          userId: '',
        ).overrideWithValue(true),
      ],
    );
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    expect(_FakeStockRequests.builds, 1);
    expect(_FakeStockRequests.lastStatus, RequestStatus.pending);

    // Typed into the field, so its controller listener and debounce run.
    for (final term in _terms) {
      await tester.enterText(find.byType(TextField), term);
      await tester.pump(posCatalogSearchDebounce * 2);
    }
    expect(controller.text, 'rice');

    expect(find.text('2'), findsOneWidget);
    expect(_FakeStockRequests.builds, 1);
    expect(_FakeStockRequests.lastStatus, RequestStatus.pending);
  });

  ({_FakeCapella capella, MockBox box, ProviderContainer container})
  ordersHarness(Stream<Branch> branch) {
    // Already seen, so no order notification fires in the test.
    SharedPreferences.setMockInitialValues({
      'seen_inventory_requests': ['req-branch-1', 'req-branch-2'],
    });
    final box = getIt<LocalStorage>() as MockBox;
    final strategy = MockSyncStrategy();
    final capella = _FakeCapella();
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
    when(() => strategy.getStrategy(any())).thenReturn(capella);
    when(() => strategy.current).thenReturn(capella);
    final container = ProviderContainer(
      overrides: [activeBranchProvider.overrideWith((ref) => branch)],
    );
    addTearDown(container.dispose);
    return (capella: capella, box: box, container: container);
  }

  for (final orders in _ordersProviders) {
    test('a branch switch reopens the ${orders.name} requests for the new '
        'branch', () async {
      final branch = StreamController<Branch>();
      addTearDown(branch.close);
      final (:capella, :box, :container) = ordersHarness(branch.stream);
      final sub = container.listen(orders.watch, (_, __) {});
      addTearDown(sub.close);

      branch.add(Branch(id: 'branch-1', name: 'One', businessId: 'b'));
      await _settle();
      await container.read(orders.future);
      expect(capella.openedFor.last, 'branch-1');

      when(() => box.getBranchId()).thenReturn('branch-2');
      branch.add(Branch(id: 'branch-2', name: 'Two', businessId: 'b'));
      await _settle();
      final requests = await container.read(orders.future);

      expect(capella.openedFor.last, 'branch-2');
      expect(capella.live, ['branch-2']);
      expect(requests.single.branchId, 'branch-2');
    });

    test('a ${orders.name} setup overtaken by a rebuild never opens its '
        'branch', () async {
      final (:capella, :box, :container) = ordersHarness(
        const Stream<Branch>.empty(),
      );
      when(() => box.getBranchId()).thenReturn('branch-1');
      final sub = container.listen(orders.watch, (_, __) {});
      addTearDown(sub.close);

      // Rebuilt for branch-2 while branch-1's setup is still awaiting.
      when(() => box.getBranchId()).thenReturn('branch-2');
      container.invalidate(orders.self);
      container.read(orders.watch);
      await _settle();
      final requests = await container.read(orders.future);

      expect(capella.openedFor, ['branch-2']);
      expect(capella.live, ['branch-2']);
      expect(requests.single.branchId, 'branch-2');
    });
  }
}
