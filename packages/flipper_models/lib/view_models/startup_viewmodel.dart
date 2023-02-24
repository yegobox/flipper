library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:universal_platform/universal_platform.dart';

import 'gate.dart';

final isWeb = UniversalPlatform.isWeb;

class StartUpViewModel extends BaseViewModel {
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic({
    required bool invokeLogin,
    required LoginInfo loginInfo,
    required Function navigationCallback,
  }) async {
    ProxyService.isarApi.logOut();
    loginInfo.redirecting = true;
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
      loginInfo.isLoggedIn = true;
      navigationCallback("home");
    } catch (e) {
      if (e is LoginChoicesException) {
        loginInfo.isLoggedIn = false;
        loginInfo.loginChoices = true;
        navigationCallback("login_choices");
      } else if (e is NoDrawerOpenException) {
        navigationCallback("drawer");
      } else if (e is SessionException || e is ErrorReadingFromYBServer) {
        loginInfo.isLoggedIn = false;
        navigationCallback("login");
      } else if (e is NotFoundException) {
        navigationCallback("signup");
      } else {
        log.i(e.toString());
        ProxyService.isarApi.logOut();
        loginInfo.isLoggedIn = false;
        navigationCallback("login");
      }
    }
  }
}
