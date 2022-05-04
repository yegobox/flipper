library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_models/isar_models.dart' as isar;
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
        log.e("session expired");
        String? userPhone = ProxyService.box.getUserPhone();
        try {
          await ProxyService.isarApi.login(
            userPhone: userPhone!,
          );
          await appInit();
        } catch (e) {
          if (e is InternalServerError) {
            log.e("internal server error");
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
        loginInfo.isLoggedIn = false;
        loginInfo.redirecting = false;
        loginInfo.needSignUp = true;
        rethrow;
      } else {
        log.e("The error:$e");
        errorCallback(1);

        rethrow;
      }
    }

    loginInfo.isLoggedIn = true;
    // we are logged in but there is a chance that this number is a tenant
    // that is given access to this business's branch
    // TODOtenant's is not useful when sync is not supported.

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
      log.e("userId::$userId");
      isar.Business business =
          await ProxyService.isarApi.getLocalOrOnlineBusiness(userId: userId!);

      ProxyService.appService.setBusiness(business: business);
      // get local or online branches
      List<isar.Branch> branches =
          await ProxyService.isarApi.getLocalBranches(businessId: business.id);

      ProxyService.box.write(key: 'branchId', value: branches[0].id);
      ProxyService.box.write(key: 'businessId', value: business.id);

      return business;
    } catch (e) {
      rethrow;
    }
  }
}
