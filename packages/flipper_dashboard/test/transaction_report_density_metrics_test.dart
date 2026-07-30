import 'package:flipper_dashboard/features/transaction_reports/transaction_report_density.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure sizing rules for Transaction Reports density. Kept apart from the
/// widget test so it runs without the package's service-layer dependencies.
void main() {
  group('ReportMetrics.forHeight', () {
    test('tiers by body height', () {
      expect(ReportMetrics.forHeight(1000).density, ReportDensity.comfortable);
      expect(ReportMetrics.forHeight(880).density, ReportDensity.cozy);
      expect(ReportMetrics.forHeight(640).density, ReportDensity.compact);
    });

    test('scaled-up text counts as a shorter screen', () {
      // 900 logical px is comfortable at 1.0, but only 720 px of usable room
      // once every label is drawn 25% larger.
      expect(ReportMetrics.forHeight(900).density, ReportDensity.comfortable);
      expect(
        ReportMetrics.forHeight(900, textScale: 1.25).density,
        ReportDensity.compact,
      );
    });

    test('falls back to legacy sizing for unbounded height', () {
      expect(
        ReportMetrics.forHeight(double.infinity),
        same(ReportMetrics.comfortable),
      );
    });

    test('compact keeps chrome cheaper than comfortable everywhere', () {
      const compact = ReportMetrics.compact;
      const roomy = ReportMetrics.comfortable;
      expect(compact.gridRowHeight, lessThan(roomy.gridRowHeight));
      expect(compact.gridHeaderRowHeight, lessThan(roomy.gridHeaderRowHeight));
      expect(compact.kpiBarHeight, lessThan(roomy.kpiBarHeight));
      expect(compact.sectionGap, lessThan(roomy.sectionGap));
      expect(compact.appBarHeight, lessThan(roomy.appBarHeight));
      expect(roomy.appBarMulti, 1.0);
    });
  });
}
