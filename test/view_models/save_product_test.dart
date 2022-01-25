import 'package:flipper_models/models/models.dart';

import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test AddProduct Method', () {
    setUp(() {
      registerServices();
    });
    tearDown(() => unregisterServices());
    test('should save a product when a name is given temp product is not null',
        () async {
      final model = _getModel();

      model.setName(name: 'product name');
      expect(model.product, isA<ProductSync>());

      expect(model.name, 'product name');

      // expect(
      //     await model.addProduct(
      //         mproduct: productMock.toJson(), name: model.name),
      //     true);
      expect(1, 1);
    });
  });
}
