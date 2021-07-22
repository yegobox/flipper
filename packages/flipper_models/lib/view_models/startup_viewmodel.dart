import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/app_service.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic() async {
    await appInit();

    if (appService.isLoggedIn()) {
      List<Business>? businesses = await ProxyService.api.businesses();

      isBusinessSet = (businesses.isNotEmpty) ? true : false;
      int? businessId = ProxyService.box.read(key: 'businessId');

      if (isBusinessSet) {
        ProxyService.appService.setBusiness(businesses: businesses);

        if (ProxyService.box.read(key: pageKey) == null) {
          ProxyService.box.write(key: pageKey, value: businesses[0].type);
        }
        //TODOWhen we add the possiblity to add multiple users to log in on one system then we need to change this
        //TODOWe need to add a way to get the current user's name and id
        ProxyService.box.write(key: 'userName', value: businesses[0].name);
        ProxyService.box.write(
            key: 'businessUrl',
            value: businesses[0].businessUrl ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU');
        _navigationService.replaceWith(Routes.home);
      } else if (businessId != null) {
        _navigationService.replaceWith(Routes.signup);
      }
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  }

  /// get IDS to use along the way in the app
  appInit() async {
    if (appService.hasLoggedInUser) {
      List<Business>? businesses = await ProxyService.api.businesses();

      if (businesses.isNotEmpty) {
        log.i(businesses[0].id);
        List<Branch> branches =
            await ProxyService.api.branches(businessId: businesses[0].id);
        // log.i('BranchId', branches[0].id);
        // log.i('BusinessId', businesses[0].id);
        ProxyService.box.write(key: 'branchId', value: branches[0].id);
        ProxyService.box.write(key: 'businessId', value: businesses[0].id);
      }
    }
  }
}
