import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
import 'package:nock/nock.dart';

import 'package:integration_test/integration_test.dart';

import 'package:flipper_rw/main.dart' as app;

import 'test_cases.dart';

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d windows integration_test/smoke_windows_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(nock.init);

  group('Complete E2E Test:', () {
    testWidgets('App start and runs windows', (WidgetTester tester) async {
      await tester.runAsync(testAppStartAndRunsWindows);
    });
  });
}

Future<void> testAppStartAndRunsWindows(WidgetTester tester) async {
  await startAppAndPump(tester);
  await verifyLoginPage(tester);
  await enterEmptyPINAndVerifyErrorMessage(tester);
  // await enterNonEmptyPINAndLogIn(tester);
}



