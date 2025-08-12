import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_column.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../test_helpers/setup.dart';
// flutter test test/features/kitchen_display/widgets/order_column_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  group('OrderColumn Tests', () {
    late List<ITransaction> mockOrders;
    late Function(ITransaction, OrderStatus, OrderStatus) mockOnOrderAccepted;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockOrders = [
        ITransaction(
          id: '1',
          branchId: 1,
          transactionNumber: 'ORD001',
          customerName: 'John Doe',
          subTotal: 25.50,
          status: 'pending',
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 30.0,
          customerChangeDue: 4.50,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          createdAt: DateTime.now(),
        ),
        ITransaction(
          id: '2',
          branchId: 1,
          transactionNumber: 'ORD002',
          customerName: 'Jane Smith',
          subTotal: 15.75,
          status: 'pending',
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 20.0,
          customerChangeDue: 4.25,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          createdAt: DateTime.now(),
        ),
      ];

      mockOnOrderAccepted = (order, fromStatus, toStatus) {};
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays column title correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Pending Orders',
                orders: mockOrders,
                color: Colors.orange,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Pending Orders'), findsOneWidget);
    });

    testWidgets('displays order count correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Pending Orders',
                orders: mockOrders,
                color: Colors.orange,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('shows empty state when no orders', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Empty Column',
                orders: [],
                color: Colors.blue,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('No orders'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays order cards when orders exist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Pending Orders',
                orders: mockOrders,
                color: Colors.orange,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('Order #ORD001'), findsOneWidget);
      expect(find.textContaining('Order #ORD002'), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Test Column',
                orders: mockOrders,
                color: Colors.green,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(DragTarget<Map<String, dynamic>>), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('applies correct color styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Red Column',
                orders: [],
                color: Colors.red,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final titleFinder = find.text('Red Column');
      expect(titleFinder, findsOneWidget);
      
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, Colors.red);
    });

    testWidgets('shows draggable order cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Draggable Orders',
                orders: mockOrders,
                color: Colors.purple,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Draggable<Map<String, dynamic>>), findsNWidgets(2));
    });

    testWidgets('handles single order correctly', (tester) async {
      final singleOrder = [mockOrders.first];
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Single Order',
                orders: singleOrder,
                color: Colors.teal,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.textContaining('Order #ORD001'), findsOneWidget);
      expect(find.textContaining('Order #ORD002'), findsNothing);
    });

    testWidgets('has proper container constraints', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderColumn(
                title: 'Constrained Column',
                orders: mockOrders,
                color: Colors.indigo,
                status: OrderStatus.incoming,
                onOrderAccepted: mockOnOrderAccepted,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints, const BoxConstraints(maxWidth: 300));
    });
  });
}