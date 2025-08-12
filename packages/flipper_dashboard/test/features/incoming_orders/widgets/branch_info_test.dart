import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/incoming_orders/widgets/branch_info_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('BranchInfo Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockIncomingBranch;
    late Branch mockSourceBranch;

    setUp(() {
      mockSourceBranch = Branch(
        id: '1',
        name: 'Main Branch',
        businessId: 1,
        longitude: '0.0',
        latitude: '0.0',
        location: 'Downtown',
        isDefault: true,
      );

      mockRequest = InventoryRequest(
        id: '1',
        mainBranchId: 1,
        subBranchId: 2,
        branchId: '1',
        deliveryDate: DateTime.now(),
        deliveryNote: 'Test delivery',
        createdAt: DateTime.now(),
        branch: mockSourceBranch,
      );

      mockIncomingBranch = Branch(
        id: '2',
        name: 'Sub Branch',
        businessId: 1,
        longitude: '0.0',
        latitude: '0.0',
        location: 'Uptown',
        isDefault: false,
      );
    });

    testWidgets('displays branch names correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      expect(find.text('From: '), findsOneWidget);
      expect(find.text('Main Branch'), findsOneWidget);
      expect(find.text('To: '), findsOneWidget);
      expect(find.text('Sub Branch'), findsOneWidget);
    });

    testWidgets('displays swap icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
    });

    testWidgets('has correct container structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsNWidgets(2));
      expect(find.byType(Row), findsNWidgets(3));
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('applies correct text colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      final fromBranchText = tester.widget<Text>(find.text('Main Branch'));
      final toBranchText = tester.widget<Text>(find.text('Sub Branch'));

      expect(fromBranchText.style?.color, Colors.green[700]);
      expect(toBranchText.style?.color, Colors.blue[700]);
    });

    testWidgets('handles null branch name gracefully', (tester) async {
      final requestWithNullBranch = InventoryRequest(
        id: '1',
        mainBranchId: 1,
        subBranchId: 2,
        branchId: '1',
        deliveryDate: DateTime.now(),
        deliveryNote: 'Test delivery',
        createdAt: DateTime.now(),
        branch: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: requestWithNullBranch,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      expect(find.text('null'), findsOneWidget);
      expect(find.text('Sub Branch'), findsOneWidget);
    });

    testWidgets('icon has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.swap_horiz));
      expect(icon.color, Colors.blue[700]);
      expect(icon.size, 24);
    });

    testWidgets('label text has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      final fromLabel = tester.widget<Text>(find.text('From: '));
      final toLabel = tester.widget<Text>(find.text('To: '));

      expect(fromLabel.style?.fontSize, 14);
      expect(fromLabel.style?.fontWeight, FontWeight.w500);
      expect(toLabel.style?.fontSize, 14);
      expect(toLabel.style?.fontWeight, FontWeight.w500);
    });

    testWidgets('branch name text has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BranchInfo(
              request: mockRequest,
              incomingBranch: mockIncomingBranch,
            ),
          ),
        ),
      );

      final fromBranch = tester.widget<Text>(find.text('Main Branch'));
      final toBranch = tester.widget<Text>(find.text('Sub Branch'));

      expect(fromBranch.style?.fontSize, 14);
      expect(fromBranch.style?.fontWeight, FontWeight.w600);
      expect(toBranch.style?.fontSize, 14);
      expect(toBranch.style?.fontWeight, FontWeight.w600);
    });
  });
}