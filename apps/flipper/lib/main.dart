import 'dart:async';
import 'dart:isolate';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/StateObserver.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/locator.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/log_service.dart';

import 'dart:developer' as developer;

// Memory tracking variables
bool _memoryTrackingEnabled = true;
Timer? _memoryTrackingTimer;

// Function to initialize Firebase
Future<void> _initializeFirebase() async {
  try {
    // Don't use microtask for Firebase as critical services depend on it
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

// Function to initialize Supabase
Future<void> _initializeSupabase() async {
  try {
    // Wrap in a microtask to allow UI thread to continue
    await Future<void>.microtask(() async {
      await loadSupabase();
      print('Supabase initialized successfully');
    });
  } catch (e) {
    print('Supabase initialization error: $e');
  }
}

// Function to start memory tracking
void _startMemoryTracking() {
  if (!_memoryTrackingEnabled || !kDebugMode) return;

  _memoryTrackingTimer?.cancel();
  _memoryTrackingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
    _trackMemoryUsage();
  });

  developer.log('Memory tracking started', name: 'MemoryTracker');
}

// Function to track memory usage
void _trackMemoryUsage() {
  final info = WidgetsBinding.instance.runtimeType.toString();
  developer.log('Memory tracking: $info', name: 'MemoryTracker');

  // Force a GC to get more accurate readings
  if (kDebugMode) {
    developer.log('Forcing GC for memory tracking', name: 'MemoryTracker');
  }

  // Log memory info from VM
  try {
    developer.Timeline.startSync('getMemoryInfo');
    developer.postEvent('memory', {'command': 'collect'});
    developer.Timeline.finishSync();

    developer.log('Memory tracking completed', name: 'MemoryTracker');
  } catch (e) {
    developer.log('Error tracking memory: $e', name: 'MemoryTracker');
  }
}

// Flag to control dependency initialization in tests
bool skipDependencyInitialization = false;

// net info: billers
//1.1.14
Future<void> main() async {
  // Initialize GlobalErrorHandler first to capture early errors
  GlobalErrorHandler.initialize();

  // Flutter framework error handler - combine Sentry with LogService
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Send to both Sentry and our LogService
    Sentry.captureException(details.exception, stackTrace: details.stack);
    LogService().logException(details.exception,
        stackTrace: details.stack, type: 'flutter_error');
  };

  // Run everything in a guarded zone
  await runZonedGuarded<Future<void>>(() async {
    final widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (!skipDependencyInitialization) {
      await _initializeFirebase();
      await _initializeSupabase();
      loc.setupLocator(stackedRouter: stackedRouter);
      setupDialogUi();
      setupBottomSheetUi();
      await initDependencies();
      initializeDependencies().then((_) {
        print('All dependencies initialized');
      });
    }

    await SentryFlutter.init(
      (options) => options
        ..dsn = kDebugMode ? AppSecrets.sentryKeyDev : AppSecrets.sentryKey
        ..release = 'flipper@1.170.4252223232243+1723059742'
        ..environment = 'production'
        ..experimental.replay.sessionSampleRate = 1.0
        ..experimental.replay.onErrorSampleRate = 1.0
        ..tracesSampleRate = 1.0
        ..attachScreenshot = true,
      appRunner: () {
        // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          FlutterNativeSplash.remove();
          // Use PosthogService singleton to initialize PostHog
          await PosthogService.instance.initialize();

          // Start memory tracking after app initialization
          if (kDebugMode) {
            _startMemoryTracking();
          }

          // Initialize asset sync service for background uploads
        });
        runApp(
          ProviderScope(
            observers: [StateObserver()],
            child: OverlaySupport.global(
              child: Sizer(builder: (context, orientation, deviceType) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'flipper',
                  theme: ThemeData(
                    textTheme: GoogleFonts.poppinsTextTheme(),
                    brightness: Brightness.light,
                    primaryColor: Colors.blue,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF00C2E8),
                      primary: const Color(0xFF00C2E8),
                      secondary: const Color(0xFF1D1D1D),
                    ).copyWith(surface: Colors.white),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    cardTheme: CardThemeData(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
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
                    Locale('en'),
                    Locale('es'),
                  ],
                  locale: const Locale('en'),
                  themeMode: ThemeMode.system,
                  routerDelegate: stackedRouter.delegate(),
                  routeInformationParser: stackedRouter.defaultRouteParser(),
                );
              }),
            ),
          ),
        );
      },
    );
  }, (error, stackTrace) {
    // Catch uncaught async errors
    Sentry.captureException(error, stackTrace: stackTrace``);
    // Also log to our LogService
    LogService()
        .logException(error, stackTrace: stackTrace, type: 'zone_error');
    debugPrint("Uncaught error: $error");
  });

  // Add isolate error listener
  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      final error = errorAndStacktrace.first;
      final stackTrace = errorAndStacktrace.last;

      // Send to both Sentry and LogService
      Sentry.captureException(error,
          stackTrace: StackTrace.fromString(stackTrace.toString()));
      await LogService().logException(
        error,
        stackTrace: StackTrace.fromString(stackTrace.toString()),
        type: 'isolate_error',
      );
    }).sendPort,
  );
}
