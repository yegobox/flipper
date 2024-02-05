import 'dart:async';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_rw/StateObserver.dart';

import 'package:flipper_rw/flipper_localize/lib/flipper_localize.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';

import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'newRelic.dart' if (dart.library.html) 'newRelic_web.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

///TODO: need to generate this key in firebase
const kWebRecaptchaSiteKey = '';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!isWindows) {
    ///https://firebase.google.com/docs/app-check/flutter/debug-provider?hl=en&authuser=1
    await FirebaseAppCheck.instance.activate(
      // Android:
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,

      ///TODO: enable appCheck on ios and web when I support them
      /// iOS:
      appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
      // Web:
      webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
    );
  }
  if (!isWindows && !isWeb) {
    /// init admob
    await MobileAds.instance.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error to the console.
      FlutterError.dumpErrorToConsole(details);

      // Send the error to Firebase Crashlytics.
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
  }
  if (isAndroid && foundation.kReleaseMode && !isWeb & !isWindows) {
    NewRelic.initialize();
  }
  if (!isWindows) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initDependencies();
  loc.setupLocator(
    stackedRouter: stackedRouter,
  );
  setupDialogUi();
  setupBottomSheetUi();

  ///Will switch to localNotification when it support windows
  if (isAndroid || isIos && !isWeb) {
    await NotificationsCubit.initialize(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    );
  }

  HttpOverrides.global = MyHttpOverrides();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  await SentryFlutter.init(
    (options) {
      options.dsn = kDebugMode
          ? ''
          : 'https://f3b8abd190f84fa0abdb139178362bc2@o205255.ingest.sentry.io/6067680';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
    },
    appRunner: () => runApp(
      ProviderScope(
        observers: [StateObserver()],
        child: OverlaySupport.global(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: true,
            title: 'flipper',
            // Define the light theme for the app, based on defined colors and
            // properties above.
            //TODOimplement my own as this is killing design
            // theme: GThemeGenerator.generate(),
            // darkTheme: GThemeGenerator.generateDark(),
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            localizationsDelegates: [
              FirebaseUILocalizations.withDefaultOverrides(
                const LabelOverrides(),
              ),
              const FlipperLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              CountryLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
            ],
            locale: const Locale('en'),
            // locale: model
            //     .languageService.locale,
            // themeMode: model.settingService.themeMode.value,
            themeMode: ThemeMode.system,
            routerDelegate: stackedRouter.delegate(),
            routeInformationParser: stackedRouter.defaultRouteParser(),
          ),
        ),
      ),
    ),
  );
}
