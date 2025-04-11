import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/StateObserver.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

/// A loading app that shows immediately while dependencies are initializing
class FlipperLoadingApp extends StatelessWidget {
  const FlipperLoadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.light,
        primaryColor: const Color(0xFF00C2E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C2E8),
          primary: const Color(0xFF00C2E8),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/Title with a subtle scaling animation
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(1.1),
                child: Text(
                  'Flipper',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Loading description with a fade-in effect
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 800),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF00C2E8).withOpacity(0.7)),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Flag to control dependency initialization in tests
bool skipDependencyInitialization = false;

// net info: billers
//1.1.14
Future<void> main() async {
  // Ensure Flutter binding is initialized first so we can show a loading UI immediately
  WidgetsFlutterBinding.ensureInitialized();

  // Show the app with a loading indicator while dependencies initialize
  runApp(const FlipperLoadingApp());

  // Initialize dependencies in the background
  if (!skipDependencyInitialization) {
    await initializeDependencies();
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
    appRunner: () => runApp(
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
    ),
  );
}
