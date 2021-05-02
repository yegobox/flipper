import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper_login/colors.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
// cd android && ./gradlew signingReport
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  (!isWindows) ? await Firebase.initializeApp() : '';
  // (isWindows || isMacOs) ? Cbl.init() : '';
  await GetStorage.init();
  // done init in mobile.//done separation.
  setupLocator();

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
    // await FirebaseCrashlytics.instance.recordError(e, s);
  });
}
