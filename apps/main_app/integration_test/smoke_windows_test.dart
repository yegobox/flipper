import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
import 'package:nock/nock.dart';

import 'package:integration_test/integration_test.dart';

import 'package:flipper_rw/main.dart' as app;

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d windows integration_test/smoke_windows_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // Mock the HTTP client at the ViewModel level
  setUpAll(nock.init);

  group('Complete E2E Test:', () {
    testWidgets('App start and runs windows', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await app.main();
        await tester.pumpAndSettle(const Duration(seconds: 12));

        expect(find.text('Log in to Flipper by QR Code'), findsOneWidget);

        await tester.tap(find.byKey(const Key('pinLogin')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify that the PIN text field is rendered within the Form
        expect(find.byType(Form), findsOneWidget);

        expect(find.byType(TextFormField), findsOneWidget);

        // Simulate entering an empty PIN
        await tester.enterText(find.byType(TextFormField), '');

        // Verify that the validator error message is displayed
        await tester.tap(find.text('Log in'));

        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('PIN is required'), findsOneWidget);

        // Simulate entering a non-empty PIN
        await tester.enterText(find.byType(TextFormField), '1234');
        await tester.tap(find.text('Log in'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.text('Pin not found.'), findsOneWidget);

        /// now test with real PIN.
      });
    });
  });
}

