import 'package:flipper_dashboard/features/bulk_product/widgets/compact_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/bulk_product/widgets/compact_progress_dialog_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('CompactProgressDialog Tests', () {
    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing item 1',
              currentItem: 1,
              totalItems: 10,
            ),
          ),
        ),
      );

      expect(find.text('Saving items'), findsOneWidget);
    });

    testWidgets('displays progress text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing item 5',
              currentItem: 5,
              totalItems: 10,
            ),
          ),
        ),
      );

      expect(find.text('Processing item 5'), findsOneWidget);
    });

    testWidgets('calculates percentage correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing',
              currentItem: 3,
              totalItems: 10,
            ),
          ),
        ),
      );

      expect(find.text('30%'), findsOneWidget);
      expect(find.text('3 of 10'), findsOneWidget);
    });

    testWidgets('handles zero total items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'No items',
              currentItem: 0,
              totalItems: 0,
            ),
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('0 of 0'), findsOneWidget);
    });

    testWidgets('shows completion state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Completed',
              currentItem: 10,
              totalItems: 10,
            ),
          ),
        ),
      );

      expect(find.text('100%'), findsOneWidget);
      expect(find.text('10 of 10'), findsOneWidget);
    });

    testWidgets('has correct progress indicators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing',
              currentItem: 5,
              totalItems: 10,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('circular progress indicator has correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing',
              currentItem: 2,
              totalItems: 4,
            ),
          ),
        ),
      );

      final circularProgress = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(circularProgress.value, 0.5);
    });

    testWidgets('linear progress indicator has correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Processing',
              currentItem: 3,
              totalItems: 6,
            ),
          ),
        ),
      );

      final linearProgress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(linearProgress.value, 0.5);
    });

    testWidgets('shows green color when complete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Complete',
              currentItem: 5,
              totalItems: 5,
            ),
          ),
        ),
      );

      final circularProgress = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final linearProgress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(circularProgress.valueColor?.value, Colors.green);
      expect(linearProgress.valueColor?.value, Colors.green);
    });

    testWidgets('shows blue color when in progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'In progress',
              currentItem: 3,
              totalItems: 5,
            ),
          ),
        ),
      );

      final circularProgress = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      final linearProgress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(circularProgress.valueColor?.value, Colors.blue);
      expect(linearProgress.valueColor?.value, Colors.blue);
    });

    testWidgets('has correct dialog structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactProgressDialog(
              progress: 'Test',
              currentItem: 1,
              totalItems: 2,
            ),
          ),
        ),
      );

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsOneWidget);
    });
  });
}