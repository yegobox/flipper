import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:logging/logging.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_rw/state_observer.dart';
import 'package:flipper_models/amplify_config_helper.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_services/locator.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_services/GlobalLogError.dart';
// Flag to control dependency initialization in tests
// import 'package:flipper_web/core/utils/initialization.dart';
//
import 'package:supabase_models/sync/ditto_sync_registry.dart';

import 'package:ditto_live/ditto_live.dart';
import 'package:permission_handler/permission_handler.dart';

// Function to initialize Firebase
Future<void> _initializeFirebase() async {
  try {
    final platform = Ditto.currentPlatform;

    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      debugPrint('📱 [Firebase] Requesting permissions (non-blocking)...');
      // Fire and forget permission requests so they don't block the startup sequence
      unawaited([
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.notification,
      ].request().timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('⚠️ [Firebase] Background permission request timed out');
        return {};
      }));
    }
    // Don't use microtask for Firebase as critical services depend on it
    debugPrint('📱 [Firebase] Calling Firebase.initializeApp...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      debugPrint('⚠️ [Firebase] Firebase.initializeApp timed out');
      throw TimeoutException('Firebase.initializeApp timed out');
    });
    // talker.info('Firebase initialized successfully');
  } catch (e) {
    // talker.info('Firebase initialization error: $e');
  }
}

// Function to initialize Supabase.
Future<void> _initializeSupabase() async {
  try {
    await loadSupabase();

    // await initializeDitto(); // Initialization moved to AppService
  } catch (e) {
    // talker.info('Supabase initialization error: $e');
  }
}

// Function to initialize Transaction Delegation (Real-time Ditto-based)

bool skipDependencyInitialization = false;
// net info: billers
//1.1.14
Future<void> main() async {
  // Initialize GlobalErrorHandler first to capture early errors

  // Initialize WidgetsBinding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure logging
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Centralized initialization function
  Future<void> initializeApp() async {
    if (!skipDependencyInitialization) {
      debugPrint('🚀 [main] initializeApp starting...');

      debugPrint('� [main] Step 1: _initializeFirebase...');
      await _initializeFirebase();

      debugPrint('� [main] Step 2: setupLocator...');
      loc.setupLocator(stackedRouter: stackedRouter);
      setupDialogUi();
      setupBottomSheetUi();

      debugPrint('� [main] Step 3: initializeDependencies...');
      await initializeDependencies();

      debugPrint('🚀 [main] Step 4: GlobalErrorHandler.initialize...');
      GlobalErrorHandler.initialize();

      debugPrint('� [main] Step 5: _initializeSupabase...');
      await _initializeSupabase();

      debugPrint('🚀 [main] Step 6: initDependencies...');
      await initDependencies();

      debugPrint('🚀 [main] Step 7: Amplify configuration...');
      final isSimulator = UniversalPlatform.isIOS && !UniversalPlatform.isWeb;
      final shouldBlock =
          !kDebugMode && !isSimulator && !AppSecrets.isTestEnvironment();
      await AmplifyConfigHelper.configureAmplify(block: shouldBlock);

      debugPrint('🚀 [main] Step 8: DittoSyncRegistry.registerDefaults...');
      await DittoSyncRegistry.registerDefaults();

      debugPrint('🎉 [main] initializeApp completed successfully!');
    }
  }

  runApp(
    FutureBuilder(
      future: initializeApp().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          debugPrint('❌ App initialization timed out after 60 seconds');

          final exception = TimeoutException(
            'App initialization timed out',
            const Duration(seconds: 60),
          );

          // Report to telemetry (fire-and-forget)
          try {
            Sentry.captureException(
              exception,
              stackTrace: StackTrace.current,
              hint: Hint.withMap({
                'context': 'App initialization timeout',
                'timeout_duration': '60 seconds',
              }),
            );
          } catch (e) {
            debugPrint('Failed to report timeout to telemetry: $e');
          }

          throw exception;
        },
      ),
      builder: (context, snapshot) {
        debugPrint(
            '🎬 [main] FutureBuilder snapshot: ${snapshot.connectionState} | hasError: ${snapshot.hasError} | hasData: ${snapshot.hasData}');
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Remove splash screen before showing error
            FlutterNativeSplash.remove();
            // Log full error to Sentry/monitoring
            debugPrint('❌ App initialization error: ${snapshot.error}');
            if (snapshot.stackTrace != null) {
              debugPrint('Stack trace: ${snapshot.stackTrace}');
            }

            // Report to telemetry systems
            try {
              final stackTrace = snapshot.stackTrace ?? StackTrace.current;
              Sentry.captureException(
                snapshot.error,
                stackTrace: stackTrace,
                hint: Hint.withMap({
                  'context': 'App initialization failed',
                  'error_type': snapshot.error.runtimeType.toString(),
                }),
              );

              GlobalErrorHandler.logError(
                snapshot.error!,
                stackTrace: stackTrace,
                type: 'initialization_error',
                context: {'error_type': snapshot.error.runtimeType.toString()},
              );
            } catch (e) {
              debugPrint('Failed to report error to telemetry: $e');
            }

            // Show user-friendly error screen
            return const MaterialApp(
              home: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Initialization Failed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Something went wrong while starting the app. Please try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Remove splash screen immediately when initialization is done
          FlutterNativeSplash.remove();
          debugPrint('🎬 [main] Splash removed, returning FlipperApp');

          // Return FlipperApp.
          return const FlipperApp();
        } else {
          // While initializing, show the loading screen.
          // The native splash is preserved until the future completes.
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    ),
  );
}

