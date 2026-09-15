// The Umusada join prompt is paused: opening the ordering flow must go
// straight through instead of asking an unconnected business to join.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/umusada_join_gate_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/umusada_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the join requirement is off', () {
    // Flipping this back to true restores the prompt and should fail this
    // test, which is the reminder to re-check the flow.
    expect(UmusadaHelper.requireJoin, isFalse);
  });

  testWidgets('handleOrderingFlow continues without showing a dialog', (
    tester,
  ) async {
    var continued = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  UmusadaHelper.handleOrderingFlow(context, () => continued++),
              child: const Text('order'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('order'));
    await tester.pumpAndSettle();

    expect(continued, 1, reason: 'ordering flow should proceed immediately');
    // No join sheet, and no Umusada/Repository lookup behind it.
    expect(find.textContaining('Umusada'), findsNothing);
    expect(find.byType(Dialog), findsNothing);
  });
}
