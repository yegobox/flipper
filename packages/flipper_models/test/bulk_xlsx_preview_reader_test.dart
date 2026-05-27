import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/utils/bulk_excel_parser.dart';
import 'package:flipper_models/utils/bulk_xlsx_preview_reader.dart';

void main() {
  group('BulkXlsxPreviewReader refs', () {
    test('max row from simple refs', () {
      expect(BulkXlsxPreviewReader.maxRowFromRefForTest('A1'), 1);
      expect(BulkXlsxPreviewReader.maxRowFromRefForTest('C12'), 12);
      expect(BulkXlsxPreviewReader.maxRowFromRefForTest('B3:D99'), 99);
    });

    test('dimension snippet yields max row', () {
      const xml =
          '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
          '<dimension ref="A1:BC500"/></worksheet>';
      expect(BulkXlsxPreviewReader.maxRowFromDimensionForTest(xml), 500);
    });

    test('column letters to indices', () {
      expect(BulkXlsxPreviewReader.excelColIndexZeroBased('A7'), 0);
      expect(BulkXlsxPreviewReader.excelColIndexZeroBased('Z1'), 25);
      expect(BulkXlsxPreviewReader.excelColIndexZeroBased('AA2'), 26);
    });
  });

  test('cellValueRawString strips BOM and trims', () {
    expect(BulkExcelParser.cellValueRawString('\uFEFF  hello  '), 'hello');
  });

  test('sheetScoreForHeaderIndices weights required columns', () {
    expect(
      BulkExcelParser.sheetScoreForHeaderIndices({'BarCode': 0, 'Name': 1}),
      22,
    );
    expect(BulkExcelParser.sheetScoreForHeaderIndices({'Price': 0}), 1);
    expect(BulkExcelParser.sheetScoreForHeaderIndices({}), 0);
  });
}
