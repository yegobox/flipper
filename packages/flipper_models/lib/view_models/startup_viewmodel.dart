import 'package:flipper/routes.locator.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/branch.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
// import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/app_service.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final appService = locator<AppService>();
  bool didSync = false;
  Future<void> runStartupLogic() async {
    appService.isLoggedIn();
    if (appService.hasLoggedInUser) {
      List<Business>? response = await ProxyService.api.businesses();

      didSync = (response != null && response.isNotEmpty) ? true : false;
      if (didSync) {
        _navigationService.navigateTo(Routes.businessHomeView);
      } else {
        _navigationService.navigateTo(Routes.signUpFormView);
      }
    } else {
      _navigationService.replaceWith(Routes.loginView);
    }
  }

  /// get IDS to use along the way in the app
  appInit() async {
    if (appService.hasLoggedInUser) {
      List<Business>? businesses = await ProxyService.api.businesses();
      List<Branch> branches =
          await ProxyService.api.branches(businessId: businesses![0].id);
      // print(businesses[0].id);
      // print(branches[0].id);
      ProxyService.box.write(key: 'branchId', value: branches[0].id);
      ProxyService.box.write(key: 'businessId', value: businesses[0].id);
    }
  }
}
