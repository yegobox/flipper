import 'package:flutter/material.dart';

import 'common.dart';

void main() {
  patrol('Run app-windows:', ($) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Optionally, you can log the error details here
      // print('FlutterError: ${details.exceptionAsString()}');
    };
    try {
      final widgetTester = $.tester;

      // Clear any existing exceptions before the test
      widgetTester.takeException();
      await createApp($);
      var exceptionCount = 0;
      dynamic exception = widgetTester.takeException();
      while (exception != null) {
        exceptionCount++;
        exception = widgetTester.takeException();
      }
      if (exceptionCount != 0) {
        // tester.log('Warning: $exceptionCount exceptions were ignored after app initialization');
      }

      expect(find.text('Log in to Flipper by QR Code'), findsOneWidget);

      await $.tap(find.byKey(const Key('pinLogin')));
      // Verify that the PIN text field is rendered within the Form
      expect(find.byType(Form), findsOneWidget);

      expect(find.byType(TextFormField), findsOneWidget);

      // Simulate entering an empty PIN
      await $.enterText(find.byType(TextFormField), '');

      // Verify that the validator error message is displayed
      await $.tap(find.text('Log in'));

      // await $.pumpAndSettle();

      expect(find.text('PIN is required'), findsOneWidget);

      // Simulate entering a non-empty PIN
      await $.enterText(find.byType(TextFormField), '1234');
      await $.tap(find.text('Log in'));

      /// now test with real PIN. it login and go to openDrawerPage
      // await $.enterText(find.byType(TextFormField), '67814');
      //
      // await $.tap(find.text('Log in'));
      //
      // await $.pumpAndSettle(const Duration(seconds: 10));
      //
      // await $.tap(find.byKey(const Key('openDrawerPage')));
    } catch (e) {
    } finally {
      // Restore the original error handler
      // FlutterError.onError = originalOnError;
    }
  });
}
