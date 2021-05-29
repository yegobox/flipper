import 'dart:io';

import 'package:flipper/flipper_options.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_login/flipper_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isWeb = UniversalPlatform.isWeb;

class FlipperApp extends StatefulWidget {
  @override
  State<FlipperApp> createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  @override
  Widget build(BuildContext context) {
    if (!isWindows && !isMacOs) {
      final FirebaseAnalytics analytics = FirebaseAnalytics();
      final FirebaseAnalyticsObserver observer =
          FirebaseAnalyticsObserver(analytics: analytics);

      return MaterialApp(
        themeMode: ThemeMode.system,
        theme: FlipperThemeData.lightThemeData
            .copyWith(platform: TargetPlatform.android),
        darkTheme: FlipperThemeData.darkThemeData
            .copyWith(platform: TargetPlatform.android),
        debugShowCheckedModeBanner: false,
        title: 'flipper',
        localizationsDelegates: const [
          ...FlipperLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate()
        ],
        supportedLocales: FlipperLocalizations.supportedLocales,
        // locale: FlipperOptions.of(context).locale,
        locale: const Locale('es'),
        localeResolutionCallback: (locale, supportedLocales) {
          deviceLocale = locale!;
          return locale;
        },
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: <NavigatorObserver>[observer],
        onGenerateRoute: StackedRouter().onGenerateRoute,
      );
    } else {
      return MaterialApp(
        themeMode: ThemeMode.system,
        theme: FlipperThemeData.lightThemeData
            .copyWith(platform: TargetPlatform.android),
        darkTheme: FlipperThemeData.darkThemeData
            .copyWith(platform: TargetPlatform.android),
        debugShowCheckedModeBanner: false,
        title: 'flipper',
        localizationsDelegates: const [
          ...FlipperLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate()
        ],
        supportedLocales: FlipperLocalizations.supportedLocales,
        // locale: FlipperOptions.of(context).locale,
        locale: const Locale('es'),
        localeResolutionCallback: (locale, supportedLocales) {
          deviceLocale = locale!;
          return locale;
        },
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
      );
    }
  }
}
