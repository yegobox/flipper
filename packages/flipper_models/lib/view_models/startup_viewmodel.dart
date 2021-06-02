import 'package:flipper/constants.dart';
import 'package:flipper/routes.locator.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/app_service.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final appService = locator<AppService>();
  bool didSync = false;

  Future<void> runStartupLogic() async {
    appService.isLoggedIn();

    if (appService.hasLoggedInUser) {
      List<Business>? businesses = await ProxyService.api.businesses();

      didSync = (businesses.isNotEmpty) ? true : false;

      if (didSync) {
        ProxyService.appService.setBusiness(businesses: businesses);
        if (ProxyService.box.read(key: pageKey) == null) {
          ProxyService.box.write(key: pageKey, value: businesses[0].type);
        }
        _navigationService.replaceWith(Routes.home);
      } else {
        _navigationService.navigateTo(Routes.signup);
      }
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  }

  /// get IDS to use along the way in the app
//   appInit() async {
//     // ProxyService.api.logOut();
//     if (appService.hasLoggedInUser) {
//       List<Business>? businesses = await ProxyService.api.businesses();
//       try {
//         List<Branch> branches =
//             await ProxyService.api.branches(businessId: businesses[0].id);

//         ProxyService.box.write(key: 'branchId', value: branches[0].id);
//         ProxyService.box.write(key: 'businessId', value: businesses[0].id);
//       } catch (e) {}
//     }
//   }
}
