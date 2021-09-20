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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:universal_platform/universal_platform.dart';

final isWeb = UniversalPlatform.isWeb;

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic() async {
    await appInit();

    if (appService.isLoggedIn()) {
      /// you added me to a business and I have not yet signed up to flipper
      /// on signup the app need to check if there is an exisiting business that I am attached to
      /// if it exists then it load it as usual with the branch in that business continue as usual
      /// signup this user for him to have username aka business name but remember that
      /// after sucess we will set his/her environment to the business assigned to him/her
      /// the same rule will apply when switching from one business to another
      ///
      /// Restoring the app database will be done by going on a setting, it should be a deliberate choice
      /// not something we suggest!
      /// but backing up the database will be suggested,
      /// follow algorithm there
      String userId = ProxyService.box.read(key: 'userId');
      List<Business>? businesses = [];
      bool internetAvailable = true;
      if (!isWeb) {
        internetAvailable = await InternetConnectionChecker().hasConnection;
      }
      if (internetAvailable) {
        try {
          businesses = await ProxyService.api.businesses(userId: userId);
        } catch (e) {
          log.i(e);
          if (e == 403) {
            // token expired.
            await ProxyService.api.logOut();
            ProxyService.nav.navigateTo(Routes.login);
          }

          return;
        }
      } else {
        ProxyService.nav.navigateTo(Routes.connectionState);
        return;
      }
      isBusinessSet = (businesses.isNotEmpty) ? true : false;

      if (isBusinessSet) {
        if (!isWindows) {
          String? token = await FirebaseMessaging.instance.getToken();
          ProxyService.firestore.saveTokenToDatabase(
              token: token!, business: businesses[0].toJson());
        }

        ProxyService.appService.setBusiness(businesses: businesses);
        ProxyService.box.write(key: 'userName', value: businesses[0].name);
        String name = businesses[0].name;
        ProxyService.box.write(
            key: 'businessUrl',
            value: businesses[0].businessUrl ??
                "https://avatars.dicebear.com/api/initials/$name.svg");

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
