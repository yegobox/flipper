import 'dart:async';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper/locator.dart';

import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true); // never executes in production
  return inDebugMode;
}

Future<void> main() async {
  Cbl.init();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await DotEnv().load('.env');

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: AppColors.flipperGreen,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    runApp(const FlipperApp());
  }, (Object e, StackTrace s) async {
    // Crashlytics.instance.setBool('runZonedGuarded', true);
    // Crashlytics.instance.setString("stringKey", "{\"test\":\"this is a json error from stringKey\"}");
    Crashlytics.instance.log(s.toString());
    print(s);
    await Crashlytics.instance.recordFlutterError(e);
  });
}
