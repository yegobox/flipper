import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/views/desktop/journal_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/other_desktop_views.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/accounting_unit_test_overrides.dart';

const _cash = Account(
  code: '1010',
  name: 'Cash on Hand',
  type: AccountType.asset,
  sub: 'Current assets',
  normal: AccountNormal.debit,
  bal: 0,
);
const _bank = Account(
  code: '1020',
  name: 'Bank',
  type: AccountType.asset,
  sub: 'Current assets',
  normal: AccountNormal.debit,
  bal: 0,
);
const _sales = Account(
  code: '4010',
  name: 'Sales Revenue',
  type: AccountType.income,
  sub: 'Revenue',
  normal: AccountNormal.credit,
  bal: 0,
);

/// [count] posted cash sales of 100 each, newest first as the journal
/// streams emit them; entry `i` is `Sale · i`, so `Sale · 0` is the oldest.
List<JournalEntry> _journal(int count) => [
  for (var i = count - 1; i >= 0; i--)
    JournalEntry(
      id: 'JE-$i',
      date: 'Nov 1',
      memo: 'Sale · $i',
      ref: 'R$i',
      status: JournalStatus.posted,
      src: 'POS',
      lines: const [
        JournalLine(ac: '1010', dr: 100),
        JournalLine(ac: '4010', cr: 100),
      ],
    ),
];

Future<void> _pump(
  WidgetTester tester,
  Widget view, {
  required List<JournalEntry> journal,
  String code = '1010',
  bool loading = false,
}) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final total = journal.length * 100;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...accountingUnitTestOverrides(),
        accountingJournalProvider.overrideWithValue(journal),
        accountingAccountsProvider.overrideWithValue([
          Account(
            code: _cash.code,
            name: _cash.name,
            type: _cash.type,
            sub: _cash.sub,
            normal: _cash.normal,
            bal: total,
          ),
          Account(
            code: _sales.code,
            name: _sales.name,
            type: _sales.type,
            sub: _sales.sub,
            normal: _sales.normal,
            bal: total,
          ),
          _bank,
        ]),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingLoadingProvider.overrideWithValue(loading),
        ledgerAccountCodeProvider.overrideWith((ref) => code),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: view),
      ),
    ),
  );
  await tester.pump();
}

int _rowsBuilt() => find.textContaining('Sale · ').evaluate().length;

ProviderContainer _container(WidgetTester tester, Type view) =>
    ProviderScope.containerOf(tester.element(find.byType(view)));

