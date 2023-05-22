import 'dart:async';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_rw/flipper_localize/lib/flipper_localize.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'init.dart'
    if (dart.library.html) 'web_init.dart'
    if (dart.library.io) 'io_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_animate/flutter_animate.dart';

Future<void> onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) async {
  // Handle the notification here.
  await Sentry.captureMessage(
    'On When notification clicked from background: ${notificationResponse.payload}',
    level: SentryLevel.info,
  );
}

Future<void> backgroundHandler(RemoteMessage message) async {
  final type = message.data['type'];
  if (type == "whatsapp") {
    final conversationKey = message.data['conversation'];
    Map<String, dynamic> conversationMap = json.decode(conversationKey);

    Conversation conversation = Conversation.fromJson(conversationMap);
    // delay so if there is other transaction going on to complete first e.g from pubnub
    Future.delayed(const Duration(seconds: 20));
    Conversation? conversationExistOnLocal = await ProxyService.isarApi
        .getConversation(messageId: conversation.messageId!);
    if (conversationExistOnLocal == null) {
      await ProxyService.isarApi.create(data: conversation);
    }
  }
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
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
    if (isAndroid || isIos) {
      final String timeZoneName =
          await FlutterNativeTimezone.getLocalTimezone();
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    if (!isWindows && !isWeb) {
      FlutterError.onError = (FlutterErrorDetails details) {
        // Log the error to the console.
        FlutterError.dumpErrorToConsole(details);

        // Send the error to Firebase Crashlytics.
        FirebaseCrashlytics.instance.recordFlutterError(details);
      };
    }
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
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

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    // done init in mobile.//done separation.
    await thirdPartyLocator();
    // setPathUrlStrategy();
    loc.setupLocator(
      stackedRouter: stackedRouter,
    );
    setupDialogUi();
    setupBottomSheetUi();
    await initDb();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    if (!isWindows) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      // Check if the app was launched from a terminated state due to a background message
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? initialMessage) {
        if (initialMessage != null) {
          // Handle the initial message
          backgroundHandler(initialMessage);
        }
      });
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        badge: true,
      );
    } else if (isWindows) {}
    runApp(
      OverlaySupport.global(
        child: ChangeNotifierProvider(
          create: (_) => LoginInfo(),
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
      ),
    );
    // close splash screen the app is fully initialized
    FlutterNativeSplash.remove();
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    if (!isWindows) {
      recordBug(error, stack);
    }
  });
}
