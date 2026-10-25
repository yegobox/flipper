import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('two alerts for one order in quick succession notify once', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final events = <StockTransferNotificationEvent>[];
    final sub = EventBus().on<StockTransferNotificationEvent>().listen(
      events.add,
    );
    addTearDown(sub.cancel);
    final order = OnlineOrder.fromDitto({
      'id': 'alert-o1',
      'branchId': 'br1',
      'orderNumber': 7,
      'customerName': 'Aline',
      'total': 5000,
      'currency': 'RWF',
      'status': 'new',
    });

    final alert = container.read(onlineOrderAlertProvider);
    // Both start before either has marked the order as seen.
    await Future.wait([alert(order), alert(order)]);
    await Future<void>.delayed(Duration.zero);

    expect(events.map((e) => e.requestId), ['alert-o1']);
  });

  test('a storage failure lets a later emission alert again', () async {
    // A non-list under the seen key makes the storage read throw.
    SharedPreferences.setMockInitialValues({'seen_inventory_requests': 5});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final events = <StockTransferNotificationEvent>[];
    final sub = EventBus().on<StockTransferNotificationEvent>().listen(
      events.add,
    );
    addTearDown(sub.cancel);
    final order = OnlineOrder.fromDitto({
      'id': 'alert-o2',
      'branchId': 'br1',
      'orderNumber': 8,
      'customerName': 'Aline',
      'total': 5000,
      'status': 'new',
    });
    final alert = container.read(onlineOrderAlertProvider);

    await expectLater(alert(order), throwsA(anything));
    SharedPreferences.setMockInitialValues({});
    await alert(order);
    await Future<void>.delayed(Duration.zero);

    expect(events.map((e) => e.requestId), ['alert-o2']);
  });
}
