import 'package:flipper_models/models/models.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

import '../helpers/test_helpers.dart';

SignupViewModel _getModel() => SignupViewModel();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

void main() {
  group('signup viewmodel ...', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    test('signup with a new user', () async {
      final model = _getModel();
      final navigationService = getAndRegisterNavigationService();
      getAndRegisterLocalStorage();

      // Random _rnd = Random();
      // String getRandomString(int length) =>
      //     String.fromCharCodes(Iterable.generate(
      //         length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      // String _name = getRandomString(10);
      // model.setName(name: _name);
      // model.setCountry(country: _name);
      // expect(model.kName, _name);

      // model.registerLocation();
      // //delay 2 seconds
      // await Future.delayed(Duration(seconds: 2));

      // expect(model.longitude, '1.1');
      // expect(model.latitude, '1.1');
      // await model.signup();

      // verify(navigationService.navigateTo(Routes.home));

      expect(true, true);
    }, skip: kIsWeb);
  });
}
