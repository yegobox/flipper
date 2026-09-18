import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('presentational ordering widgets lay out', (tester) async {
    var checked = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: Column(
              children: [
                OrderingCheckbox(
                  value: checked,
                  label: 'In stock only',
                  onChanged: () => checked = true,
                ),
                const OrderingKbd('/'),
                const OrderingBadge(
                  label: '+12% vs last',
                  foreground: OrderingTokens.warn,
                  background: OrderingTokens.warnBg,
                ),
                const OrderingEmptyState(
                  icon: Icons.search_off,
                  title: 'Nothing matches',
                  hint: 'Try a shorter word.',
                ),
                OrderingSecondaryButton(
                  label: 'Add',
                  icon: Icons.add,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('In stock only'), findsOneWidget);
    await tester.tap(find.text('In stock only'));
    expect(checked, isTrue);
  });
}
