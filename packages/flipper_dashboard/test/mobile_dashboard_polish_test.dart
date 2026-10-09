import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Phone-width layout guards for the mobile dashboard. `setSurfaceSize` is a
/// no-op for these, so the view itself is sized to a 360dp-wide phone.
void main() {
  void usePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget host(Widget child, {double textScale = 1, Locale? locale}) {
    return ProviderScope(
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: MediaQuery.withClampedTextScaling(
          minScaleFactor: textScale,
          maxScaleFactor: textScale,
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  Widget gauge({int? delta, double value = 123456789}) => Padding(
    padding: const EdgeInsets.all(16),
    child: DashboardHomeGauge(
      value: value,
      revenue: value * 2,
      grossProfit: value,
      deductions: value / 3,
      profitType: 'Net Profit',
      periodLabel: 'This Week',
      currencyCode: 'RWF',
      isEmpty: false,
      deltaPercent: delta,
      comparisonLabel: 'last week',
    ),
  );

  for (final scale in [1.0, 1.3]) {
    testWidgets('gauge fits 9-digit amounts at text scale $scale', (
      tester,
    ) async {
      usePhone(tester);
      await tester.pumpWidget(host(gauge(delta: 12), textScale: scale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a falling gauge delta is shown in loss colours', (tester) async {
    usePhone(tester);
    await tester.pumpWidget(host(gauge(delta: -18)));
    await tester.pumpAndSettle();

    final chip = tester.widget<Container>(
      find
          .ancestor(
            of: find.byIcon(Icons.arrow_downward),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = chip.decoration! as BoxDecoration;
    expect(decoration.color, MposTokens.lossTint);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.arrow_downward)).color,
      MposTokens.lossInk,
    );
  });

  testWidgets('a rising gauge delta stays in gain colours', (tester) async {
    usePhone(tester);
    await tester.pumpWidget(host(gauge(delta: 18)));
    await tester.pumpAndSettle();

    final chip = tester.widget<Container>(
      find
          .ancestor(
            of: find.byIcon(Icons.arrow_upward),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((chip.decoration! as BoxDecoration).color, MposTokens.gainTint);
  });

  for (final locale in const [Locale('en'), Locale('rw')]) {
    testWidgets('bottom nav labels stay on one line (${locale.languageCode})', (
      tester,
    ) async {
      usePhone(tester);
      await tester.pumpWidget(
        host(
          Align(
            alignment: Alignment.bottomCenter,
            child: DashboardMobileBottomNav(
              activeTab: DashboardMobileTab.home,
              onTabSelected: (_) {},
            ),
          ),
          textScale: 1.3,
          locale: locale,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
