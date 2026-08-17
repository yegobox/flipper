import 'package:flipper_hr/features/branding/hr_brand_panel.dart';
import 'package:flipper_web/core/branding/brand_panel_builder.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The panel is only ever rendered on desktop widths (>= 920px), so give it a
/// desktop-sized surface rather than the 800x600 test default.
Future<void> _pumpPanel(WidgetTester tester, Widget panel) async {
  tester.view.physicalSize = const Size(1440, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: SizedBox(width: 720, child: panel))),
  );
  // Cards float on a repeating controller — pumpAndSettle would never settle.
  await tester.pump();
}

void main() {
  group('HrBrandPanel', () {
    testWidgets('renders HR copy, not Books copy', (tester) async {
      await _pumpPanel(tester, const HrBrandPanel());

      expect(find.text('FLIPPER HR'), findsOneWidget);
      expect(
        find.text('Your team, your time, your people — all in one place.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Attendance, payroll, and leave are ready the moment you sign in.',
        ),
        findsOneWidget,
      );
      expect(find.text('FLIPPER BUSINESS OS'), findsNothing);
    });

    testWidgets('renders HR stats and floating cards', (tester) async {
      await _pumpPanel(tester, const HrBrandPanel());

      expect(find.text('3,200+'), findsOneWidget);
      expect(find.text('employees managed'), findsOneWidget);
      expect(find.text('RWF 480M'), findsOneWidget);
      expect(find.text('99.9%'), findsOneWidget);

      // Payroll / hiring / attendance — Books' revenue, sale and sales-streak
      // cards must not leak through.
      expect(find.text('Payroll · this month'), findsOneWidget);
      expect(find.text('RWF 18.2M'), findsOneWidget);
      expect(find.text('New hire'), findsOneWidget);
      expect(find.text('Amina K. · Sales'), findsOneWidget);
      expect(find.text('45 days'), findsOneWidget);
      expect(find.text('Attendance streak'), findsOneWidget);
      expect(find.text('Sales streak'), findsNothing);
      expect(find.text('New sale'), findsNothing);
    });
  });

  group('BrandPanel resolution', () {
    tearDown(() => brandPanelBuilder = null);

    testWidgets('falls back to Books panel when no host registers one', (
      tester,
    ) async {
      brandPanelBuilder = null;

      // Resolve without laying Books' panel out: its mini cards overflow under
      // the test font, which says nothing about the resolution being tested.
      late final Widget resolved;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            resolved = const BrandPanel().build(context);
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolved, isA<WebBrandPanel>());
    });

    testWidgets('renders the HR panel once main() registers it', (
      tester,
    ) async {
      brandPanelBuilder = (_) => const HrBrandPanel();
      await _pumpPanel(tester, const BrandPanel());

      expect(find.byType(HrBrandPanel), findsOneWidget);
      expect(find.byType(WebBrandPanel), findsNothing);
    });
  });
}
