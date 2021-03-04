import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import 'package:pusher_beams/pusher_beams.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true); // never executes in production
  return inDebugMode;
}

Future<void> main() async {
  await GetStorage.init();
  Cbl.init();
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic',
        channelDescription: 'flipper notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);
  initializeDateFormatting();
  await DotEnv.load(fileName: '.env');
  await Firebase.initializeApp();
  // ignore: unnecessary_statements
  FirebaseFirestore.instance.settings.persistenceEnabled;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();

  if (isInDebugMode) {
    // enableFlipper();
  }
  //
  Logger.level = isInDebugMode ? Level.verbose : Level.info;
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // FIXME: fix bellow crashlytics line
  // FirebaseCrashlytics.instance.enableInDevMode = false;
  FlutterError.onError = (e) async {
    await FirebaseCrashlytics.instance.recordFlutterError(e);
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
    await PusherBeams.start(env['PUSHER_KEY']);
  }, (Object e, StackTrace s) async {
    await FirebaseCrashlytics.instance.recordError(e, s);
  });
}
