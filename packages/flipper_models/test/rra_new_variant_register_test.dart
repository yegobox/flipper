import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

void main() {
  group('rraItemsRegisteredLocally', () {
    test('true after saveItems-only progress', () {
      final variant = Variant(
        id: 'v1',
        name: 'Tea',
        branchId: 'b1',
        itemCd: 'RW2CTBJ0000001',
        stockSynchronized: false,
        ebmSynced: false,
      );
      expect(rraItemsRegisteredLocally(variant), isTrue);
    });

    test('false when fully synced', () {
      final variant = Variant(
        id: 'v1',
        name: 'Tea',
        branchId: 'b1',
        itemCd: 'RW2CTBJ0000001',
        stockSynchronized: true,
        ebmSynced: true,
      );
      expect(rraItemsRegisteredLocally(variant), isFalse);
    });
  });

  group('isTransientRraNetworkError', () {
    test('detects timeout failures', () {
      expect(
        isTransientRraNetworkError(Exception('Connection timeout occurred.')),
        isTrue,
      );
    });
  });
}
