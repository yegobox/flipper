import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/notifications/utils/notification_utils.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
