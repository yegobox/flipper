// The Orders badge must not follow the POS search. Keying
// stockRequestsProvider by the search term rebuilt the provider and its Ditto
// observer on every term a cashier typed (Muhazi "Not Responding" on search).
// Covers both hosts: the desktop top bar (IconRow) and SearchField's toolbar.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/orders_badge_search_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
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
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) {
    builds++;
    return Stream.value([
      InventoryRequest(branchId: 'branch-1'),
      InventoryRequest(branchId: 'branch-1'),
    ]);
  }
}

const _terms = ['r', 'ri', 'ric', 'rice'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    final container = await pumpHost(
      tester,
      SearchField(
        controller: controller,
        showOrderButton: false,
        showIncomingButton: false,
        showAddButton: false,
        showDatePicker: false,
        showNoticesButton: false,
      ),
      // Every family member is faked, so a watch keyed by the term would
      // build one per term.
      overrides: [stockRequestsProvider.overrideWith(_FakeStockRequests.new)],
    );
    expect(_FakeStockRequests.builds, 1);

    await typeTerms(tester, container);

    expect(_FakeStockRequests.builds, 1);
  });
}
