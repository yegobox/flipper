import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/ticket_selection_provider.dart';
import 'package:flipper_models/db_model_export.dart';

// flutter test test/features/tickets/ticket_selection_test.dart
void main() {
  group('TicketSelectionProvider', () {
    late ProviderContainer container;
    late TicketSelectionNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(ticketSelectionProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty', () {
      final state = container.read(ticketSelectionProvider);
      expect(state.isEmpty, true);
      expect(notifier.hasSelection, false);
      expect(notifier.selectedCount, 0);
    });

    test('toggleSelection should add ticket when not selected', () {
      const ticketId = 'ticket1';
      
      notifier.toggleSelection(ticketId);
      
      final state = container.read(ticketSelectionProvider);
      expect(state.contains(ticketId), true);
      expect(notifier.isSelected(ticketId), true);
      expect(notifier.selectedCount, 1);
    });

    test('toggleSelection should remove ticket when already selected', () {
      const ticketId = 'ticket1';
      
      notifier.toggleSelection(ticketId);
      notifier.toggleSelection(ticketId);
      
      final state = container.read(ticketSelectionProvider);
      expect(state.contains(ticketId), false);
      expect(notifier.isSelected(ticketId), false);
      expect(notifier.selectedCount, 0);
    });

    test('selectAll should select all provided tickets', () {
      final tickets = [
        ITransaction(
          id: 'ticket1',
          branchId: 1,
          status: 'PARKED',
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
        ),
        ITransaction(
          id: 'ticket2',
          branchId: 1,
          status: 'PARKED',
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
        ),
        ITransaction(
          id: 'ticket3',
          branchId: 1,
          status: 'PARKED',
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
        ),
      ];
      
      notifier.selectAll(tickets);
      
      final state = container.read(ticketSelectionProvider);
      expect(state.length, 3);
      expect(state.contains('ticket1'), true);
      expect(state.contains('ticket2'), true);
      expect(state.contains('ticket3'), true);
      expect(notifier.selectedCount, 3);
    });

    test('clearSelection should remove all selections', () {
      final tickets = [
        ITransaction(
          id: 'ticket1',
          branchId: 1,
          status: 'PARKED',
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
        ),
        ITransaction(
          id: 'ticket2',
          branchId: 1,
          status: 'PARKED',
          transactionType: 'sale',
          paymentType: 'CASH',
          cashReceived: 0.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
        ),
      ];
      
      notifier.selectAll(tickets);
      notifier.clearSelection();
      
      final state = container.read(ticketSelectionProvider);
      expect(state.isEmpty, true);
      expect(notifier.hasSelection, false);
      expect(notifier.selectedCount, 0);
    });
  });
}