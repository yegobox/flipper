import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_rw/main.dart' as app_main;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/secrets.dart';
import 'common.dart';
import 'dart:async';
import 'dart:convert';
import '../lib/dependencyInitializer.dart';

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
  setUpAll(() async {
    // Initialize test dependencies
    await initializeDependenciesForTest();
    
    // Set up test data
    await ProxyService.box.writeInt(key: 'userId', value: 1);
    await ProxyService.box.writeInt(key: 'businessId', value: 1);
    await ProxyService.box.writeInt(key: 'branchId', value: 1);
    await ProxyService.box.writeString(key: 'userPhone', value: '+250783054874');
    await ProxyService.box.writeBool(key: 'pinLogin', value: false);
    await ProxyService.box.writeBool(key: 'authComplete', value: false);
  });

  tearDownAll(() async {
    await ProxyService.box.clear();
  });

  group('Windows App Smoke Test', () {
    late void Function(FlutterErrorDetails)? originalOnError;
    setUp(() {
      originalOnError = FlutterError.onError;
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
        await tester.pump(const Duration(seconds: 2));

        // Verify we're on the PIN login screen with timeout
        final pinLogin = find.byKey(const Key(pinLoginKey));
        bool foundPinLogin = false;
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (pinLogin.evaluate().isNotEmpty) {
            foundPinLogin = true;
            break;
          }
        }
        expect(foundPinLogin, isTrue, reason: 'PIN login screen not found after 5 seconds');
        
        await testLoginFlow(tester);
        await testPinValidation(tester);
        await testEodNavigation(tester);
      });
    }, timeout: const Timeout(Duration(minutes: 3)));
  });
}

/// Tests the login button and navigation to the PIN login screen.
Future<void> testLoginFlow(WidgetTester tester) async {
  // Wait for PIN login widget with timeout
  final pinLogin = find.byKey(const Key(pinLoginKey));
  bool foundPinLogin = false;
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(seconds: 1));
    if (pinLogin.evaluate().isNotEmpty) {
      foundPinLogin = true;
      break;
    }
  }
  expect(foundPinLogin, isTrue, reason: 'PIN login widget not found after 5 seconds');
  
  // Enter PIN
  final pinField = find.byType(TextFormField).first;
  await tester.tap(pinField);
  await tester.pump();
  await tester.enterText(pinField, '73268');
  await tester.pump();
  
  // Tap login button
  final loginButton = find.byKey(const Key(pinLoginButtonKey2));
  expect(loginButton, findsOneWidget, reason: 'Login button not found');
  await tester.tap(loginButton);
  
  // Wait for QuickSell widget with timeout
  final quickSell = find.byKey(const Key(quickSellKey));
  bool foundQuickSell = false;
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(seconds: 1));
    if (quickSell.evaluate().isNotEmpty) {
      foundQuickSell = true;
      break;
    }
  }
  expect(foundQuickSell, isTrue, reason: 'QuickSell widget not found after 10 seconds');
}

/// Starts the app and waits for it to load.
Future<void> startApp(WidgetTester tester) async {
  // Start the app
  await app_main.main();
  await tester.pump();
  
  // Wait for startup view to complete with timeout
  final startupText = find.text('A revolutionary business software...');
  bool foundStartup = false;
  for (int i = 0; i < 10; i++) {
    await tester.pump(const Duration(seconds: 1));
    if (startupText.evaluate().isNotEmpty) {
      foundStartup = true;
      break;
    }
  }
  expect(foundStartup, isTrue, reason: 'Startup view not found after 10 seconds');
  
  // Wait for app initialization
  await tester.pump(const Duration(seconds: 2));
  
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
