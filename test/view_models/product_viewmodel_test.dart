// import 'package:flipper/routes.router.dart';
import 'package:flipper_models/models/variation.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
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
    test('test adding variant ...', () async {
      final model = _getModel();
      final productSerice = getAndRegisterProductService(
          currentUnit: 'kg', branchId: 'BID', userId: 'UID');
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
      getAndRegisterApi(variations: ls);

      model.navigateAddVariation(productId: 'ID');

      model.setUnit(unit: 'kg');

      final result = await model.addVariant(
        variations: ls,
      );

      expect(productSerice.currentUnit, 'kg');
      expect(result, 200);
    });
  });
}
