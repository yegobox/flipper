import 'dart:async';

// import 'package:cbl/cbl.dart';
// import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flipper/flipper_app.dart';
import 'package:flipper_login/colors.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/objectbox_api.dart';
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
  (!isWindows) ? FirebaseMessaging.onBackgroundMessage(backgroundHandler) : '';
  // (isAndroid|| isWeb||isMacOs)
  // (isWindows) ? Cbl.init() : ''; //paused for now as couchbase is not supported on some platforms
  await GetStorage.init();
  // done init in mobile.//done separation.
  setupLocator();
  //make sure we init db.
  //
  await ObjectBoxApi.getDir(dbName: 'db_1');

  runZonedGuarded<Future<void>>(() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: AppColors.flipperMainColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    runApp(FlipperApp());
    // await PusherBeams.start(env['PUSHER_KEY']);
  }, (Object e, StackTrace s) async {
    // (isAndroid || isMacOs)
    // ? await FirebaseCrashlytics.instance.recordError(e, s)
    // : '';
  });
}
