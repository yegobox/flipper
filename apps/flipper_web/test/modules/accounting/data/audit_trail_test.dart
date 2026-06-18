import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/transaction_journal_poster.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ditto_store.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

Map<String, dynamic> _sale(String id) => {
      'id': id,
      'status': 'completed',
      'subTotal': 100000,
      'taxAmount': 0,
      'paymentType': 'CASH',
      'isExpense': false,
      'createdAt': '2026-06-01T10:00:00.000Z',
      'customerName': 'Alice',
      'receiptNumber': id,
    };

void main() {
  group('AuditTrailRecorder', () {
    test('persists a row with the expected fields', () async {
      final store = FakeAccountingDittoStore();
      await AuditTrailRecorder(store).record(
        businessId: 'biz',
        id: 'audit_x',
        action: 'Posted',
        target: 'JE-1',
        detail: 'Sale · Alice',
        user: '0788000000',
        role: 'Cashier',
        src: 'POS',
      );
      final row = store.auditLogs['audit_x'];
      expect(row, isNotNull);
      expect(row!['action'], 'Posted');
      expect(row['user'], '0788000000');
      expect(row['src'], 'POS');
      expect(DateTime.tryParse(row['ts'] as String), isNotNull);
      expect(row['businessId'], 'biz');
    });

    test('is a silent no-op when the store is not ready', () async {
      final store = FakeAccountingDittoStore(ready: false);
      await AuditTrailRecorder(store).record(
        businessId: 'biz',
        id: 'audit_x',
        action: 'Posted',
        target: 'JE-1',
        detail: 'd',
      );
      expect(store.auditLogs, isEmpty);
    });
  });

  group('TransactionJournalPoster audit', () {
    test('records one audit row per created entry, none on skip', () async {
      final ledger = FakeAccountingLedgerRepository(entries: []);
      final store = FakeAccountingDittoStore();
      final poster =
          TransactionJournalPoster(ledger, audit: AuditTrailRecorder(store));

      await poster.syncTransactions(
        businessId: 'biz',
        transactions: [_sale('T1')],
        items: const [],
      );
      expect(store.auditLogs.keys, ['audit_je_biz_T1_sale']);

      // Idempotent re-run: entry skipped → no extra audit row.
      await poster.syncTransactions(
        businessId: 'biz',
        transactions: [_sale('T1')],
        items: const [],
      );
      expect(store.auditLogs.length, 1);
    });
  });
}
