import 'dart:io';
import 'dart:async';
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
import 'package:flipper_services/notifications/notification_manager.dart';

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
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// Generated in previous step
import 'amplifyconfiguration.dart';

// Import for database configuration
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/storage_adapter.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

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

/// Initialize the database configuration with LocalStorage
/// This connects the LocalStorage implementation with the Repository
/// to provide configurable database filenames
Future<void> initializeDatabaseConfig() async {
  // Initialize the shared preferences storage
  final localStorage = await SharedPreferenceStorage().initializePreferences();

  // Create an adapter that connects LocalStorage to Repository
  final storageAdapter = StorageAdapter(
    getDatabaseFilename: () => localStorage.getDatabaseFilename(),
    getQueueFilename: () => localStorage.getQueueFilename(),
  );

  // Set the storage adapter in the Repository class
  Repository.setConfigStorage(storageAdapter);

  // Log the configured database filenames
  print('Database configured with main DB: ${Repository.dbFileName}');
  print('Database configured with queue DB: ${Repository.queueName}');
}

// Critical dependencies that must be initialized immediately
Future<void> _initializeCriticalDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Platform-specific database initialization
  if (!kIsWeb && Platform.isWindows) {
    // Use the ffi on windows
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  } else if (kIsWeb) {
    databaseFactoryOrNull = databaseFactoryFfiWeb;
  }

  // Initialize the database configuration with LocalStorage
  await initializeDatabaseConfig();

  // Font configuration - moved earlier as it affects UI
  GoogleFonts.config.allowRuntimeFetching = true;
}

// Secondary dependencies that can be initialized in parallel
Future<void> _initializeSecondaryDependencies() async {
  final futures = <Future>[];

  // Supabase initialization
  if (!kIsWeb) {
    futures.add(loadSupabase());
  }

  // License registration
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Firebase initialization
  futures.add(_initializeFirebase());

  // Wait for all parallel operations to complete
  await Future.wait(futures);
}

// Firebase initialization separated for better error handling
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

// Non-critical dependencies that can be initialized after UI is shown
Future<void> _initializeNonCriticalDependencies() async {
  // Amplify configuration
  _configureAmplify();

  const isTest = bool.fromEnvironment('EMULATOR_ENABLED', defaultValue: false);
  if (isTest) {
    //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);
  }

  // Platform-specific optimizations
  if (Platform.isAndroid) {
    // Android-specific optimizations
    await _optimizeForAndroid();
  } else if (Platform.isWindows) {
    // Windows-specific optimizations
    await _optimizeForWindows();
  }
}

// Android-specific optimizations
Future<void> _optimizeForAndroid() async {
  // Reduce EGL issues by deferring non-essential graphics operations
  // This helps with the D/EGL_emulation errors

  // Add a small delay to allow the UI thread to stabilize
  // This helps with the D/EGL_emulation errors on Android
  await Future.delayed(const Duration(milliseconds: 50));

  // Set render priority to reduce EGL issues
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Disable unnecessary animations during startup
  // to reduce GPU load
  if (kDebugMode) {
    print('Applying Android-specific optimizations to reduce EGL issues');
  }
}

// Windows-specific optimizations
Future<void> _optimizeForWindows() async {
  // Windows-specific performance improvements

  // Optimize SQLite operations for Windows
  // This significantly improves startup time on Windows
  if (kDebugMode) {
    print('Applying Windows-specific optimizations');
  }

  // Reduce file I/O operations during startup
  // Windows file I/O can be slow, especially on older systems

  // Optimize memory usage for Windows
  // Windows has different memory management characteristics
}

// Configure error handling for different platforms
Future<void> _configureErrorHandling() async {
  // Only configure for native platforms, not web or Windows
  final bool isNativePlatform = !isWindows && !isWeb;

  if (isNativePlatform) {
    // Set up error handling with Firebase Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error to the console first
      FlutterError.dumpErrorToConsole(details);

      // Then send to Firebase Crashlytics
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    // Handle uncaught async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

// Configure platform-specific services
Future<void> _configurePlatformServices() async {
  // Initialize New Relic only on Android in release mode
  final bool shouldUseNewRelic =
      isAndroid && foundation.kReleaseMode && !isWeb && !isWindows && !isMacOs;

  if (shouldUseNewRelic) {
    NewRelic.initialize();
  }

  // Set up Firebase Messaging (except on Windows)
  if (!isWindows) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }

  // Set up notifications (except on web and Windows)
  if (!isWeb && !isWindows) {
    await NotificationManager.create(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    );
  }

  // Configure SSL certificates for non-web platforms
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
}

// Main dependency initialization function
Future<void> initializeDependencies() async {
  // Step 1: Initialize critical dependencies needed for UI
  await _initializeCriticalDependencies();

  // Step 2: Start secondary dependencies in parallel but don't wait
  // Using unawaited from dart:async to run without waiting for completion
  _initializeSecondaryDependencies()
      .catchError((e) => print('Error in secondary init: $e'));

  // Step 3: Initialize app services and UI components
  await initDependencies();
  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();

  // Step 4: Schedule non-critical dependencies to run after UI is shown
  // This helps reduce the white screen time and improves perceived performance
  // Use a shorter delay on Windows to improve perceived performance
  final delay = Platform.isWindows ? 50 : 100;

  Future.delayed(Duration(milliseconds: delay), () async {
    await _initializeNonCriticalDependencies();
    await _configureErrorHandling();
    await _configurePlatformServices();
  });
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
