import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
import 'package:nock/nock.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flipper_rw/main.dart' as app;

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d R58MC1HCNFT integration_test/smoke_android_test.dart
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(nock.init);

  group('Complete E2E Test', () {
    testWidgets('App start and runs android', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;

      await tester.runAsync(() async {
        await app.main();

        // This is required prior to taking the screenshot (Android only).
        await binding.convertFlutterSurfaceToImage();

        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await binding.takeScreenshot('screenshot-1');
        FlutterError.onError = originalOnError;

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);

        // Tap on the "Sign In" button
        await tester.tap(find.byKey(const Key('signInButtonKey')));
        await tester.pumpAndSettle();
        // test expect to see list of sign in/up options

        expect(find.text("Phone Number"), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('phoneNumberLogin')), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('googleLogin')), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('microsoftLogin')), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.text("How would you like to proceed?"), findsOneWidget);

        await tester.pumpAndSettle();
        await binding.takeScreenshot('screenshot-2');

        // Test additional functionality...
      });
    });
  });
}
