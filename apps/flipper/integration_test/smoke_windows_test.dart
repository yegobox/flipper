import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// Import the relevant file
// import 'package:nock/nock.dart';

import 'package:flipper_rw/main.dart' as app;

import 'common.dart';

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d windows integration_test/smoke_windows_test.dart
void main() {
  // setUpAll(nock.init);

  patrol('Run app-android:', ($) async {
    await app.main();
    // await $.pumpAndSettle();
    // await $.pumpAndSettle();

    expect(find.text('Log in to Flipper by QR Code'), findsOneWidget);

    await $.tap(find.byKey(const Key('pinLogin')));
    // await $.pumpAndSettle();

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
  });
}
