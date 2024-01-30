library flipper_models;

import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import 'NotificationStream.dart';

class StartupViewModel extends FlipperBaseModel {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  Future<void> runStartupLogic({
    required bool refreshCredentials,
  }) async {
    //log(ProxyService.box.getBusinessId()?.toString() ?? "no BusinessId");
    try {
      /// an event should be trigered from mobile not desktop as desktop is anonmous and login() func might have been called.
      if (refreshCredentials) {
        log("refreshCredentials");
        await appService.isLoggedIn();
      }
      await appService.appInit();
      log("User " + ProxyService.box.getUserId().toString(),
          name: 'runStartupLogic');

      //if we reached this far then it means we have a default business/branch make sence to check drawer
      if (await ProxyService.isar
          .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!)) {
        if (ProxyService.box.getDefaultApp() == 2) {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          _routerService.navigateTo(FlipperAppRoute());
        }
        return;
      } else {
        if (ProxyService.box.getDefaultApp() == 2) {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
        }
      }
    } catch (e, stackTrace) {
      log("${e}");
      if (e is LoginChoicesException) {
        _routerService.navigateTo(LoginChoicesRoute());
      } else if (e is SessionException || e is ErrorReadingFromYBServer) {
        log(stackTrace.toString(), name: 'runStartupLogic');
        await ProxyService.isar.logOut();
        _routerService.clearStackAndShow(LoginViewRoute());
      } else if (e is BusinessNotFoundException) {
        if (Platform.isWindows) {
          /// we are supposed to come to desktop when business is registered
          /// therefore why we logout first if we find no related business
          /// then go to login again to force the user to login with the right
          /// credential, this is likely to not happen in real environment.

           ProxyService.notie.sendData('Could not login business with user ${ProxyService.box.getUserId()} not found!');
          await ProxyService.isar.logOut();
          _routerService.clearStackAndShow(LoginViewRoute());
        } else {
          _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
        }
      } else {
        log(e.toString(), name: 'runStartupLogic');
        log(stackTrace.toString(), name: 'runStartupLogic');
        await ProxyService.isar.logOut();
        //remove startup view from the stack
        _routerService.clearStackAndShow(LoginViewRoute());
      }
    }
  }
}
