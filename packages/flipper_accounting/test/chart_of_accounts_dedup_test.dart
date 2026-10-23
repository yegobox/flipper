import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

/// Businesses seeded by both the client (`<biz>_<code>`) and the
/// data-connector (`coa_<biz>_<code>`) hold two documents per account. The
/// chart must still list each account once, or every report that sums it
/// counts the balance twice.
void main() {
  late InMemoryAccountingStore store;
  late DittoAccountingLedgerRepository repo;

  void putAccount(String id, String code, {int openingBalance = 0}) {
    store.collections.putIfAbsent('chart_of_accounts', () => {})[id] = {
      '_id': id,
      'id': id,
      'businessId': 'biz',
      'business_id': 'biz',
      'code': code,
      'name': 'Account $code',
      'accountType': 'expense',
      'normal': 'debit',
      'openingBalance': openingBalance,
    };
  }

  setUp(() {
    store = InMemoryAccountingStore(seedChart: false);
    repo = DittoAccountingLedgerRepository(store);
  });

  test('lists an account seeded under both id schemes once', () async {
    putAccount('biz_5010', '5010');
    putAccount('coa_biz_5010', '5010');

    final accounts = await repo.watchChartOfAccounts(businessId: 'biz').first;

    expect(accounts.map((a) => a.code), ['5010']);
  });

  test('a fully double-seeded chart has one row per default account', () async {
    for (final a in defaultChartOfAccountsSeed) {
      putAccount('biz_${a.code}', a.code);
      putAccount('coa_biz_${a.code}', a.code);
    }

    final accounts = await repo.watchChartOfAccounts(businessId: 'biz').first;

    expect(accounts, hasLength(defaultChartOfAccountsSeed.length));
    expect(
      accounts.map((a) => a.code).toSet(),
      defaultChartOfAccountsSeed.map((a) => a.code).toSet(),
    );
  });

  test('keeps an opening balance only the legacy copy carries', () async {
    putAccount('biz_1010', '1010', openingBalance: 500);
    putAccount('coa_biz_1010', '1010');

    final accounts = await repo.watchChartOfAccounts(businessId: 'biz').first;

    expect(accounts.single.bal, 500);
  });

  test('prefers the coa_ copy whichever order the rows arrive in', () {
    final legacy = {'_id': 'biz_6000', 'code': '6000', 'name': 'Old'};
    final canonical = {'_id': 'coa_biz_6000', 'code': '6000', 'name': 'New'};

    for (final rows in [
      [legacy, canonical],
      [canonical, legacy],
    ]) {
      final kept = DittoAccountingLedgerRepository.dedupeChartOfAccountRows(
        rows,
      );
      expect(kept.single['_id'], 'coa_biz_6000');
    }
  });

  test('a custom account with a single document still appears', () async {
    putAccount('coa_biz_6010', '6010');
    putAccount('biz_7777', '7777');

    final accounts = await repo.watchChartOfAccounts(businessId: 'biz').first;

    expect(accounts.map((a) => a.code), ['6010', '7777']);
  });
}
