import 'package:flipper/routes.router.dart';
import 'package:flipper_login/flipper_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class FlipperApp extends StatelessWidget {
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
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: StackedRouter().onGenerateRoute,
      );
    }
  }
}
