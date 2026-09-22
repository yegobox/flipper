import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
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
      mockBranch = Branch(id: '1', name: 'Main Branch', businessId: '1');

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
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      expect(find.text('STATUS & DELIVERY'), findsOneWidget);
    });

    testWidgets('displays status information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
    });

    testWidgets('displays delivery information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      expect(find.text('Requested On'), findsOneWidget);
      expect(find.text('Jan 15, 2024 10:30'), findsOneWidget);
    });

    testWidgets('shows correct status icon for pending', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      // The redesign uses one neutral glyph for every status and carries the
      // meaning in colour, so the icon no longer varies. Assert the colour too,
      // or this test would pass for any status at all.
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('PENDING')).style?.color,
        OmTokens.amber,
      );
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
          home: Scaffold(body: StatusDeliveryInfo(request: approvedRequest)),
        ),
      );

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.text('APPROVED'), findsOneWidget);
      // Approved is the only branch that renders green; this is what actually
      // distinguishes it now that every status shares one icon.
      expect(
        tester.widget<Text>(find.text('APPROVED')).style?.color,
        OmTokens.greenStrong,
      );
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
          home: Scaffold(body: StatusDeliveryInfo(request: voidedRequest)),
        ),
      );

      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.text('VOIDED'), findsOneWidget);
      // Voided is not in the approved set, so it takes the amber treatment.
      expect(
        tester.widget<Text>(find.text('VOIDED')).style?.color,
        OmTokens.amber,
      );
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
          home: Scaffold(body: StatusDeliveryInfo(request: nullStatusRequest)),
        ),
      );

      // A missing status now defaults to RequestStatus.pending rather than
      // rendering "N/A", so the tile stays meaningful instead of showing a gap.
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('shows calendar icon for delivery info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('has correct container structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
        ),
      );

      // Previously a census of Column/Container/Row instances, which broke on
      // the redesign for no useful reason and would break again on the next
      // layout tweak. What the component actually promises is a heading and
      // two labelled meta tiles, each with its own glyph and value -- assert
      // that instead, so this fails when something is genuinely missing.
      expect(find.text('STATUS & DELIVERY'), findsOneWidget);

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);

      expect(find.text('Requested On'), findsOneWidget);
      expect(find.text('Jan 15, 2024 10:30'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('lays the tiles out side by side only when there is room', (
      tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.devicePixelRatio = 1.0;

      Future<void> pumpAt(double width) async {
        // setSurfaceSize is a no-op here; the view's physicalSize is what the
        // LayoutBuilder actually sees.
        tester.view.physicalSize = Size(width, 600);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: StatusDeliveryInfo(request: mockRequest)),
          ),
        );
        await tester.pump();
      }

      // Assert the observable geometry rather than widget types: each tile
      // carries its own inner Expanded, so counting them measures the tile's
      // internals instead of the layout being tested.
      await pumpAt(600);
      var status = tester.getTopLeft(find.text('Status'));
      var requested = tester.getTopLeft(find.text('Requested On'));
      expect(status.dy, requested.dy,
          reason: 'wide: the two tiles should sit on the same line');
      expect(status.dx, lessThan(requested.dx),
          reason: 'wide: Status should be the left-hand tile');

      await pumpAt(320);
      status = tester.getTopLeft(find.text('Status'));
      requested = tester.getTopLeft(find.text('Requested On'));
      expect(status.dy, lessThan(requested.dy),
          reason: 'narrow: the tiles should stack instead of being squeezed');
      expect(status.dx, requested.dx,
          reason: 'narrow: stacked tiles share a left edge');
    });
  });

  group('OrderNote Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;

    setUp(() {
      mockBranch = Branch(id: '1', name: 'Main Branch', businessId: "1");

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
          home: Scaffold(body: OrderNote(request: mockRequest)),
        ),
      );

      expect(find.text('ORDER NOTE'), findsOneWidget);
    });

    testWidgets('displays order note content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderNote(request: mockRequest)),
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
          home: Scaffold(body: OrderNote(request: nullNoteRequest)),
        ),
      );

      expect(find.text('ORDER NOTE'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderNote(request: mockRequest)),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
