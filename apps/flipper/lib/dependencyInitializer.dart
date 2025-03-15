import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flipper_models/power_sync/supabase.dart';
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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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

  if (Platform.isWindows) {
    // Use the ffi on windows
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  // Add any other initialization code here
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await loadSupabase();
  GoogleFonts.config.allowRuntimeFetching = false;
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e);
  }

  const isTest = bool.fromEnvironment('EMULATOR_ENABLED', defaultValue: false);
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: false);
  if (isTest) {
    //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);
  }

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
  final comparable = !isWindows && !isWeb;
  // TODO: to support Ios following these instruction https://developers.google.com/admob/flutter/quick-start#ios
  if (comparable) {
    // MapboxOptions.setAccessToken(AppSecrets.MAPBOX_TOKEN);

    /// init admob
    // await MobileAds.instance.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error to the console.
      FlutterError.dumpErrorToConsole(details);

      // Send the error to Firebase Crashlytics.
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    };
  }
  final newrelic =
      isAndroid && foundation.kReleaseMode && !isWeb & !isWindows && !isMacOs;
  if (newrelic) {
    NewRelic.initialize();
  }
  if (!isWindows) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }

  await initDependencies();
  loc.setupLocator(
    stackedRouter: stackedRouter,
  );
  setupDialogUi();
  setupBottomSheetUi();
  // await openDatabase();

  ///Will switch to localNotification when it support windows
  if (!isWeb && !isWindows) {
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
  await loadSupabase();
  await initDependencies();

  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();
}
