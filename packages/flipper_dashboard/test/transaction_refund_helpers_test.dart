import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction _txn({
  String id = '1',
  String? status,
  String? receiptType,
  bool? isRefunded,
  String? originalTransactionId,
  bool? isOriginalTransaction,
  bool? isLoan,
  double? subTotal,
  double? cashReceived,
  double? remainingBalance,
}) {
  final now = DateTime.now().toUtc();
  return ITransaction(
    id: id,
    branchId: 'branch-1',
    agentId: 'agent-1',
    status: status ?? 'completed',
    transactionType: 'Sale',
    paymentType: 'CASH',
    cashReceived: cashReceived ?? subTotal ?? 1000,
    customerChangeDue: 0,
    updatedAt: now,
    isIncome: true,
    isExpense: false,
    isRefunded: isRefunded,
    receiptType: receiptType,
    originalTransactionId: originalTransactionId,
    isOriginalTransaction: isOriginalTransaction,
    isLoan: isLoan,
    subTotal: subTotal ?? 1000,
    remainingBalance: remainingBalance,
  );
}

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

    test('does not force one unit on tiny partial of qty-1 line', () {
      expect(
        stockRestoreQtyForLine(
          lineQty: 1,
          refundAmount: 100,
          originalTotal: 1000,
          lineIndex: 0,
          lineCount: 1,
        ),
        0,
      );
    });
  });

  group('stockRestoreQtysForLines', () {
    test('full refund restores every line qty', () {
      expect(
        stockRestoreQtysForLines(
          lineQtys: [2, 3],
          refundAmount: 1000,
          originalTotal: 1000,
        ),
        [2, 3],
      );
    });

    test('one-third refund of three qty-1 lines restores one unit total', () {
      final qtys = stockRestoreQtysForLines(
        lineQtys: [1, 1, 1],
        refundAmount: 300,
        originalTotal: 900,
      );
      expect(qtys.fold<int>(0, (s, q) => s + q), 1);
      expect(qtys.every((q) => q == 0 || q == 1), isTrue);
    });

    test('half refund of ten units restores five', () {
      expect(
        stockRestoreQtysForLines(
          lineQtys: [10],
          refundAmount: 500,
          originalTotal: 1000,
        ),
        [5],
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
      expect(isTransactionRefunded(_txn(isRefunded: true)), isTrue);
    });

    test('detects refunded status without flag', () {
      expect(isTransactionRefunded(_txn(status: 'refunded')), isTrue);
      expect(isTransactionRefunded(_txn(status: 'partially_refunded')), isTrue);
    });

    test('detects refund receipt types', () {
      expect(isTransactionRefunded(_txn(receiptType: 'NR')), isTrue);
      expect(isTransactionRefunded(_txn(receiptType: 'CR')), isTrue);
    });

    test('detects linked refund copy rows', () {
      expect(
        isTransactionRefunded(
          _txn(
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
        isTransactionRefunded(_txn(receiptType: 'NS', status: 'completed')),
        isFalse,
      );
    });
  });

  group('canRefundTransaction', () {
    test('allows completed fully paid cash sale', () {
      expect(
        canRefundTransaction(
          _txn(
            receiptType: 'NS',
            status: 'completed',
            subTotal: 1000,
            cashReceived: 1000,
            remainingBalance: 0,
          ),
        ),
        isTrue,
      );
    });

    test('blocks open credit / loan with remaining balance', () {
      expect(
        canRefundTransaction(
          _txn(
            receiptType: 'NS',
            status: 'completed',
            isLoan: true,
            subTotal: 1000,
            cashReceived: 200,
            remainingBalance: 800,
          ),
        ),
        isFalse,
      );
      expect(
        refundBlockReason(
          _txn(
            isLoan: true,
            subTotal: 1000,
            cashReceived: 200,
            remainingBalance: 800,
          ),
        ),
        contains('Credit or partially paid'),
      );
    });

    test('allows settled loan that is fully paid', () {
      expect(
        canRefundTransaction(
          _txn(
            receiptType: 'NS',
            status: 'completed',
            isLoan: true,
            subTotal: 1000,
            cashReceived: 1000,
            remainingBalance: 0,
          ),
        ),
        isTrue,
      );
    });

    test('blocks non-completed sales', () {
      expect(
        canRefundTransaction(
          _txn(
            status: 'parked',
            subTotal: 1000,
            cashReceived: 1000,
            remainingBalance: 0,
          ),
        ),
        isFalse,
      );
      expect(
        refundBlockReason(
          _txn(
            status: 'pending',
            subTotal: 1000,
            cashReceived: 1000,
            remainingBalance: 0,
          ),
        ),
        contains('Only completed'),
      );
    });

    test('blocks underpaid completed sale', () {
      expect(
        canRefundTransaction(
          _txn(
            status: 'completed',
            subTotal: 1000,
            cashReceived: 400,
            remainingBalance: 600,
            isLoan: false,
          ),
        ),
        isFalse,
      );
    });
  });
}
