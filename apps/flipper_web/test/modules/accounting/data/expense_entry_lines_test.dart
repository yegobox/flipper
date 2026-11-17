import 'package:flipper_accounting/statutory_accounts.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/chart_account_resolver.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/expense_entry_posting.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

int _dr(List<JournalLine> lines, String ac) =>
    lines.where((l) => l.ac == ac).fold(0, (s, l) => s + l.dr);
int _cr(List<JournalLine> lines, String ac) =>
    lines.where((l) => l.ac == ac).fold(0, (s, l) => s + l.cr);

void _expectBalanced(List<JournalLine> lines) {
  expect(
    lines.fold<int>(0, (s, l) => s + l.dr),
    lines.fold<int>(0, (s, l) => s + l.cr),
  );
}

void main() {
  group('buildExpenseJournalLines', () {
    test('posts Dr expense and Cr funding for the same amount', () {
      final lines = buildExpenseJournalLines(
        expenseCode: '6010',
        fundingCode: '1020',
        amount: 50000,
      );

      expect(lines, hasLength(2));
      expect(lines[0].ac, '6010');
      expect(lines[0].dr, 50000);
      expect(lines[0].cr, 0);
      expect(lines[1].ac, '1020');
      expect(lines[1].cr, 50000);
      expect(lines[1].dr, 0);

      final totalDr = lines.fold<int>(0, (s, l) => s + l.dr);
      final totalCr = lines.fold<int>(0, (s, l) => s + l.cr);
      expect(totalDr, totalCr);
    });
  });

  group('fundingCodeForPaymentMethod', () {
    final roles = ChartAccountResolver(defaultChartOfAccountsSeed);

    test('maps cash, bank, and momo to liquid accounts', () {
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.cash),
        '1010',
      );
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.bank),
        '1020',
      );
      expect(
        fundingCodeForPaymentMethod(roles, ExpensePaymentMethod.momo),
        '1030',
      );
    });
  });

  group('suggestNextExpenseCode', () {
    test('skips used 60xx codes', () {
      expect(suggestNextExpenseCode(defaultChartOfAccountsSeed), '6060');
    });
  });

  group('buildStatutoryPaymentLines', () {
    final roles = ChartAccountResolver(defaultChartOfAccountsSeed);

    List<JournalLine> pay(StatutoryPayment p, {required int owed}) =>
        buildStatutoryPaymentLines(
          payment: p,
          roles: roles,
          fundingCode: '1020',
          amount: 100000,
          owed: owed,
        );

    test('VAT always clears 2100, even with nothing owed in the ledger', () {
      for (final owed in [0, 40000, 250000]) {
        final lines = pay(StatutoryPayment.vat, owed: owed);
        expect(_dr(lines, '2100'), 100000);
        expect(_cr(lines, '1020'), 100000);
        expect(lines, hasLength(2));
        _expectBalanced(lines);
      }
    });

    test('PAYE fully owed clears 2310 PAYE Payable', () {
      final lines = pay(StatutoryPayment.paye, owed: 150000);
      expect(_dr(lines, payePayableCode), 100000);
      expect(_dr(lines, salariesCode), 0);
      _expectBalanced(lines);
    });

    test('PAYE with nothing owed is a salary cost', () {
      final lines = pay(StatutoryPayment.paye, owed: 0);
      expect(_dr(lines, payePayableCode), 0);
      expect(_dr(lines, salariesCode), 100000);
      _expectBalanced(lines);
    });

    test('RSSB above what is owed splits: debt first, the rest a cost', () {
      final lines = pay(StatutoryPayment.rssb, owed: 30000);
      expect(_dr(lines, rssbPayableCode), 30000);
      expect(_dr(lines, employerRssbCode), 70000);
      expect(_cr(lines, '1020'), 100000);
      _expectBalanced(lines);
    });

    test('a negative balance (overpaid before) counts as nothing owed', () {
      final lines = pay(StatutoryPayment.rssb, owed: -5000);
      expect(_dr(lines, rssbPayableCode), 0);
      expect(_dr(lines, employerRssbCode), 100000);
    });
  });

  group('statutoryOwed', () {
    Account paye(int bal) => Account(
      code: payePayableCode,
      name: 'PAYE Payable',
      type: AccountType.liability,
      sub: 'Current liabilities',
      normal: AccountNormal.credit,
      bal: bal,
    );

    JournalEntry entry(JournalStatus status, int dr) => JournalEntry(
      id: 'JE-$dr',
      date: '1 Nov 2026',
      memo: 'PAYE paid to RRA',
      ref: 'JE-$dr',
      status: status,
      src: 'Manual',
      lines: [
        JournalLine(ac: payePayableCode, dr: dr),
        JournalLine(ac: '1010', cr: dr),
      ],
    );

    test('is the posted balance when nothing waits for approval', () {
      expect(
        statutoryOwed(
          accounts: [paye(80000)],
          journal: [entry(JournalStatus.posted, 30000)],
          liabilityCode: payePayableCode,
        ),
        80000,
      );
    });

    test('takes off payments to the liability waiting for approval', () {
      expect(
        statutoryOwed(
          accounts: [paye(80000)],
          journal: [
            entry(JournalStatus.pending, 60000),
            entry(JournalStatus.draft, 10000),
          ],
          liabilityCode: payePayableCode,
        ),
        20000,
      );
    });

    test('is zero less pending payments when the chart lacks the account', () {
      expect(
        statutoryOwed(
          accounts: defaultChartOfAccountsSeed
              .where((a) => a.code != payePayableCode)
              .toList(),
          journal: [entry(JournalStatus.pending, 5000)],
          liabilityCode: payePayableCode,
        ),
        -5000,
      );
    });
  });

  group('statutory accounts', () {
    test('VAT has no cost account: its liability is used', () {
      final roles = ChartAccountResolver(defaultChartOfAccountsSeed);
      expect(statutoryExpenseCode(roles, StatutoryPayment.vat), '2100');
    });

    Account acct(String code, String name, AccountType type) => Account(
      code: code,
      name: name,
      type: type,
      sub: '',
      normal: type == AccountType.expense
          ? AccountNormal.debit
          : AccountNormal.credit,
      bal: 0,
    );

    test('salaries by name never picks a liability', () {
      final roles = ChartAccountResolver([
        acct('2390', 'Salaries payable', AccountType.liability),
        acct('2395', 'Wages owed', AccountType.liability),
        acct('6100', 'Staff salaries', AccountType.expense),
      ]);
      expect(roles.salaries, '6100');
    });

    test('with only salary liabilities, PAYE cost goes to 6020', () {
      final roles = ChartAccountResolver([
        acct('2390', 'Salaries payable', AccountType.liability),
        acct('2395', 'Wages owed', AccountType.liability),
      ]);
      expect(roles.salaries, isNull);
      expect(statutoryExpenseCode(roles, StatutoryPayment.paye), salariesCode);
    });

    test('wages by name is used when no salaries account exists', () {
      final roles = ChartAccountResolver([
        acct('6110', 'Wages payable', AccountType.expense),
        acct('6120', 'Casual wages', AccountType.expense),
      ]);
      expect(roles.salaries, '6120');
    });
  });

  group('ensureChartAccounts', () {
    test('adds only the seed accounts the chart is missing', () async {
      final oldChart = defaultChartOfAccountsSeed
          .where((a) => !{'2310', '2320', '6025', '1150'}.contains(a.code))
          .toList();
      final repo = FakeAccountingLedgerRepository(coa: List.of(oldChart));

      await ensureChartAccounts(
        repo,
        businessId: 'biz',
        codes: const ['2310', '1020', '2310', '9999'],
        existingCodes: {for (final a in oldChart) a.code},
      );

      expect(repo.lastCreatedAccount?.code, '2310');
      expect(repo.lastCreatedAccount?.type, AccountType.liability);
    });

    test('a code another device already added is left alone', () async {
      final repo = FakeAccountingLedgerRepository();
      // The caller's view is stale: 2310 is already in the repository.
      await ensureChartAccounts(
        repo,
        businessId: 'biz',
        codes: const ['2310'],
        existingCodes: const {},
      );
      expect(repo.lastCreatedAccount, isNull);
    });
  });
}
