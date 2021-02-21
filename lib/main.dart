import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper_services/locator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
// commit

import 'package:pusher_beams/pusher_beams.dart';
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.data}');
// }

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true); // never executes in production
  return inDebugMode;
}

Future<void> main() async {
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
  await DotEnv.load(fileName: ".env");
  await Firebase.initializeApp();
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
  // Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = (e) async {
    // Crashlytics.instance.setBool('runZonedGuarded', false);
    // Crashlytics.instance.setString("stringKey", "{\"test\":\"this is a json error from stringKey\"}");
    // Crashlytics.instance.log("{\"test\":\"this is a json error\"}");
    // FIXME: fix bellow crashlytics line
    // await Crashlytics.instance.recordFlutterError(e);
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
    // Crashlytics.instance.setBool('runZonedGuarded', true);
    // Crashlytics.instance.setString("stringKey", "{\"test\":\"this is a json error from stringKey\"}");
    // FIXME: fix bellow crashlytics line
    // Crashlytics.instance.log(s.toString());
    // FIXME: fix bellow crashlytics line
    // await Crashlytics.instance.recordFlutterError(e);
  });
}
