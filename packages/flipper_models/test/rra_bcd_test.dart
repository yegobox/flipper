import 'package:flipper_models/sync/utils/rra_bcd.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('rraSafeBcd', () {
    test('leaves a barcode RRA already accepts alone', () {
      expect(rraSafeBcd('6009510800104'), '6009510800104');
      expect(rraSafeBcd('  6009510800104 '), '6009510800104');
    });

    test('drops null and blank barcodes', () {
      expect(rraSafeBcd(null), isNull);
      expect(rraSafeBcd('   '), isNull);
    });

    test('cuts an oversized barcode to 20 characters, keeping the tail', () {
      final safe = rraSafeBcd('Variant A 1781672471286');
      expect(safe, 'iant A 1781672471286');
      expect(safe!.length, lessThanOrEqualTo(kRraBcdMaxLength));
    });

    test('keeps same-name variants distinct after trimming', () {
      expect(
        rraSafeBcd('Variant A 1781672471286'),
        isNot(rraSafeBcd('Variant A 1781672471999')),
      );
    });
  });

  group('isRraBcdSizeError', () {
    test('matches the RRA validation message', () {
      expect(
        isRraBcdSizeError(
          "Request parameter error: Validation error for fields: [ 'itemList[19].bcd': size must be between 0 and 20. rejected value: 'Variant A 1781672471286']]",
        ),
        isTrue,
      );
    });

    test('ignores unrelated failures', () {
      expect(isRraBcdSizeError(null), isFalse);
      expect(isRraBcdSizeError('Invoice number already exists.'), isFalse);
      expect(
        isRraBcdSizeError(
          "Validation error for fields: [ 'itemList[0].itemNm': size must be between 0 and 200]",
        ),
        isFalse,
      );
    });
  });
}
