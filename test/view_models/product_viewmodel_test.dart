import 'package:flipper_models/models/models.dart';

import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());
    test('test adding variant ...', () async {
      final model = _getModel();

      // model.navigateAddVariation(productId: 2);

      model.setUnit(unit: 'kg');

      final result = await model.addVariant(
          variations: [variationMock], supplyPrice: 0.0, retailPrice: 0.0);

      expect(model.productService.currentUnit, 'kg');

      expect(result, 200);
    });
    test('When name is empty save should be disabled', () async {
      final model = _getModel();

      model.setName(name: ' '); //test when even empty string is given

      expect(model.lock, true);
    });

    test('When name and price is given lock should be removed to enable save',
        () async {
      final model = _getModel();

      model.setName(name: 'richie');

      model.isPriceSet(true);

      expect(model.lock, false);
    });
  });
}
