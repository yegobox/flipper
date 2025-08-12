import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_helpers/setup.dart';
// flutter test test/features/incoming_orders/widgets/items_list_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  group('ItemsList Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;
    late List<TransactionItem> mockItems;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockBranch = Branch(
        id: '1',
        name: 'Main Branch',
        businessId: 1,
      );

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
      );

      mockItems = [
        TransactionItem(
          id: '1',
          name: 'Test Item 1',
          qty: 10.0,
          price: 100.0,
          discount: 0.0,
          prc: 100.0,
          quantityRequested: 10,
          quantityApproved: 5,
          branchId: '1',
          transactionId: '1',
        ),
        TransactionItem(
          id: '2',
          name: 'Test Item 2',
          qty: 8.0,
          price: 150.0,
          discount: 0.0,
          prc: 150.0,
          quantityRequested: 8,
          quantityApproved: 8,
          branchId: '1',
          transactionId: '1',
        ),
      ];

      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => mockItems);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Items'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays items after loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump(); // Trigger the async provider

      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
    });

    testWidgets('displays quantity information correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('5/10'), findsOneWidget); // Item 1: approved/requested
      expect(find.text('8/8'), findsOneWidget);  // Item 2: approved/requested
    });

    testWidgets('shows pending quantity for partially approved items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Pending: 5'), findsOneWidget); // Item 1 has 5 pending
    });

    testWidgets('shows approve button for pending items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Approve'), findsOneWidget); // Only Item 1 should have approve button
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Column), findsNWidgets(4)); // Main column + 2 item columns + 1 data column
      expect(find.byType(Card), findsNWidgets(2)); // 2 item cards
    });

    testWidgets('handles empty items list', (tester) async {
      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Items'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('handles approved request status', (tester) async {
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        branch: mockBranch,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ItemsList(request: approvedRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should not show approve buttons for approved requests
      expect(find.text('Approve'), findsNothing);
    });
  });
}