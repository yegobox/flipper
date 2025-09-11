
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/login/pin_screen.dart';

void main() {
  testWidgets('PinScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: PinScreen()));

    // Verify that the title is rendered.
    expect(find.text('Enter PIN'), findsOneWidget);

    // Verify that the PIN input field is rendered.
    expect(find.byKey(const Key('pinInput')), findsOneWidget);

    // Verify that the Submit button is rendered.
    expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
  });
}
