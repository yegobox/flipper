import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BarKeypad fills dots and submits on 6 digits', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarKeypad(
            enabled: true,
            title: 'Test',
            hint: 'Enter PIN',
            onSubmit: (pin) => submitted = pin,
          ),
        ),
      ),
    );

    for (final digit in ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(digit));
    }
    await tester.pump(const Duration(milliseconds: 100));

    expect(submitted, '123456');
    expect(find.byType(BarKeypad), findsOneWidget);
    expect(barPinCellCount, 6);
  });

  testWidgets('BarKeypad Clear resets entry', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarKeypad(
            enabled: true,
            title: 'Test',
            hint: 'Enter PIN',
            onSubmit: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('1'));
    await tester.tap(find.text('Clear'));
    await tester.pump();
    await tester.tap(find.text('9'));
    await tester.pump();

    expect(find.text('9'), findsOneWidget);
  });

  testWidgets('BarKeypad does not swallow keys typed into a text field', (
    tester,
  ) async {
    String? submitted;
    final controller = TextEditingController(text: 'B1');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(controller: controller),
              BarKeypad(
                enabled: true,
                title: 'Test',
                hint: 'Enter PIN',
                onSubmit: (pin) => submitted = pin,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    for (var i = 0; i < 6; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    }
    await tester.pump(const Duration(milliseconds: 100));

    // Backspace reached the field instead of the keypad.
    expect(controller.text, 'B');
    expect(submitted, isNull);
  });

  testWidgets('BarKeypad ignores keys while its route is covered', (
    tester,
  ) async {
    String? submitted;
    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        home: Scaffold(
          body: BarKeypad(
            enabled: true,
            title: 'Test',
            hint: 'Enter PIN',
            onSubmit: (pin) => submitted = pin,
          ),
        ),
      ),
    );
    navKey.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Scaffold()),
    );
    await tester.pumpAndSettle();

    for (var i = 0; i < 6; i++) {
      expect(
        await tester.sendKeyEvent(LogicalKeyboardKey.digit1),
        isFalse,
      );
    }
    await tester.pump(const Duration(milliseconds: 100));

    expect(submitted, isNull);
  });
}
