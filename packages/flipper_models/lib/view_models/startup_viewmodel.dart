library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:universal_platform/universal_platform.dart';

import 'gate.dart';

final isWeb = UniversalPlatform.isWeb;

class StartupViewModel extends BaseViewModel {
  final appService = locator<AppService>();
  final BuildContext context;
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

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

      GoRouter.of(context).push('/home');

      /// if you want to test signup or any other route before landing to final destionation
      /// un comment the code below but do not forget after testing to comment back the code
      // GoRouter.of(context).push('/signup/Rwanda');
    } catch (e, stack) {
      if (e is LoginChoicesException) {
        LoginInfo().isLoggedIn = false;
        LoginInfo().loginChoices = true;
        GoRouter.of(context).push('/tenants');
      } else if (e is NoDrawerOpenException) {
        // LoginInfo().setDrawerOpen(true);
        GoRouter.of(context).push('/drawer/open');
      } else if (e is SessionException || e is ErrorReadingFromYBServer) {
        LoginInfo().isLoggedIn = false;
        GoRouter.of(context).push('/login');
      } else if (e is NotFoundException) {
        GoRouter.of(context).push('/signup/Rwanda');
      } else {
        log.i(e.toString());
        log.i(stack);
        ProxyService.isarApi.logOut();
        LoginInfo().isLoggedIn = false;
        GoRouter.of(context).push('/login');
      }
    }
  }
}
