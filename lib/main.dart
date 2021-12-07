import 'dart:async';
import 'dart:io';

// import 'package:cbl/cbl.dart';
// import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/gate.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_themes/stacked_themes.dart';
// import 'package:flipper/flipper_app_legacy.dart';
import 'package:flipper_login/colors.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/objectbox_api.dart';
import 'package:flipper_services/proxy.dart';
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
  ProxyService.notification.display(message);
}

class FlipperHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// cd android && ./gradlew signingReport
void main() async {
  // CouchbaseLite.initialize(libraries: flutterLibraries())
  WidgetsFlutterBinding.ensureInitialized();
  // https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
  // https://api.flutter.dev/flutter/dart-io/SecurityContext/setTrustedCertificates.html
  // https://github.com/flutter/flutter/issues/19588
  HttpOverrides.global = FlipperHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// not using try and catch since there is some work need to be done in firebase desktop package

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
  await ThemeManager.initialise();
  await ObjectBoxApi.getDir(dbName: 'db_1');

  runZonedGuarded<Future<void>>(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://f3b8abd190f84fa0abdb139178362bc2@o205255.ingest.sentry.io/6067680';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: AppColors.flipperMainColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    //deal with full screen mode flutter 2.5
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.leanBack,
    // );
    // runApp(FlipperAppLegacy());
    runApp(Gate());
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    if (!isWindows) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
