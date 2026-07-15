import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_header.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

RequestHeader _header(
  InventoryRequest request, {
  bool isIncoming = true,
  bool expanded = false,
  VoidCallback? onToggle,
}) {
  return RequestHeader(
    request: request,
    isIncoming: isIncoming,
    expanded: expanded,
    onToggle: onToggle ?? () {},
  );
}

// flutter test test/features/incoming_orders/widgets/request_header_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('RequestHeader Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;
    late List<TransactionItem> mockItems;

    setUp(() {
      mockBranch = Branch(id: '1', name: 'Main Branch', businessId: '1');

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
        TransactionItem(
          id: '2',
          ttCatCd: 'TT',
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
        itemCounts: 2,
        transactionItems: mockItems,
      );
    });

    Future<void> pumpHeader(
      WidgetTester tester,
      InventoryRequest request, {
      bool isIncoming = true,
      bool expanded = false,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: _header(
                request,
                isIncoming: isIncoming,
                expanded: expanded,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('displays branch name correctly', (tester) async {
      await pumpHeader(tester, mockRequest);

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Request From Main Branch'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows box icon instead of copy', (tester) async {
      await pumpHeader(tester, mockRequest);

      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsNothing);
    });

    testWidgets('displays approved/requested count for incoming',
        (tester) async {
      await pumpHeader(tester, mockRequest);

      // 5+8 approved / 10+8 requested
      expect(find.textContaining('13/18'), findsOneWidget);
    });

    testWidgets('outgoing pending shows requested total only', (tester) async {
      await pumpHeader(tester, mockRequest, isIncoming: false);

      expect(find.textContaining('18 Item'), findsOneWidget);
      expect(find.textContaining('13/18'), findsNothing);
    });

    testWidgets('expand chevron reflects expanded state', (tester) async {
      await pumpHeader(tester, mockRequest, expanded: true);

      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      final materials = tester.widgetList<Material>(find.byType(Material));
      expect(
        materials.any((m) => m.color == OmTokens.accentWash),
        isTrue,
      );
    });

    testWidgets('handles null branch name', (tester) async {
      final requestWithoutBranch = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        itemCounts: 18.0,
      );

      await pumpHeader(tester, requestWithoutBranch);

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Request From Unknown'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('calls onToggle when chevron tapped', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: _header(
                mockRequest,
                onToggle: () => toggled = true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();

      expect(toggled, isTrue);
    });
  });
}
