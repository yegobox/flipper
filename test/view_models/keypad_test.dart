import 'package:flipper_services/keypad_service.dart';
import 'package:test/test.dart';
import '../helpers/test_helpers.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_models/models/order_mock.dart';

BusinessHomeViewModel _getModel() => BusinessHomeViewModel();

void main() {
  group('Test Keypad', () {
    late KeyPadService keypadService;
    late KeyPadService mockedKeyPadService;
    setUp(() {
      registerServices();
      keypadService = getAndRegisterKeyPadServiceUnmocked();
      mockedKeyPadService = getAndRegisterKeyPadService();
    });
    tearDown(() => unregisterServices());
    test('should react on keypad pressed and pop keys and can reset', () {
      final model = _getModel();
      model.addKey('4');
      model.addKey('4');
      expect(keypadService.key, '44');
      //reset
      model.pop();
      expect(keypadService.key, '4');
      model.pop();
      expect(keypadService.key, '0.0');

      model.addKey('5');
      model.addKey('5');
      expect(keypadService.key, '55');
      model.reset();
      expect(keypadService.key, '0.0');
    });

    test('Pressing + should create a new order', () {
      final model = _getModel();

      model.addKey('+');

      expect(mockedKeyPadService.orders, [orderMock]);
    });
  });
}
