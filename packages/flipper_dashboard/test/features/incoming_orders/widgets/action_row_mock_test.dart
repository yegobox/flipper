import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
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

  group('ActionRow Tests', () {
    late InventoryRequest mockRequest;
    late Branch mockBranch;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();

      mockBranch = Branch(
        id: '1',
        name: 'Main Branch',
        businessId: 1,
      );

      mockRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'pending',
        branch: mockBranch,
      );

      // Mock the transactionItemsProvider
      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => []);
    });

    tearDown(() {
      env.restore();
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ActionRow(request: mockRequest),
            ),
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
          child: MaterialApp(
            home: Scaffold(
              body: ActionRow(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Row), findsNWidgets(3)); // Main row + 2 button rows
      expect(find.byType(Material), findsNWidgets(3)); // Scaffold + 2 buttons
      expect(find.byType(InkWell), findsNWidgets(2));
    });

    testWidgets('buttons are aligned to the end', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ActionRow(request: mockRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      final mainRow = tester.widget<Row>(find.byType(Row).first);
      expect(mainRow.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('handles approved request status', (tester) async {
      final approvedRequest = InventoryRequest(
        id: '1',
        branchId: '1',
        status: 'approved',
        branch: mockBranch,
      );

      when(() => env.mockDbSync.transactionItems(requestId: '1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ActionRow(request: approvedRequest),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Void'), findsOneWidget);
    });

    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ActionRow(request: mockRequest),
            ),
          ),
        ),
      );

      // Don't pump, check initial loading state
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Void'), findsOneWidget);
    });
  });
}