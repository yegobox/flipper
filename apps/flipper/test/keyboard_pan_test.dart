import 'package:flipper_rw/keyboard_pan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('keyboardPanShift', () {
    test('a field above the keyboard does not move', () {
      expect(
        keyboardPanShift(const Rect.fromLTRB(0, 100, 200, 140), 500),
        0,
      );
    });

    test('a covered field slides up to clear the keyboard plus margin', () {
      expect(
        keyboardPanShift(const Rect.fromLTRB(0, 700, 200, 740), 500),
        740 + 16 - 500,
      );
    });

    test('a field just above the keyboard still gets its margin', () {
      expect(
        keyboardPanShift(
          const Rect.fromLTRB(0, 450, 200, 490),
          500,
          margin: 20,
        ),
        10,
      );
    });

    test('never slides the field top off the screen', () {
      expect(
        keyboardPanShift(const Rect.fromLTRB(0, 60, 200, 900), 300),
        60,
      );
    });
  });

  group('KeyboardPan', () {
    late ValueNotifier<Rect?> occlusion;

    setUp(() => occlusion = ValueNotifier<Rect?>(null));
    tearDown(() => occlusion.dispose());

    Future<FocusNode> pumpBottomField(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              KeyboardPan(occlusion: occlusion, child: child!),
          home: Scaffold(
            body: Column(
              children: [
                const Spacer(),
                TextField(focusNode: focus),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
      return focus;
    }

    double slide(WidgetTester tester) {
      final transform = tester.widget<Transform>(
        find
            .descendant(
              of: find.byType(KeyboardPan),
              matching: find.byType(Transform),
            )
            .first,
      );
      return transform.transform.getTranslation().y;
    }

    testWidgets('slides a covered field above the keyboard and back',
        (tester) async {
      final focus = await pumpBottomField(tester);
      final fieldBottom = tester.getRect(find.byType(EditableText)).bottom;

      focus.requestFocus();
      occlusion.value = const Rect.fromLTRB(0, 500, 1000, 800);
      await tester.pumpAndSettle();
      expect(slide(tester), closeTo(-(fieldBottom + 16 - 500), 0.5));

      occlusion.value = null;
      await tester.pumpAndSettle();
      expect(slide(tester), 0);
    });

    testWidgets('does not move when nothing is focused', (tester) async {
      await pumpBottomField(tester);

      occlusion.value = const Rect.fromLTRB(0, 500, 1000, 800);
      await tester.pumpAndSettle();
      expect(slide(tester), 0);
    });

    testWidgets('does not move for a field the keyboard does not cover',
        (tester) async {
      final focus = await pumpBottomField(tester);

      focus.requestFocus();
      // A keyboard band below the field, e.g. a short floating keyboard.
      occlusion.value = const Rect.fromLTRB(0, 1200, 1000, 1400);
      await tester.pumpAndSettle();
      expect(slide(tester), 0);
    });
  });
}
