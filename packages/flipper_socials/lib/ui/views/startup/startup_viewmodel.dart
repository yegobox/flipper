import 'package:stacked/stacked.dart';
// import 'package:flipper_socials/app/app.locator.dart';
// import 'package:flipper_socials/app/app.router.dart';
// import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartupViewModel extends BaseViewModel {
  //final _routerService = locator<RouterService>();
  final BuildContext? context;

  StartupViewModel({this.context});
  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
    GoRouter.of(context!).push('/home');
    // await _routerService.replaceWith(const HomeViewRoute());
  }
}
