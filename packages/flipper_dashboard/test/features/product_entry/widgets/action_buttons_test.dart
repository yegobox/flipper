import 'package:flipper_dashboard/features/product_entry/widgets/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    required VoidCallback onSave,
    required VoidCallback onClose,
    bool isSaving = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ActionButtons(
          onSave: onSave,
          onClose: onClose,
          isSaving: isSaving,
        ),
      ),
    );
  }

  group('ActionButtons', () {
    testWidgets('renders Save and Close buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(onSave: () {}, onClose: () {}));

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('calls onSave when Save button is tapped', (
      WidgetTester tester,
    ) async {
      bool saveCalled = false;

      await tester.pumpWidget(
        buildTestWidget(onSave: () => saveCalled = true, onClose: () {}),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(saveCalled, true);
    });

    testWidgets('calls onClose when Close button is tapped', (
      WidgetTester tester,
    ) async {
      bool closeCalled = false;

      await tester.pumpWidget(
        buildTestWidget(onSave: () {}, onClose: () => closeCalled = true),
      );

      await tester.tap(find.text('Close'));
      await tester.pump();

      expect(closeCalled, true);
    });

    testWidgets('shows spinner when isSaving is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(onSave: () {}, onClose: () {}, isSaving: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
    });

    testWidgets('disables buttons when isSaving is true', (
      WidgetTester tester,
    ) async {
      bool saveCalled = false;
      bool closeCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          onSave: () => saveCalled = true,
          onClose: () => closeCalled = true,
          isSaving: true,
        ),
      );

      final saveButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final closeButton = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      expect(saveButton.onPressed, null);
      expect(closeButton.onPressed, null);
    });

    testWidgets('enables buttons when isSaving is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(onSave: () {}, onClose: () {}, isSaving: false),
      );

      final saveButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final closeButton = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      expect(saveButton.onPressed, isNotNull);
      expect(closeButton.onPressed, isNotNull);
    });
  });
}
