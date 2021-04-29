import 'package:flipper/routes.router.dart';
import 'package:flipper_login/flipper_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class FlipperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
