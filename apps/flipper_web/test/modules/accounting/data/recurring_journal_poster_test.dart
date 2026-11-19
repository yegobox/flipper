import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/recurring_journal_poster.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

const _rent = RecurringSchedule(
  id: 'R-01',
  name: 'Rent',
  freq: 'Monthly',
  day: '1',
  next: '1 Dec 2026',
  amount: 300000,
  debitCode: '6010',
  creditCode: '1020',
  iconName: 'Home',
  active: true,
);

void main() {
  test('posts a schedule once per period, as one batched save', () async {
    final ledger = FakeAccountingLedgerRepository();
    final p = RecurringJournalPoster(ledger);

    expect(
      await p.postSchedule(
        businessId: 'biz',
        schedule: _rent,
        period: '2026-11',
      ),
      isTrue,
    );
    expect(ledger.batchWritesCalls, 1);
    final entry = ledger.entries.single;
    expect(entry.status, JournalStatus.posted);
    expect(entry.lines.map((l) => (l.ac, l.dr, l.cr)), [
      ('6010', 300000, 0),
      ('1020', 0, 300000),
    ]);

    // The same period again posts nothing.
    expect(
      await p.postSchedule(
        businessId: 'biz',
        schedule: _rent,
        period: '2026-11',
      ),
      isFalse,
    );
    expect(ledger.entries, hasLength(1));
  });
}
