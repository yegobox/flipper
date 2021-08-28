import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      String userId = ProxyService.box.read(key: 'userId');
      List<Business>? businesses =
          await ProxyService.api.businesses(userId: userId);

      String? token = await FirebaseMessaging.instance.getToken();
      ProxyService.firestore
          .saveTokenToDatabase(token: token!, business: businesses[0].toJson());

      isBusinessSet = (businesses.isNotEmpty) ? true : false;

      if (isBusinessSet) {
        ProxyService.appService.setBusiness(businesses: businesses);
        ProxyService.box.write(key: 'userName', value: businesses[0].name);
        ProxyService.box.write(
            key: 'businessUrl',
            value: businesses[0].businessUrl ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU');

        switch (ProxyService.box.read(key: pageKey)) {
          case 'social':
            _navigationService.replaceWith(Routes.chat);
            break;
          default:
            _navigationService.replaceWith(Routes.home);
        }
        //TODOWhen we add the possiblity to add multiple users to log in on one system then we need to change this
        //TODOWe need to add a way to get the current user's name and id
      } else {
        _navigationService.replaceWith(Routes.signup);
      }
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  }

  /// get IDS to use along the way in the app
  appInit() async {
    if (ProxyService.box.read(key: 'branchId') != null ||
        ProxyService.box.read(key: 'businessId') != null) return;
    if (appService.isLoggedIn()) {
      String userId = ProxyService.box.read(key: 'userId');

      List<Business>? businesses =
          await ProxyService.api.businesses(userId: userId);

      if (businesses.isNotEmpty) {
        log.i(businesses[0].id);
        List<Branch> branches =
            await ProxyService.api.branches(businessId: businesses[0].id);
        log.i(branches[0].id);
        log.i(businesses[0].id);
        ProxyService.box.write(key: 'branchId', value: branches[0].id);
        ProxyService.box.write(key: 'businessId', value: businesses[0].id);
      }
    }
  }
}
