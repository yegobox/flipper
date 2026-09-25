import 'package:flipper_dashboard/features/kitchen_display/providers/transaction_items_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  // Regression: Served sat in the card's tag row, which overflowed the 300px
  // column; taps on the overflowing part were outside the row and did nothing.
  testWidgets('Served on a Ready card is tappable and fires', (tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final served = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          kitchenTicketItemsProvider.overrideWith((ref, key) async => []),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: OrderColumn(
              stage: KitchenStage.ready,
              orders: const [
                KitchenOrderView(
                  order: KitchenOrder(
                    transactionId: 't1',
                    branchId: 'b',
                    stage: KitchenStage.ready,
                  ),
                ),
              ],
              onOrderMoved: (_, __, ___) {},
              onSetDueDate: (_, __) {},
              onServed: (v) => served.add(v.order.transactionId),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Served'));
    await tester.pumpAndSettle();
    expect(served, ['t1']);
  });
}
