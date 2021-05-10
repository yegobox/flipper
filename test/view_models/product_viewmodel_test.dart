// import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/models/product_mock.dart';
// import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
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
    test('test adding variant ...', () async {
      final model = _getModel();

      List<Variation> ls = [];
      Variation data = new Variation(
        name: 'name',
        sku: 'N/A',
        productId: "",
        unit: 'kg',
        channels: ['UID'],
        productName: 'temp',
        branchId: 'BID',
        id: 'ID',
        table: AppTables.variation,
      );
      ls.add(data);
      getAndRegisterApi(
        variations: ls,
        productService: productService,
      );

      model.navigateAddVariation(productId: 'ID');

      model.setUnit(unit: 'kg');

      final result = await model.addVariant(
        variations: ls,
      );

      expect(productService.currentUnit, 'kg');
      expect(result, 200);
    });
    test('When name is empty save should be disabled', () async {
      final model = _getModel();
      model.setName(name: ' '); //test when even empty string is given
      expect(model.lock, true);
    });
    test('should save a product when a name is given temp product is not null',
        () async {
      final model = _getModel();
      Product product = productService.product!;
      Map data = product.toJson();

      model.setName(name: 'product name');
      expect(model.product, isA<Product>());

      expect(model.name, 'product name');
      // data['name'] = 'product name';
      getAndRegisterApi(productService: productService, uri: 'product');

      expect(await model.addProduct(), true);
    });
    test('When name is given lock should be removed to enable save', () async {
      final model = _getModel();
      model.setName(name: 'richie');
      expect(model.lock, false);
    });
  });
}
