import 'package:flipper_dashboard/utils/branch_transfer_stock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/stock.model.dart';

void main() {
  group('isAuthenticCapellaStock', () {
    test('rejects null and empty-branch placeholders from getStockById miss', () {
      expect(isAuthenticCapellaStock(null), isFalse);
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 'missing',
            branchId: '',
            currentStock: 0,
          ),
        ),
        isFalse,
      );
    });

    test('accepts stock rows with a real branchId', () {
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 's1',
            branchId: 'branch-a',
            currentStock: 50,
          ),
        ),
        isTrue,
      );
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 's2',
            branchId: 'branch-a',
            currentStock: 0,
          ),
        ),
        isTrue,
      );
    });
  });

  group('onHandFromStock', () {
    test('uses currentStock only for authentic Capella rows', () {
      expect(
        onHandFromStock(
          Stock(id: 's1', branchId: 'b1', currentStock: 50),
        ),
        50,
      );
      expect(
        onHandFromStock(
          Stock(id: 'phantom', branchId: '', currentStock: 0),
          qtyFallback: 50,
        ),
        50,
      );
      expect(
        onHandFromStock(
          Stock(id: 'phantom', branchId: '', currentStock: 0),
        ),
        0,
      );
    });
  });
}
