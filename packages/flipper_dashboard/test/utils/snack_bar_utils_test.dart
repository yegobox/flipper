import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';

// flutter test test/utils/snack_bar_utils_test.dart
class TestItem {
  final String id;
  final String name;

  TestItem(this.id, this.name);
}

void main() {
  group('showCustomSnackBarUtil', () {
    testWidgets('shows snackbar without close button by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showCustomSnackBarUtil(context, 'Test message'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Test message'), findsOneWidget);
      expect(find.text('X'), findsNothing);
    });

    testWidgets('shows snackbar with close button when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showCustomSnackBarUtil(
                  context,
                  'Test message',
                  showCloseButton: true,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Test message'), findsOneWidget);
      expect(find.text('X'), findsOneWidget);

      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();

      expect(find.text('Test message'), findsNothing);
    });
  });

  group('showDeletionConfirmationSnackBar', () {
    testWidgets('shows snackbar with correct content for single item',
        (tester) async {
      bool confirmCalled = false;
      final items = [TestItem('1', 'Item 1')];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDeletionConfirmationSnackBar(
                  context,
                  items,
                  (item) => item.name,
                  () async {
                    confirmCalled = true;
                  },
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Delete 1 item?'), findsOneWidget);
      expect(find.text('• Item 1'), findsOneWidget);
      expect(find.text('DELETE'), findsOneWidget);

      await tester.tap(find.byType(SnackBarAction));
      await tester.pumpAndSettle();
      expect(confirmCalled, isTrue);
    });

    testWidgets('shows snackbar with correct content for multiple items',
        (tester) async {
      final items = [
        TestItem('1', 'Item 1'),
        TestItem('2', 'Item 2'),
        TestItem('3', 'Item 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDeletionConfirmationSnackBar(
                  context,
                  items,
                  (item) => item.name,
                  () async {},
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Delete 3 items?'), findsOneWidget);
      expect(find.text('• Item 1'), findsOneWidget);
      expect(find.text('• Item 2'), findsOneWidget);
      expect(find.text('• Item 3'), findsOneWidget);
    });

    testWidgets('shows "and X more..." for more than 3 items', (tester) async {
      final items = List.generate(5, (i) => TestItem('$i', 'Item $i'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDeletionConfirmationSnackBar(
                  context,
                  items,
                  (item) => item.name,
                  () async {},
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Delete 5 items?'), findsOneWidget);
      expect(find.text('• and 2 more...'), findsOneWidget);
    });
  });
}
