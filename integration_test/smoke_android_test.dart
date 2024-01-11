import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_models/mocks/isarApiMock.dart';
import 'package:flipper_rw/StateObserver.dart';
import 'package:flipper_rw/firebase_options.dart';
import 'package:flipper_rw/flipper_localize/lib/flipper_localize.dart';
import 'package:flipper_rw/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
// Import the relevant file
import 'package:google_fonts/google_fonts.dart';
import 'package:nock/nock.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:integration_test/integration_test.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flipper_rw/main.dart' as app;

// https://stackoverflow.com/questions/69248403/flutter-widget-testing-with-httpclient
//https://pub.dev/packages/nock
//https://github.com/nock/nock?tab=readme-ov-file#how-does-it-work
//https://designer.mocky.io/
//flutter test --dart-define=Test=true -d R58MC1HCNFT integration_test/smoke_android_test.dart
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  // Mock the HTTP client at the ViewModel level
  setUpAll(nock.init);

  testWidgets('App start and runs windows', (WidgetTester tester) async {
    // int? userId = ProxyService.box.getUserId();
    // final interceptor =
    //     nock("https://apihub.yegobox.com/v2/api").get("/businessUserId/$userId")
    //       ..reply(
    //         200,
    //         "result",
    //       );

    // expect(interceptor.isDone, true);
    // Build our app and trigger a frame.
    app.main();
    // This is required prior to taking the screenshot (Android only).
    await binding.convertFlutterSurfaceToImage();

    await tester.pumpAndSettle();
    // Verify that our counter starts at 0.

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await binding.takeScreenshot('screenshot-1');

    // Test additional functionality...
  });
}
