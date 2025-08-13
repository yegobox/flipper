import 'package:flipper_dashboard/features/incoming_orders/widgets/request_header.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_helpers/setup.dart';
// flutter test test/features/incoming_orders/widgets/request_header_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  group('RequestHeader Tests', () {
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

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 18.0,
        transactionItems: mockItems,
      );

      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => mockItems);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays branch name correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('Request From Main Branch'), findsOneWidget);
    });

    testWidgets('displays item count in title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('(2 items)'), findsOneWidget);
    });

    testWidgets('shows copy icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('displays approved/requested count', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('13/18'), findsOneWidget); // 5+8 approved / 10+8 requested
    });

    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      expect(find.textContaining('0/18'), findsOneWidget);
    });

    testWidgets('handles single item correctly', (tester) async {
      final singleItemRequest = InventoryRequest(
        id: '2',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 1.0,
        transactionItems: [mockItems.first],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: singleItemRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('(1 items)'), findsOneWidget);
      expect(find.textContaining('Item'), findsOneWidget); // Should show "Item" not "Items"
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Row), findsNWidgets(2)); // Main row + inner row
      expect(find.byType(Material), findsNWidgets(2)); // Scaffold material + Copy button material
      expect(find.byType(InkWell), findsOneWidget); // Copy button inkwell
      expect(find.byType(Container), findsOneWidget); // Item count container
    });

    testWidgets('handles null branch name', (tester) async {
      final requestWithoutBranch = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        itemCounts: 18.0,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: requestWithoutBranch),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('Request From null'), findsOneWidget);
    });

    testWidgets('copy button is tappable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestHeader(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      final copyButton = find.byIcon(Icons.copy);
      expect(copyButton, findsOneWidget);
      
      await tester.tap(copyButton);
      await tester.pump();
      
      // Should not throw any errors
    });
  });
}