import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_rw/flipper_localize/lib/flipper_localize.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_fonts/google_fonts.dart';
import 'package:newrelic_mobile/config.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  // Handle the notification here.
  await Sentry.captureMessage(
    'On When notification clicked from background: ${notificationResponse.payload}',
    level: SentryLevel.info,
  );
}

Future<void> backgroundHandler(RemoteMessage message) async {}

void main() async {
  runZonedGuarded<Future<void>>(() async {
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

    if (isWindows || isLinux) {
      // TODO: implement when windows notifification is supported in localNotification plugin
      /// ref: https://github.com/Merrit/adventure_list
      // final systemTray = SystemTrayManager(appWindow);
      // await systemTray.initialize();
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!isWindows && !isWeb) {
      FlutterError.onError = (FlutterErrorDetails details) {
        // Log the error to the console.
        FlutterError.dumpErrorToConsole(details);

        // Send the error to Firebase Crashlytics.
        FirebaseCrashlytics.instance.recordFlutterError(details);
      };
    }
    if (isAndroid && foundation.kReleaseMode) {
      const appToken = "AAbbd887ce4300ef17e2e403be632d198c86f486a0-NRMA";
      Config config = Config(
          accessToken: appToken,
          analyticsEventEnabled: true,
          networkErrorRequestEnabled: true,
          networkRequestEnabled: true,
          crashReportingEnabled: true,
          interactionTracingEnabled: true,
          httpResponseBodyCaptureEnabled: true,
          loggingEnabled: true,
          webViewInstrumentation: true,
          printStatementAsEventsEnabled: true,
          httpInstrumentationEnabled: true);
      await NewrelicMobile.instance.startAgent(config);
    }
    if (foundation.kReleaseMode) {
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://f3b8abd190f84fa0abdb139178362bc2@o205255.ingest.sentry.io/6067680';
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          options.tracesSampleRate = 1.0;
          options.attachScreenshot = true;
        },
      );
    }

    if (!isWindows) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        badge: true,
      );
    } else if (isWindows) {}
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await initDependencies();
    // setPathUrlStrategy();
    loc.setupLocator(
      stackedRouter: stackedRouter,
    );
    setupDialogUi();
    setupBottomSheetUi();

    ///Will switch to localNotification when it support windows
    if (isAndroid || isIos) {
      await NotificationsCubit.initialize(
        flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
      );
    }
    runApp(
      OverlaySupport.global(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: true,
          title: 'flipper',
          // Define the light theme for the app, based on defined colors and
          // properties above.
          //TODOimplement my own as this is killing design
          // theme: GThemeGenerator.generate(),
          // darkTheme: GThemeGenerator.generateDark(),
          theme: ThemeData(
            useMaterial3: true,
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
        ).animate().fadeIn(
              delay: const Duration(milliseconds: 50),
              duration: const Duration(milliseconds: 400),
            ),
      ),
    );

    // close splash screen the app is fully initialized
    FlutterNativeSplash.remove();
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    if (!isWindows) {
      // recordBug(error, stack);
    }
  });
}
