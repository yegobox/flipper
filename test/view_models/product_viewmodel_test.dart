import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    test('test adding variant ...', () async {
      final model = _getModel();
      final productSerice = getAndRegisterProductService(
          currentUnit: 'kg', branchId: 'B', userId: 'UID');
      // final api = getAndRegisterApi();
      final result = await model.addVariant(
        name: 'name',
        retailPrice: 0.0,
        supplyPrice: 0.0,
        sku: 'sku',
        branchId: 'b',
        productId: 'ID',
        unit: 'kg',
        userid: 'uid',
        productName: 'name',
      );
      expect(productSerice.currentUnit, 'kg');
      expect(result, 200);
    });
  });
}
