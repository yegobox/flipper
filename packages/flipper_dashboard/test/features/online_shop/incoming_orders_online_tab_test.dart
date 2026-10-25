import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/online_orders_view.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/online_shop/online_orders_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _Incoming extends StockRequests {
  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) => Stream.value(const []);
}

class _Outgoing extends OutgoingStockRequests {
  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) => Stream.value(const []);
}

class _Available extends Notifier<bool> {
  @override
  bool build() => true;

  void set(bool value) => state = value;
}

final _available = NotifierProvider<_Available, bool>(_Available.new);

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('losing the shop while on Online falls back to Incoming', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        stockRequestsProvider.overrideWith(_Incoming.new),
        outgoingStockRequestsProvider.overrideWith(_Outgoing.new),
        activeBranchProvider.overrideWith(
          (ref) => Stream.value(
            Branch(id: 'br1', name: 'Main', businessId: 'b1', isDefault: true),
          ),
        ),
        sideMenuShowIncomingOrdersProvider.overrideWithValue(false),
        onlineShopAvailableProvider.overrideWith(
          (ref) => ref.watch(_available),
        ),
        onlineShopBranchIdProvider.overrideWithValue('br1'),
        newOnlineOrdersCountProvider.overrideWithValue(0),
        onlineOrdersProvider(
          'br1',
        ).overrideWith((ref) => Stream.value(const [])),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const Scaffold(body: IncomingOrdersScreen()),
        ),
      ),
    );
    // pumpAndSettle times out on this screen, so pump a fixed time.
    await _settle(tester);

    await tester.tap(find.text('Online'));
    await _settle(tester);
    expect(find.byType(OnlineOrdersView), findsOneWidget);

    container.read(_available.notifier).set(false);
    await _settle(tester);
    expect(find.text('Online'), findsNothing);
    expect(find.byType(OnlineOrdersView), findsNothing);
    expect(find.text('Received Orders'), findsOneWidget);
  });
}
