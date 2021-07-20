import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.dart';
// import 'api_test.dart';

StartUpViewModel _getModel() => StartUpViewModel();
final Business businessMockData = new Business(
  id: 1,
  name: 'name',
  latitude: '1',
  longitude: '2',
  channels: [''],
  table: '',
  country: '',
  type: '',
);
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
      // await Future.delayed(Duration(microseconds: 5000));
      await api.businesses();

      expect(model.didSync, false);

      verify(navigationService.replaceWith(Routes.home));
    });
    test('When user not logged in should take user to login', () async {
      final appService = getAndRegisterAppService(hasLoggedInUser: false);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      appService.isLoggedIn();
      model.runStartupLogic();
      expect(model.didSync, false);
      verify(navigationService.replaceWith(Routes.login));
    });
  });
}
