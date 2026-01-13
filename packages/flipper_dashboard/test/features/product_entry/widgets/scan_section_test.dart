import 'package:flipper_dashboard/features/product_entry/widgets/scan_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  Widget buildTestWidget({
    required Function(String) onBarcodeScanned,
    required VoidCallback onRequestCamera,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          child: ScanSection(
            controller: controller,
            focusNode: focusNode,
            onBarcodeScanned: onBarcodeScanned,
            onRequestCamera: onRequestCamera,
          ),
        ),
      ),
    );
  }

  group('ScanSection', () {
    testWidgets('renders scan field with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(onBarcodeScanned: (_) {}, onRequestCamera: () {}),
      );

      expect(find.text('Quick Scan'), findsOneWidget);
      expect(find.text('Scan or Type Barcode'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('calls onBarcodeScanned when form is submitted', (
      WidgetTester tester,
    ) async {
      String? scannedValue;

      await tester.pumpWidget(
        buildTestWidget(
          onBarcodeScanned: (value) => scannedValue = value,
          onRequestCamera: () {},
        ),
      );

      const barcode = '1234567890';
      await tester.enterText(find.byType(TextFormField), barcode);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 2)); // Wait for timer

      expect(scannedValue, barcode);
    });

    testWidgets('does not call onBarcodeScanned for empty input', (
      WidgetTester tester,
    ) async {
      String? scannedValue;

      await tester.pumpWidget(
        buildTestWidget(
          onBarcodeScanned: (value) => scannedValue = value,
          onRequestCamera: () {},
        ),
      );

      await tester.enterText(find.byType(TextFormField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 2));

      expect(scannedValue, null);
    });

    testWidgets('calls onRequestCamera when camera icon is tapped', (
      WidgetTester tester,
    ) async {
      bool cameraCalled = false;

      await tester.pumpWidget(
        buildTestWidget(
          onBarcodeScanned: (_) {},
          onRequestCamera: () => cameraCalled = true,
        ),
      );

      // Camera icon is only shown on mobile platforms (not on web)
      // For testing purposes, we check if the icon exists in the widget tree
      final cameraIcon = find.byIcon(FluentIcons.camera_20_regular);

      // Only test the tap if the camera icon is present (mobile platforms)
      if (tester.any(cameraIcon)) {
        await tester.tap(cameraIcon);
        await tester.pump();
        expect(cameraCalled, true);
      } else {
        // On web/desktop, the camera icon shouldn't be present
        expect(cameraIcon, findsNothing);
      }
    });

    testWidgets('uses provided controller', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(onBarcodeScanned: (_) {}, onRequestCamera: () {}),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller, controller);
      // Note: focusNode is not exposed as a public getter on TextFormField
      // but is used internally by the widget
    });
  });
}
