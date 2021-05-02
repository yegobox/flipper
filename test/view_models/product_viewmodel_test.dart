import 'package:flipper/routes.router.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

ProductViewModel _getModel() => ProductViewModel();
void main() {
  group('Test Add product', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    test('test adding variant ...', () async {
      final model = _getModel();
      final productSerice = getAndRegisterProductService(
          currentUnit: 'kg', branchId: 'BID', userId: 'UID');
      final navigationService = getAndRegisterNavigationService();

      model.navigateAddVariation(productId: 'ID');
      // FIXME:
      // verify(navigationService.navigateTo(
      //   Routes.addVariation,
      // ));

      model.setUnit(unit: 'kg');

      final result = await model.addVariant(
        name: 'name',
        retailPrice: 0.0,
        supplyPrice: 0.0,
        sku: 'sku',
        productId: 'ID',
      );

      expect(productSerice.currentUnit, 'kg');
      expect(result, 200);
    });
  });
}
