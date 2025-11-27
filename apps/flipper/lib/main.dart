// import 'package:flipper_models/helperModels/talker.dart';
import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_rw/state_observer.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_services/app_service.dart';
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
import 'firebase_options.dart';
import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_services/GlobalLogError.dart';
// Flag to control dependency initialization in tests
import 'package:flipper_web/core/utils/initialization.dart';
import 'package:supabase_models/sync/ditto_sync_registry.dart';

// Function to initialize Firebase
Future<void> _initializeFirebase() async {
  try {
    // Don't use microtask for Firebase as critical services depend on it
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // talker.info('Firebase initialized successfully');
  } catch (e) {
    // talker.info('Firebase initialization error: $e');
  }
}

// Function to initialize Supabase.
Future<void> _initializeSupabase() async {
  try {
    await loadSupabase();

    await initializeDitto();
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

  // FIXED: Initialize WidgetsBinding BEFORE Sentry
  WidgetsFlutterBinding.ensureInitialized();
  final widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Centralized initialization function
  Future<void> initializeApp() async {
    if (!skipDependencyInitialization) {
      debugPrint('🚀 Starting app initialization...');

      debugPrint('📱 Initializing Firebase...');
      await _initializeFirebase();
      debugPrint('✅ Firebase initialized');

      debugPrint('🔧 Initializing dependencies...');
      await initializeDependencies();
      debugPrint('✅ Dependencies initialized');

      debugPrint('🗄️  Initializing Supabase...');
      await _initializeSupabase();
      GlobalErrorHandler.initialize();
      loc.setupLocator(stackedRouter: stackedRouter);
      debugPrint('✅ Locator setup complete');

      debugPrint('💬 Setting up dialogs...');
      setupDialogUi();
      debugPrint('✅ Dialogs setup complete');

      debugPrint('📋 Setting up bottom sheets...');
      setupBottomSheetUi();
      debugPrint('✅ Bottom sheets setup complete');

      debugPrint('⚙️  Initializing additional dependencies...');
      await initDependencies();
      debugPrint('✅ Additional dependencies initialized');

      debugPrint('🔄 Registering Ditto sync defaults...');
      await DittoSyncRegistry.registerDefaults();
      debugPrint('✅ Ditto sync defaults registered');

      debugPrint('🎉 App initialization completed successfully!');
    }
  }

  // Run the app within Sentry's guarded zone
  await SentryFlutter.init(
    (options) async => options
      ..dsn = AppSecrets.sentryKey
      ..release = await AppService().version()
      ..environment = 'production'
      ..tracesSampleRate = 0.2
      ..attachScreenshot = false,
    appRunner: () => runApp(
      FutureBuilder(
        future: initializeApp().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            debugPrint('❌ App initialization timed out after 30 seconds');

            final exception = TimeoutException(
              'App initialization timed out',
              const Duration(seconds: 30),
            );

            // Report to telemetry (fire-and-forget)
            try {
              Sentry.captureException(
                exception,
                stackTrace: StackTrace.current,
                hint: Hint.withMap({
                  'context': 'App initialization timeout',
                  'timeout_duration': '30 seconds',
                }),
              );
            } catch (e) {
              debugPrint('Failed to report timeout to telemetry: $e');
            }

            throw exception;
          },
        ),
        builder: (context, snapshot) {
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

                // Send to Sentry
                Sentry.captureException(
                  snapshot.error,
                  stackTrace: stackTrace,
                  hint: Hint.withMap({
                    'context': 'App initialization failed',
                    'error_type': snapshot.error.runtimeType.toString(),
                  }),
                );

                // Send to GlobalErrorHandler
                GlobalErrorHandler.logError(
                  snapshot.error!,
                  stackTrace: stackTrace,
                  type: 'initialization_error',
                  context: {
                    'error_type': snapshot.error.runtimeType.toString()
                  },
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
            // Remove splash screen when the main app is ready
            debugPrint('🎬 [main.dart] Removing splash screen...');
            FlutterNativeSplash.remove();
            debugPrint(
                '🎬 [main.dart] Splash removed, returning FlipperApp...');
            return const FlipperApp();
          } else {
            // While initializing, show the loading screen.
            // The native splash is preserved until the future completes.
            return const MaterialApp(
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
    ),
  );
}

class FlipperApp extends StatelessWidget {
  const FlipperApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🎬 [FlipperApp] Building FlipperApp widget tree...');
    return ProviderScope(
      observers: [StateObserver()],
      child: OverlaySupport.global(
        child: MaterialApp.router(
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
        ),
      ),
    );
  }
}