void main() {
  group('General ledger', () {
    testWidgets('builds only the rows on screen', (tester) async {
      await _pump(
        tester,
        const AccountingGeneralLedgerView(),
        journal: _journal(5000),
      );

      expect(_rowsBuilt(), inInclusiveRange(1, 100));
      // Oldest first, opening at zero.
      expect(find.text('Sale · 0'), findsOneWidget);
      expect(find.text(money(100)), findsWidgets);
      expect(find.textContaining(money(500000)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrolls to the last posting, which lands on the closing '
        'balance', (tester) async {
      await _pump(
        tester,
        const AccountingGeneralLedgerView(),
        journal: _journal(2000),
      );

      await tester.scrollUntilVisible(
        find.text('Sale · 1999'),
        3000,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 200,
      );

      expect(find.text('Sale · 1999'), findsOneWidget);
      expect(find.text(money(200000)), findsWidgets);
      expect(_rowsBuilt(), lessThan(100));
      expect(tester.takeException(), isNull);
    });

    testWidgets('an account with no postings shows an empty card', (
      tester,
    ) async {
      await _pump(
        tester,
        const AccountingGeneralLedgerView(),
        journal: _journal(10),
        code: '1020',
      );

      expect(_rowsBuilt(), 0);
      expect(find.text('Bank'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('picking another account shows its postings', (tester) async {
      await _pump(
        tester,
        const AccountingGeneralLedgerView(),
        journal: _journal(3),
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('4010 · Sales Revenue').last);
      await tester.pumpAndSettle();

      final container = _container(tester, AccountingGeneralLedgerView);
      expect(container.read(ledgerAccountCodeProvider), '4010');
      expect(_rowsBuilt(), 3);
      expect(tester.takeException(), isNull);
    });

    test('postings follow the selected account', () {
      final container = ProviderContainer(
        overrides: [
          accountingJournalProvider.overrideWithValue(_journal(3)),
          accountingAccountsProvider.overrideWithValue([_cash, _sales]),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(generalLedgerPostingsProvider), isEmpty);
      container.read(ledgerAccountCodeProvider.notifier).state = '4010';
      final postings = container.read(generalLedgerPostingsProvider);
      expect(postings.map((p) => p.memo), ['Sale · 0', 'Sale · 1', 'Sale · 2']);
      expect(postings.last.balance, _sales.bal);
    });
  });

  group('Journal', () {
    testWidgets('builds only the entries on screen', (tester) async {
      await _pump(
        tester,
        AccountingJournalView(onNewEntry: () {}, onRecordExpense: () {}),
        journal: _journal(3000),
      );

      expect(_rowsBuilt(), inInclusiveRange(1, 100));
      // Newest first, as the stream emits.
      expect(find.text('Sale · 2999'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.scrollUntilVisible(
        find.text('Sale · 0'),
        3000,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 300,
      );
      expect(find.text('Sale · 0'), findsOneWidget);
    });

    testWidgets('the header filters by status and source', (tester) async {
      final journal = [
        ..._journal(3),
        const JournalEntry(
          id: 'JE-M',
          date: 'Nov 2',
          memo: 'Manual · rent',
          ref: 'M1',
          status: JournalStatus.pending,
          src: 'Manual',
          lines: [
            JournalLine(ac: '1010', cr: 50),
            JournalLine(ac: '4010', dr: 50),
          ],
        ),
      ];
      await _pump(
        tester,
        AccountingJournalView(onNewEntry: () {}, onRecordExpense: () {}),
        journal: journal,
        loading: true,
      );
      final l10n = tester
          .element(find.byType(AccountingJournalView))
          .flipperL10n;
      final container = _container(tester, AccountingJournalView);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text(l10n.booksEntriesAwaitingApproval(1)), findsOneWidget);

      // Status chips.
      await tester.tap(find.text('${l10n.booksFilterPending} (1)'));
      await tester.pump();
      expect(container.read(journalFilterProvider), JournalFilter.pending);
      expect(_rowsBuilt(), 0);
      expect(find.text('Manual · rent'), findsOneWidget);

      // Source menu. The progress bar never settles, so pump a while.
      await tester.tap(find.text(l10n.booksFilter));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(l10n.booksAllSources), findsOneWidget);
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      // All sources must carry a non-null value: PopupMenuButton treats a
      // null result as a dismissal and never calls onSelected.
      expect(
        tester
            .widgetList<PopupMenuItem<String>>(
              find.byType(PopupMenuItem<String>),
            )
            .first
            .value,
        '',
      );
      // A tap on the open menu's item misses its hit test here, so choose
      // through the button's own callback.
      final menu = tester.widget<PopupMenuButton<String>>(
        find.byType(PopupMenuButton<String>),
      );
      menu.onSelected!('POS');
      await tester.pump();
      expect(container.read(journalSourceFilterProvider), 'POS');
      expect(find.text('Manual · rent'), findsNothing);

      // All sources clears the filter and the excluded entry returns.
      menu.onSelected!('');
      await tester.pump();
      expect(container.read(journalSourceFilterProvider), isNull);
      expect(find.text('Manual · rent'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an empty journal still says nothing matches', (tester) async {
      await _pump(
        tester,
        AccountingJournalView(onNewEntry: () {}, onRecordExpense: () {}),
        journal: const [],
      );

      final l10n = tester
          .element(find.byType(AccountingJournalView))
          .flipperL10n;
      expect(find.text(l10n.booksNoEntriesMatchFilter), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('a loading button shows a spinner', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AccountingButton(label: 'Save', primary: true, isLoading: true),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });
}
