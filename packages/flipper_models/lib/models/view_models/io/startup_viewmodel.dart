library flipper_models;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/app_service.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final isWeb = UniversalPlatform.isWeb;

class StartUpViewModel extends BaseViewModel {
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic(
      {bool? invokeLogin, required LoginInfo loginInfo}) async {
    if (!appService.isLoggedIn()) {
      await login(invokeLogin);
    }

    // ProxyService.api.logOut();
    // fake login
    // ProxyService.box.write(key: 'userId', value: "300");
    // ProxyService.box.write(key: 'chatUid', value: "300");
    // await ProxyService.api.login(userPhone: '+250783054874');
    // fake login
    List<Business> businesses = [];
    try {
      businesses = await appInit();
    } catch (e) {
      if (e is SessionException) {
        String? userPhone = ProxyService.box.getUserPhone();
        try {
          await ProxyService.api.login(
            userPhone: userPhone ?? '',
          );
        } catch (e) {
          if (e is InternalServerError) {
            // GoRouter.of(context).go(Routes.login);
            loginInfo.isLoggedIn = false;
          }
        }
      }
    }

    // if we are logged in, go to home we have business locally arleady!
    if (appService.isLoggedIn()) {
      if (businesses.isEmpty) {
        /// a user has logged in but has no business, so first check using
        /// his phone number if has a tenant he can log to
        String phoneNumber = ProxyService.box.getUserPhone()!;
        TenantSync? tenant;
        tenant = await ProxyService.api.isTenant(phoneNumber: phoneNumber);

        /// instead of going to the network everytime to check if is tenant
        /// load tenant from local storage if not then go to network and save it to local if does not exist local
        if (tenant != null) {
          ProxyService.api.saveTenant(phoneNumber: phoneNumber);
        }
        tenant = await ProxyService.api.isTenant(phoneNumber: phoneNumber);
        // FIXMEthis is a hack to get the tenant to work
        if (tenant != null &&
            tenant.permissions.where((e) => e.name == "admin").isNotEmpty) {
          /// if we only have one branch no need to switch from branches go straight to business.
          if (tenant.branches.length == 1) {
            Business business = await ProxyService.api
                .getBusinessFromOnlineGivenId(
                    id: tenant.branches[0].fbusinessId!);

            navigateToDashboard(
              business: business,
              branch: tenant.branches[0],
              loginInfo: loginInfo,
            );
            return;
          } else if (tenant.branches.length > 1) {
            /// TODOwhen we support multiple branches we need to add this logic
            // GoRouter.of(context).go(Routes.switchBranch);
            loginInfo.switchBranch = true;
          }
        }

        /// if not, then go to the business creation page
        /// if has a tenant, then go to the tenant page to chose a branch he is logging to
        /// by getting tenant's branch when click on branch to log to
        /// first fetch related business and update all related fields such us, userid,businessid,branchId
        /// in local storage.
        /// first get the location
        String? countryName = await ProxyService.country.getCountryName();
        // GoRouter.of(context).go(Routes.signup + "/$countryName");
        loginInfo.needSignUp = true;
        loginInfo.country = countryName!;
        return;
      }

      /// you added me to a business and I have not yet signed up to flipper
      /// on signup the app need to check if there is an exisiting business that I am attached to
      /// if it exists then it load it as usual with the branch in that business continue as usual
      /// signup this user for him to have username aka business name but remember that
      /// after sucess we will set his/her environment to the business assigned to him/her
      /// the same rule will apply when switching from one business to another
      /// Restoring the app database will be done by going on a setting, it should be a deliberate choice
      /// not something we suggest!
      /// but backing up the database will be suggested,
      /// follow algorithm there
      try {
        Business business = ProxyService.api.getBusiness();
        navigateToDashboard(
          business: business,
          loginInfo: loginInfo,
        );
      } catch (e) {
        log.e(e);
      }
    } else {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        loginInfo.noNet = false;
      } else {
        loginInfo.noNet = true;
      }
    }
  }

  Future<void> login(bool? invokeLogin) async {
    if (invokeLogin != null && invokeLogin == true) {
      User? user = FirebaseAuth.instance.currentUser;

      String? phone = user?.phoneNumber;
      if (phone == null && user?.email != null) {
        ProxyService.box.write(key: 'needLinkPhoneNumber', value: true);
        phone = user?.email;
      }
      await ProxyService.api.login(
        userPhone: phone!,
      );
    }
  }

  void navigateToDashboard(
      {required Business business,
      BranchSync? branch,
      required LoginInfo loginInfo}) {
    if (branch != null) {
      ProxyService.box.write(key: 'branchId', value: branch.id);
    }
    ProxyService.box.write(key: 'businessId', value: business.id);

    ProxyService.appService.setBusiness(businesses: [business]);
    ProxyService.box.write(key: 'userName', value: business.name);
    String name = business.name;
    ProxyService.box.write(
        key: 'businessUrl',
        value: business.businessUrl ??
            "https://avatars.dicebear.com/api/initials/$name.svg");

    switch (ProxyService.box.read(key: pageKey)) {
      case 'social':
        //_navigationService.replaceWith(Routes.chat);
        // _navigationService.replaceWith(Routes.home);
        loginInfo.isLoggedIn = true;
        break;
      default:
        // _navigationService.replaceWith(Routes.home);
        loginInfo.isLoggedIn = true;
    }
  }

  /// get IDS to use along the way in the app
  Future<List<Business>> appInit() async {
    List<Business> businesses = [];

    String userId = ProxyService.box.read(key: 'userId');

    businesses =
        await ProxyService.api.getLocalOrOnlineBusiness(userId: userId);
    if (businesses.isNotEmpty) {
      ProxyService.appService.setBusiness(businesses: businesses);
      // get local or online branches
      List<BranchSync> branches =
          await ProxyService.api.getLocalBranches(businessId: businesses[0].id);
      ProxyService.box.write(key: 'branchId', value: branches[0].id);
    }

    return businesses;
  }
}
