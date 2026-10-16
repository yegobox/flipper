import 'package:flipper_ai_feature/src/services/flo_local_briefing_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction _txn({
  double subTotal = 500,
  bool isExpense = false,
  String? receiptType = 'NS',
  String transactionType = 'Sale',
}) =>
    ITransaction(
      branchId: 'b1',
      status: 'completed',
      transactionType: transactionType,
      paymentType: 'CASH',
      cashReceived: subTotal,
      customerChangeDue: 0,
      updatedAt: DateTime(2026, 10, 16),
      isIncome: !isExpense,
      isExpense: isExpense,
      agentId: 'agent-test',
      subTotal: subTotal,
      receiptType: receiptType,
    );

void main() {
  group('FloLocalBriefingService.isFloSale', () {
    test('a completed sale counts', () {
      expect(FloLocalBriefingService.isFloSale(_txn()), isTrue);
      expect(
        FloLocalBriefingService.isFloSale(_txn(receiptType: null)),
        isTrue,
      );
    });

    test('a Cash Out (e.g. a confirmed SMS debit) is not revenue', () {
      final cashOut = _txn(
        isExpense: true,
        receiptType: 'Cash Out',
        transactionType: 'Transport',
      );
      expect(FloLocalBriefingService.isFloSale(cashOut), isFalse);
    });

    test('a legacy expense marked only by isExpense is not revenue', () {
      expect(FloLocalBriefingService.isFloSale(_txn(isExpense: true)), isFalse);
    });

    test('a Cash In is not revenue', () {
      final cashIn = _txn(receiptType: 'Cash In', transactionType: 'Loan');
      expect(FloLocalBriefingService.isFloSale(cashIn), isFalse);
    });

    test('a zero-value row is not revenue', () {
      expect(FloLocalBriefingService.isFloSale(_txn(subTotal: 0)), isFalse);
    });
  });
}
