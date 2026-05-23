import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';

void main() {
  group('BulkAddProductViewModel.removeRowAt', () {
    test('removeRowAt drops row and disposes controllers for barCode', () {
      final model = BulkAddProductViewModel();
      model.setExcelDataForTesting([
        {'BarCode': 'A', 'Name': 'One', 'Price': '10'},
        {'BarCode': 'B', 'Name': 'Two', 'Price': '20'},
      ]);
      model.initializeControllers();
      expect(model.rowCount, 2);
      expect(model.controllers.containsKey('B'), isTrue);

      model.removeRowAt(1);

      expect(model.rowCount, 1);
      expect(model.excelData!.first['BarCode'], 'A');
      expect(model.controllers.containsKey('B'), isFalse);
      expect(model.quantityControllers.containsKey('B'), isFalse);
    });

    test('removeRowAt on last row leaves empty list', () {
      final model = BulkAddProductViewModel();
      model.setExcelDataForTesting([
        {'BarCode': 'X', 'Name': 'Only', 'Price': '1'},
      ]);
      model.removeRowAt(0);
      expect(model.rowCount, 0);
      expect(model.canSave, isFalse);
    });
  });
}
