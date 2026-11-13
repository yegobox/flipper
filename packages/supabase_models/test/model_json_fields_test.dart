import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

// flutter test test/model_json_fields_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  group('Variant.fromJson lastAvgCostReceiptRef', () {
    Map<String, dynamic> base() => {
          'id': 'v1',
          'name': 'Fanta',
          'branchId': 'b1',
        };

    test('reads the camelCase key', () {
      final variant = Variant.fromJson({
        ...base(),
        'lastAvgCostReceiptRef': 'rcpt-1',
      });
      expect(variant.lastAvgCostReceiptRef, 'rcpt-1');
    });

    test('falls back to the snake_case column name', () {
      final variant = Variant.fromJson({
        ...base(),
        'last_avg_cost_receipt_ref': 'rcpt-2',
      });
      expect(variant.lastAvgCostReceiptRef, 'rcpt-2');
    });

    test('prefers camelCase when both are present', () {
      final variant = Variant.fromJson({
        ...base(),
        'lastAvgCostReceiptRef': 'camel',
        'last_avg_cost_receipt_ref': 'snake',
      });
      expect(variant.lastAvgCostReceiptRef, 'camel');
    });

    test('stays null when neither key is present', () {
      expect(Variant.fromJson(base()).lastAvgCostReceiptRef, isNull);
    });
  });

  group('Supplier.toFlipperJson custNo', () {
    test('drops the leading 0 of a local phone number', () {
      final json = Supplier(telNo: '0788123456').toFlipperJson();
      expect(json['custNo'], '788123456');
      expect(json['telNo'], '0788123456');
    });

    test('keeps a number without a leading 0 as is', () {
      expect(
        Supplier(telNo: '250788123456').toFlipperJson()['custNo'],
        '250788123456',
      );
    });

    test('is null without a phone number', () {
      expect(Supplier().toFlipperJson()['custNo'], isNull);
    });
  });
}
