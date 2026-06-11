import 'package:flipper_web/modules/accounting/data/mapper/transaction_to_accounts.dart';
import 'package:flipper_web/modules/accounting/data/transaction_journal_poster.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

Map<String, dynamic> _loanSale({
  required String id,
  String paymentType = 'CASH',
  int subTotal = 100000,
  int remainingBalance = 60000,
}) => {
      'id': id,
      'status': 'parked',
      'subTotal': subTotal,
      'taxAmount': 0,
      'paymentType': paymentType,
      'isExpense': false,
      'isLoan': true,
      'remainingBalance': remainingBalance,
      'createdAt': '2026-06-01T10:00:00.000Z',
      'customerName': 'Alice',
      'receiptNumber': id,
    };

void main() {
  group('TransactionToAccounts.paymentToEntry', () {
    test('balances debits and credits against AR', () {
      final entry = TransactionToAccounts.paymentToEntry(
        txn: _loanSale(id: 'L1'),
        amount: 25000,
        dateIso: '2026-06-10T09:00:00.000Z',
      );
      final dr = entry.lines.fold<int>(0, (s, l) => s + l.dr);
      final cr = entry.lines.fold<int>(0, (s, l) => s + l.cr);
      expect(dr, 25000);
      expect(cr, 25000);
      expect(entry.lines.any((l) => l.ac == '1100' && l.cr == 25000), isTrue);
      expect(entry.src, 'POS');
    });

    test('maps payment type to the matching liquid account', () {
      for (final (payType, account) in [
        ('CASH', '1010'),
        ('BANK TRANSFER', '1020'),
        ('MOMO', '1030'),
      ]) {
        final entry = TransactionToAccounts.paymentToEntry(
          txn: _loanSale(id: 'L1', paymentType: payType),
          amount: 1000,
          dateIso: '2026-06-10T09:00:00.000Z',
        );
        expect(
          entry.lines.any((l) => l.ac == account && l.dr == 1000),
          isTrue,
          reason: '$payType should debit $account',
        );
      }
    });
  });

  group('deterministic entry ids', () {
    test('auto-poster creates entries with the deterministic sale id', () async {
      final fake = FakeAccountingLedgerRepository(entries: []);
      await TransactionJournalPoster(fake).syncTransactions(
        businessId: 'biz',
        transactions: [_loanSale(id: 'T1')],
        items: const [],
      );
      expect(fake.entries.length, 1);
      expect(fake.entries.single.uuid, 'je_biz_T1_sale');
    });

    test('auto-poster skips when the deterministic id already exists '
        '(e.g. POS posted first)', () async {
      final fake = FakeAccountingLedgerRepository(entries: []);
      // Simulate the POS-side poster having already created the entry.
      await fake.createJournalEntry(
        businessId: 'biz',
        entry: TransactionToAccounts.toJournal(
          [_loanSale(id: 'T1')],
          const [],
        ).single,
        transactionId: 'T1',
        entryId: 'je_biz_T1_sale',
      );

      await TransactionJournalPoster(fake).syncTransactions(
        businessId: 'biz',
        transactions: [_loanSale(id: 'T1')],
        items: const [],
      );
      expect(fake.entries.length, 1);
    });

    test('loan sale entry splits collected cash and open AR', () {
      final entries = TransactionToAccounts.toJournal(
        [_loanSale(id: 'T1', subTotal: 100000, remainingBalance: 60000)],
        const [],
      );
      final lines = entries.single.lines;
      expect(lines.any((l) => l.ac == '1010' && l.dr == 40000), isTrue);
      expect(lines.any((l) => l.ac == '1100' && l.dr == 60000), isTrue);
      expect(lines.any((l) => l.ac == '4010' && l.cr == 100000), isTrue);
    });
  });
}
