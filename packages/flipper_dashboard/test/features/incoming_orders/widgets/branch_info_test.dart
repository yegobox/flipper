import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// flutter test test/features/incoming_orders/widgets/branch_info_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('BranchInfo Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockActiveBranch;
    late Branch mockSourceBranch;
    late Branch mockMainBranch;

    setUp(() {
      mockSourceBranch = Branch(
        id: '2',
        name: 'Requester Branch',
        businessId: '1',
        longitude: 0.0,
        latitude: 0.0,
        location: 'Downtown',
        isDefault: true,
      );

      mockMainBranch = Branch(
        id: '1',
        name: 'Fulfiller Branch',
        businessId: '1',
        longitude: 0.0,
        latitude: 0.0,
        location: 'Midtown',
        isDefault: false,
      );

      mockRequest = InventoryRequest(
        id: '1',
        mainBranchId: '1',
        subBranchId: '2',
        branchId: '2',
        deliveryDate: DateTime.now(),
        deliveryNote: 'Test delivery',
        createdAt: DateTime.now(),
        branch: mockSourceBranch,
      );

      mockActiveBranch = Branch(
        id: '1',
        name: 'Active Store',
        businessId: '1',
        longitude: 0.0,
        latitude: 0.0,
        location: 'Uptown',
        isDefault: false,
      );
    });

    Future<void> pumpBranchInfo(
      WidgetTester tester, {
      required InventoryRequest request,
      required Branch activeBranch,
      bool isIncoming = true,
      Branch? fromBranch,
      Branch? toBranch,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            branchByIdProvider(branchId: request.subBranchId).overrideWith(
              (ref) => Stream.value(fromBranch ?? request.branch),
            ),
            if (request.mainBranchId != null)
              branchByIdProvider(branchId: request.mainBranchId).overrideWith(
                (ref) => Stream.value(toBranch ?? mockMainBranch),
              ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: BranchInfo(
                request: request,
                activeBranch: activeBranch,
                isIncoming: isIncoming,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('incoming shows requester → active branch', (tester) async {
      await pumpBranchInfo(
        tester,
        request: mockRequest,
        activeBranch: mockActiveBranch,
        fromBranch: mockSourceBranch,
      );

      expect(find.textContaining('From:'), findsOneWidget);
      expect(find.textContaining('Requester Branch'), findsOneWidget);
      expect(find.textContaining('To:'), findsOneWidget);
      expect(find.textContaining('Active Store'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
    });

    testWidgets('outgoing shows active → fulfiller branch', (tester) async {
      await pumpBranchInfo(
        tester,
        request: mockRequest,
        activeBranch: mockActiveBranch,
        isIncoming: false,
        toBranch: mockMainBranch,
      );

      expect(find.textContaining('Active Store'), findsOneWidget);
      expect(find.textContaining('Fulfiller Branch'), findsOneWidget);
    });

    testWidgets('uses handoff accent on swap icon', (tester) async {
      await pumpBranchInfo(
        tester,
        request: mockRequest,
        activeBranch: mockActiveBranch,
        fromBranch: mockSourceBranch,
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.swap_horiz));
      expect(icon.color, OmTokens.accentStrong);
      expect(icon.size, 17);
    });

    testWidgets('handles null branch name gracefully', (tester) async {
      final requestWithNullBranch = InventoryRequest(
        id: '1',
        mainBranchId: '1',
        subBranchId: '2',
        branchId: '2',
        deliveryDate: DateTime.now(),
        deliveryNote: 'Test delivery',
        createdAt: DateTime.now(),
        branch: null,
      );

      await pumpBranchInfo(
        tester,
        request: requestWithNullBranch,
        activeBranch: mockActiveBranch,
        fromBranch: null,
      );

      expect(find.textContaining('From:'), findsOneWidget);
      expect(find.textContaining('Active Store'), findsOneWidget);
    });
  });
}
