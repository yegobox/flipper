import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_models/SyncStrategy.dart';
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

  tearDownAll(() async {
    await env.dispose();
  });

  group('ItemsList Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;
    late List<TransactionItem> mockItems;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      // Mock the getStrategy method to return the mockDbSync
      when(
        () => env.mockSyncStrategy.getStrategy(Strategy.capella),
      ).thenReturn(env.mockDbSync);

      mockBranch = Branch(id: '1', name: 'Main Branch', businessId: "1");

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
      );

      mockItems = [
        TransactionItem(
          id: '1',
          ttCatCd: "TT",
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
          ttCatCd: "TT",
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

      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => mockItems);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ITEMS'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      when(
        () => env.mockSyncStrategy.getStrategy(Strategy.capella),
      ).thenReturn(env.mockDbSync);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays items after loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
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
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      // mockRequest is still pending, and a pending request now shows only the
      // requested quantity -- the approved-vs-requested split would be
      // meaningless before anyone has approved anything. findRichText is
      // required because the line is a Text.rich of label + value spans.
      expect(find.text('Requested: 10', findRichText: true), findsOneWidget);
      expect(find.text('Requested: 8', findRichText: true), findsOneWidget);
      expect(find.text('Approved: 5/10', findRichText: true), findsNothing);
    });

    testWidgets('shows the approved split once the request is approved', (
      tester,
    ) async {
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        branch: mockBranch,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: approvedRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Approved: 5/10', findRichText: true), findsOneWidget);
      expect(find.text('Approved: 8/8', findRichText: true), findsOneWidget);
    });

    testWidgets('shows pending quantity for partially approved items', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      // "Pending: N" was removed in the redesign. What a partially approved
      // request shows is the approved-vs-requested split, which carries the
      // same information (10 requested, 5 approved => 5 outstanding).
      expect(find.text('Requested: 10', findRichText: true), findsOneWidget);
    });

    testWidgets('offers no row-level approve action', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      // The per-item Approve button was removed in the redesign: approval is
      // now a request-level action, not a row-level one. This widget's only
      // row action is Update, and only for an editable outgoing request, so a
      // plain incoming pending request should offer neither.
      expect(find.text('Approve'), findsNothing);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.text('Update'), findsNothing);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ITEMS'), findsOneWidget);
      // Rows are Containers with OmTokens borders now, not Material Cards.
      // Assert one row per item by its name, which is what the list is for
      // and does not re-break the next time the surface widget changes.
      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
    });

    testWidgets('handles empty items list', (tester) async {
      when(
        () => env.mockSyncStrategy.getStrategy(Strategy.capella),
      ).thenReturn(env.mockDbSync);
      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('ITEMS'), findsOneWidget);
      // Empty list: the heading stands alone, with no item rows under it.
      expect(find.text('Test Item 1'), findsNothing);
      expect(find.text('Test Item 2'), findsNothing);
    });

    testWidgets('handles approved request status', (tester) async {
      when(
        () => env.mockSyncStrategy.getStrategy(Strategy.capella),
      ).thenReturn(env.mockDbSync);
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        branch: mockBranch,
      );

      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => mockItems);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ItemsList(request: approvedRequest)),
          ),
        ),
      );

      await tester.pump();

      // Should not show approve buttons for approved requests
      expect(find.text('Approve'), findsNothing);
    });
  });
}
