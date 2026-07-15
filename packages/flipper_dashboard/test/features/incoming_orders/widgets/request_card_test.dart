import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
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

  tearDownAll(() async {
    await env.dispose();
  });

  group('RequestCard Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;
    late Branch mockIncomingBranch;
    late List<TransactionItem> mockItems;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockBranch = Branch(id: '1', name: 'Source Branch', businessId: '1');

      mockIncomingBranch = Branch(
        id: '2',
        name: 'Incoming Branch',
        businessId: '1',
      );

      mockItems = [
        TransactionItem(
          id: '1',
          ttCatCd: 'TT',
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
        itemCounts: 1,
        transactionItems: mockItems,
        orderNote: 'Test order note',
        subBranchId: '1',
        mainBranchId: '2',
      );

      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => mockItems);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('renders accordion panel without Material ExpansionTile',
        (tester) async {
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

      expect(find.byType(RequestCard), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNothing);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Request From Source Branch'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('expands to show content when header tapped', (tester) async {
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

      expect(find.text('ITEMS'), findsNothing);

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text('ITEMS'), findsOneWidget);
      expect(find.text('STATUS & DELIVERY'), findsOneWidget);
      expect(find.text('Test order note'), findsOneWidget);
    });

    testWidgets('uses handoff panel radius and surface', (tester) async {
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

      final panel = tester.widget<Container>(find.byType(Container).first);
      final decoration = panel.decoration as BoxDecoration?;
      expect(decoration?.color, OmTokens.surface);
      expect(
        (decoration?.borderRadius as BorderRadius?)?.topLeft.x,
        OmTokens.radiusLg,
      );
    });

    testWidgets('omits order note when empty', (tester) async {
      final requestWithoutNote = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
        itemCounts: 1,
        transactionItems: mockItems,
        subBranchId: '1',
        mainBranchId: '2',
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
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text('Test order note'), findsNothing);
      expect(find.text('ORDER NOTE'), findsNothing);
    });
  });
}
