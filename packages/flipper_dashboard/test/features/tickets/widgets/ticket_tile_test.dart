import 'package:flipper_dashboard/features/tickets/widgets/ticket_tile.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/tickets/widgets/ticket_tile_test.dart
void main() {
  group('TicketTile Tests', () {
    late ITransaction mockTicket;
    late VoidCallback mockOnTap;
    late Function(ITransaction) mockOnDelete;
    bool tapped = false;
    ITransaction? deletedTicket;

    setUp(() {
      tapped = false;
      deletedTicket = null;
      mockOnTap = () => tapped = true;
      mockOnDelete = (ticket) => deletedTicket = ticket;

      mockTicket = ITransaction(
        id: 'ticket123',
        branchId: 1,
        transactionNumber: 'TKT001',
        ticketName: 'Test Ticket',
        subTotal: 150.75,
        status: 'pending',
        transactionType: 'ticket',
        paymentType: 'cash',
        cashReceived: 150.75,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isIncome: true,
        isExpense: false,
      );
    });

    testWidgets('displays ticket name correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.text('Test Ticket'), findsOneWidget);
    });

    testWidgets('displays ticket ID correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.textContaining('ID: ticket12'), findsOneWidget);
    });

    testWidgets('displays subtotal correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.textContaining('Subtotal: 150.75'), findsOneWidget);
    });

    testWidgets('handles tap correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TicketTile));
      expect(tapped, isTrue);
    });

    testWidgets('shows delete button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('displays loan badge when ticket is loan', (tester) async {
      final loanTicket = ITransaction(
        id: 'loan123',
        branchId: 1,
        transactionNumber: 'LOAN001',
        ticketName: 'Loan Ticket',
        subTotal: 200.0,
        status: 'pending',
        transactionType: 'ticket',
        paymentType: 'cash',
        cashReceived: 200.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        isLoan: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: loanTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.text('LOAN'), findsOneWidget);
    });

    testWidgets('displays due date when present', (tester) async {
      final ticketWithDueDate = ITransaction(
        id: 'due123',
        branchId: 1,
        transactionNumber: 'DUE001',
        ticketName: 'Due Ticket',
        subTotal: 100.0,
        status: 'pending',
        transactionType: 'ticket',
        paymentType: 'cash',
        cashReceived: 100.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        dueDate: DateTime.now().add(const Duration(hours: 24)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: ticketWithDueDate,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.textContaining('Due:'), findsOneWidget);
      expect(find.byIcon(Icons.event), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('handles null ticket name', (tester) async {
      final ticketWithoutName = ITransaction(
        id: 'noname123',
        branchId: 1,
        transactionNumber: 'NONAME001',
        ticketName: null,
        subTotal: 50.0,
        status: 'pending',
        transactionType: 'ticket',
        paymentType: 'cash',
        cashReceived: 50.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: ticketWithoutName,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.text('N/A'), findsOneWidget);
    });

    testWidgets('shows status chip for non-loan tickets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      // Should show status but not LOAN
      expect(find.text('LOAN'), findsNothing);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('card has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
      
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(8.0));
    });

    testWidgets('handles zero subtotal', (tester) async {
      final zeroSubtotalTicket = ITransaction(
        id: 'zero123',
        branchId: 1,
        transactionNumber: 'ZERO001',
        ticketName: 'Zero Ticket',
        subTotal: 0.0,
        status: 'pending',
        transactionType: 'ticket',
        paymentType: 'cash',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: zeroSubtotalTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.textContaining('Subtotal: 0.00'), findsOneWidget);
    });

    testWidgets('handles delete button tap correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketTile(
              ticket: mockTicket,
              onTap: mockOnTap,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deletedTicket, equals(mockTicket));
    });
  });
}