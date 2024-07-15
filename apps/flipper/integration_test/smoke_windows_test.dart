import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flipper_rw/main.dart' as app_main;
import 'package:flipper_ui/flipper_ui.dart';
import 'common.dart';

// patrol test  --target integration_test/smoke_windows_test.dart
void main() {
  testWidgets('Test app works on Windows', (WidgetTester tester) async {
    await app_main.main();
    await tester.pumpAndSettle();

    // Find the login button
    final loginButton = find.byKey(const Key('pinLogin_desktop'));
    expect(loginButton, findsOneWidget);

    await tester.pumpAndSettle();
    // navigat to pin login screen
    await tester.tap(loginButton);
    // await tester.pumpAndSettle();

    // Simulate entering an empty PIN
    final pinField = find.byType(TextFormField);
    await tester.enterText(pinField, '');

    // Tap the login button
    await tester.tap(find.widgetWithText(BoxButton, 'Log in'));
    await tester.pumpAndSettle();

    // Verify that the validator error message is displayed
    final errorText = find.text('PIN is required');
    expect(errorText, findsOneWidget);

    // Simulate entering a non-empty PIN
    await tester.enterText(pinField, '1234');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(errorText, findsNothing);

    final pinNotFoundError = find.text('Pin: Not found');
    expect(pinNotFoundError, findsOneWidget);

    // Simulate entering a real PIN
    await tester.enterText(pinField, '73268');
    await tester.tap(find.widgetWithText(BoxButton, 'Log in'));
    await tester.pumpAndSettle();
    expect(pinNotFoundError, findsNothing);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    /// click on  EOD from ribbon
    await tester.tap(find.byKey(const Key('eod_desktop')));

    // should see the drawer screen
    final drawer = find.byKey(const Key('openDrawerPage'));
    expect(drawer, findsOneWidget);
  });
}
