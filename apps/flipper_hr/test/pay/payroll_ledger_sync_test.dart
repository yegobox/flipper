import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_providers.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/payroll_ledger_sync.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_employee_repository.dart';
import '../helpers/fake_pay_repository.dart';

/// A payslip row as Supabase returns it: 200,000 gross with 5,000 withheld
/// for a staff loan.
Map<String, dynamic> _slipRow({String status = 'paid', String? voidedAt}) => {
  'id': 'slip-1',
  'employee_id': 'e-1',
  'period_start': '2026-11-01',
  'period_end': '2026-11-30',
  'gross': 200000,
  'paye': 24000,
  'pension_employee': 12000,
  'maternity_employee': 600,
  'cbhi': 817,
  'other_deductions': 5000,
  'advance_recovery': 3000,
  'net_pay': 154583,
  'pension_employer': 12000,
  'maternity_employer': 600,
  'occupational_hazards': 4000,
  'paid_amount': 154583,
  'status': status,
  'voided_at': voidedAt,
  'created_at': '2026-11-20T08:00:00Z',
};

Map<String, dynamic> _paymentRow({
  String kind = 'salary',
  String method = 'cash',
  String? voidedAt,
}) => {
  'id': 'pay-1',
  'employee_id': 'e-1',
  'kind': kind,
  'amount': 154583,
  'paid_on': '2026-11-30',
  'method': method,
  'voided_at': voidedAt,
  'created_at': '2026-11-30T09:00:00Z',
};

Map<String, dynamic> _advanceRow({
  String status = 'written_off',
  num recovered = 4000,
  String? writtenOffAt = '2026-12-10T10:00:00Z',
}) => {
  'id': 'adv-1',
  'employee_id': 'e-1',
  'amount': 10000,
  'given_on': '2026-11-18',
  'method': 'cash',
  'recovered': recovered,
  'status': status,
  'written_off_at': writtenOffAt,
  'created_at': '2026-11-18T07:00:00Z',
};

