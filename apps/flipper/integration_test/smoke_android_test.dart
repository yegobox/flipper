import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'common.dart';

// Skip this test if not running on Android
bool get shouldRunTest =>
    Platform.isAndroid ||
    const bool.fromEnvironment('FORCE_TEST', defaultValue: false);

void main() {
  if (!shouldRunTest) {
    debugPrint('Skipping Android smoke test on non-Android platform');
    group('Android Smoke Test (Skipped)', () {
      test('Skipped on non-Android platform', () {});
    });
    return;
  }

  patrol('Run app-android:', (tester) async {
    try {
      final widgetTester = tester.tester;
      await createApp(tester);

      // This is required prior to taking the screenshot (Android only).
      // await binding.convertFlutterSurfaceToImage();

      var exceptionCount = 0;
      dynamic exception = widgetTester.takeException();
      while (exception != null) {
        exceptionCount++;
        exception = widgetTester.takeException();
      }
      if (exceptionCount != 0) {
        // tester.log('Warning: $exceptionCount exceptions were ignored after app initialization');
      }
      // await binding.takeScreenshot('screenshot-1');

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // Tap on the "Sign In" button
      await tester.tap(find.byKey(const Key('signInButtonKey')));

      // test expect to see list of sign in/up options

      expect(find.text("Phone Number"), findsOneWidget);

      expect(find.byKey(const Key('phoneNumberLogin')), findsOneWidget);

      expect(find.byKey(const Key('googleLogin')), findsOneWidget);

      expect(find.byKey(const Key('microsoftLogin')), findsOneWidget);

      expect(find.text("How would you like to proceed?"), findsOneWidget);

      /// now Test login using the PIN
      /// pinLogin
      await tester.tap(find.byKey(const Key('pinLogin')));

      expect(find.byType(Form), findsOneWidget);

      expect(find.byType(TextFormField), findsOneWidget);

      // Simulate entering an empty PIN
      await tester.enterText(find.byType(TextFormField), '');

      // Verify that the validator error message is displayed
      await tester.tap(find.text('Log in'));

      expect(find.text('PIN is required'), findsOneWidget);

      /// Simulate entering a non-empty PIN or wrong pin
      await tester.enterText(find.byType(TextFormField), '1234');
      await tester.tap(find.text('Log in'));

      // Verify that a SnackBar is present
      expect(find.byType(SnackBar), findsOneWidget);

      // Verify the SnackBar properties
      final snackBar = tester.tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.width, 250);
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.backgroundColor, Colors.red);

      final snackBarTextFinder = find.descendant(
        of: find.byType(SnackBar),
        matching: find.byType(Text),
      );
      expect(snackBarTextFinder, findsOneWidget);

      // Verify the error message
      final snackBarText = tester.tester.widget<Text>(snackBarTextFinder);
      expect(snackBarText.data, 'Pin: Not found');

      await tester.enterText(find.byType(TextFormField), '73268');
      await tester.tap(find.text('Log in'));
      // pump and settle
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('openDrawerPage')), findsOneWidget);

      ///TODO: here I will write more tests to test the app usage
      ///
      ///
      ///
      ///
      ///
      ///
      ///

      /// click on  EOD from ribbon
      await tester.tap(find.byKey(const Key('eod_desktop')));

      // should see the drawer screen

      // Add a delay to ensure all animations have completed
      await tester.pumpAndSettle();

      /// find TextFormField

      /// find submit button

      // tap on submit button

      await tester.pumpAndSettle();

      /// go back to login screen
      expect(find.text('Sign In'), findsOneWidget);
    } catch (e) {
      debugPrint('Test error: $e');
      rethrow; // Rethrow to ensure test failure is reported
    }
  });
}
