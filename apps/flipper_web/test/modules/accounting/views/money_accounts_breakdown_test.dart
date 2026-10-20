import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/views/desktop/dashboard_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/other_desktop_views.dart';
import 'package:flipper_web/modules/accounting/views/mobile/mobile_views.dart';
import 'package:flipper_web/modules/accounting/widgets/money_accounts_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/books_overview_fixtures.dart';

/// Large, negative and empty on purpose: the widest text each layout must fit.
const _balances = [
  (code: '1010', bal: 12345678),
  (code: '1030', bal: -5000),
  (code: '1020', bal: 0),
];
const _total = 12340678;

/// The real width, not `setSurfaceSize` (which leaves the view at 800×600).
void _useSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingLiquidBalancesProvider.overrideWithValue(_balances),
        accountingCashBankTotalProvider.overrideWithValue(_total),
        accountingAccountsProvider.overrideWithValue(fixtureAccounts),
        accountingJournalProvider.overrideWithValue(fixtureJournal),
        accountingIncomeStatementProvider.overrideWithValue(fixturePl),
        accountingTrendProvider.overrideWithValue(fixtureTrend),
        accountingArAgingProvider.overrideWithValue(const <AgingRow>[]),
        accountingApAgingProvider.overrideWithValue(const <AgingRow>[]),
        accountingPeriodLabelProvider.overrideWithValue('Oct 2026'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingLoadingProvider.overrideWithValue(false),
        ...overrides,
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _inBreakdown(String text) => find.descendant(
  of: find.byType(MoneyAccountsBreakdown),
  matching: find.text(text),
);

/// Every account label and amount is in the breakdown, coloured by sign.
void _expectBreakdown(WidgetTester tester) {
  for (final label in ['Cash', 'Mobile money', 'Bank']) {
    expect(_inBreakdown(label), findsOneWidget, reason: label);
  }
  Color? color(String amount) =>
      tester.widget<Text>(_inBreakdown(amount)).style?.color;
  expect(color('12,345,678'), AccountingTokens.ink1);
  expect(color('(5,000)'), AccountingTokens.lossInk);
  expect(color('0'), AccountingTokens.ink3);
}

void main() {
  group('desktop dashboard "Cash & bank" card', () {
    // 2 columns, the narrowest 4-column grid, and a wide screen.
    for (final width in [860.0, 960.0, 1440.0]) {
      testWidgets('shows cash, mobile money and bank at ${width.toInt()}px', (
        tester,
      ) async {
        _useSize(tester, Size(width, 2000));
        // Other dashboard cards (the expense donut legend) overflow under
        // the test font, which is wider than real fonts. Only errors raised
        // by the card this change touches fail the test.
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) => errors.add(details.toString());
        await _pump(
          tester,
          AccountingDashboardView(onNewEntry: () {}, onRecordExpense: () {}),
        );
        FlutterError.onError = previous;

        expect(
          errors.where(
            (e) =>
                e.contains('money_accounts_breakdown.dart') ||
                e.contains('accounting_kpi_card.dart'),
          ),
          isEmpty,
        );
        expect(find.byType(MoneyAccountsBreakdown), findsOneWidget);
        _expectBreakdown(tester);
        // The total is unchanged, and the old "across 3 accounts" is gone.
        expect(
          find.textContaining('12,340,678', findRichText: true),
          findsOneWidget,
        );
        expect(find.textContaining('across'), findsNothing);
      });
    }
  });

  // Narrower than any card the 4-column grid lays out (~180px of content).
  testWidgets('card rows fit a 150px card', (tester) async {
    _useSize(tester, const Size(400, 300));
    await _pump(
      tester,
      const Center(
        child: SizedBox(
          width: 150,
          child: MoneyAccountsBreakdown(balances: _balances),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    _expectBreakdown(tester);
  });

  group('mobile snapshot', () {
    // 480px: the narrowest width at which the existing hero card's header
    // fits the test font (every glyph is 1em wide). Real phones are covered
    // by the strip tests below, at the strip's own width.
    testWidgets('strip sits under the KPI grid', (tester) async {
      _useSize(tester, const Size(480, 1400));
      await _pump(
        tester,
        const AccountingSnapshotTab(),
        overrides: [
          pendingCountProvider.overrideWithValue(0),
          accountingInventoryValueProvider.overrideWith((ref) async => 0),
        ],
      );

      expect(tester.takeException(), isNull);
      final strip = find.byKey(const Key('books-money-accounts-strip'));
      expect(strip, findsOneWidget);
      _expectBreakdown(tester);
      // The 2×2 grid is untouched: its "Cash & bank" tile is still there.
      expect(find.text('Cash & bank'), findsOneWidget);
      expect(
        tester.getTopLeft(strip).dy,
        greaterThan(tester.getBottomLeft(find.text('Payable')).dy),
      );
    });

    // Inner width of the strip on a 320px and a 360px phone: screen minus
    // the list's 16px and the strip's 14px padding on each side.
    for (final width in [260.0, 300.0]) {
      testWidgets('columns fit ${width.toInt()}px with amounts level', (
        tester,
      ) async {
        _useSize(tester, const Size(400, 300));
        await _pump(
          tester,
          Center(
            child: SizedBox(
              width: width,
              child: const MoneyAccountsBreakdown(
                balances: _balances,
                layout: MoneyAccountsLayout.columns,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        _expectBreakdown(tester);
        final bottoms = {
          for (final amount in ['12,345,678', '(5,000)', '0'])
            tester.getBottomLeft(_inBreakdown(amount)).dy,
        };
        expect(bottoms, hasLength(1));
      });
    }
  });

  group('balance sheet', () {
    testWidgets('desktop lists the money accounts under Total assets', (
      tester,
    ) async {
      _useSize(tester, const Size(1200, 1400));
      await _pump(
        tester,
        const AccountingFinancialStatementsView(),
        overrides: [
          statementsTabProvider.overrideWith((ref) => StatementsTab.balance),
        ],
      );

      expect(tester.takeException(), isNull);
      final assets = tester.getTopLeft(find.text('Total assets')).dy;
      final liabilities = tester.getTopLeft(find.text('Total liabilities')).dy;
      for (final (label, amount) in [
        ('Cash', '12,345,678'),
        ('Mobile money', '(5,000)'),
        ('Bank', '0'),
      ]) {
        final y = tester.getTopLeft(find.text(label)).dy;
        expect(y, greaterThan(assets), reason: label);
        expect(y, lessThan(liabilities), reason: label);
        expect(find.text(amount), findsWidgets);
      }
    });

    testWidgets('mobile lists the money accounts under Total assets', (
      tester,
    ) async {
      _useSize(tester, const Size(360, 780));
      await _pump(
        tester,
        AccountingStatementDetail(report: MobileReportKey.bs, onBack: () {}),
        overrides: [accountingVatProvider.overrideWithValue(null)],
      );

      expect(tester.takeException(), isNull);
      final assets = tester.getTopLeft(find.text('Total assets')).dy;
      final liabilities = tester.getTopLeft(find.text('Total liabilities')).dy;
      for (final label in ['Cash', 'Mobile money', 'Bank']) {
        final y = tester.getTopLeft(find.text(label)).dy;
        expect(y, greaterThan(assets), reason: label);
        expect(y, lessThan(liabilities), reason: label);
      }
    });
  });
}
