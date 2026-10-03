import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/notifications/utils/notification_utils.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _item(String name) => TransactionItem(
  name: name,
  price: 100,
  qty: 1,
  discount: 0,
  prc: 100,
  ttCatCd: 'A',
);

void main() {
  group('NotificationUtils.formatDelegationBody', () {
    test('includes customer name when present', () {
      final delegation = TransactionDelegation(
        transactionId: 'tx-1',
        branchId: 'branch-1',
        status: 'delegated',
        receiptType: 'NS',
        paymentType: 'Cash',
        subTotal: 12500,
        customerName: 'Jane Doe',
        delegatedFromDevice: 'POS-2',
      );

      expect(
        NotificationUtils.formatDelegationBody(delegation),
        'NS receipt for Jane Doe · RWF 12,500 · from POS-2',
      );
    });

    test('omits customer name when blank', () {
      final delegation = TransactionDelegation(
        transactionId: 'tx-2',
        branchId: 'branch-1',
        status: 'delegated',
        receiptType: 'TS',
        paymentType: 'Card',
        subTotal: 500,
        customerName: '   ',
        delegatedFromDevice: 'POS-1',
      );

      expect(
        NotificationUtils.formatDelegationBody(delegation),
        'TS receipt · RWF 500 · from POS-1',
      );
    });
  });

  group('NotificationUtils.formatStockTransferBody', () {
    final source = Branch(id: 'b-main', name: 'Kigali Main');

    test('names the source branch, never its id', () {
      final request = InventoryRequest(
        branchId: 'b-dest',
        mainBranchId: '0a768d23-bf31-4fef-8c48-3078f47211ca',
        itemCounts: 3,
      )..branch = source;

      final body = NotificationUtils.formatStockTransferBody(request);
      expect(body, 'Incoming transfer from Kigali Main (3 items)');
      expect(body, isNot(contains('0a768d23')));
    });

    test('falls back to a generic label before the branch syncs', () {
      final request = InventoryRequest(
        branchId: 'b-dest',
        mainBranchId: '0a768d23-bf31-4fef-8c48-3078f47211ca',
        itemCounts: 1,
      );

      expect(
        NotificationUtils.formatStockTransferBody(request),
        'Incoming transfer from another branch (1 item)',
      );
    });

    test('lists product names when items are loaded', () {
      final request = InventoryRequest(branchId: 'b-dest', itemCounts: 4)
        ..branch = source
        ..transactionItems = [_item('Sugar'), _item('Rice'), _item('Oil')];

      expect(
        NotificationUtils.formatStockTransferBody(request),
        'Incoming transfer from Kigali Main: Sugar, Rice +2 more',
      );
    });

    test('no count when nothing is known about the items', () {
      final request = InventoryRequest(branchId: 'b-dest')..branch = source;

      expect(
        NotificationUtils.formatStockTransferBody(request),
        'Incoming transfer from Kigali Main',
      );
    });
  });
}
