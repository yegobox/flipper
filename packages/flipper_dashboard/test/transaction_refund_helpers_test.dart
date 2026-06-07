import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

void main() {
  group('stockRestoreQtyForLine', () {
    test('returns full qty for full refund', () {
      expect(
        stockRestoreQtyForLine(
          lineQty: 5,
          refundAmount: 1000,
          originalTotal: 1000,
          lineIndex: 0,
          lineCount: 1,
        ),
        5,
      );
    });

    test('returns proportional qty for partial refund', () {
      expect(
        stockRestoreQtyForLine(
          lineQty: 10,
          refundAmount: 500,
          originalTotal: 1000,
          lineIndex: 0,
          lineCount: 1,
        ),
        5,
      );
    });

    test('returns zero when line qty is zero', () {
      expect(
        stockRestoreQtyForLine(
          lineQty: 0,
          refundAmount: 500,
          originalTotal: 1000,
          lineIndex: 0,
          lineCount: 1,
        ),
        0,
      );
    });
  });

  group('isPartialRefund', () {
    test('detects partial vs full', () {
      expect(isPartialRefund(500, 1000), isTrue);
      expect(isPartialRefund(1000, 1000), isFalse);
    });
  });

  group('refundStatusForAmount', () {
    test('returns correct status strings', () {
      expect(refundStatusForAmount(500, 1000), 'partially_refunded');
      expect(refundStatusForAmount(1000, 1000), 'refunded');
    });
  });

  group('isTransactionRefunded', () {
    test('detects isRefunded flag', () {
      expect(
        isTransactionRefunded(ITransaction(id: '1', isRefunded: true)),
        isTrue,
      );
    });

    test('detects refunded status without flag', () {
      expect(
        isTransactionRefunded(ITransaction(id: '1', status: 'refunded')),
        isTrue,
      );
      expect(
        isTransactionRefunded(
          ITransaction(id: '1', status: 'partially_refunded'),
        ),
        isTrue,
      );
    });

    test('detects refund receipt types', () {
      expect(
        isTransactionRefunded(ITransaction(id: '1', receiptType: 'NR')),
        isTrue,
      );
      expect(
        isTransactionRefunded(ITransaction(id: '1', receiptType: 'CR')),
        isTrue,
      );
    });

    test('detects linked refund copy rows', () {
      expect(
        isTransactionRefunded(
          ITransaction(
            id: '2',
            originalTransactionId: '1',
            isOriginalTransaction: false,
          ),
        ),
        isTrue,
      );
    });

    test('allows refundable normal sale', () {
      expect(
        isTransactionRefunded(
          ITransaction(id: '1', receiptType: 'NS', status: 'completed'),
        ),
        isFalse,
      );
    });
  });
}
