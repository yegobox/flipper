import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:amplify_flutter/amplify_flutter.dart' as apmplify;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/notification_manager.dart';
import 'package:flipper_services/locator.dart';

import 'new_relic.dart' if (dart.library.html) 'new_relic_web.dart';
import 'amplifyconfiguration.dart';

Future<void> _configureAmplify() async {
  final authPlugin = cognito.AmplifyAuthCognito();
  AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
  await apmplify.Amplify.addPlugins([
    authPlugin,
    amplifyStorageS3,
  ]);

  try {
    await apmplify.Amplify.configure(amplifyconfig);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {}

const kWebRecaptchaSiteKey = '';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _initializeCriticalDependencies() async {
  // Configure HTTP overrides for SSL/TLS connections
  if (!foundation.kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    debugPrint('HTTP overrides configured for secure connections');
    ByteData data =
        // echo | openssl s_client -connect apihub.yegobox.com:443 | openssl x509 > apihub.yegobox.pem
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  // Platform-specific database initialization
  if (!foundation.kIsWeb && Platform.isWindows) {
    databaseFactoryOrNull = databaseFactoryFfi;
  } else if (foundation.kIsWeb) {
    databaseFactoryOrNull = databaseFactoryFfiWeb;
  }
  // Font configuration
  GoogleFonts.config.allowRuntimeFetching = true;
}

Future<void> _initializeSecondaryDependencies() async {
  // License registration
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

Future<void> _initializeNonCriticalDependencies() async {
  _configureAmplify();

  const isTest = bool.fromEnvironment('EMULATOR_ENABLED', defaultValue: false);
  if (isTest) {
    // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);
  }

  if (Platform.isAndroid) {
    await _optimizeForAndroid();
  }
}

Future<void> _optimizeForAndroid() async {
  await Future.delayed(const Duration(milliseconds: 100));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  if (foundation.kDebugMode) {
    debugPrint('Applying Android-specific optimizations to reduce EGL issues');
  }
}

Future<void> _configureErrorHandling() async {
  final bool isNativePlatform = !isWindows && !isWeb;

  if (isNativePlatform) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    foundation.PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

Future<void> _configurePlatformServices() async {
  final bool shouldUseNewRelic =
      isAndroid && foundation.kReleaseMode && !isWeb && !isWindows && !isMacOs;

  if (shouldUseNewRelic) {
    NewRelic.initialize();
  }

  if (!isWindows) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }

  if (!isWeb && !isWindows) {
    await NotificationManager.create(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    );
  }
}

Future<void> initializeDependencies() async {
  try {
    await _initializeCriticalDependencies();

    if (!foundation.kIsWeb) {
      if (Platform.isAndroid) {
        _optimizeForAndroid()
            .catchError((e) => debugPrint('Android optimization error: $e'));
      }
    }

    _initializeSecondaryDependencies()
        .catchError((e) => debugPrint('Error in secondary init: $e'));

    await _initializeNonCriticalDependencies();
    await _configureErrorHandling();
    await _configurePlatformServices();
  } catch (e, stackTrace) {
    debugPrint('Error during dependency initialization: $e');
    debugPrint(stackTrace.toString());
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    } catch (_) {
      // Ignore errors when logging errors
    }
  }
}

Future<void> initializeDependenciesForTest({
  LocalStorage? localStorage,
  DatabaseSyncInterface? databaseSyncInterface,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadSupabase();

  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();

  await initDependencies();
}
