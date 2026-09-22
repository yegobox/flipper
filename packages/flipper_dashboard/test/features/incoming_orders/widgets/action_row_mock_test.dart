import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
import 'package:flipper_dashboard/features/incoming_orders/providers/incoming_orders_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_helpers/setup.dart';

// flutter test test/features/incoming_orders/widgets/action_row_mock_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() async {
    await env.dispose();
  });

  group('ActionRow Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockBranch = Branch(id: '1', name: 'Main Branch', businessId: "1");

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
      );

      // Mock the transactionItemsProvider
      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => []);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionItemsProvider(mockRequest.id).overrideWithValue(AsyncValue.data([])),
          ],
          child: MaterialApp(
            home: Scaffold(body: ActionRow(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Void'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('has correct button structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionItemsProvider(mockRequest.id).overrideWithValue(AsyncValue.data([])),
          ],
          child: MaterialApp(
            home: Scaffold(body: ActionRow(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Row), findsAtLeastNWidgets(3));
      expect(find.byType(Material), findsAtLeastNWidgets(4)); // Scaffold + 3 actions
      expect(find.byType(InkWell), findsNWidgets(3));
      expect(find.text('Produce'), findsOneWidget);
    });

    testWidgets('buttons are aligned to the end', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionItemsProvider(mockRequest.id).overrideWithValue(AsyncValue.data([])),
          ],
          child: MaterialApp(
            home: Scaffold(body: ActionRow(request: mockRequest)),
          ),
        ),
      );

      await tester.pump();

      // The action bar is responsive: below OmTokens.compactBreakpoint (880)
      // the buttons stretch to fill the width, and only above it are they
      // right-aligned. The default 800x600 test surface is BELOW that
      // breakpoint, which is why asserting end-alignment unconditionally
      // stopped holding. Check both sides of the rule instead.
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.devicePixelRatio = 1.0;

      final endAligned = find.byWidgetPredicate(
        (w) => w is Row && w.mainAxisAlignment == MainAxisAlignment.end,
      );

      tester.view.physicalSize = const Size(1000, 600);
      await tester.pump();
      expect(endAligned, findsOneWidget,
          reason: 'wide: actions should sit to the right');

      tester.view.physicalSize = const Size(600, 600);
      await tester.pump();
      expect(endAligned, findsNothing,
          reason: 'narrow: actions stretch to fill instead of bunching right');
    });

    testWidgets('renders no footer for an approved request', (tester) async {
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        branch: mockBranch,
      );

      when(
        () => env.mockDbSync.transactionItems(requestId: '1'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionItemsProvider(approvedRequest.id).overrideWithValue(AsyncValue.data([])),
          ],
          child: MaterialApp(
            home: Scaffold(body: ActionRow(request: approvedRequest)),
          ),
        ),
      );

      await tester.pump();

      // An approved request is history: it has no actionable footer at all
      // ("Approved history / non-actionable: no footer", handoff section 6).
      // The widget returns SizedBox.shrink() before it builds any buttons.
      expect(find.text('Approve'), findsNothing);
      expect(find.text('Void'), findsNothing);
      expect(find.text('Produce'), findsNothing);
    });

    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionItemsProvider(mockRequest.id).overrideWithValue(AsyncValue.loading()),
          ],
          child: MaterialApp(
            home: Scaffold(body: ActionRow(request: mockRequest)),
          ),
        ),
      );

      // Check loading state - should show disabled buttons
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Void'), findsOneWidget);
    });
  });
}
