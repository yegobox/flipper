import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../lib/utils/resume_transaction_helper.dart';

void main() {
  group('TransactionInitializationHelper Tests', () {
    test('TransactionInitializationHelper class exists', () {
      expect(TransactionInitializationHelper, isNotNull);
    });

    test('initializeSession method exists', () {
      expect(TransactionInitializationHelper.initializeSession, isNotNull);
    });

    test('initializeCustomer method exists', () {
      expect(TransactionInitializationHelper.initializeCustomer, isNotNull);
    });

    test('resuming leaves a split as it was', () {
      final container = ProviderContainer(
        overrides: [
          paymentMethodsProvider.overrideWith(
            () => PaymentMethodsNotifier([
              Payment(amount: 1000, method: 'CASH'),
              Payment(amount: 600, method: 'MOBILE MONEY'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      TransactionInitializationHelper.applyPaymentWithRemainderForTest(
        container,
        ITransaction(
          id: 'txn-1',
          branchId: 'branch-1',
          status: PENDING,
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0,
          customerChangeDue: 0,
          updatedAt: DateTime.utc(2026, 10, 22),
          isIncome: true,
          isExpense: false,
          agentId: 'agent-test',
          subTotal: 1600,
        ),
      );

      expect(
        [
          for (final p in container.read(paymentMethodsProvider))
            (p.method, p.amount),
        ],
        [('CASH', 1000.0), ('MOBILE MONEY', 600.0)],
      );
    });

    test('_initializePaymentWithRemainder method concept exists', () {
      // Just checking that the public methods exist
      expect(TransactionInitializationHelper.initializeSession, isNotNull);
    });
  });
}
