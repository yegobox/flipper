import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/utils/bulk_excel_parser.dart';

void main() {
  group('BulkExcelParser.normalizeHeaderKey', () {
    test('strips BOM and extra spaces', () {
      expect(
        BulkExcelParser.normalizeHeaderKey('\uFEFF  Bar Code  '),
        'barcode',
      );
    });

    test('maps aliases to canonical names', () {
      expect(
        BulkExcelParser.canonicalHeaderForKey('barcode'),
        'BarCode',
      );
      expect(
        BulkExcelParser.canonicalHeaderForKey('retailprice'),
        'Price',
      );
      expect(
        BulkExcelParser.canonicalHeaderForKey('qty'),
        'Quantity',
      );
    });
  });

  group('BulkExcelParser file hints', () {
    test('rejects unsupported WPS .et extension message', () {
      expect(
        BulkExcelParser.unsupportedFormatHelp('products.et'),
        contains('Save As'),
      );
      expect(BulkExcelParser.isSupportedExtension('file.xlsx'), isTrue);
      expect(BulkExcelParser.isKnownUnsupportedExtension('file.et'), isTrue);
    });
  });
}
