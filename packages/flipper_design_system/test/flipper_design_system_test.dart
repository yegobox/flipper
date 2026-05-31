import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlipperColors uses cyan brand primary', () {
    expect(FlipperColors.primary, const Color(0xFF00C2E8));
    expect(kcPrimaryColor, FlipperColors.primary);
  });

  testWidgets('FlipperTheme registers FlipperThemeExtension', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FlipperTheme.light(),
        home: Builder(
          builder: (context) {
            final extension = FlipperThemeExtension.of(context);
            expect(extension.borderColor, FlipperColors.border);
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('FlipperButton renders label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FlipperTheme.light(),
        home: Scaffold(
          body: FlipperButton(
            text: 'Save',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
  });
}
