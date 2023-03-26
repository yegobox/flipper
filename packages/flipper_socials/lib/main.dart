import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flipper_socials/app/app.bottomsheets.dart';
import 'package:flipper_socials/app/app.dialogs.dart';
import 'package:flipper_socials/app/app.locator.dart';
import 'package:flipper_socials/app/app.router.dart';
import 'package:flipper_socials/ui/common/app_colors.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  setPathUrlStrategy();
  setupLocator(
    stackedRouter: stackedRouter,
  );
  setupDialogUi();
  setupBottomSheetUi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
        builder: (_) => MaterialApp.router(
              title: 'Stacked Application',
              theme: Theme.of(context).copyWith(
                primaryColor: kcBackgroundColor,
                focusColor: kcPrimaryColor,
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black,
                    ),
              ),
              routerDelegate: stackedRouter.delegate(),
              routeInformationParser: stackedRouter.defaultRouteParser(),
            ).animate().fadeIn(
                  delay: const Duration(milliseconds: 50),
                  duration: const Duration(milliseconds: 400),
                ));
  }
}
