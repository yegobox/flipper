import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_rw/main.dart' as app_main;
import 'common.dart';
import 'dart:async';

// Constants for widget keys and text
const String mainApp = 'mainApp';
const String eodDesktopKey = 'eod_desktop';
const String pinLoginDesktopKey = 'pinLogin_desktop';
const String pinLoginKey = 'PinLogin';
const String pinLoginButtonKey = 'pinLoginButton_desktop';
const String pinLoginButtonKey2 = 'pinLoginButton';
const String pinRequiredText = 'PIN is required';
const String pinNotFoundText = 'Pin: Not found';
const String quickSellKey = 'quickSell';
Future<void> runWithErrorHandler(Future<void> Function() call) async {
  final originalOnError = FlutterError.onError;
  try {
    await call();
  } finally {
    FlutterError.onError = originalOnError;
  }
}

Future<bool> retryUntilFound(WidgetTester tester, Finder finder, {int maxAttempts = 5}) async {
  for (var i = 0; i < maxAttempts; i++) {
    await tester.pumpAndSettle(const Duration(seconds: 1));
    if (finder.evaluate().isNotEmpty) return true;
  }
  return false;
}

void main() {
  group('Windows App Smoke Test', () {
    late FlutterExceptionHandler originalOnError;

    setUp(() {
      originalOnError = FlutterError.onError!;
      FlutterError.onError = (FlutterErrorDetails details) {
        print('Error occurred: ${details.exception}');
        print('Stack trace: ${details.stack}');
        originalOnError?.call(details);
      };
    });

    tearDown(() {
      FlutterError.onError = originalOnError;
    });

    testWidgets('Test app initialization and login flow',
        (WidgetTester tester) async {
      await runWithErrorHandler(() async {
        await startApp(tester);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Check if already logged in
        if (await isLoggedIn(tester)) {
          print('User already logged in, testing EOD navigation...');
          await navigateToEodAndBack(tester);
        } else {
          print('User not logged in, testing full login flow...');
          await testLoginFlow(tester);
          await testPinValidation(tester);
          await testEodNavigation(tester);
        }
      });
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}

/// Tests the login button and navigation to the PIN login screen.
Future<void> testLoginFlow(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  final pinLogin = find.byKey(const Key(pinLoginKey));
  expect(pinLogin, findsOneWidget, reason: 'PIN login widget not found');
  
  final pinField = find.byType(TextFormField).first;
  await tester.tap(pinField);
  await tester.pumpAndSettle();
  await tester.enterText(pinField, '73268');
  await tester.pumpAndSettle();
  
  final loginButton = find.byKey(const Key(pinLoginButtonKey2));
  expect(loginButton, findsOneWidget, reason: 'Login button not found');
  await tester.tap(loginButton);
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  final quickSell = find.byKey(const Key(quickSellKey));
  final found = await retryUntilFound(tester, quickSell);
  expect(found, isTrue, reason: 'QuickSell widget not found after login');
}

/// Starts the app and waits for it to load.
Future<void> startApp(WidgetTester tester) async {
  await app_main.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Wait for startup view to complete
  final startupText = find.text('A revolutionary business software...');
  final foundStartup = await retryUntilFound(tester, startupText);
  expect(foundStartup, isTrue, reason: 'Startup view not found');
  
  // Wait for startup animation and initialization
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  // Verify app is initialized
  final app = find.byKey(const Key(mainApp));
  expect(app, findsOneWidget, reason: 'Main app widget not found');
}

/// Checks if the user is logged in by looking for the 'QuickSell' key.
Future<bool> isLoggedIn(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));
  
  // First check for PIN login screen
  final pinLogin = find.byKey(const Key(pinLoginKey));
  if (await retryUntilFound(tester, pinLogin)) {
    return false;
  }
  
  // Then check for QuickSell (logged in state)
  final quickSell = find.byKey(const Key(quickSellKey));
  return await retryUntilFound(tester, quickSell, maxAttempts: 3);
}

/// Navigates to the EOD screen and back to the login screen.
Future<void> navigateToEodAndBack(WidgetTester tester) async {
  final eodButton = find.byKey(const Key(eodDesktopKey));
  expect(eodButton, findsOneWidget, reason: 'EOD button not found');
  
  await tester.tap(eodButton);
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  final backToLogin = find.byKey(const Key(pinLoginDesktopKey));
  final found = await retryUntilFound(tester, backToLogin);
  expect(found, isTrue, reason: 'Back to login button not found after EOD navigation');
}

/// Tests PIN validation logic (empty PIN, invalid PIN, valid PIN).
Future<void> testPinValidation(WidgetTester tester) async {
  final pinLogin = find.byKey(const Key(pinLoginKey));
  expect(pinLogin, findsOneWidget, reason: 'PIN login widget not found');

  final pinField = find.byType(TextFormField).first;
  final loginButton = find.byKey(const Key(pinLoginButtonKey2));
  expect(loginButton, findsOneWidget, reason: 'Login button not found');

  // Test empty PIN
  await tester.tap(pinField);
  await tester.pumpAndSettle();
  await tester.enterText(pinField, '');
  await tester.pumpAndSettle();
  await tester.tap(loginButton);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  
  final emptyPinError = find.text(pinRequiredText);
  final foundEmptyError = await retryUntilFound(tester, emptyPinError);
  expect(foundEmptyError, isTrue, reason: 'Empty PIN error message not found');

  // Test invalid PIN
  await tester.tap(pinField);
  await tester.pumpAndSettle();
  await tester.enterText(pinField, '1234');
  await tester.pumpAndSettle();
  await tester.tap(loginButton);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  
  final invalidPinError = find.text(pinNotFoundText);
  final foundInvalidError = await retryUntilFound(tester, invalidPinError);
  expect(foundInvalidError, isTrue, reason: 'Invalid PIN error message not found');

  // Test valid PIN
  await tester.tap(pinField);
  await tester.pumpAndSettle();
  await tester.enterText(pinField, '73268');
  await tester.pumpAndSettle();
  await tester.tap(loginButton);
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  final quickSell = find.byKey(const Key(quickSellKey));
  final foundQuickSell = await retryUntilFound(tester, quickSell);
  expect(foundQuickSell, isTrue, reason: 'QuickSell widget not found after valid PIN login');
}

/// Tests navigation to the EOD screen and back to the login screen.
Future<void> testEodNavigation(WidgetTester tester) async {
  final eodButton = find.byKey(const Key(eodDesktopKey));
  expect(eodButton, findsOneWidget, reason: 'EOD button not found');
  
  await tester.tap(eodButton);
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  final backToLogin = find.byKey(const Key(pinLoginDesktopKey));
  final found = await retryUntilFound(tester, backToLogin);
  expect(found, isTrue, reason: 'Back to login button not found after EOD navigation');
}
