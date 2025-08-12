import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TicketCard _formatDate Tests', () {
    testWidgets('formats date correctly', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: 'test',
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        createdAt: DateTime(2023, 5, 15, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketCard(
              ticket: ticket,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Created: 5/15 14:30'), findsOneWidget);
    });

    testWidgets('handles null date', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: 'test',
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        createdAt: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketCard(
              ticket: ticket,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Created: Unknown'), findsOneWidget);
    });

    testWidgets('pads minutes correctly', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: 'test',
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        createdAt: DateTime(2023, 12, 1, 9, 5),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketCard(
              ticket: ticket,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Created: 12/1 9:05'), findsOneWidget);
    });
  });
}