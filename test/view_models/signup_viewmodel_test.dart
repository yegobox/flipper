import 'package:flipper_models/view_models/signup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
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
      //write test to test model.signup set setName with random name and setCountry with random country
      //test that the model is updated with the new name and country
      //randomise a string
      Random _rnd = Random();
      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      String _name = getRandomString(10);
      model.setName(name: _name);
      model.setCountry(country: _name);
      expect(model.kName, _name);
      expect(model.kCountry, _name);

      model.registerLocation();

      //calling signup method should get the business registerd
      //and calling box.read('businessId') should not return null
      //calling box.read('branchId') should not return null)
      //should very that we land on the business page home page

      //expect model.longitude to be set
      //expect model.latitude to be set
      expect(model.longitude, '0.0');
      expect(model.latitude, '0.0');
      // await model.signup();
      // expect(model.businessId, not(null));
    });
  });
}
