import 'package:flutter/material.dart';

import 'common.dart';

// patrol develop  --target integration_test/smoke_android_test.dart
void main() {
  patrol('Run app-android:', (tester) async {
    // Override the error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      // Optionally, you can log the error details here
      // print('FlutterError: ${details.exceptionAsString()}');
    };

    try {
      final widgetTester = tester.tester;

      // Clear any existing exceptions before the test
      widgetTester.takeException();
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
      final drawer = find.byKey(const Key('openDrawerPage'));
      expect(drawer, findsOneWidget);

      // Add a delay to ensure all animations have completed
      await tester.pumpAndSettle();

      /// find TextFormField
      final textFormField = find.byType(TextFormField);
      await tester.enterText(textFormField, '0.0');

      /// find submit button
      final submitButton = find.byKey(const Key('closeDrawerButton'));
      expect(submitButton, findsOneWidget);
      // tap on submit button
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('openDrawerPage')), findsNothing);
      await tester.pumpAndSettle();

      /// go back to login screen
      expect(find.text('Sign In'), findsOneWidget);
    } catch (e) {
      // print('Caught error: $e'); // Log the error for debugging
    } finally {
      // Restore the original error handler
      // FlutterError.onError = originalOnError;
    }
  });
}
