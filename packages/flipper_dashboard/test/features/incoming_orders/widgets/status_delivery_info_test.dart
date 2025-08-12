import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/incoming_orders/widgets/status_delivery_info_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('StatusDeliveryInfo Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;

    setUp(() {
      mockBranch = Branch(
        id: '1',
        name: 'Main Branch',
        businessId: 1,
      );

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        createdAt: DateTime(2024, 1, 15, 10, 30),
        branch: mockBranch,
      );
    });

    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.text('Status & Delivery'), findsOneWidget);
    });

    testWidgets('displays status information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
    });

    testWidgets('displays delivery information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.text('Requested On'), findsOneWidget);
      expect(find.text('Jan 15, 2024 10:30'), findsOneWidget);
    });

    testWidgets('shows correct status icon for pending', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.byIcon(Icons.pending), findsOneWidget);
    });

    testWidgets('shows correct status icon for approved', (tester) async {
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        createdAt: DateTime(2024, 1, 15, 10, 30),
        branch: mockBranch,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: approvedRequest),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('APPROVED'), findsOneWidget);
    });

    testWidgets('shows correct status icon for voided', (tester) async {
      final voidedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'voided',
        createdAt: DateTime(2024, 1, 15, 10, 30),
        branch: mockBranch,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: voidedRequest),
          ),
        ),
      );

      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('VOIDED'), findsOneWidget);
    });

    testWidgets('handles null status gracefully', (tester) async {
      final nullStatusRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: null,
        createdAt: DateTime(2024, 1, 15, 10, 30),
        branch: mockBranch,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: nullStatusRequest),
          ),
        ),
      );

      expect(find.text('N/A'), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
    });

    testWidgets('shows calendar icon for delivery info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('has correct container structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusDeliveryInfo(request: mockRequest),
          ),
        ),
      );

      expect(find.byType(Column), findsNWidgets(4));
      expect(find.byType(Container), findsNWidgets(3));
      expect(find.byType(Row), findsNWidgets(2));
    });
  });

  group('OrderNote Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;

    setUp(() {
      mockBranch = Branch(
        id: '1',
        name: 'Main Branch',
        businessId: 1,
      );

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        orderNote: 'Please handle with care',
        branch: mockBranch,
      );
    });

    testWidgets('displays order note title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderNote(request: mockRequest),
          ),
        ),
      );

      expect(find.text('Order Note'), findsOneWidget);
    });

    testWidgets('displays order note content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderNote(request: mockRequest),
          ),
        ),
      );

      expect(find.text('Please handle with care'), findsOneWidget);
    });

    testWidgets('handles null order note', (tester) async {
      final nullNoteRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        orderNote: null,
        branch: mockBranch,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderNote(request: nullNoteRequest),
          ),
        ),
      );

      expect(find.text('Order Note'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderNote(request: mockRequest),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}