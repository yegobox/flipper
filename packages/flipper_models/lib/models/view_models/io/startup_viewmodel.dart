library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_models/isar_models.dart' as isar;
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:universal_platform/universal_platform.dart';

final isWeb = UniversalPlatform.isWeb;

class StartUpViewModel extends BaseViewModel {
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic({
    required bool invokeLogin,
    required LoginInfo loginInfo,
    required Function errorCallback,
  }) async {
    // start by allowing app to redirect
    loginInfo.redirecting = true;
    if (!appService.isLoggedIn()) {
      try {
        await login(invokeLogin);
      } catch (e) {
        rethrow;
      }
    }

    try {
      await appInit();
      notifyListeners();
    } catch (e) {
      if (e is SessionException) {
        String? userPhone = ProxyService.box.getUserPhone();
        try {
          await ProxyService.api.login(
            userPhone: userPhone!,
          );
          await appInit();
        } catch (e) {
          if (e is InternalServerError) {
            loginInfo.isLoggedIn = false;
            rethrow;
          }
        }

        /// a business not found either locally or online
        /// then go so signup page, it is important that from login page
        /// we checked if a user is logged in, if not then we check if a user
        /// has internet because it will be used either to login again or to fetch
        /// business from the server.
      } else if (e is NotFoundException) {
        String? countryName = await ProxyService.country.getCountryName();
        loginInfo.country = countryName!;
        loginInfo.isLoggedIn = true;
        loginInfo.redirecting = false;
        loginInfo.needSignUp = true;
        rethrow;
      } else {
        errorCallback(1);

        rethrow;
      }
    }

    /// if no exception is thrown, then we are logged in
    /// proceed with going to home of the app.

    loginInfo.isLoggedIn = true;

    /// a user has logged in but has no business, so first check using
    /// his phone number if has a tenant he can log to
    /// FIXMEpause working on tenants
    // String phoneNumber = ProxyService.box.getUserPhone()!;
    // TenantSync? tenant;
    // tenant = await ProxyService.api.isTenant(phoneNumber: phoneNumber);

    /// instead of going to the network everytime to check if is tenant
    /// load tenant from local storage if not then go to network and save it to local if does not exist local

    // if (tenant != null) {
    //   ProxyService.api.saveTenant(phoneNumber: phoneNumber);
    // }
    // tenant = await ProxyService.api.isTenant(phoneNumber: phoneNumber);
    // if (tenant != null &&
    //     tenant.permissions.where((e) => e.name == "admin").isNotEmpty) {
    //   /// if we only have one branch no need to switch from branches go straight to business.
    //   if (tenant.branches.length == 1) {
    //     isar.Business business = await ProxyService.isarApi
    //         .getBusinessFromOnlineGivenId(
    //             id: tenant.branches[0].fbusinessId!);

    //     navigateToDashboard(
    //       business: business,
    //       branch: tenant.branches[0],
    //       loginInfo: loginInfo,
    //     );
    //     return;
    //   } else if (tenant.branches.length > 1) {
    //     /// TODOwhen we support multiple branches we need to add this logic
    //     // GoRouter.of(context).go(Routes.switchBranch);
    //     loginInfo.switchBranch = true;
    //   }
    // }
    /// unpause working on tenants

    /// if not, then go to the business creation page
    /// if has a tenant, then go to the tenant page to chose a branch he is logging to
    /// by getting tenant's branch when click on branch to log to
    /// first fetch related business and update all related fields such us, userid,businessid,branchId
    /// in local storage.
    /// first get the location

    loginInfo.redirecting = false;
  }

  Future<void> login(bool? invokeLogin) async {
    if (invokeLogin != null && invokeLogin == true) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        String? phone = user?.phoneNumber;
        if (phone == null && user?.email != null) {
          ProxyService.box.write(key: 'needLinkPhoneNumber', value: true);
          phone = user?.email;
        }
        await ProxyService.isarApi.login(
          userPhone: phone!,
        );
      } catch (e) {
        rethrow;
      }
    }
  }

  /// get IDS to use along the way in t
  /// he app
  Future<isar.Business> appInit() async {
    try {
      String? userId = ProxyService.box.getUserId();
      log.e("here::$userId");
      isar.Business business =
          await ProxyService.isarApi.getLocalOrOnlineBusiness(userId: userId!);

      ProxyService.appService.setBusiness(business: business);
      // get local or online branches
      List<isar.BranchSync> branches =
          await ProxyService.isarApi.getLocalBranches(businessId: business.id);
      ProxyService.box.write(key: 'branchId', value: branches[0].id);
      ProxyService.box.write(key: 'businessId', value: business.id);

      return business;
    } catch (e) {
      rethrow;
    }
  }
}
