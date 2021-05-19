import 'package:flipper/routes.locator.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/branch.dart';
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
        _navigationService.replaceWith(Routes.home);
      } else {
        _navigationService.navigateTo(Routes.signup);
      }
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  }

  /// get IDS to use along the way in the app
  appInit() async {
    if (appService.hasLoggedInUser) {
      List<Business>? businesses = await ProxyService.api.businesses();
      try {
        List<Branch> branches =
            await ProxyService.api.branches(businessId: businesses[0].id);
        // print(businesses[0].id);
        // print(branches[0].id);
        print(branches[0].id);
        ProxyService.box.write(key: 'branchId', value: branches[0].id);
        ProxyService.box.write(key: 'businessId', value: businesses[0].id);
        // we sometime get index out of bounds when attempty to access businesses[0] and yet no business have been created
      } catch (e) {}
    }
  }
}
// ProxyPreserveHost On
// ProxyRequests Off

// RewriteCond %{HTTP:UPGRADE} ^WebSocket$ [NC,OR]
// RewriteCond %{HTTP:CONNECTION} ^Upgrade$ [NC]
// RewriteRule .* ws://127.0.0.1:8065%{REQUEST_URI} [P,QSA,L]
// RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
// RewriteRule .* http://127.0.0.1:8082%{REQUEST_URI} [P,QSA,L]
// RequestHeader set X-Forwarded-Proto "https"
