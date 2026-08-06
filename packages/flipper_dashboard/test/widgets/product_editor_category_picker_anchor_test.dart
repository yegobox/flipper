import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_category_picker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/widgets/product_editor_category_picker_anchor_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
//
// The search field is a flutter_typeahead Floater target: it anchors an
// OverlayPortal and re-shows the overlay child whenever its global offset
// changes. Under DevicePreview (an app-wide LayoutBuilder, debug builds) that
// re-mount lands inside a layout pass and throws
// '!_skipMarkNeedsLayout' from _RenderTheater._addDeferredChild.
//
// So: nothing state-dependent may sit ABOVE the field. This test pins the
// field's position across selection changes.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final cats = [
    Category(id: '1', name: 'Drinks'),
    Category(id: '2', name: 'Bread'),
  ];

  /// A real mouse click: press, let FRAMES ELAPSE while held, then release.
  ///
  /// `tester.tap` sends down+up with no frame in between, so any widget that
  /// unmounts as a *consequence* of the press is still there at release time and
  /// the tap "works" — masking exactly this class of bug.
  Future<void> clickWithMouse(WidgetTester tester, Finder finder) async {
    final gesture = await tester.startGesture(
      tester.getCenter(finder),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Widget harness(ValueNotifier<String?> selection) {
    return ProviderScope(
      overrides: [
        categoryProvider.overrideWith((ref) => Stream.value(cats)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String?>(
            valueListenable: selection,
            builder: (context, selected, _) => SingleChildScrollView(
              child: ProductEditorCategoryPicker(
                selectedCategoryId: selected,
                selectedCategoryName: selected == null
                    ? null
                    : cats.firstWhere((c) => c.id == selected).name,
                onCategoryChanged: (v) => selection.value = v,
                onAddCategory: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('clicking a result with a MOUSE', () {
    // A mouse press outside a focused TextField unfocuses it on pointer DOWN —
    // on every platform (_EditableTextTapOutsideAction unfocuses for
    // PointerDeviceKind.mouse even on mobile). If the results list is
    // focus-gated, the row under the cursor unmounts before pointer-up and the
    // click is swallowed. tester.tap defaults to a TOUCH pointer, which does not
    // reproduce it — the explicit `kind` is the whole point of these tests.
    testWidgets('selects the category', (tester) async {
      final selection = ValueNotifier<String?>(null);
      addTearDown(selection.dispose);

      await tester.pumpWidget(harness(selection));
      await tester.pumpAndSettle();

      // Click into the field with a mouse — the list opens.
      await tester.tap(
        find.byType(TextField),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
      expect(find.text('Drinks'), findsOneWidget);

      await clickWithMouse(tester, find.text('Drinks'));

      expect(selection.value, equals('1'));
      expect(find.text('Filed under'), findsOneWidget);
    });

    testWidgets('selects a typed-then-clicked result', (tester) async {
      final selection = ValueNotifier<String?>(null);
      addTearDown(selection.dispose);

      await tester.pumpWidget(harness(selection));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField), kind: PointerDeviceKind.mouse);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Bre');
      await tester.pumpAndSettle();

      await clickWithMouse(tester, find.text('Bread'));

      expect(selection.value, equals('2'));
    });
  });

  testWidgets('mounts no OverlayPortal — results are inline', (tester) async {
    final selection = ValueNotifier<String?>(null);
    addTearDown(selection.dispose);

    await tester.pumpWidget(harness(selection));
    await tester.pumpAndSettle();

    final inPicker = find.descendant(
      of: find.byType(ProductEditorCategoryPicker),
      matching: find.byType(OverlayPortal),
    );
    expect(inPicker, findsNothing);

    // Open the results and type: still no overlay.
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(inPicker, findsNothing);

    await tester.enterText(find.byType(TextField), 'Dri');
    await tester.pumpAndSettle();
    expect(find.text('Drinks'), findsOneWidget);
    expect(inPicker, findsNothing);
  });

  testWidgets('the search field does not move when the selection changes',
      (tester) async {
    final selection = ValueNotifier<String?>(null);
    addTearDown(selection.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryProvider.overrideWith((ref) => Stream.value(cats)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<String?>(
              valueListenable: selection,
              builder: (context, selected, _) => SingleChildScrollView(
                child: ProductEditorCategoryPicker(
                  selectedCategoryId: selected,
                  selectedCategoryName: selected == null
                      ? null
                      : cats.firstWhere((c) => c.id == selected).name,
                  onCategoryChanged: (v) => selection.value = v,
                  onAddCategory: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Offset fieldTopLeft() => tester.getTopLeft(find.byType(TextField));

    final unselected = fieldTopLeft();

    // Select a category.
    selection.value = '1';
    await tester.pumpAndSettle();
    expect(find.text('Filed under'), findsOneWidget);
    expect(
      fieldTopLeft(),
      equals(unselected),
      reason: 'Selecting a category moved the Floater target — anything that '
          'appears on selection must render BELOW the search field.',
    );

    // Switch to another category.
    selection.value = '2';
    await tester.pumpAndSettle();
    expect(fieldTopLeft(), equals(unselected));

    // Clear it again.
    selection.value = null;
    await tester.pumpAndSettle();
    expect(fieldTopLeft(), equals(unselected));
  });
}
