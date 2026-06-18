import 'package:flipper_web/modules/accounting/data/transaction_journal_poster.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

Map<String, dynamic> _sale({
  required String id,
  required String customer,
  String status = 'completed',
  int subTotal = 100000,
}) => {
      'id': id,
      'status': status,
      'sub_total': subTotal,
      'tax_amount': 0,
      'payment_type': 'CASH',
      'is_expense': false,
      'created_at': '2026-05-15T10:00:00.000Z',
      'customer_name': customer,
      'receipt_number': id,
    };

void main() {
  group('TransactionJournalPoster.syncTransactions', () {
    test('posts one balanced entry per recognized transaction', () async {
      final fake = FakeAccountingLedgerRepository(entries: []);
      await TransactionJournalPoster(fake).syncTransactions(
        businessId: 'biz',
        transactions: [
          _sale(id: 'A', customer: 'Alice'),
          _sale(id: 'B', customer: 'Bob'),
        ],
        items: const [],
      );
      expect(fake.entries.length, 2);
    });

    test('attributes each entry to the correct transaction id even when '
        'non-recognized rows are interleaved', () async {
      final fake = FakeAccountingLedgerRepository(entries: []);

      await TransactionJournalPoster(fake).syncTransactions(
        businessId: 'biz',
        transactions: [
          // Not recognized (draft) — filtered out of journal generation.
          _sale(id: 'DRAFT', customer: 'Nobody', status: 'draft'),
          _sale(id: 'A', customer: 'Alice'),
          _sale(id: 'B', customer: 'Bob'),
        ],
        items: const [],
      );

      // Only the two recognized sales produce entries.
      expect(fake.entries.length, 2);

      // The non-recognized row must not have an entry attributed to it.
      expect(fake.txnToEntryId.containsKey('DRAFT'), isFalse);

      // Each recognized transaction maps to ITS OWN entry (not shifted by the
      // dropped draft row, which was the prior index-misalignment bug).
      final aUuid = fake.txnToEntryId['A'];
      final bUuid = fake.txnToEntryId['B'];
      expect(aUuid, isNotNull);
      expect(bUuid, isNotNull);

      final aEntry = fake.entries.firstWhere((e) => e.uuid == aUuid);
      final bEntry = fake.entries.firstWhere((e) => e.uuid == bUuid);
      expect(aEntry.memo, contains('Alice'));
      expect(bEntry.memo, contains('Bob'));
    });

    test('is idempotent: re-running does not duplicate entries', () async {
      final fake = FakeAccountingLedgerRepository(entries: []);
      final poster = TransactionJournalPoster(fake);
      final txns = [_sale(id: 'A', customer: 'Alice')];

      await poster.syncTransactions(
          businessId: 'biz', transactions: txns, items: const []);
      await poster.syncTransactions(
          businessId: 'biz', transactions: txns, items: const []);

      expect(fake.entries.length, 1);
    });
  });
}
