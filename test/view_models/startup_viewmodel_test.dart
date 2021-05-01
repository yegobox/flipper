import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.dart';
import 'api_test.dart';

StartUpViewModel _getModel() => StartUpViewModel();
void main() {
  group('StartUpViewModel', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    test('When user logged in and synced should land on dashboard', () async {
      List<Business> c = [];
      c.add(businessMockData);
      final api = getAndRegisterApi(businesses: c);
      final appService = getAndRegisterAppService(hasLoggedInUser: true);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      appService.isLoggedIn();
      model.runStartupLogic();
      await api.businesses();
      expect(model.didSync, true);
      verify(navigationService.navigateTo(Routes.businessHomeView));
    });
    test('When user not logged in should take user to login', () async {
      final appService = getAndRegisterAppService(hasLoggedInUser: false);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      appService.isLoggedIn();
      model.runStartupLogic();
      expect(model.didSync, false);
      verify(navigationService.replaceWith(Routes.loginView));
    });
    // test('when logged in but not synced should take you to signup', () async {
    //   // List<Business> c = [];
    //   final api = getAndRegisterApi(businesses: []);
    //   final appService = getAndRegisterAppService(hasLoggedInUser: true);
    //   final navigationService = getAndRegisterNavigationService();
    //   final model = _getModel();
    //   appService.isLoggedIn();
    //   model.runStartupLogic();
    //   await api.businesses();
    //   expect(model.didSync, true);
    //   verify(navigationService.navigateTo(Routes.signUpFormView));
    // });
  });
}
