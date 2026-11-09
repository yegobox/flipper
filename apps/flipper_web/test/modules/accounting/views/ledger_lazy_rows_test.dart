import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/views/desktop/journal_view.dart';
import 'package:flipper_web/modules/accounting/views/desktop/other_desktop_views.dart';
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
        accountingLoadingProvider.overrideWithValue(false),
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
}
