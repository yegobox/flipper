import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/gate.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flipper_services/locator.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import 'init.dart'
    if (dart.library.html) 'web_init.dart'
    if (dart.library.io) 'io_init.dart';

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

  await GetStorage.init();
  // done init in mobile.//done separation.
  setupLocator();
  await initDb();

  ProxyService.notification.initialize();
  await ThemeManager.initialise();

  (!isWindows) ? FirebaseMessaging.onBackgroundMessage(backgroundHandler) : '';
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
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.black,
    //     systemNavigationBarColor: AppColors.flipperMainColor,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    //deal with full screen mode flutter 2.5
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.leanBack,
    // );
    // runApp(FlipperAppLegacy());
    runApp(const Gate());
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    if (!isWindows) {
      recordBug(error, stack);
    }
  });
}
