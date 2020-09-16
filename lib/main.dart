import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper/locator.dart';
import 'package:flutter/material.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true); // never executes in production
  return inDebugMode;
}

// void enableFlipper() {
//   FlipperClient flipperClient = FlipperClient.getDefault();
//   flipperClient.addPlugin(new FlipperNetworkPlugin(
//       // If you use http library, you must set it to false and use https://pub.dev/packages/flipperkit_http_interceptor
//       // useHttpOverrides: false,
//       // Optional, for filtering request
//       // filter: (HttpClientRequest request) {
//       //   String url = '${request.uri}';
//       //   if (url.startsWith('https://via.placeholder.com') || url.startsWith('https://gravatar.com')) {
//       //     return false;
//       //   }
//       //   return true;
//       // }
//       ));
//   flipperClient.addPlugin(new FlipperReduxInspectorPlugin());
//   flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
//   flipperClient.start();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  if (isInDebugMode) {
    // enableFlipper();
  }
  Logger.level = isInDebugMode ? Level.verbose : Level.info;
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = (e) async {
    // Crashlytics.instance.setBool('runZonedGuarded', false);
    // Crashlytics.instance.setString("stringKey", "{\"test\":\"this is a json error from stringKey\"}");
    // Crashlytics.instance.log("{\"test\":\"this is a json error\"}");
    await Crashlytics.instance.recordFlutterError(e);
  };
  runZonedGuarded<Future<void>>(() async {
    runApp(FlipperApp());
  }, (e, s) async {
    // Crashlytics.instance.setBool('runZonedGuarded', true);
    // Crashlytics.instance.setString("stringKey", "{\"test\":\"this is a json error from stringKey\"}");
    // Crashlytics.instance.log("{\"test\":\"this is a json error\"}");
    await Crashlytics.instance.recordFlutterError(e);
  });
}

// Future<void> main() async {
//   configureLogger();
//   WidgetsFlutterBinding.ensureInitialized();
//   // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//   //   statusBarColor: Colors.black,
//   //   statusBarIconBrightness: Brightness.dark,
//   //   systemNavigationBarColor: Colors.white,
//   //   systemNavigationBarIconBrightness: Brightness.light,
//   //   systemNavigationBarDividerColor: Colors.transparent,
//   // )); 
// }



