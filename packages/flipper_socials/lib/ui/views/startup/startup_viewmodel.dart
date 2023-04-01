import 'package:flipper_routing/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  //final _routerService = locator<RouterService>();
  final BuildContext? context;
  final _routerService = locator<RouterService>();
  StartupViewModel({this.context});
  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    // GoRouter.of(context!).push('/home');
    _routerService.replaceWith(const FlipperAppRoute());
    // GoRouter.of(context!).push('/onboarding');
    // await _routerService.replaceWith(const HomeViewRoute());
  }
}
