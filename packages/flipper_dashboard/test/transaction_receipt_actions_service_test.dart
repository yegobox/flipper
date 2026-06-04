import 'package:flipper_dashboard/services/transaction_receipt_actions_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction _tx({String? receiptType, bool refunded = false}) {
  final now = DateTime.now().toUtc();
  return ITransaction(
    id: 'tx-1',
    branchId: 'b1',
    agentId: 'a1',
    status: 'complete',
    transactionType: 'Sale',
    subTotal: 1000,
    paymentType: 'CASH',
    cashReceived: 1000,
    customerChangeDue: 0,
    updatedAt: now,
    receiptType: receiptType,
    isIncome: true,
    isExpense: false,
    isRefunded: refunded,
  );
}

void main() {
  final service = TransactionReceiptActionsService();

  test('resolveCopyFilterType uses CS for normal sales', () {
    expect(
      service.resolveCopyFilterType(_tx(receiptType: 'NS')),
      FilterType.CS,
    );
  });

  test('resolveCopyFilterType uses CR when refunded', () {
    expect(
      service.resolveCopyFilterType(_tx(receiptType: 'NS', refunded: true)),
      FilterType.CR,
    );
  });

  test('resolveCopyFilterType rejects training receipts', () {
    expect(
      () => service.resolveCopyFilterType(_tx(receiptType: 'TS')),
      throwsA(isA<TransactionReceiptException>()),
    );
  });
}
