import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ticket Sorting Logic Tests', () {
    test('separates loan and regular tickets correctly', () {
      final tickets = [
        ITransaction(
          id: 'regular1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 1000.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          isLoan: false,
        ),
        ITransaction(
          id: 'loan1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 2000.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          isLoan: true,
        ),
      ];

      final loanTickets = tickets.where((t) => t.isLoan == true).toList();
      final nonLoanTickets = tickets.where((t) => t.isLoan != true).toList();

      expect(loanTickets.length, 1);
      expect(nonLoanTickets.length, 1);
      expect(loanTickets.first.id, 'loan1');
      expect(nonLoanTickets.first.id, 'regular1');
    });

    testWidgets('TicketCard displays correctly', (tester) async {
      final ticket = ITransaction(
        id: 'test123',
        branchId: 1,
        status: PARKED,
        transactionType: 'sale',
        paymentType: 'cash',
        cashReceived: 1500.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        subTotal: 1500.0,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketCard(
              ticket: ticket,
              isSelected: false,
              onSelectionChanged: (selected) {},
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Ticket #TEST12'), findsOneWidget);
      expect(find.textContaining('Total:'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
}
