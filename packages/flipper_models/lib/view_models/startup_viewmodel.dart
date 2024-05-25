library flipper_models;

import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends FlipperBaseModel {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  Future<void> runStartupLogic({
    required bool refreshCredentials,
  }) async {
    try {
      /// there is cases where when app re-start and then for some reason the realm is closed
      /// this ensure that we first check if realm is closed and re-open a realm instance to avoid issues
      if (ProxyService.realm.isRealmClosed()) {
        await ProxyService.realm.configure(useInMemoryDb: false);
      }

      /// an event should be trigered from mobile not desktop as desktop is anonmous and login() func might have been called.
      if (refreshCredentials) {
        log("refreshCredentials");
        await appService.isLoggedIn();
      }
      await appService.appInit();

      Business? activeBusinesses = await ProxyService.local
          .activeBusinesses(userId: ProxyService.box.getUserId()!);
      //if we reached this far then it means we have a default business/branch make sence to check drawer
      if (await ProxyService.realm
          .isDrawerOpen(cashierId: activeBusinesses!.serverId!)) {
        /// if there is missing initial data, this is the right time to add them
        /// this is the case when a user login to a different device and the data does not exist there
        /// or has not been synced! though we don't expect this scenario to happen mostly because
        /// we are now using realm, but for the essence that we migrated from non sync db
        /// then this method is required!
        ProxyService.forceDateEntry.dataBootstrapper();
        if (ProxyService.box.getDefaultApp() == 2) {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          _routerService.navigateTo(FlipperAppRoute());
        }
        return;
      } else {
        /// if there is missing initial data, this is the right time to add them
        /// this is the case when a user login to a different device and the data does not exist there
        /// or has not been synced! though we don't expect this scenario to happen mostly because
        /// we are now using realm, but for the essence that we migrated from non sync db
        /// then this method is required!
        ProxyService.forceDateEntry.dataBootstrapper();
        if (ProxyService.box.getDefaultApp() == 2) {
          _routerService.navigateTo(SocialHomeViewRoute());
        } else {
          openDrawer();
        }
      }
    } catch (e, stackTrace) {
      log("In catch block ${e}");
      if (e is LoginChoicesException) {
        _routerService.navigateTo(LoginChoicesRoute());
      } else if (e is SessionException || e is ErrorReadingFromYBServer) {
        log(stackTrace.toString(), name: 'runStartupLogic');
        await ProxyService.realm.logOut();
        _routerService.clearStackAndShow(LoginViewRoute());
      } else if (e is BusinessNotFoundException) {
        if (Platform.isWindows) {
          /// we are supposed to come to desktop when business is registered
          /// therefore why we logout first if we find no related business
          /// then go to login again to force the user to login with the right
          /// credential, this is likely to not happen in real environment.

          ProxyService.notie.sendData(
              'Could not login business with user ${ProxyService.box.getUserId()} not found!');
          await ProxyService.realm.logOut();
          _routerService.clearStackAndShow(LoginViewRoute());
        } else {
          _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
        }
      } else {
        log(e.toString(), name: 'runStartupLogic');
        log(stackTrace.toString(), name: 'runStartupLogic');
        await ProxyService.realm.logOut();
        //remove startup view from the stack
        _routerService.clearStackAndShow(LoginViewRoute());
      }
    }
  }
}
