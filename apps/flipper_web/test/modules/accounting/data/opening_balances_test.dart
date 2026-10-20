import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/accounting_unit_test_overrides.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

JournalEntry _je(
  String uuid,
  List<JournalLine> lines, {
  JournalStatus status = JournalStatus.posted,
  String? number,
}) => JournalEntry(
  id: number ?? 'JE-$uuid',
  uuid: uuid,
  date: '',
  memo: uuid,
  ref: uuid,
  status: status,
  src: 'POS',
  lines: lines,
);

/// Owner puts 100,000 cash in (Dr 1010 / Cr 3010).
JournalEntry _cashIn(String uuid) => _je(uuid, const [
  JournalLine(ac: '1010', dr: 100000),
  JournalLine(ac: '3010', cr: 100000),
]);

/// A 20,000 cash sale (Dr 1010 / Cr 4010).
JournalEntry _sale(String uuid) => _je(uuid, const [
  JournalLine(ac: '1010', dr: 20000),
  JournalLine(ac: '4010', cr: 20000),
]);

/// A 15,000 rent paid in cash (Dr 6000 / Cr 1010).
JournalEntry _cashOut(String uuid) => _je(uuid, const [
  JournalLine(ac: '6000', dr: 15000),
  JournalLine(ac: '1010', cr: 15000),
]);

int _bal(List<Account> accounts, String code) =>
    accounts.firstWhere((a) => a.code == code).bal;

/// Honours the date range like the real repositories: entries without a date
/// pass every range.
class _DatedLedger extends FakeAccountingLedgerRepository {
  _DatedLedger(this._dated, {this.undated = const []})
    : super(entries: [..._dated.keys, ...undated]);

  final Map<JournalEntry, DateTime> _dated;
  final List<JournalEntry> undated;

  @override
  Stream<List<JournalEntry>> watchJournalEntries({
    required String businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    bool inRange(DateTime d) =>
        (startDate == null || !d.isBefore(startDate)) &&
        (endDate == null || !d.isAfter(endDate));
    return Stream.value([
      for (final MapEntry(key: e, value: d) in _dated.entries)
        if (inRange(d)) e,
      ...undated,
    ]);
  }
}

void main() {
  group('openingBalances', () {
    test('balance-sheet accounts carry, profit goes to Retained Earnings', () {
      final opening = openingBalances(defaultChartOfAccountsSeed, [
        _cashIn('a'),
        _sale('b'),
      ]);
      expect(opening['1010'], 120000);
      expect(opening['3010'], 100000);
      expect(opening['3020'], 20000);
      expect(opening.containsKey('4010'), isFalse);
    });

    test('pending entries and unknown accounts carry nothing', () {
      final opening = openingBalances(defaultChartOfAccountsSeed, [
        _je('p', const [
          JournalLine(ac: '1010', dr: 500),
          JournalLine(ac: '3010', cr: 500),
        ], status: JournalStatus.pending),
        _je('u', const [
          JournalLine(ac: '9999', dr: 70),
          JournalLine(ac: '1010', cr: 70),
        ]),
      ]);
      expect(opening, {'1010': -70});
    });

    test('a chart without Retained Earnings still carries the rest', () {
      final coa = defaultChartOfAccountsSeed
          .where((a) => a.code != retainedEarningsCode)
          .toList();
      final opening = openingBalances(coa, [_sale('b')]);
      expect(opening, {'1010': 20000});
    });
  });

  group('entriesBeforePeriod', () {
    test('matches by backend id, not the repeatable entry number', () {
      final inPeriod = _cashOut('x');
      final before = _je('y', const [], number: inPeriod.id);
      expect(
        entriesBeforePeriod(
          throughPeriodEnd: [inPeriod, before],
          period: [inPeriod],
        ),
        [before],
      );
    });

    test('an entry in both lists is never carried', () {
      final undated = _sale('u');
      expect(
        entriesBeforePeriod(throughPeriodEnd: [undated], period: [undated]),
        isEmpty,
      );
    });
  });

  group('accountsWithBalances with an opening', () {
    final prior = [_cashIn('a'), _sale('b')];
    final period = [_cashOut('c')];
    final accounts = accountsWithBalances(
      defaultChartOfAccountsSeed,
      period,
      opening: openingBalances(defaultChartOfAccountsSeed, prior),
    );

    test('cash on hand is the money held, not the period movement', () {
      expect(_bal(accounts, '1010'), 105000);
      expect(_bal(accounts, '3010'), 100000);
    });

    test('the period profit and loss is unchanged', () {
      final pl = incomeStatement(accounts);
      expect(pl.netIncome, -15000);
      expect(_bal(accounts, '4010'), 0);
    });

    test('the trial balance and balance sheet still balance', () {
      expect(trialBalance(accounts).balanced, isTrue);
      final bs = balanceSheet(accounts);
      expect(bs.totalAssets, bs.totalLiabEquity);
    });

    test('no opening gives exactly the old result', () {
      final plain = accountsWithBalances(defaultChartOfAccountsSeed, period);
      expect(_bal(plain, '1010'), -15000);
    });
  });

  test('providers carry earlier months into the selected one', () async {
    final ledger = _DatedLedger(
      {
        _cashIn('a'): DateTime(2026, 9, 3),
        _sale('b'): DateTime(2026, 9, 20),
        _cashOut('c'): DateTime(2026, 10, 5),
        // After the period: must not reach the opening.
        _sale('later'): DateTime(2026, 11, 2),
      },
      undated: [
        _je('undated', const [
          JournalLine(ac: '1020', dr: 300),
          JournalLine(ac: '3010', cr: 300),
        ]),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        ...accountingUnitTestOverrides(),
        accountingLedgerRepositoryProvider.overrideWithValue(ledger),
        accountingBusinessIdProvider.overrideWithValue('biz'),
        accountingDateRangeProvider.overrideWith(
          (ref) => (DateTime(2026, 10, 1), DateTime(2026, 10, 31)),
        ),
      ],
    );
    addTearDown(container.dispose);
    for (final p in [
      chartOfAccountsStreamProvider,
      journalEntriesStreamProvider,
      journalEntriesThroughPeriodEndProvider,
    ]) {
      container.listen(p, (_, _) {});
      await container.read(p.future);
    }

    final accounts = container.read(accountingAccountsProvider);
    expect(_bal(accounts, '1010'), 105000);
    // The undated entry is in the period list (it passes every range) and
    // counts once, not twice.
    expect(_bal(accounts, '1020'), 300);
    expect(container.read(accountingIncomeStatementProvider).netIncome, -15000);
    expect(trialBalance(accounts).balanced, isTrue);
    expect(container.read(accountingLiquidBalancesProvider), [
      (code: '1010', bal: 105000),
      (code: '1030', bal: 0),
      (code: '1020', bal: 300),
    ]);
    expect(container.read(accountingCashBankTotalProvider), 105300);
  });
}
