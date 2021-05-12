import 'package:flipper_services/keypad_service.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';

BusinessHomeViewModel _getModel() => BusinessHomeViewModel();

void main() {
  group('Test Keypad', () {
    late KeyPadService keypadService;
    setUp(() {
      registerServices();
      keypadService = getAndRegisterKeyPadService();
    });
    tearDown(() => unregisterServices());
    test('should react on keypad pressed and reset', () {
      final model = _getModel();
      model.addKey('4');
      model.addKey('4');
      expect(keypadService.key, '44');
      //reset
      model.reset();
      expect(keypadService.key, '4');
      model.reset();
      expect(keypadService.key, '0.0');
    });
  });
}
