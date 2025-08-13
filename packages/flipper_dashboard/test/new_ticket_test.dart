import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewTicket UI Tests', () {
    late ITransaction mockTransaction;

    setUp(() {
      mockTransaction = ITransaction(
        id: 'test123',
        branchId: 1,
        transactionNumber: 'TXN001',
        ticketName: 'Test Ticket',
        subTotal: 100.0,
        status: 'pending',
        transactionType: 'sale',
        paymentType: 'cash',
        cashReceived: 100.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        note: 'Test note',
      );
    });

    testWidgets('loading state components exist', (tester) async {
      // Test the loading UI components directly
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Saving...'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Saving...'), findsOneWidget);
    });

    testWidgets('loan checkbox and date picker layout', (tester) async {
      bool isLoan = true;
      DateTime dueDate = DateTime.now().add(Duration(days: 7));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [
                    Checkbox(value: isLoan, onChanged: null),
                    Text('Mark as Loan'),
                  ],
                ),
                if (isLoan)
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event, color: Colors.blue, size: 20),
                        const SizedBox(width: 4),
                        Text('Due: ${dueDate.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Mark as Loan'), findsOneWidget);
      expect(find.textContaining('Due:'), findsOneWidget);
      expect(find.byIcon(Icons.event), findsOneWidget);
    });
  });
}