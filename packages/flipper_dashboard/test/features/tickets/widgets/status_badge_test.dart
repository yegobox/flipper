import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/tickets/widgets/status_badge_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('TicketCard Status Badge Tests', () {
    testWidgets('displays status badge with PARKED status', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: PARKED,
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
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

      expect(find.text('Waiting'), findsOneWidget);
    });

    testWidgets('displays status badge with WAITING status', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: WAITING,
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
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

      expect(find.text('Waiting'), findsOneWidget);
    });

    testWidgets('displays status badge with IN_PROGRESS status', (tester) async {
      final ticket = ITransaction(
        branchId: 1,
        status: IN_PROGRESS,
        transactionType: 'test',
        paymentType: 'test',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
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

      expect(find.text('In Progress'), findsOneWidget);
    });
  });
}