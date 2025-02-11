import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_rw/main.dart' as app_main;
import 'common.dart';

// Constants for widget keys and text
const String mainApp = 'mainApp';
const String eodDesktopKey = 'eod_desktop';
const String pinLoginDesktopKey = 'pinLogin_desktop';
const String pinLoginKey = 'PinLogin';
const String pinLoginButtonKey = 'pinLoginButton_desktop';
const String pinRequiredText = 'PIN is required';
const String pinNotFoundText = 'Pin: Not found';
Future<void> restoreFlutterError(Future<void> Function() call) async {
  final originalOnError = FlutterError.onError!;
  await call();
  final overriddenOnError = FlutterError.onError!;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (overriddenOnError != originalOnError) overriddenOnError(details);
    originalOnError(details);
  };
}

void main() {
  group('Windows App Smoke Test', () {
    // Store the original error handler.
    FlutterError.onError = (FlutterErrorDetails details) {
      // Handle the error (e.g., log it or fail the test)
      throw details.exception;
    };

    testWidgets('Test app initialization and login flow',
        (WidgetTester tester) async {
      await startApp(tester);

      // Check if already logged in
      if (await isLoggedIn(tester)) {
        await navigateToEodAndBack(tester);
      }

      // await testLoginFlow(tester);
      // await testPinValidation(tester);
      // await testEodNavigation(tester);
    });
  });
}

/// Tests the login button and navigation to the PIN login screen.
Future<void> testLoginFlow(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));
  
  final backToLogin = find.byKey(const Key(pinLoginDesktopKey));
  expect(backToLogin, findsOneWidget);
  //
}

/// Starts the app and waits for it to load.
Future<void> startApp(WidgetTester tester) async {
  await restoreFlutterError(() async {
    await app_main.main();
    await tester.pumpAndSettle();
  });
}

/// Checks if the user is logged in by looking for the 'QuickSell' key.
Future<bool> isLoggedIn(WidgetTester tester) async {
  final quickSell = find.byKey(const Key(mainApp));
  return tester.any(quickSell);
}

/// Navigates to the EOD screen and back to the login screen.
Future<void> navigateToEodAndBack(WidgetTester tester) async {
  await tester.tap(find.descendant(
    of: find.byType(GestureDetector),
    matching: find.byKey(const Key('eod_desktop')),
  ));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  final backToLogin = find.byKey(const Key(pinLoginDesktopKey));
  expect(backToLogin, findsOneWidget);
}

/// Tests PIN validation logic (empty PIN, invalid PIN, valid PIN).
Future<void> testPinValidation(WidgetTester tester) async {
  final pinField = find.byType(TextFormField);

  // Test empty PIN
  await tester.enterText(pinField, '');
  await tester.tap(find.byKey(const Key(pinLoginButtonKey)));
  await tester.pumpAndSettle();
  expect(find.text(pinRequiredText), findsOneWidget);

  // Test invalid PIN
  await tester.enterText(pinField, '1234');
  await tester.tap(find.byKey(const Key(pinLoginButtonKey)));
  await tester.pumpAndSettle();
  expect(find.text(pinNotFoundText), findsOneWidget);

  // Test valid PIN
  await tester.enterText(pinField, '73268');
  await tester.pumpAndSettle();
  expect(find.text(pinNotFoundText), findsNothing);
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

/// Tests navigation to the EOD screen and back to the login screen.
Future<void> testEodNavigation(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key(eodDesktopKey)));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  final backToLogin = find.byKey(const Key(pinLoginDesktopKey));
  expect(backToLogin, findsOneWidget);
}
