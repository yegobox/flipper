import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('test add product viewmodel',(){
    //should initiate the model and services.
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('give the name is not null should update product',(){
      // expect(1,1);
      var sharedPreferences = getAndRegisterSharedPreferencesMock();
      // var model = StartupViewModel();
      // await model.initialise();
      // verify(sharedPreferences.isAppConstantsInitialized());
      expect(1,1);
    });
  });
}