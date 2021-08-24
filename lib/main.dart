import 'dart:async';

// import 'package:cbl/cbl.dart';
// import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper_login/colors.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/objectbox_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

// cd android && ./gradlew signingReport
main() async {
  // CouchbaseLite.initialize(libraries: flutterLibraries())
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  (!isWindows) ? await Firebase.initializeApp() : '';
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    if (!isWindows) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
    // Pass all uncaught errors from the framework to Crashlytics.
    if (!isWindows) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }
  (!isWindows) ? FirebaseMessaging.onBackgroundMessage(backgroundHandler) : '';
  // (isAndroid|| isWeb||isMacOs)
  // (isWindows) ? Cbl.init() : ''; //paused for now as couchbase is not supported on some platforms
  await GetStorage.init();
  // done init in mobile.//done separation.
  setupLocator();
  await ObjectBoxApi.getDir(dbName: 'db_1');
  // AwesomeNotifications().initialize(
  //     // set the icon to null if you want to use the default app icon
  //     // 'resource://drawable/res_app_icon',
  //     null,
  //     [
  //       NotificationChannel(
  //         channelKey: 'flipper_channel',
  //         channelName: 'Flipper notifications',
  //         channelDescription: 'Notification channel for basi notification',
  //         defaultColor: Color(0xFF9D50DD),
  //         ledColor: Colors.white,
  //       )
  //     ]);
  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     // Insert here your friendly dialog box before call the request method
  //     // This is very important to not harm the user experience
  //     AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // });

  runZonedGuarded<Future<void>>(() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: AppColors.flipperMainColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    runApp(FlipperApp());
  }, (error, stack) {
    if (!isWindows) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
