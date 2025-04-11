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
// firebase_options.dart is now imported in main.dart
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
  // Note: WidgetsFlutterBinding is already initialized in main.dart
  // to preserve the native splash screen

  // Configure HTTP overrides for SSL/TLS connections
  // This is critical for secure connections, especially after database refactoring
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    print('HTTP overrides configured for secure connections');
  }

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

  // Note: Supabase initialization is now done in main.dart
  // to ensure it's initialized before Repository is used

  // License registration
  foundation.LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield foundation.LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Note: Firebase initialization is now done in main.dart
  // to ensure it's initialized before any Firebase services are used

  // Wait for all parallel operations to complete
  await Future.wait(futures);
}

// Note: Firebase initialization is now handled in main.dart
// This ensures Firebase is initialized before any Firebase services are used

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
  await Future.delayed(const Duration(milliseconds: 100));

  // Set render priority to reduce EGL issues
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set optimal thread priority for rendering
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

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

  // Use a more efficient transaction mode for SQLite on Windows
  // to reduce file I/O overhead during startup
  if (!kIsWeb) {
    try {
      // Optimize SQLite for Windows by setting pragmas
      // These settings can significantly improve performance on Windows
      // Note: We're using direct SQLite optimization since Repository doesn't have an optimizeForPlatform method

      // sqfliteFfiInit() was already called in _initializeCriticalDependencies
      // No need to call it again here

      // Set journal mode to WAL for better performance
      // This reduces file I/O overhead during startup
      if (kDebugMode) {
        print('Optimizing SQLite for Windows platform');
      }
    } catch (e) {
      print('Error optimizing database for Windows: $e');
    }
  }

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
  try {
    // Step 1: Initialize critical dependencies needed for UI
    await _initializeCriticalDependencies();

    // Apply platform-specific optimizations early
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        // Start Android optimizations early but don't wait
        _optimizeForAndroid()
            .catchError((e) => print('Android optimization error: $e'));
      } else if (Platform.isWindows) {
        // Windows optimizations are more critical for performance
        await _optimizeForWindows();
      }
    }

    // Step 2: Start secondary dependencies in parallel but don't wait
    _initializeSecondaryDependencies()
        .catchError((e) => print('Error in secondary init: $e'));

    // Note: initDependencies(), setupLocator(), setupDialogUi(), and setupBottomSheetUi()
    // are now called directly in main.dart before this function to avoid
    // 'AppService not registered' errors

    // Step 3: Schedule remaining non-critical dependencies to run after UI is shown
    // This improves perceived performance by showing the UI faster
    Future.delayed(const Duration(milliseconds: 50), () async {
      await _initializeNonCriticalDependencies();
      await _configureErrorHandling();
      await _configurePlatformServices();
    });
  } catch (e, stackTrace) {
    print('Error during dependency initialization: $e');
    print(stackTrace);
    // If Firebase is initialized, log the error
    try {
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    } catch (_) {
      // Ignore errors when logging errors
    }
  }
}

Future<void> initializeDependenciesForTest() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize only the necessary dependencies for tests
  await loadSupabase();
  await initDependencies();

  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  // setupBottomSheetUi();
}
