import 'package:flipper_dashboard/widgets/mpos/mpos_item_line.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget line) => MaterialApp(
  localizationsDelegates: FlipperLocalizationDelegates.delegates,
  supportedLocales: FlipperLocalizationDelegates.supportedLocales,
  home: Scaffold(body: line),
);

void main() {
  late int decrements;
  late int increments;
  late int deletes;

  setUp(() {
    decrements = 0;
    increments = 0;
    deletes = 0;
  });

  Widget line({required bool canEdit, bool canReduce = false}) => _app(
    MposItemLine(
      name: 'Fanta',
      unitPrice: 1000,
      baseUnitPrice: 1000,
      qty: 3,
      canEdit: canEdit,
      canReduce: canReduce,
      onDecrement: () => decrements++,
      onIncrement: () => increments++,
      onDelete: () => deletes++,
      onPriceChanged: (_) {},
      onPriceReset: () {},
    ),
  );

  Future<void> tapAll(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.tap(find.byIcon(Icons.delete_outline_rounded));
    await tester.pump();
  }

  testWidgets('a locked resumed-ticket line ignores every control', (
    tester,
  ) async {
    await tester.pumpWidget(line(canEdit: false));
    await tapAll(tester);

    expect((decrements, increments, deletes), (0, 0, 0));
    expect(find.byIcon(Icons.sell_outlined), findsNothing);
  });

  testWidgets(
    'reduce-only lowers qty and deletes but never raises or reprices',
    (tester) async {
      await tester.pumpWidget(line(canEdit: false, canReduce: true));
      await tapAll(tester);

      expect((decrements, increments, deletes), (1, 0, 1));
      expect(find.byIcon(Icons.sell_outlined), findsNothing);
    },
  );
}
