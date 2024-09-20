import 'dart:async';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flipper_models/power_sync/powersync.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'newRelic.dart' if (dart.library.html) 'newRelic_web.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// TODO: configure https://docs.amplify.aws/gen1/flutter/start/project-setup/platform-setup/ for ios,macos
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart' as apmplify;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;

// Generated in previous step
import 'amplifyconfiguration.dart';

Future<void> _configureAmplify() async {
  // Add any Amplify plugins you want to use
  final authPlugin = cognito.AmplifyAuthCognito();
  AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
  // await apmplify.Amplify.addPlugin(authPlugin);
  await apmplify.Amplify.addPlugins([
    authPlugin,
    amplifyStorageS3,
  ]);

  // You can use addPlugins if you are going to be adding multiple plugins
  // await Amplify.addPlugins([authPlugin, analyticsPlugin]);

  // Once Plugins are added, configure Amplify
  // Note: Amplify can only be configured once.
  try {
    await apmplify.Amplify.configure(amplifyconfig);
  } catch (e) {
    print(e);
  }
}

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

Future<void> initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Add any other initialization code here

  GoogleFonts.config.allowRuntimeFetching = false;
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.settings = const Settings(
  //   persistenceEnabled: true,
  // );
  await openDatabase();
  _configureAmplify();
  if (!isWindows) {
    ///https://firebase.google.com/docs/app-check/flutter/debug-provider?hl=en&authuser=1
    // await FirebaseAppCheck.instance.activate(
    //   // Android:
    //   androidProvider:
    //       kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,

    //   ///TODO: enable appCheck on ios and web when I support them
    //   appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    //   // Web:
    //   webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
    // );
  }
  // TODO: to support Ios following these instruction https://developers.google.com/admob/flutter/quick-start#ios
  if (!isWindows && !isWeb && !isMacOs && !isLinux) {
    // MapboxOptions.setAccessToken(AppSecrets.MAPBOX_TOKEN);

    /// init admob
    // await MobileAds.instance.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error to the console.
      FlutterError.dumpErrorToConsole(details);

      // Send the error to Firebase Crashlytics.
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
  }
  if (isAndroid && foundation.kReleaseMode && !isWeb & !isWindows && !isMacOs) {
    NewRelic.initialize();
  }
  if (!isWindows) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }

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

  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  // Add any other necessary initializations
}

Future<void> initializeDependenciesForTest() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize only the necessary dependencies for tests
  await initDependencies();
  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();

  // Mock or stub any services that are required for your tests
  // For example:
  // locator.registerSingleton<ProxyService>(MockProxyService());
}
