import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flipper_rw/main.dart' as app;

/// desktop test cases
Future<void> startAppAndPump(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 12));
}

Future<void> verifyLoginPage(WidgetTester tester) async {
  expect(find.text('Log in to Flipper by QR Code'), findsOneWidget);
  await tester.tap(find.byKey(const Key('pinLogin')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.byType(Form), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);
}

Future<void> enterEmptyPINAndVerifyErrorMessage(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.text('PIN is required'), findsOneWidget);
}

Future<void> enterNonEmptyPINAndLogIn(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField), '1234');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.enterText(find.byType(TextFormField), '67814');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.tap(find.byKey(const Key('openDrawerPage')));
}

/// end of desktop

/// start of android

Future<void> runAppAndVerifyInitialScreen(WidgetTester tester) async {
  await app.main();
  await tester.pumpAndSettle();
  expect(find.text('Create Account'), findsOneWidget);
  expect(find.text('Sign In'), findsOneWidget);
}

Future<void> tapSignInButtonAndVerifyOptions(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('signInButtonKey')));
  await tester.pumpAndSettle();
  expect(find.text("Phone Number"), findsOneWidget);
  expect(find.byKey(const Key('phoneNumberLogin')), findsOneWidget);
  expect(find.byKey(const Key('googleLogin')), findsOneWidget);
  expect(find.byKey(const Key('microsoftLogin')), findsOneWidget);
  expect(find.text("How would you like to proceed?"), findsOneWidget);
}

Future<void> testPINLogin(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('pinLogin')));
  await tester.pumpAndSettle();
  expect(find.byType(Form), findsOneWidget);
  expect(find.byType(TextFormField), findsOneWidget);

  // Simulate entering an empty PIN
  await tester.enterText(find.byType(TextFormField), '');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.text('PIN is required'), findsOneWidget);

  // Simulate entering a non-empty PIN
  await tester.enterText(find.byType(TextFormField), '1234');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 5));

  // Log in with real PIN and go to openDrawerPage
  await tester.enterText(find.byType(TextFormField), '67814');
  await tester.tap(find.text('Log in'));
  await tester.pumpAndSettle(const Duration(seconds: 10));
  await tester.tap(find.byKey(const Key('openDrawerPage')));
}
