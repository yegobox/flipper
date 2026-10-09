import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/widgets/analytics_gauge/flipper_analytic.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_app_bar_leading.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_hit_area.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_press_button.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_states.dart';
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
      // Ink decorations are clipped to their Material's rectangle; the New
      // sale glow drawn as Ink showed up as a pale box around the button.
      expect(
        find.descendant(
          of: find.byType(DashboardMobileBottomNav),
          matching: find.byType(Ink),
        ),
        findsNothing,
      );
    });
  }

  testWidgets('small icon controls get a 48dp touch target', (tester) async {
    usePhone(tester);
    var taps = 0;
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        Row(
          children: [
            MposPressButton(
              semanticLabel: 'Back',
              onPressed: () => taps++,
              child: const SizedBox(width: 40, height: 40),
            ),
            MposHitArea(
              semanticLabel: 'Close',
              onTap: () => taps++,
              child: const SizedBox(width: 34, height: 34),
            ),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byType(MposPressButton)), const Size(48, 48));
    expect(tester.getSize(find.byType(MposHitArea)), const Size(48, 48));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // A tap in the margin outside the drawn 34dp circle still lands.
    final hit = tester.getTopLeft(find.byType(MposHitArea));
    await tester.tapAt(hit + const Offset(2, 2));
    await tester.tap(find.byType(MposPressButton));
    expect(taps, 2);
    handle.dispose();
  });

  testWidgets('header has a 48dp menu button that opens the drawer', (
    tester,
  ) async {
    usePhone(tester);
    var opened = 0;
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        Align(
          alignment: Alignment.topLeft,
          child: DashboardMobileAppBarLeading(onOpenDrawer: () => opened++),
        ),
      ),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await tester.tap(find.byType(IconButton));
    expect(opened, 1);
    handle.dispose();
  });

  testWidgets('error state offers a working retry, not the raw error', (
    tester,
  ) async {
    usePhone(tester);
    var retries = 0;
    await tester.pumpWidget(
      host(Center(child: MposErrorState(onRetry: () => retries++))),
    );
    expect(find.text("Couldn't load this"), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retries, 1);

    await tester.pumpWidget(
      host(MposErrorState(compact: true, onRetry: () => retries++)),
    );
    await tester.tap(find.text('Retry'));
    expect(retries, 2);
  });

  testWidgets('skeletons lay out at phone width, with and without motion', (
    tester,
  ) async {
    usePhone(tester);
    for (final reduceMotion in [false, true]) {
      await tester.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(disableAnimations: reduceMotion),
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  MposSkeletonCard(height: 290, lines: 4),
                  MposSkeletonList(rows: 3),
                ],
              ),
            ),
          ),
        ),
      );
      // The shimmer loops forever, so pump a frame rather than settle.
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(MposSkeletonCard)).height,
        moreOrLessEquals(290),
      );
    }
  });

  test('refresh helper completes even when the reload fails', () async {
    await mposAwaitRefresh(Future<Object?>.error(StateError('offline')));
    await mposAwaitRefresh(Future<Object?>.value(1));
  });
}
