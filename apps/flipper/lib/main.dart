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

//1.0.1
Future<void> main() async {
  await initializeDependencies();
  await SentryFlutter.init(
    (options) => options
      ..dsn = kDebugMode ? AppSecrets.sentryKeyDev : AppSecrets.sentryKey
      ..release = 'flipper@1.170.4252223232243+1723059742'
      ..environment = 'production'
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
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.blueAccent,
                ).copyWith(surface: Colors.white),
                cardTheme: CardTheme(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
    ),
  );
}
