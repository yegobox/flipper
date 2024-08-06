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
import 'package:talker_flutter/talker_flutter.dart';

class StartupViewModel extends FlipperBaseModel {
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  Future<void> runStartupLogic({
    required bool refreshCredentials,
  }) async {
    final talker = TalkerFlutter.init();
    // await ProxyService.realm.logOut();
    try {
      /// there is cases where when app re-start and then for some reason the realm is closed
      /// this ensure that we first check if realm is closed and re-open a realm instance to avoid issues
      /// or the app start and and module service init the db with in-memory because we don't want
      ///  @preResolve
      /// @LazySingleton()
      /// Future<RealmApiInterface> realmApi() async {
      ///   /// to speed-up the application starting time, when we init realm, we just pass in memory db
      ///   /// then when user login we will close it and switch to flexible sync
      ///   return await RealmAPI().configure(
      ///     useInMemoryDb: true,
      ///   );
      /// }
      /// then we are are forced here when app start to re-open the realm with useInMemoryDb false
      /// for performance this is supposed to take a time to configure the db and get data in sync
      /// but we might find solution soon to pass a flag to default to a fallback which use the non-direct sync
      /// which sync data later...i.e not wait for synchronizations
      /// TODO: I think bellow code are not necessary
      if (ProxyService.box.encryptionKey().isNotEmpty &&
          ProxyService.realm.realm == null) {
        talker.info("In startupFile we are re-init the realm db");
        await ProxyService.realm.configure(
          useInMemoryDb: false,
          useFallBack: false,
          localRealm: ProxyService.local.localRealm,
          branchId: ProxyService.box.getBranchId(),
          userId: ProxyService.box.getUserId(),
          businessId: ProxyService.box.getBusinessId(),
          encryptionKey: ProxyService.box.encryptionKey(),
        );
      }

      /// an event should be triggered from mobile not desktop as desktop is anonmous and login() func might have been called.
      if (refreshCredentials) {
        log("refreshCredentials");
        await appService.isLoggedIn();
        await appService.appInit();
      }

      int userId = ProxyService.box.getUserId()!;
      //if we reached this far then it means we have a default business/branch make sence to check drawer
      if (ProxyService.realm.isDrawerOpen(
          cashierId: userId, branchId: ProxyService.box.getBranchId()!)) {
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
      talker.info("StartupViewModel ${e}");
      talker.error("StartupViewModel ${stackTrace}");
      if (e is LoginChoicesException) {
        _routerService.navigateTo(LoginChoicesRoute());
      } else if (e is SessionException || e is PinError) {
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
        // log(e.toString(), name: 'runStartupLogic');
        // log(stackTrace.toString(), name: 'runStartupLogic');
        await ProxyService.realm.logOut();
        //remove startup view from the stack
        _routerService.clearStackAndShow(LoginViewRoute());
      }
    }
  }
}
