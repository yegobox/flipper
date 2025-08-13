import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_helpers/setup.dart';
// flutter test test/features/incoming_orders/widgets/request_card_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  group('RequestCard Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;
    late Branch mockIncomingBranch;
    late List<TransactionItem> mockItems;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockBranch = Branch(
        id: '1',
        name: 'Source Branch',
        businessId: 1,
      );

      mockIncomingBranch = Branch(
        id: '2',
        name: 'Incoming Branch',
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
      ];

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 10.0,
        transactionItems: mockItems,
        orderNote: 'Test order note',
      );

      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => mockItems);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays as expansion tile', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestCard(
                request: mockRequest,
                incomingBranch: mockIncomingBranch,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    testWidgets('shows request header in title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestCard(
                request: mockRequest,
                incomingBranch: mockIncomingBranch,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('Request From Source Branch'), findsOneWidget);
    });

    testWidgets('expands to show content when tapped', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RequestCard(
                  request: mockRequest,
                  incomingBranch: mockIncomingBranch,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Initially collapsed
      expect(find.text('Items'), findsNothing);

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Should now show content
      expect(find.text('Items'), findsOneWidget);
    });

    testWidgets('shows all child widgets when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RequestCard(
                  request: mockRequest,
                  incomingBranch: mockIncomingBranch,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Expand the tile
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Check for child widgets
      expect(find.text('Items'), findsOneWidget); // ItemsList
      expect(find.textContaining('Source Branch'), findsAtLeastNWidgets(1)); // BranchInfo + RequestHeader
      expect(find.text('Test order note'), findsOneWidget); // OrderNote
    });

    testWidgets('has correct card styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestCard(
                request: mockRequest,
                incomingBranch: mockIncomingBranch,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
      expect(card.shadowColor, Colors.black26);
      expect(card.margin, EdgeInsets.only(bottom: 16.0));
    });

    testWidgets('handles request without order note', (tester) async {
      final requestWithoutNote = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 10.0,
        transactionItems: mockItems,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RequestCard(
                  request: requestWithoutNote,
                  incomingBranch: mockIncomingBranch,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Expand the tile
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Should not show order note
      expect(find.text('Test order note'), findsNothing);
    });

    testWidgets('handles empty order note', (tester) async {
      final requestWithEmptyNote = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 10.0,
        transactionItems: mockItems,
        orderNote: '',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RequestCard(
                  request: requestWithEmptyNote,
                  incomingBranch: mockIncomingBranch,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Expand the tile
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Should not show order note section
      expect(find.text('Test order note'), findsNothing);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: RequestCard(
                request: mockRequest,
                incomingBranch: mockIncomingBranch,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Theme), findsAtLeastNWidgets(1));
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    testWidgets('shows content container when expanded', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: RequestCard(
                  request: mockRequest,
                  incomingBranch: mockIncomingBranch,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Expand the tile
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Should show the content container with decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasDecoratedContainer = containers.any(
        (container) => container.decoration != null,
      );
      
      expect(hasDecoratedContainer, isTrue);
    });
  });
}