import 'package:flipper_dashboard/widgets/transaction_detail_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

ITransaction _sampleTransaction({bool refunded = false}) {
  final now = DateTime.now().toUtc();
  return ITransaction(
    id: 'tx-refund-test',
    branchId: 'branch-1',
    agentId: 'agent-1',
    status: refunded ? 'refunded' : 'complete',
    transactionType: 'Sale',
    subTotal: 3500,
    paymentType: 'CASH',
    cashReceived: 3500,
    customerChangeDue: 0,
    updatedAt: now,
    isIncome: true,
    isExpense: false,
    isRefunded: refunded,
    refundedAmount: refunded ? 3500 : null,
  );
}

void main() {
  testWidgets('refund row is disabled when already refunded', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showTransactionActionsSheet(
                  context: context,
                  transaction: _sampleTransaction(refunded: true),
                  referenceLabel: '#INC-1',
                  onRefund: () {},
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Already refunded'), findsOneWidget);
    expect(find.text('Refund payment'), findsNothing);
  });
}
