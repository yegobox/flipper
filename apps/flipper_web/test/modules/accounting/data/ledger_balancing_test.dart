import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> _sale({
  String id = 'txn-1',
  int subTotal = 118000,
  int taxAmount = 18000,
  String paymentType = 'CASH',
  bool isLoan = false,
  int remainingBalance = 0,
  String status = 'completed',
}) => {
      'id': id,
      'status': status,
      'sub_total': subTotal,
      'tax_amount': taxAmount,
      'payment_type': paymentType,
      'is_expense': false,
      'is_loan': isLoan,
      if (isLoan && remainingBalance > 0) 'remaining_balance': remainingBalance,
      'created_at': '2026-05-15T10:00:00.000Z',
      'customer_name': 'Test Customer',
      'receipt_number': id,
    };

Map<String, dynamic> _expense({
  String id = 'exp-1',
  int subTotal = 50000,
  String paymentType = 'CASH',
}) => {
      'id': id,
      'status': 'completed',
      'sub_total': subTotal,
      'tax_amount': 0,
      'payment_type': paymentType,
      'is_expense': true,
      'created_at': '2026-05-15T12:00:00.000Z',
      'note': 'Misc expense',
    };

Map<String, dynamic> _item({
  String transactionId = 'txn-1',
  double splyAmt = 70000,
}) => {
      'transaction_id': transactionId,
      'sply_amt': splyAmt,
      'qty': 1.0,
    };

/// Opening inventory + capital so COGS relief does not drive inventory negative.
/// Dr Inventory (1200) / Cr Owner's Capital (3010).
JournalEntry _openingInventory(int amount) => JournalEntry(
      id: 'JE-OPEN',
      date: 'Jan 1',
      memo: 'Opening inventory',
      ref: 'OPEN',
      status: JournalStatus.posted,
      src: 'Opening',
      lines: [
        JournalLine(ac: '1200', dr: amount),
        JournalLine(ac: '3010', cr: amount),
      ],
    );

int _drTotal(JournalEntry e) => e.lines.fold(0, (s, l) => s + l.dr);
int _crTotal(JournalEntry e) => e.lines.fold(0, (s, l) => s + l.cr);

