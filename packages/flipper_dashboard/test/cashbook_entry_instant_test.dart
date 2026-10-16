import 'package:flipper_dashboard/cashbook.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _cashOut({DateTime? createdAt, DateTime? lastTouched}) =>
    ITransaction(
      id: 'txn-1',
      branchId: 'branch-1',
      status: COMPLETE,
      transactionType: 'Bank charges',
      paymentType: 'MTN MOMO',
      cashReceived: 20,
      customerChangeDue: 0,
      updatedAt: lastTouched,
      isIncome: false,
      isExpense: true,
      agentId: 'agent-test',
      subTotal: 20,
      createdAt: createdAt,
      lastTouched: lastTouched,
    );

void main() {
  group('cashbookEntryInstant', () {
    test('a bank SMS confirmed today stays on the day the money moved', () {
      final smsDay = DateTime(2026, 10, 13, 9, 30);
      final confirmedAt = DateTime(2026, 10, 16, 14, 7);

      expect(
        cashbookEntryInstant(
          _cashOut(createdAt: smsDay, lastTouched: confirmedAt),
        ),
        smsDay,
      );
    });

    test('falls back to lastTouched when createdAt is missing', () {
      final touched = DateTime(2026, 10, 16, 14, 7);
      // The constructor stamps a missing createdAt with now; a synced row can
      // still arrive without one.
      final txn = _cashOut(lastTouched: touched)..createdAt = null;

      expect(cashbookEntryInstant(txn), touched);
    });
  });
}
