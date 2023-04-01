library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gate.dart';

final isWeb = UniversalPlatform.isWeb;

class StartupViewModel extends BaseViewModel {
  final appService = loc.locator<AppService>();
  final BuildContext context;
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();
  StartupViewModel({required this.context});
  Future<void> listenToAuthChange() async {}

  Future<void> runStartupLogic({
    required bool invokeLogin,
  }) async {
    LoginInfo().redirecting = true;
    try {
      /// an event should be trigered from mobile not desktop as desktop is anonmous and login() func might have been called.
      if (invokeLogin && !ProxyService.box.isAnonymous()) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !appService.isLoggedIn()) {
          await ProxyService.isarApi.login(
            userPhone: user.phoneNumber ?? user.email!,
          );
        }
      }
      await appService.appInit();
      //if we reached this far then it means we have a default business/branch make sence to check drawer
      if (await ProxyService.isarApi
              .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!) ==
          null) {
        throw NoDrawerOpenException(term: "Business Drawer is not open");
      }
      LoginInfo().isLoggedIn = true;

      _routerService.replaceWith(FlipperAppRoute());

      /// if you want to test signup or any other route before landing to final destionation
      /// un comment the code below but do not forget after testing to comment back the code
      // GoRouter.of(context).push('/signup/Rwanda');
    } catch (e) {
      if (e is LoginChoicesException) {
        LoginInfo().isLoggedIn = false;
        LoginInfo().loginChoices = true;
        _routerService.replaceWith(TenantAddRoute());
      } else if (e is NoDrawerOpenException) {
        /// in debug mode start with the signup flow, this will help in testing entire flow instead of jumping
        /// right to opening drawer
        if (kDebugMode) {
          _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
        } else {
          _routerService.navigateTo(DrawerScreenRoute(open: "open"));
        }
      } else if (e is SessionException || e is ErrorReadingFromYBServer) {
        LoginInfo().isLoggedIn = false;
        _routerService.replaceWith(LoginViewRoute());
      } else if (e is NotFoundException) {
        _routerService.replaceWith(SignUpViewRoute(countryNm: "Rwanda"));
      } else {
        ProxyService.isarApi.logOut();
        LoginInfo().isLoggedIn = false;
        _routerService.replaceWith(LoginViewRoute());
      }
    }
  }
}
