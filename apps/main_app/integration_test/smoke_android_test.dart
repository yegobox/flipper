import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
import 'package:nock/nock.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flipper_rw/main.dart' as app;
import 'package:patrol/patrol.dart';
import 'test_cases.dart';
// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d R58MC1HCNFT integration_test/smoke_android_test.dart
//patrol build android --targets integration_test/smoke_android_test.dart  --verbose
//patrol test --targets integration_test/smoke_android_test.dart
void main() {
  setUpAll(nock.init);

  group('Complete E2E Test', () {
    patrolTest('Run app-android:', (tester) async {
      await runAppAndVerifyInitialScreen(tester);
      await tapSignInButtonAndVerifyOptions(tester);
      // await testPINLogin(tester);
    });
  });
}

