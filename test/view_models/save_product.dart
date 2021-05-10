import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test AddProduct Method', () {
    late ProductService productService;
    setUp(() {
      registerServices();
      productService = getAndRegisterProductService(
        currentUnit: 'kg',
        branchId: 'BID',
        userId: 'UID',
      );
    });
    tearDown(() => unregisterServices());
    test('should save a product when a name is given temp product is not null',
        () async {
      final model = _getModel();

      model.setName(name: 'product name');
      expect(model.product, isA<Product>());

      expect(model.name, 'product name');
      getAndRegisterApi(productService: productService, uri: 'product');

      expect(await model.addProduct(), true);
    });
  });
}
