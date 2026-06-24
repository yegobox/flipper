import 'package:flipper_dashboard/widgets/sales_by_cashier_chart.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/supabase_models.dart';

ITransaction _tx({
  required String id,
  required String agentId,
  required double subTotal,
  required double cashReceived,
}) {
  final now = DateTime(2026, 4, 25, 12);
  return ITransaction(
    id: id,
    agentId: agentId,
    branchId: 'b1',
    status: 'COMPLETE',
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: cashReceived,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: true,
    isExpense: false,
    receiptNumber: 1,
    subTotal: subTotal,
    receiptType: 'NS',
  );
}

void main() {
  testWidgets('SalesByCashierChart golden', (tester) async {
    final txs = [
      _tx(id: 't1', agentId: 'alice@example.com', subTotal: 460, cashReceived: 460),
      _tx(id: 't2', agentId: 'chloe@example.com', subTotal: 230, cashReceived: 230),
      _tx(id: 't3', agentId: 'bob@example.com', subTotal: 195, cashReceived: 195),
    ];
    final sums = <String, TransactionPaymentSums>{
      't1': const TransactionPaymentSums(byHand: 280, credit: 200, hasAnyRecord: true),
      't2': const TransactionPaymentSums(byHand: 230, credit: 0, hasAnyRecord: true),
      't3': const TransactionPaymentSums(byHand: 195, credit: 0, hasAnyRecord: true),
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 1200,
            height: 700,
            child: SalesByCashierChart(
              transactions: txs,
              paymentSumsByTransactionId: sums,
              currencySymbol: 'RWF',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SalesByCashierChart),
      matchesGoldenFile('goldens/sales_by_cashier_chart.png'),
    );
  });
}

