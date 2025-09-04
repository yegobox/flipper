import 'package:flipper_dashboard/SearchableCategoryDropdown.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers/setup.dart';
// flutter test test/widgets/searchable_category_dropdown_test.dart  --no-test-assets --dart-define=FLUTTER_TEST_ENV=true

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;
  final testCategories = [
    Category(id: '1', name: 'Electronics'),
    Category(id: '2', name: 'Clothing'),
    Category(id: '3', name: 'Food & Beverages'),
  ];

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
  });

  tearDown(() {
    env.restore();
  });

  Future<void> pumpWidget(
    WidgetTester tester, {
    String? selectedValue,
    required ValueChanged<String?> onChanged,
    VoidCallback? onAdd,
    bool isEnabled = true,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryProvider.overrideWith((ref) => Stream.value(testCategories)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SearchableCategoryDropdown(
              selectedValue: selectedValue,
              onChanged: onChanged,
              onAdd: onAdd,
              isEnabled: isEnabled,
            ),
          ),
        ),
      ),
    );
  }

  group('SearchableCategoryDropdown Widget Tests', () {
    testWidgets('should render with correct label and hint text', (WidgetTester tester) async {
      String? changedValue;
      
      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              (widget.text as TextSpan).toPlainText().contains('Category')),
          findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              (widget.text as TextSpan).toPlainText().contains('*')),
          findsOneWidget);
      expect(find.text('Search categories...'), findsOneWidget);
    });

    testWidgets('should show add button when onAdd is provided', (WidgetTester tester) async {
      bool addPressed = false;
      String? changedValue;

      await pumpWidget(
        tester,
        onChanged: (value) => changedValue = value,
        onAdd: () => addPressed = true,
      );
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add_circle_outline);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      expect(addPressed, isTrue);
    });

    testWidgets('should not show add button when onAdd is null', (WidgetTester tester) async {
      String? changedValue;

      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    });

    testWidgets('should show suggestions when typing', (WidgetTester tester) async {
      String? changedValue;

      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.enterText(textField, 'Elec');
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Clothing'), findsNothing);
      expect(find.text('Food & Beverages'), findsNothing);
    });

    testWidgets('should call onChanged when suggestion is selected', (WidgetTester tester) async {
      String? changedValue;

      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.enterText(textField, 'Elec');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Electronics'));
      await tester.pumpAndSettle();

      expect(changedValue, equals('1'));
    });

    testWidgets('should show all categories when field is empty', (WidgetTester tester) async {
      String? changedValue;

      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Food & Beverages'), findsOneWidget);
    });

    testWidgets('should disable add button when widget is disabled', (WidgetTester tester) async {
      bool addPressed = false;
      String? changedValue;

      await pumpWidget(
        tester,
        onChanged: (value) => changedValue = value,
        onAdd: () => addPressed = true,
        isEnabled: false,
      );
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add_circle_outline);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      expect(addPressed, isFalse);
    });

    testWidgets('should show empty message when no categories match search', (WidgetTester tester) async {
      String? changedValue;

      await pumpWidget(tester, onChanged: (value) => changedValue = value);
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.enterText(textField, 'NonExistent');
      await tester.pumpAndSettle();

      expect(find.text('No categories found'), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryProvider.overrideWith((ref) => Stream.empty()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SearchableCategoryDropdown(
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // Should show no suggestions when loading
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('should handle error state', (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryProvider.overrideWith((ref) => Stream.error('Error')),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SearchableCategoryDropdown(
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textField = find.byType(TextFormField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // Should show no suggestions when error
      expect(find.byType(ListTile), findsNothing);
    });
  });
}