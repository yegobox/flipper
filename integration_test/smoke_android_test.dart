import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
import 'package:nock/nock.dart';
import 'package:flutter/foundation.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flipper_rw/main.dart' as app;

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d R58MC1HCNFT integration_test/smoke_android_test.dart
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.defaultTestTimeout = Timeout.none;

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

        FlutterError.onError = originalOnError;

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);

        await binding.takeScreenshot('screenshot-1');

        // Test additional functionality...
      });
    }, timeout: Timeout.none);
  });
}
