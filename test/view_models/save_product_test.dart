import 'package:flipper_models/models/models.dart';

import 'package:flipper_services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test AddProduct Method', () {
    late ProductService productService;
    late Map data;
    setUp(() {
      registerServices();
      productService = getAndRegisterProductService(
        currentUnit: 'kg',
        branchId: 11,
        userId: 'UID',
      );
      data = productService.product!.toJson();
      data['name'] = 'product name';
      data['color'] = '#ee5253';
      getAndRegisterApi(data: data, uri: 'product');
    });
    tearDown(() => unregisterServices());
    test('should save a product when a name is given temp product is not null',
        () async {
      final model = _getModel();

      model.setName(name: 'product name');
      expect(model.product, isA<ProductSync>());

      expect(model.name, 'product name');

      expect(await model.addProduct(mproduct: data, name: model.name), true);
    });
  });
}
