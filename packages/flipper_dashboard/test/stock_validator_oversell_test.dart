import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_dashboard/utils/stock_validator.dart';

void main() {
  test(
    'validateStockQuantity returns empty when allowSellingBelowStock is true',
    () async {
      final out =
          await validateStockQuantity([], allowSellingBelowStock: true);
      expect(out, isEmpty);
    },
  );
}
