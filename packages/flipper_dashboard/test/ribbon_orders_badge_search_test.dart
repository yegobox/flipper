// The top bar's Orders badge must not follow the POS search. Keying
// stockRequestsProvider by the search term rebuilt the provider and its Ditto
// observer on every term a cashier typed (Muhazi "Not Responding" on search).
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/ribbon_orders_badge_search_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/inventory_request.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    final mockBox = MockBox();
    getIt.registerSingleton<LocalStorage>(mockBox);
    when(() => mockBox.getBranchId()).thenReturn('branch-1');
    when(() => mockBox.isProformaMode()).thenReturn(false);
    when(() => mockBox.isTrainingMode()).thenReturn(false);
    when(
      () => mockBox.onProformaModeChanged,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockBox.onTrainingModeChanged,
    ).thenAnswer((_) => const Stream.empty());
    _FakeStockRequests.builds = 0;
  });

  tearDown(() async => getIt.reset());

  testWidgets('typing a search keeps the Orders badge on one provider', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        onlineShopAvailableProvider.overrideWithValue(false),
        // Only the unsearched instance is faked: a badge still keyed by the
        // term would build a real one and lose the count.
        stockRequestsProvider(
          status: RequestStatus.pending,
        ).overrideWith(_FakeStockRequests.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: const Scaffold(body: Center(child: IconRow())),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    for (final term in ['r', 'ri', 'ric', 'rice']) {
      container.read(searchStringProvider.notifier).emitString(value: term);
      await tester.pump();
    }

    expect(find.text('2'), findsOneWidget);
    expect(_FakeStockRequests.builds, 1);
  });
}
