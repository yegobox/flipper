import 'dart:async';
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

// Flag to control dependency initialization in tests
bool skipDependencyInitialization = false;

// net info: billers
//1.1.14
Future<void> main() async {
  // Preserve the native splash screen until initialization is complete
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Keep the device in portrait mode during initialization to avoid UI issues
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase first as critical services depend on it
  await _initializeFirebase();

  // Initialize Supabase next as Repository depends on it
  await _initializeSupabase();

  // Initialize critical UI-related services
  loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();
  
  // Initialize minimal dependencies required for UI
  await initDependencies();

  // Initialize the rest of the dependencies in the background
  // while showing the UI to the user
  if (!skipDependencyInitialization) {
    // Start initialization but don't block UI
    initializeDependencies().then((_) {
      print('All dependencies initialized');
    });
  }
  
  await SentryFlutter.init(
    (options) => options
      ..dsn = kDebugMode ? AppSecrets.sentryKey : AppSecrets.sentryKey
      ..release = 'flipper@1.170.4252223232243+1723059742'
      ..environment = 'production'
      ..experimental.replay.sessionSampleRate = 1.0
      ..experimental.replay.onErrorSampleRate = 1.0
      ..tracesSampleRate = 1.0
      ..attachScreenshot = true,
    appRunner: () {
      // Remove the native splash screen once the app is ready to show
      FlutterNativeSplash.remove();

      // Now run the actual app
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
                  cardTheme: CardTheme(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                // darkTheme: ThemeData(
                //   textTheme: GoogleFonts.poppinsTextTheme(),
                //   brightness: Brightness.light, // Use dark brightness
                //   primaryColor: Colors.blue,
                //   colorScheme: ColorScheme.fromSeed(
                //     seedColor: Colors.blue, // Set a dark theme color
                //     brightness:
                //         Brightness.light, // Important: Set brightness to dark
                //     primary: Colors.blue,
                //     secondary: Colors.grey[800]!, // Example dark secondary color
                //   ).copyWith(
                //       surface: Colors.grey[900]!), // Example dark surface color
                //   appBarTheme: const AppBarTheme(
                //     backgroundColor: Colors.black,
                //     foregroundColor: Colors.white,
                //     elevation: 0,
                //   ),
                //   cardTheme: CardTheme(
                //     elevation: 2,
                //     color: Colors.grey[800], // Example dark card color
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(4)),
                //   ),
                // ),
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
}
