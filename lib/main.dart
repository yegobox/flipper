import 'dart:async';

// import 'package:cbl/cbl.dart';
// import 'package:cbl_flutter/cbl_flutter.dart';
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
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;

// cd android && ./gradlew signingReport
main() async {
  // CouchbaseLite.initialize(libraries: flutterLibraries());

  WidgetsFlutterBinding.ensureInitialized();
  (!isWindows) ? await Firebase.initializeApp() : '';
  // (isAndroid|| isWeb||isMacOs)
  // (isWindows) ? Cbl.init() : ''; //paused for now as couchbase is not supported on some platforms
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