void main() {
  group('chart of accounts integrity', () {
    test('operating expense account 6000 exists (POS expense target)', () {
      expect(
        defaultChartOfAccountsSeed.any((a) => a.code == '6000'),
        isTrue,
        reason: 'POS expenses post to 6000; it must exist or its debit leg is '
            'silently dropped and the ledger will not balance.',
      );
    });

    test('every expense account is classified for the income statement', () {
      const validSubs = {'Cost of sales', 'Operating expenses'};
      for (final a
          in defaultChartOfAccountsSeed.where((a) => a.type == AccountType.expense)) {
        expect(
          validSubs.contains(a.sub),
          isTrue,
          reason: 'Expense ${a.code} (${a.name}) has sub "${a.sub}" which the '
              'income statement does not pick up.',
        );
      }
    });

    test('COGS (5010) and Inventory (1200) exist for cost-of-sale postings', () {
      expect(defaultChartOfAccountsSeed.any((a) => a.code == '5010'), isTrue);
      expect(defaultChartOfAccountsSeed.any((a) => a.code == '1200'), isTrue);
    });
  });

  group('double-entry on individual entries', () {
    test('POS sale with item cost posts balanced Dr COGS / Cr Inventory', () {
      final journal = TransactionToAccounts.toJournal(
        [_sale(subTotal: 118000, taxAmount: 18000)],
        [_item(splyAmt: 70000), _item(splyAmt: 5000)],
      );
      final entry = journal.single;

      expect(_drTotal(entry), _crTotal(entry), reason: 'entry must balance');
      expect(
        entry.lines.any((l) => l.ac == '5010' && l.dr == 75000),
        isTrue,
        reason: 'COGS debited with summed item supply cost',
      );
      expect(
        entry.lines.any((l) => l.ac == '1200' && l.cr == 75000),
        isTrue,
        reason: 'Inventory relieved for the cost of goods sold',
      );
    });

    test('sale without items posts no COGS lines and still balances', () {
      final entry =
          TransactionToAccounts.toJournal([_sale()], []).single;
      expect(_drTotal(entry), _crTotal(entry));
      expect(entry.lines.any((l) => l.ac == '5010'), isFalse);
      expect(entry.lines.any((l) => l.ac == '1200'), isFalse);
    });

    test('every posted journal line references a seeded account', () {
      final codes = {for (final a in defaultChartOfAccountsSeed) a.code};
      final journal = TransactionToAccounts.toJournal(
        [
          _sale(id: 'txn-1'),
          _sale(id: 'txn-2', isLoan: true, status: 'parked', remainingBalance: 40000),
          _expense(id: 'exp-1'),
        ],
        [_item(transactionId: 'txn-1')],
      );
      for (final e in journal) {
        for (final l in e.lines) {
          expect(
            codes.contains(l.ac),
            isTrue,
            reason: 'entry ${e.id} posts to account ${l.ac} which is not in the COA',
          );
        }
      }
    });
  });

  group('ledger-level invariants from posted entries', () {
    // A realistic mixed period: cash sale (with cost), partial-loan sale,
    // a credit-only loan, and a cash expense, on top of opening inventory.
    List<JournalEntry> buildJournal() {
      final txns = [
        _sale(id: 'txn-1', subTotal: 118000, taxAmount: 18000, paymentType: 'CASH'),
        _sale(
          id: 'txn-2',
          subTotal: 200000,
          taxAmount: 0,
          isLoan: true,
          status: 'parked',
          remainingBalance: 75000,
          paymentType: 'CASH',
        ),
        _sale(
          id: 'txn-3',
          subTotal: 100000,
          taxAmount: 0,
          isLoan: true,
          status: 'parked',
          remainingBalance: 100000,
          paymentType: 'CREDIT',
        ),
        _expense(id: 'exp-1', subTotal: 50000, paymentType: 'CASH'),
      ];
      final items = [
        _item(transactionId: 'txn-1', splyAmt: 60000),
        _item(transactionId: 'txn-2', splyAmt: 90000),
      ];
      return [
        _openingInventory(500000),
        ...TransactionToAccounts.toJournal(txns, items),
      ];
    }

    test('trial balance balances (total debits == total credits)', () {
      final accounts =
          accountsWithBalances(defaultChartOfAccountsSeed, buildJournal());
      final tb = trialBalance(accounts);
      expect(tb.totDr, tb.totCr);
      expect(tb.balanced, isTrue);
    });

    test('accounting equation holds: Assets == Liabilities + Equity', () {
      final accounts =
          accountsWithBalances(defaultChartOfAccountsSeed, buildJournal());
      final bs = balanceSheet(accounts);
      expect(bs.totalAssets, bs.totalLiabEquity);
    });

    test('income statement now reflects COGS and the cash expense', () {
      final accounts =
          accountsWithBalances(defaultChartOfAccountsSeed, buildJournal());
      final pl = incomeStatement(accounts);
      // COGS = 60000 + 90000 from the two sales with items.
      expect(pl.cogs, 150000);
      // The cash expense posted to 6000 is captured in operating expenses.
      expect(pl.totalOpex, 50000);
    });

    test('a line to an unknown account unbalances the trial balance', () {
      // Guards the regression where POS expenses posted to a missing 6000.
      final journal = [
        JournalEntry(
          id: 'JE-BAD',
          date: 'May 1',
          memo: 'Expense to non-existent account',
          ref: 'BAD',
          status: JournalStatus.posted,
          src: 'Expense',
          lines: const [
            JournalLine(ac: '9999', dr: 50000), // not in COA -> dropped
            JournalLine(ac: '1010', cr: 50000),
          ],
        ),
      ];
      final accounts = accountsWithBalances(defaultChartOfAccountsSeed, journal);
      final tb = trialBalance(accounts);
      expect(
        tb.balanced,
        isFalse,
        reason: 'dropping one leg of an entry must show as an imbalance',
      );
    });
  });
}
