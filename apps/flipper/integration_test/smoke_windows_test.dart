import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
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
import 'dart:io';
import '../lib/dependencyInitializer.dart';

// Skip this test if not running on Windows
bool get shouldRunTest => Platform.isWindows || const bool.fromEnvironment('FORCE_TEST', defaultValue: false);

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  if (!shouldRunTest) {
    debugPrint('Skipping Windows smoke test on non-Windows platform');
    group('Windows Smoke Test (Skipped)', () {
      test('Skipped on non-Windows platform', () {
      //  skip('This test is only meant to run on Windows');
      });
    });
    return;
  }

  setUpAll(() async {
    try {
      debugPrint('Starting Windows smoke test setup...');
      // Initialize test dependencies with timeout
      await initializeDependenciesForTest().timeout(
        const Duration(minutes: 2),
        onTimeout: () => throw TimeoutException('Test initialization timed out after 2 minutes'),
      );
      
      debugPrint('Setting up test data...');
      // Set up test data in parallel to speed up initialization
      await Future.wait([
        ProxyService.box.writeInt(key: 'userId', value: 1),
        ProxyService.box.writeInt(key: 'businessId', value: 1),
        ProxyService.box.writeInt(key: 'branchId', value: 1),
        ProxyService.box.writeString(key: 'userPhone', value: '+250783054874'),
        ProxyService.box.writeBool(key: 'pinLogin', value: false),
        ProxyService.box.writeBool(key: 'authComplete', value: false),
      ]).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Test data setup timed out after 30 seconds'),
      );
      debugPrint('Test setup completed successfully');
    } catch (e, stackTrace) {
      debugPrint('Error during test setup: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  });

  tearDownAll(() async {
    if (!shouldRunTest) return;
    
    try {
      debugPrint('Starting test cleanup...');
      await ProxyService.box.clear().timeout(
        const Duration(seconds: 30),
        onTimeout: () => debugPrint('Warning: Cleanup timed out'),
      );
      debugPrint('Test cleanup completed');
    } catch (e) {
      debugPrint('Error during cleanup: $e');
    }
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
        try {
          // Start app with timeout
          await startApp(tester).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('App startup timed out after 30 seconds'),
          );

          // Verify we're on the PIN login screen with timeout
          final pinLogin = find.byKey(const Key(pinLoginKey));
          bool foundPinLogin = false;
          for (int i = 0; i < 10; i++) {
            await tester.pump(const Duration(seconds: 1));
            if (pinLogin.evaluate().isNotEmpty) {
              foundPinLogin = true;
              break;
            }
          }
          expect(foundPinLogin, isTrue, reason: 'PIN login screen not found after 10 seconds');
          
          // Run test flows with individual timeouts
          await testLoginFlow(tester).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Login flow timed out'),
          );
          await testPinValidation(tester).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('PIN validation timed out'),
          );
          await testEodNavigation(tester).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('EOD navigation timed out'),
          );
        } catch (e, stackTrace) {
          debugPrint('Test execution error: $e');
          debugPrint('Stack trace: $stackTrace');
          rethrow;
        }
      });
    }, timeout: const Timeout(Duration(minutes: 2)));
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
  // Start the app with error handling
  try {
    // Ensure we're running on Windows
    if (!Platform.isWindows) {
      throw Exception('This test must be run on Windows');
    }

    // Initialize app with error capture
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('Flutter error during app initialization: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
      throw details.exception;
    };

    // Start the app
    await app_main.main();
    await tester.pump();
    
    // Wait for startup view with detailed error reporting
    final startupText = find.text('A revolutionary business software...');
    bool foundStartup = false;
    String lastError = '';
    
    for (int i = 0; i < 15; i++) {
      try {
        await tester.pump(const Duration(seconds: 1));
        if (startupText.evaluate().isNotEmpty) {
          foundStartup = true;
          break;
        }
        // Check for error indicators
        final errorText = find.textContaining('Error').evaluate();
        if (errorText.isNotEmpty) {
          lastError = errorText.first.widget.toString();
          break;
        }
      } catch (e) {
        debugPrint('Error during startup check: $e');
        lastError = e.toString();
      }
    }
    
    if (!foundStartup) {
      throw Exception('Startup view not found after 15 seconds. Last error: $lastError');
    }
    
    // Wait for app initialization with error check
    await tester.pump(const Duration(seconds: 2));
    
    // Verify app is initialized
    final app = find.byKey(const Key(mainApp));
    if (app.evaluate().isEmpty) {
      throw Exception('Main app widget not found after initialization');
    }
  } catch (e, stackTrace) {
    debugPrint('Fatal error during app startup: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
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
