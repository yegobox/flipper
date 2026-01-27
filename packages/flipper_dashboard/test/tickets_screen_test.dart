import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

import '../lib/features/tickets/screens/tickets_screen.dart';

// Mock classes for testing
class MockITransaction extends Mock implements ITransaction {}

void main() {
  group('TicketsScreen Tests', () {
    late MockITransaction mockTransaction;

    setUp(() {
      mockTransaction = MockITransaction();
      
      // Setup default return values for the mock transaction
      when(mockTransaction.id).thenReturn('123');
      when(mockTransaction.customerId).thenReturn(null);
      when(mockTransaction.customerName).thenReturn('Test Customer');
      when(mockTransaction.status).thenReturn('PENDING');
      when(mockTransaction.subTotal).thenReturn(100.0);
      when(mockTransaction.cashReceived).thenReturn(0.0);
    });

    test('TicketsScreen widget can be instantiated', () {
      final widget = TicketsScreen(
        transaction: mockTransaction,
      );
      
      expect(widget, isNotNull);
      expect(widget.transaction, equals(mockTransaction));
      expect(widget.showAppBar, isTrue); // Default value
    });

    test('TicketsScreen widget with custom showAppBar', () {
      final widget = TicketsScreen(
        transaction: mockTransaction,
        showAppBar: false,
      );
      
      expect(widget, isNotNull);
      expect(widget.showAppBar, isFalse);
    });

    test('TicketsScreen properties are correctly assigned', () {
      const key = Key('test-key');
      const showAppBar = false;
      
      final widget = TicketsScreen(
        key: key,
        transaction: mockTransaction,
        showAppBar: showAppBar,
      );
      
      expect(widget.key, equals(key));
      expect(widget.transaction, equals(mockTransaction));
      expect(widget.showAppBar, equals(showAppBar));
    });

    test('TicketsScreen handles null transaction', () {
      final widget = TicketsScreen(
        transaction: null, // Null transaction
        showAppBar: true,
      );
      
      expect(widget, isNotNull);
      expect(widget.transaction, isNull);
      expect(widget.showAppBar, isTrue);
    });

    test('TicketsScreen with transaction that has ticketName', () {
      // Set up transaction with a ticket name (simulating resumed ticket)
      when(mockTransaction.ticketName).thenReturn('Resumed Ticket #001');
      
      final widget = TicketsScreen(
        transaction: mockTransaction,
        showAppBar: true,
      );
      
      expect(widget.transaction?.ticketName, equals('Resumed Ticket #001'));
    });

    test('TicketsScreen handles transaction with empty ticketName', () {
      // Set up transaction with an empty ticket name
      when(mockTransaction.ticketName).thenReturn('');
      
      final widget = TicketsScreen(
        transaction: mockTransaction,
        showAppBar: true,
      );
      
      expect(widget.transaction?.ticketName, equals(''));
    });

    test('TicketsScreen class exists', () {
      expect(TicketsScreen, isNotNull);
    });
  });
}