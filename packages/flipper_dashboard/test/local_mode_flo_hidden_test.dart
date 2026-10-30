import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/dashboard_mobile_bottom_nav.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Local mode has no Flo: its tab and tiles disappear. With the flag off the
/// bottom bar must be unchanged.
void main() {
  tearDown(() => LocalMode.debugSet(false));

  Future<void> pumpNav(WidgetTester tester) => tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          bottomNavigationBar: DashboardMobileBottomNav(
            activeTab: DashboardMobileTab.home,
            onTabSelected: (_) {},
          ),
        ),
      ),
    ),
  );

  testWidgets('full sync keeps the Flo tab', (tester) async {
    LocalMode.debugSet(false);
    await pumpNav(tester);
    await tester.pumpAndSettle();
    expect(find.text('Ask Flo'), findsOneWidget);
  });

  testWidgets('local mode drops the Flo tab', (tester) async {
    LocalMode.debugSet(true);
    await pumpNav(tester);
    await tester.pumpAndSettle();
    expect(find.text('Ask Flo'), findsNothing);
    expect(find.text('Books'), findsOneWidget);
  });

  testWidgets('hiddenInLocalMode only hides Flo, HR and Credits', (
    tester,
  ) async {
    final seen = <String, bool>{};
    Future<void> collect() => tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            for (final page in ['Chat', 'HR', 'Credits', 'POS', 'Cashbook']) {
              seen[page] = hiddenInLocalMode(ref, page);
            }
            return const SizedBox();
          },
        ),
      ),
    );

    LocalMode.debugSet(false);
    await collect();
    expect(seen.values, everyElement(isFalse));

    LocalMode.debugSet(true);
    await collect();
    await tester.pump();
    expect(seen, {
      'Chat': true,
      'HR': true,
      'Credits': true,
      'POS': false,
      'Cashbook': false,
    });
  });
}
