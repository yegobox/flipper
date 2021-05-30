// import 'package:flipper/routes.router.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/product_mock.dart';
// import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
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
      getAndRegisterApi(data: data, uri: 'product');
    });
    tearDown(() => unregisterServices());
    test('test adding variant ...', () async {
      final model = _getModel();

      List<Variation> ls = [];
      Variation v = new Variation(
        name: 'name',
        sku: 'N/A',
        productId: 2,
        unit: 'kg',
        channels: ['UID'],
        productName: 'temp',
        branchId: 11,
        id: 1,
        table: AppTables.variation,
        taxName: 'N/A',
        taxPercentage: 0.0,
      );
      ls.add(v);
      getAndRegisterApi(
        variations: ls,
        data: data,
      );

      model.navigateAddVariation(productId: 'ID');

      model.setUnit(unit: 'kg');

      final result = await model.addVariant(
          variations: ls, supplyPrice: 0.0, retailPrice: 0.0);

      expect(productService.currentUnit, 'kg');
      expect(result, 200);
    });
    test('When name is empty save should be disabled', () async {
      final model = _getModel();
      model.setName(name: ' '); //test when even empty string is given
      expect(model.lock, true);
    });

    test('When name is given lock should be removed to enable save', () async {
      final model = _getModel();
      model.setName(name: 'richie');
      expect(model.lock, false);
    });
  });
}
