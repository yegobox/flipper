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
import 'package:universal_platform/universal_platform.dart';

final isWeb = UniversalPlatform.isWeb;

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final appService = locator<AppService>();
  bool isBusinessSet = false;
  final log = getLogger('StartUpViewModel');

  Future<void> runStartupLogic() async {
    await appInit();
    List<Business>? businesses = [];

    // if we are logged in, go to home we have business locally arleady!
    if (appService.isLoggedIn()) {
      String? userId = ProxyService.box.read(key: 'userId');
      businesses = await ProxyService.api.lBusinesses(userId: userId ?? '0');
      if (businesses.isEmpty) {
        _navigationService.replaceWith(Routes.signup);
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
      Business business = ProxyService.api.getBusiness();
      navigateToDashboard(business);
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  }

  void navigateToDashboard(Business businesses) {
    ProxyService.appService.setBusiness(businesses: [businesses]);
    ProxyService.box.write(key: 'userName', value: businesses.name);
    String name = businesses.name;
    ProxyService.box.write(
        key: 'businessUrl',
        value: businesses.businessUrl ??
            "https://avatars.dicebear.com/api/initials/$name.svg");

    switch (ProxyService.box.read(key: pageKey)) {
      case 'social':
        _navigationService.replaceWith(Routes.chat);
        break;
      default:
        _navigationService.replaceWith(Routes.home);
    }
  }

  /// get IDS to use along the way in the app
  appInit() async {
    if (ProxyService.box.read(key: 'branchId') != null ||
        ProxyService.box.read(key: 'businessId') != null) return;
    if (appService.isLoggedIn()) {
      String userId = ProxyService.box.read(key: 'userId');

      List<Business>? businesses = [];

      businesses = await ProxyService.api.lBusinesses(userId: userId);
      if (businesses.isEmpty) {
        //time to go to internet to fetch them
        businesses = await ProxyService.api.businesses(userId: userId);
      }

      if (businesses.isNotEmpty) {
        List<Branch> branches = [];
        branches =
            await ProxyService.api.lbranches(businessId: businesses[0].id);
        if (branches.isEmpty) {
          //time to go to internet to fetch them
          branches =
              await ProxyService.api.branches(businessId: businesses[0].id);
        }

        log.i(branches[0].id);
        log.i(businesses[0].id);
        ProxyService.box.write(key: 'branchId', value: branches[0].id);
        ProxyService.box.write(key: 'businessId', value: businesses[0].id);
      }
    }
  }
}
