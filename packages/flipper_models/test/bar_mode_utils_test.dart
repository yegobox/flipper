import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

void main() {
  group('bar_mode_utils', () {
    test('barTabTotal sums price x qty', () {
      final lines = [
        TransactionItem(
          name: 'A',
          qty: 2,
          price: 6500,
          prc: 6500,
          discount: 0,
          ttCatCd: '1',
          itemTyCd: '2',
          itemCd: 'a',
        ),
        TransactionItem(
          name: 'B',
          qty: 3,
          price: 2400,
          prc: 2400,
          discount: 0,
          ttCatCd: '1',
          itemTyCd: '2',
          itemCd: 'b',
        ),
      ];
      expect(barTabTotal(lines), 20200);
      expect(barTabItemCount(lines), 5);
    });

    test('barLineMatchesMerge uses variant cashier and default price', () {
      final line = TransactionItem(
        name: 'X',
        variantId: 'v1',
        loggedByTenantId: 't1',
        qty: 1,
        price: 1000,
        prc: 1000,
        discount: 0,
        ttCatCd: '1',
        itemTyCd: '2',
        itemCd: 'x',
      );
      expect(
        barLineMatchesMerge(
          line: line,
          variantId: 'v1',
          cashierTenantId: 't1',
          defaultPrice: 1000,
        ),
        isTrue,
      );
      expect(
        barLineMatchesMerge(
          line: line,
          variantId: 'v1',
          cashierTenantId: 't2',
          defaultPrice: 1000,
        ),
        isFalse,
      );
      expect(
        barLineMatchesMerge(
          line: line,
          variantId: 'v1',
          cashierTenantId: 't1',
          defaultPrice: 900,
        ),
        isFalse,
      );
    });

    test('barVatBreakdown treats VAT as inclusive 18%', () {
      final b = barVatBreakdown(11800);
      expect(b.total, 11800);
      expect(b.vat, closeTo(1800, 0.01));
      expect(b.subtotal, closeTo(10000, 0.01));
    });

    test('barTenantInitials', () {
      expect(barTenantInitials('Victoria M.'), 'VM');
      expect(barTenantInitials('Eric'), 'ER');
    });

    test('barPinMatchesTenant compares login PIN from pins table', () {
      final tenant = Tenant(id: '1', name: 'Staff', pin: 123456);
      expect(barPinMatchesTenant(tenant, '123456'), isTrue);
      expect(barPinMatchesTenant(tenant, '1234'), isFalse);
      expect(barPinMatchesTenant(Tenant(id: '2', name: 'No pin'), '123456'), isFalse);
      expect(barPinMatchesTenant(Tenant(id: '3', name: 'Unset', pin: 0), '123456'), isFalse);
    });

    test('isUsableStaffPin treats 0 as unset', () {
      expect(isUsableStaffPin(123456), isTrue);
      expect(isUsableStaffPin(0), isFalse);
      expect(isUsableStaffPin(null), isFalse);
    });

    test('barPinCellCount matches login UI', () {
      expect(barPinCellCount, 6);
    });
  });
}
