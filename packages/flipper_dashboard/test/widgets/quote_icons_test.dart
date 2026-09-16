import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every quotation-card icon, so a malformed path is caught here rather than
/// rendering as an empty box on the front desk. Nothing about an SVG string is
/// checked at compile time.
const _quoteIcons = <String, String>{
  'quoteDocument': AdminDashboardSvgs.quoteDocument,
  'quoteEdit': AdminDashboardSvgs.quoteEdit,
  'quoteCheck': AdminDashboardSvgs.quoteCheck,
  'quoteCheckCircle': AdminDashboardSvgs.quoteCheckCircle,
  'quoteTrash': AdminDashboardSvgs.quoteTrash,
  'quoteSend': AdminDashboardSvgs.quoteSend,
  'quoteDownload': AdminDashboardSvgs.quoteDownload,
  'quotePrint': AdminDashboardSvgs.quotePrint,
  'quoteDraft': AdminDashboardSvgs.quoteDraft,
  'quoteCalendar': AdminDashboardSvgs.quoteCalendar,
  'quoteMoon': AdminDashboardSvgs.quoteMoon,
  'quoteBed': AdminDashboardSvgs.quoteBed,
  'quoteClock': AdminDashboardSvgs.quoteClock,
  'quoteChevronDown': AdminDashboardSvgs.quoteChevronDown,
  'quoteAlert': AdminDashboardSvgs.quoteAlert,
  'quoteRemoveCircle': AdminDashboardSvgs.quoteRemoveCircle,
};

void main() {
  group('quotation icon set', () {
    _quoteIcons.forEach((name, svg) {
      testWidgets('$name renders', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AdminDashboardSvgs.tinted(
                  svg,
                  color: const Color(0xFF101828),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$name failed to parse');
      });
    });

    test('every icon uses currentColor so tinted() can colour it', () {
      // A baked-in stroke colour would ignore the tint and render, say, a
      // black icon inside the blue Accept button.
      _quoteIcons.forEach((name, svg) {
        expect(
          svg.contains('stroke="currentColor"'),
          isTrue,
          reason: '$name does not use currentColor',
        );
      });
    });

    test('every icon shares the 24x24 grid and stroke weight', () {
      _quoteIcons.forEach((name, svg) {
        expect(svg.contains('viewBox="0 0 24 24"'), isTrue, reason: name);
        expect(svg.contains('stroke-width="1.85"'), isTrue, reason: name);
      });
    });
  });
}
