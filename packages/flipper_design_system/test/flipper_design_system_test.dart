import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

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
          body: FlipperButton(text: 'Save', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
  });

  group('CustomAppBar leading', () {
    Future<void> pump(WidgetTester tester, CLOSEBUTTON closeButton) =>
        tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: CustomAppBar(
                title: 'My money',
                closeButton: closeButton,
                onPop: () {},
              ),
            ),
          ),
        );

    testWidgets('NONE leaves the title with no button', (tester) async {
      await pump(tester, CLOSEBUTTON.NONE);
      expect(find.text('My money'), findsOneWidget);
      expect(find.byType(AppBarRoundIconButton), findsNothing);
      // The title starts on the 16dp page gutter.
      expect(tester.getTopLeft(find.text('My money')).dx, 16);
    });

    testWidgets('ICON still shows the round button', (tester) async {
      await pump(tester, CLOSEBUTTON.ICON);
      expect(find.byType(AppBarRoundIconButton), findsOneWidget);
    });
  });
}
