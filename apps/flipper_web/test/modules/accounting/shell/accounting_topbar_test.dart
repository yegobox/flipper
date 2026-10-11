import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, {VoidCallback? onOpenLauncher}) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  Widget topbar = const AccountingTopbar();
  if (onOpenLauncher != null) {
    topbar = AppLauncherHost(onOpenLauncher: onOpenLauncher, child: topbar);
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingPeriodLabelProvider.overrideWithValue('Oct 2026'),
        pendingCountProvider.overrideWithValue(0),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: topbar),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('inside the native app the Apps button opens the host launcher', (
    tester,
  ) async {
    var opened = 0;
    await _pump(tester, onOpenLauncher: () => opened++);

    await tester.tap(find.byKey(const Key('books-topbar-apps')));
    await tester.pumpAndSettle();

    expect(opened, 1);
    // The web sheet must not open on top of the host's.
    expect(find.text('Quick Sell'), findsNothing);
  });

  testWidgets('on the web the Apps button opens the apps sheet with POS', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.byKey(const Key('books-topbar-apps')));
    await tester.pumpAndSettle();

    expect(find.text('Quick Sell'), findsOneWidget);
  });
}
