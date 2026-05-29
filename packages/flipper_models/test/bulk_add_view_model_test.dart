import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';

void main() {
  group('BulkAddProductViewModel.removeRowAt', () {
    test('removeRowAt drops row and disposes controllers for row', () {
      final model = BulkAddProductViewModel();
      model.setExcelDataForTesting([
        {'BarCode': 'A', 'Name': 'One', 'Price': '10'},
        {'BarCode': 'B', 'Name': 'Two', 'Price': '20'},
      ]);
      model.initializeControllers();
      expect(model.rowCount, 2);
      final uidB = model.bulkRowUidForRow(model.excelData![1]);
      expect(model.controllers.containsKey(uidB), isTrue);

      model.removeRowAt(1);

      expect(model.rowCount, 1);
      expect(model.excelData!.first['BarCode'], 'A');
      expect(model.controllers.containsKey(uidB), isFalse);
      expect(model.quantityControllers.containsKey(uidB), isFalse);
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

    test(
      'removeRowAt when crossing from large to small fills all controllers',
      () {
        final rows = List.generate(
          201,
          (i) => <String, dynamic>{
            'BarCode': 'B$i',
            'Name': 'N$i',
            'Price': '10',
          },
        );
        final model = BulkAddProductViewModel();
        model.setExcelDataForTesting(rows);
        expect(model.exceedsEditableLimit, isTrue);
        model.initializeControllers();
        expect(model.controllers.length, 20);

        model.removeRowAt(200);

        expect(model.rowCount, 200);
        expect(model.exceedsEditableLimit, isFalse);
        final uidFirst = model.bulkRowUidForRow(model.excelData!.first);
        expect(model.controllers.containsKey(uidFirst), isTrue);
        expect(model.controllers[uidFirst]!.text, '10');
      },
    );

    test('initializeControllers seeds tax D when non-VAT', () {
      final model = BulkAddProductViewModel();
      model.setVatEnabledForTesting(false);
      model.setExcelDataForTesting([
        {'BarCode': 'X', 'Name': 'P', 'Price': '1'},
      ]);
      model.initializeControllers();
      final uid = model.bulkRowUidForRow(model.excelData!.first);
      expect(model.selectedTaxTypes[uid], 'D');
    });

    test('initializeControllers seeds tax B when VAT', () {
      final model = BulkAddProductViewModel();
      model.setVatEnabledForTesting(true);
      model.setExcelDataForTesting([
        {'BarCode': 'X', 'Name': 'P', 'Price': '1'},
      ]);
      model.initializeControllers();
      final uid = model.bulkRowUidForRow(model.excelData!.first);
      expect(model.selectedTaxTypes[uid], 'B');
    });

    test('resolveTaxTyCdForRow coerces B to D on non-VAT', () {
      final model = BulkAddProductViewModel();
      model.setVatEnabledForTesting(false);
      model.setExcelDataForTesting([
        {'BarCode': 'X', 'Name': 'P', 'Price': '1', 'TaxType': 'B'},
      ]);
      final row = model.excelData!.first;
      final uid = model.bulkRowUidForRow(row);
      expect(model.resolveTaxTyCdForRow(uid, row), 'D');
    });

    test('large import uses one page of field controllers at a time', () {
      final rows = List.generate(
        250,
        (i) => <String, dynamic>{
          'BarCode': 'B$i',
          'Name': 'N',
          'Price': '5',
        },
      );
      final model = BulkAddProductViewModel();
      model.setExcelDataForTesting(rows);
      model.initializeControllers();
      expect(model.controllers.length, 20);
      expect(model.rowsVisibleInGrid.length, 20);

      model.nextLargeImportPage();
      expect(model.largeImportPageIndex, 1);
      expect(model.controllers.length, 20);

      model.prevLargeImportPage();
      expect(model.largeImportPageIndex, 0);
    });
  });
}
