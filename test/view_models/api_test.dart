import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';
import 'package:flipper_services/abstractions/api.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

const TESTDIR = '_tmp2';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
final Business businessMockData = new Business(
  id: '1',
  name: 'name',
  latitude: '1',
  longitude: '2',
  channels: [''],
  table: '',
  country: '',
  type: '',
);
StartUpViewModel _getModel() => StartUpViewModel();
@GenerateMocks([Api])
void main() {
  group('Start#2', () {
    setUp(() {
      registerServices();
      // if (!Directory(TESTDIR).existsSync()) {
      //   Directory(TESTDIR).createSync();
      // }
    });
    tearDown(() => unregisterServices());
    test('when logged in but not synced should take you to signup', () async {
      List<Business> c = [];
      final api = getAndRegisterApi(businesses: c);
      final appService = getAndRegisterAppService(hasLoggedInUser: true);
      final navigationService = getAndRegisterNavigationService();
      final model = _getModel();
      appService.isLoggedIn();
      model.runStartupLogic();
      await api.businesses();
      expect(model.didSync, false);
      verify(navigationService.navigateTo(Routes.signUpFormView));
    });
    test('create temporal Product', () {
      //code here
      expect(1, 1);
    });
  });
}
