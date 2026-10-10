import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_header.dart';
import 'package:flipper_web/modules/accounting/widgets/books_brand_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required bool inFlipperApp,
  AccountingMobileTab tab = AccountingMobileTab.snapshot,
}) async {
  Widget header = const AccountingMobileHeader();
  if (inFlipperApp) {
    header = AppLauncherHost(
      onOpenLauncher: () {},
      hostProvidesHeader: true,
      child: header,
    );
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingMobileTabProvider.overrideWith((ref) => tab),
        pendingCountProvider.overrideWithValue(2),
        accountingFiscalYearLabelProvider.overrideWithValue('FY 2026'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: header),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('inside the Flipper app Snapshot shows only the entity card', (
    tester,
  ) async {
    await _pump(tester, inFlipperApp: true);

    expect(find.text('FY 2026 · RWF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    expect(find.byType(BooksBrandRow), findsNothing);
  });

  testWidgets('inside the Flipper app other tabs draw no header at all', (
    tester,
  ) async {
    await _pump(tester, inFlipperApp: true, tab: AccountingMobileTab.approvals);

    expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    expect(
      find.descendant(
        of: find.byType(AccountingMobileHeader),
        matching: find.byType(DecoratedBox),
      ),
      findsNothing,
    );
  });

  testWidgets('standalone Books keeps its brand row and bell', (tester) async {
    await _pump(tester, inFlipperApp: false);

    expect(find.byType(BooksBrandRow), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('FY 2026 · RWF'), findsOneWidget);
  });
}
