import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_category_picker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/widgets/product_editor_category_picker_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testCategories = [
    Category(id: '1', name: 'Drinks'),
    Category(id: '2', name: 'Bread'),
  ];

  Future<void> pumpPicker(
    WidgetTester tester, {
    String? selectedCategoryId,
    String? selectedCategoryName,
    ValueChanged<String?>? onCategoryChanged,
    VoidCallback? onAddCategory,
    Future<void> Function(String? initialName)? onCreateCategory,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryProvider.overrideWith((ref) => Stream.value(testCategories)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProductEditorCategoryPicker(
                selectedCategoryId: selectedCategoryId,
                selectedCategoryName: selectedCategoryName,
                onCategoryChanged: onCategoryChanged ?? (_) {},
                onAddCategory: onAddCategory ?? () {},
                onCreateCategory: onCreateCategory,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ProductEditorCategoryPicker', () {
    testWidgets('prompts for a category and offers existing ones when nothing '
        'is selected', (tester) async {
      await pumpPicker(tester);

      expect(
        find.text('No category chosen yet — search above or create a new one.'),
        findsOneWidget,
      );
      expect(find.text('Or pick one of yours'), findsOneWidget);
      expect(find.text('Drinks'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);
    });

    testWidgets('names the selected category and can clear it', (tester) async {
      String? changed;
      var changedCalled = false;

      await pumpPicker(
        tester,
        selectedCategoryId: '1',
        selectedCategoryName: 'Drinks',
        onCategoryChanged: (value) {
          changed = value;
          changedCalled = true;
        },
      );

      expect(find.text('Filed under'), findsOneWidget);
      expect(find.text('Drinks'), findsOneWidget);
      // The chip row stays available, relabelled as a switch.
      expect(find.text('Switch to'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(changedCalled, isTrue);
      expect(changed, isNull);
    });

    testWidgets('tapping a quick-pick chip selects that category',
        (tester) async {
      String? changed;

      await pumpPicker(tester, onCategoryChanged: (value) => changed = value);

      await tester.tap(find.text('Bread'));
      await tester.pumpAndSettle();

      expect(changed, equals('2'));
    });

    testWidgets('the New button starts the create flow', (tester) async {
      String? requestedName;
      var createCalled = false;

      await pumpPicker(
        tester,
        onCreateCategory: (initialName) async {
          requestedName = initialName;
          createCalled = true;
        },
      );

      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();

      expect(createCalled, isTrue);
      expect(requestedName, isNull);
    });

    testWidgets('falls back to onAddCategory when no create handler is given',
        (tester) async {
      var addCalled = false;

      await pumpPicker(tester, onAddCategory: () => addCalled = true);

      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();

      expect(addCalled, isTrue);
    });

    testWidgets('offers to create the typed name when nothing matches',
        (tester) async {
      String? requestedName;

      await pumpPicker(
        tester,
        onCreateCategory: (initialName) async => requestedName = initialName,
      );

      final searchField = find.byType(TextField);
      await tester.tap(searchField);
      await tester.enterText(searchField, 'Airtime');
      await tester.pumpAndSettle();

      expect(find.text('Nothing matches "Airtime"'), findsOneWidget);

      await tester.tap(find.text('Create "Airtime"'));
      await tester.pumpAndSettle();

      expect(requestedName, equals('Airtime'));
    });
  });
}