/// Keep in sync with [DevicePreview.enabled] on [FlipperApp]. When preview is on,
/// `MaterialApp.router` must pass the inherited `MediaQuery` flag expected by
/// `package:device_preview` (`isWidgetsAppUsingInheritedMediaQuery` assert).
const bool kFlipperDevicePreviewEnabled = kDebugMode;

class FlipperApp extends StatefulWidget {
  const FlipperApp({super.key});

  @override
  State<FlipperApp> createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  late final ThemeData _theme;
  /// Must be created once per app lifetime. Calling [stackedRouter.delegate] on every
  /// [build] recreates the navigator delegate and can attach [RenderObject]s while an
  /// ancestor [LayoutBuilder] is still in [performLayout], triggering Flutter's
  /// "mutated in performLayout" assertion (often surfaced via DevicePreview).
  late final RouterDelegate<Object> _routerDelegate;
  late final RouteInformationParser<Object> _routeInformationParser;

  @override
  void initState() {
    debugPrint('🎬 [FlipperApp] initState called');
    super.initState();
    _theme = _buildTheme();
    _routerDelegate = stackedRouter.delegate() as RouterDelegate<Object>;
    _routeInformationParser =
        stackedRouter.defaultRouteParser() as RouteInformationParser<Object>;
    // Remove splash screen after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '🎬 [FlipperApp] First frame rendered, removing splash screen...');
      FlutterNativeSplash.remove();
    });
  }

  ThemeData _buildTheme() {
    // Disable runtime fetching since we have fonts bundled in flipper/google_fonts
    GoogleFonts.config.allowRuntimeFetching = false;

    return ThemeData(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎬 [FlipperApp] build start');

    return ProviderScope(
      observers: [StateObserver()],
      child: OverlaySupport.global(
        child: DevicePreview(
          enabled: kFlipperDevicePreviewEnabled,
          tools: const [
            ...DevicePreview.defaultTools,
          ],
          builder: (context) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'flipper',
            theme: _theme,
            // Required by package:device_preview when enabled (assert).
            useInheritedMediaQuery: kFlipperDevicePreviewEnabled, // ignore: deprecated_member_use
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
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
            builder: (context, child) {
              return child!;
            },
          ),
        ),
      ),
    );
  }
}