void main() {
  group('pay-book records for Books', () {
    test('a payslip carries every deduction, other deductions included', () {
      final r = payslipRecord(Payslip.fromRow(_slipRow()));
      expect(r.gross, 200000);
      expect(r.employeeRssb, 12000 + 600 + 817);
      expect(r.employerRssb, 12000 + 600 + 4000);
      expect(r.otherDeductions, 5000);
      expect(r.voidedAt, isNull);
      // 2300 is the payslip's net pay, so paying it clears what is owed.
      final lines = PayrollJournalPoster.payslipLines(r);
      expect(lines.singleWhere((l) => l.ac == '2300').cr, 154583);
      expect(lines.singleWhere((l) => l.ac == '2330').cr, 5000);
    });

    test('a void is dated when it was voided', () {
      final r = payslipRecord(
        Payslip.fromRow(
          _slipRow(status: 'void', voidedAt: '2026-12-01T12:00:00Z'),
        ),
      );
      expect(r.voidedAt, DateTime.utc(2026, 12, 1, 12));
    });

    test('payments map their kind and money account', () {
      final cases = {
        ('salary', 'cash'): (PayrollPaymentKind.salary, PayrollFunding.cash),
        ('advance', 'mobile_money'): (
          PayrollPaymentKind.advance,
          PayrollFunding.mobileMoney,
        ),
        ('reimbursement', 'bank_transfer'): (
          PayrollPaymentKind.reimbursement,
          PayrollFunding.bank,
        ),
        ('other', 'cash'): (PayrollPaymentKind.other, PayrollFunding.cash),
      };
      for (final MapEntry(key: (kind, method), value: (k, f))
          in cases.entries) {
        final r = paymentRecord(
          PayPayment.fromRow(_paymentRow(kind: kind, method: method)),
        );
        expect(r.kind, k, reason: kind);
        expect(r.funding, f, reason: method);
        expect(r.amount, 154583);
        expect(r.voidedAt, isNull);
      }
    });

    test('a voided payment is dated when it was voided', () {
      final r = paymentRecord(
        PayPayment.fromRow(_paymentRow(voidedAt: '2026-12-02T08:00:00Z')),
      );
      expect(r.voidedAt, DateTime.utc(2026, 12, 2, 8));
    });

    test('a write-off posts only what was still owed', () {
      final w = writeOffRecord(Advance.fromRow(_advanceRow()))!;
      expect(w.amount, 6000);
      expect(w.writtenOffAt, DateTime.utc(2026, 12, 10, 10));
      expect(w.createdAt, DateTime.utc(2026, 11, 18, 7));
    });

    test('no write-off for an open or fully recovered advance', () {
      expect(
        writeOffRecord(Advance.fromRow(_advanceRow(status: 'open'))),
        isNull,
      );
      expect(
        writeOffRecord(Advance.fromRow(_advanceRow(recovered: 10000))),
        isNull,
      );
    });
  });

  group('PayrollLedgerSync', () {
    final book = PayBook(
      payslips: [Payslip.fromRow(_slipRow())],
      payments: [PayPayment.fromRow(_paymentRow())],
      advances: [
        Advance.fromRow(_advanceRow()),
        Advance.fromRow(_advanceRow(status: 'open')),
      ],
    );

    test('posts the book to the business it is given', () async {
      final calls = <(String, int, int, int)>[];
      final container = ProviderContainer(
        overrides: [
          payrollLedgerPosterProvider.overrideWithValue(({
            required businessId,
            required payslips,
            required payments,
            required writeOffs,
          }) async {
            calls.add((
              businessId,
              payslips.length,
              payments.length,
              writeOffs.length,
            ));
            return 3;
          }),
        ],
      );
      addTearDown(container.dispose);
      final sync = container.read(payrollLedgerSyncProvider);
      expect(await sync.syncBook(book, businessId: 'biz-1'), 3);
      expect(calls, [('biz-1', 1, 1, 1)]);
      // No business: nothing is posted.
      expect(await sync.syncBook(book, businessId: ''), 0);
      expect(calls, hasLength(1));
    });

    test('a poster failure never reaches the pay action', () async {
      final container = ProviderContainer(
        overrides: [
          payrollLedgerPosterProvider.overrideWithValue(({
            required businessId,
            required payslips,
            required payments,
            required writeOffs,
          }) async {
            throw StateError('ledger offline');
          }),
        ],
      );
      addTearDown(container.dispose);
      expect(
        await container
            .read(payrollLedgerSyncProvider)
            .syncBook(book, businessId: 'biz-1'),
        0,
      );
    });

    test('the Ditto poster writes nothing until Ditto is up', () async {
      final container = ProviderContainer(
        overrides: [dittoReadyProvider.overrideWith((ref) => false)],
      );
      addTearDown(container.dispose);
      final post = container.read(payrollLedgerPosterProvider);
      Future<int> run() => post(
        businessId: 'biz-1',
        payslips: [payslipRecord(book.payslips.single)],
        payments: const [],
        writeOffs: const [],
      );
      expect(await run(), 0);

      // Marked ready but no Ditto instance behind it (as in a test): the
      // poster checks the store itself and still writes nothing.
      container.read(dittoReadyProvider.notifier).state = true;
      expect(await run(), 0);
    });
  });

  group('pay actions', () {
    late List<String> postedTo;
    late PayActions actions;
    late FakePayRepository repo;
    final e = employee();

    setUp(() {
      postedTo = [];
      repo = FakePayRepository();
      final container = ProviderContainer(
        overrides: [
          payRepositoryProvider.overrideWithValue(repo),
          hrClockProvider.overrideWithValue(() => DateTime(2026, 11, 20)),
          // The user has since switched to another business.
          selectedBusinessProvider.overrideWithValue(
            Business.fromJson({'id': 'biz-2', 'name': 'Other Shop'}),
          ),
          payrollLedgerPosterProvider.overrideWithValue(({
            required businessId,
            required payslips,
            required payments,
            required writeOffs,
          }) async {
            postedTo.add(businessId);
            return 0;
          }),
        ],
      );
      addTearDown(container.dispose);
      actions = container.read(payActionsProvider);
    });

    test('an approved advance posts to the employee\'s own business', () async {
      final r = await repo.requestAdvance(employeeId: e.id, amount: 10000);
      await actions.approveRequest(e, r, method: PaymentMethod.cash);
      await pumpEventQueue();
      expect(postedTo, ['biz-1']);
    });

    test('requests and declines move no money, so nothing posts', () async {
      await actions.requestAdvance(e, amount: 10000);
      final r = await repo.requestAdvance(employeeId: e.id, amount: 10000);
      await actions.cancelRequest(e, r);
      await actions.declineRequest(e, r);
      await pumpEventQueue();
      expect(postedTo, isEmpty);
    });
  });
}
