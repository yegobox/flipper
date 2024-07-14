import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flipper_rw/main.dart' as app_main;

import 'common.dart';

void main() {
  testWidgets('Test app works on Windows', (WidgetTester tester) async {
    await app_main.main();
    await tester.pumpAndSettle();

    // Find the login button
    final loginButton = find.byKey(const Key('pinLogin'));
    expect(loginButton, findsOneWidget);

    // Simulate entering an empty PIN
    // final pinField = find.byType(TextFormField);
    // await tester.enterText(pinField, '');

    // Tap the login button
    // await tester.tap(loginButton);
    // await tester.pumpAndSettle();

    // Verify that the validator error message is displayed
    // final errorText = find.text('PIN is required');
    // expect(errorText, findsOneWidget);

    // Simulate entering a non-empty PIN
    // await tester.enterText(pinField, '1234');
    // await tester.tap(loginButton);
    // await tester.pumpAndSettle();

    // ... (Add more test cases as needed)
  });
}
