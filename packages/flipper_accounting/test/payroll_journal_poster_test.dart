import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

final _after = DateTime.utc(2026, 11, 20);
final _before = DateTime.utc(2026, 10, 31);

/// Gross 500,000; PAYE 87,000; employee pension 30,000 + maternity 1,500 +
/// CBHI 1,900 = 33,400; employer pension 30,000 + maternity 1,500 + hazards
/// 10,000 = 41,500; 20,000 of an advance taken back.
PayrollPayslipRecord _payslip({
  String id = 'slip-1',
  DateTime? createdAt,
  DateTime? voidedAt,
}) => PayrollPayslipRecord(
  id: id,
  createdAt: createdAt ?? _after,
  periodEnd: DateTime(2026, 11, 30),
  gross: 500000,
  paye: 87000,
  employeeRssb: 33400,
  employerRssb: 41500,
  advanceRecovery: 20000,
  voidedAt: voidedAt,
);

PayrollPaymentRecord _payment({
  String id = 'pay-1',
  PayrollPaymentKind kind = PayrollPaymentKind.salary,
  PayrollFunding funding = PayrollFunding.mobileMoney,
  int amount = 359600,
  DateTime? voidedAt,
}) => PayrollPaymentRecord(
  id: id,
  createdAt: _after,
  paidOn: DateTime(2026, 11, 30),
  kind: kind,
  amount: amount,
  funding: funding,
  voidedAt: voidedAt,
);

int _dr(List<JournalLine> l, String ac) =>
    l.where((x) => x.ac == ac).fold(0, (s, x) => s + x.dr);
int _cr(List<JournalLine> l, String ac) =>
    l.where((x) => x.ac == ac).fold(0, (s, x) => s + x.cr);

void _expectBalanced(List<JournalLine> lines) {
  expect(
    lines.fold<int>(0, (s, l) => s + l.dr),
    lines.fold<int>(0, (s, l) => s + l.cr),
  );
  // Ditto line ids are <entryId>_<accountCode>: one line per account.
  expect(lines.map((l) => l.ac).toSet(), hasLength(lines.length));
}

void main() {
  group('payslip accrual', () {
    test('books the cost and every party owed', () {
      final lines = PayrollJournalPoster.payslipLines(_payslip());
      expect(_dr(lines, '6020'), 500000);
      expect(_dr(lines, '6025'), 41500);
      expect(_cr(lines, '2310'), 87000);
      expect(_cr(lines, '2320'), 33400 + 41500);
      expect(_cr(lines, '1150'), 20000);
      // Net pay: 500,000 - 87,000 - 33,400 - 20,000.
      expect(_cr(lines, '2300'), 359600);
      _expectBalanced(lines);
    });

    test('other deductions stay in net pay owed, and it still balances', () {
      final p = PayrollPayslipRecord(
        id: 's',
        createdAt: null,
        periodEnd: DateTime(2026, 11, 30),
        gross: 100001,
        paye: 0,
        employeeRssb: 0,
        employerRssb: 0,
        advanceRecovery: 0,
      );
      _expectBalanced(PayrollJournalPoster.payslipLines(p));
    });
  });

  group('payments', () {
    test('salary clears net pay owed from the right money account', () {
      final lines = PayrollJournalPoster.paymentLines(_payment());
      expect(_dr(lines, '2300'), 359600);
      expect(_cr(lines, '1030'), 359600);
      _expectBalanced(lines);
    });

    test('an advance becomes money staff owe the business', () {
      final lines = PayrollJournalPoster.paymentLines(
        _payment(
          kind: PayrollPaymentKind.advance,
          funding: PayrollFunding.cash,
          amount: 50000,
        ),
      );
      expect(_dr(lines, '1150'), 50000);
      expect(_cr(lines, '1010'), 50000);
    });

    test('a reimbursement is an operating expense paid by bank', () {
      final lines = PayrollJournalPoster.paymentLines(
        _payment(
          kind: PayrollPaymentKind.reimbursement,
          funding: PayrollFunding.bank,
          amount: 7000,
        ),
      );
      expect(_dr(lines, '6000'), 7000);
      expect(_cr(lines, '1020'), 7000);
    });
  });

  group('plan', () {
    test('a void adds the original reversed, dated when it was voided', () {
      final voidedAt = DateTime(2026, 12, 2);
      final plan = PayrollJournalPoster.plan(
        businessId: 'biz',
        payslips: [_payslip(voidedAt: voidedAt)],
      );
      expect(plan.map((p) => p.entryId), [
        'je_biz_payslip_slip-1',
        'je_biz_payslip_slip-1_void',
      ]);
      final original = plan.first.lines;
      final reversal = plan.last.lines;
      expect(plan.last.date, voidedAt);
      for (final ac in ['6020', '6025', '2310', '2320', '1150', '2300']) {
        expect(_dr(reversal, ac), _cr(original, ac));
        expect(_cr(reversal, ac), _dr(original, ac));
      }
    });

    test('records from before launch are never posted', () {
      final plan = PayrollJournalPoster.plan(
        businessId: 'biz',
        payslips: [
          _payslip(createdAt: _before),
          PayrollPayslipRecord(
            id: 'no-date',
            createdAt: null,
            periodEnd: DateTime(2026, 11, 30),
            gross: 1000,
            paye: 0,
            employeeRssb: 0,
            employerRssb: 0,
            advanceRecovery: 0,
          ),
        ],
        writeOffs: [
          PayrollWriteOffRecord(
            advanceId: 'adv',
            createdAt: _before,
            writtenOffAt: _after,
            amount: 5000,
          ),
        ],
      );
      expect(plan, isEmpty);
    });

    test('memos never carry who was paid', () {
      final plan = PayrollJournalPoster.plan(
        businessId: 'biz',
        payslips: [_payslip()],
        payments: [_payment()],
      );
      expect(plan.map((p) => p.memo), ['Payroll 30 Nov 2026', 'Salary paid']);
      expect(plan.first.ref, 'PAY-slip-1');
    });
  });

  group('sync', () {
    test('posts each record once, however often it runs', () async {
      final store = InMemoryAccountingStore();
      final poster = PayrollJournalPoster(store);

      Future<int> run() => poster.sync(
        businessId: 'biz',
        payslips: [_payslip()],
        payments: [_payment()],
      );

      expect(await run(), 2);
      expect(await run(), 0);
      expect(store.all('journal_entries'), hasLength(2));
      for (final e in store.all('journal_entries')) {
        expect(e['status'], 'posted');
      }

      // After paying in full nothing is owed to staff; PAYE and RSSB are.
      expect(store.creditBalance('2300'), 0);
      expect(store.creditBalance('2310'), 87000);
      expect(store.creditBalance('2320'), 74900);
    });

    test('a void posted later cancels the original', () async {
      final store = InMemoryAccountingStore();
      final poster = PayrollJournalPoster(store);
      await poster.sync(businessId: 'biz', payslips: [_payslip()]);
      expect(store.creditBalance('2310'), 87000);

      final posted = await poster.sync(
        businessId: 'biz',
        payslips: [_payslip(voidedAt: DateTime(2026, 12, 1))],
      );
      expect(posted, 1);
      for (final ac in ['2300', '2310', '2320', '1150', '6020', '6025']) {
        expect(store.creditBalance(ac), 0, reason: ac);
      }
    });

    test('checks what is posted in one query, not one per record', () async {
      final store = _CountingStore();
      final poster = PayrollJournalPoster(store);
      await poster.sync(
        businessId: 'biz',
        payslips: [for (var i = 0; i < 25; i++) _payslip(id: 'slip-$i')],
      );
      expect(store.journalEntryQueries, 1);
    });
  });
}

/// Counts reads of `journal_entries`.
class _CountingStore extends InMemoryAccountingStore {
  int journalEntryQueries = 0;

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) {
    if (collection == 'journal_entries') journalEntryQueries++;
    return super.queryCollection(collection, query, args);
  }
}
