/// Keeps the Books ledger in step with the pay book.
///
/// The pay book lives in Supabase; the ledger in Ditto. After every pay
/// action, and whenever the Pay page loads the branch's book, the whole book
/// goes to [PayrollJournalPoster], which posts only the entries that are
/// missing. Posting never blocks or fails a pay action: a record that does not
/// post now is posted by the next sync, from any device.
library;

import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int _francs(double v) => v.round();

PayrollFunding payrollFunding(PaymentMethod m) => switch (m) {
  PaymentMethod.cash => PayrollFunding.cash,
  PaymentMethod.mobileMoney => PayrollFunding.mobileMoney,
  PaymentMethod.bankTransfer => PayrollFunding.bank,
};

PayrollPaymentKind payrollPaymentKind(PaymentKind k) => switch (k) {
  PaymentKind.salary => PayrollPaymentKind.salary,
  PaymentKind.advance => PayrollPaymentKind.advance,
  PaymentKind.reimbursement => PayrollPaymentKind.reimbursement,
  PaymentKind.other => PayrollPaymentKind.other,
};

PayrollPayslipRecord payslipRecord(Payslip p) => PayrollPayslipRecord(
  id: p.id,
  createdAt: p.createdAt,
  periodEnd: p.periodEnd,
  gross: _francs(p.gross),
  paye: _francs(p.paye),
  employeeRssb: _francs(p.pensionEmployee + p.maternityEmployee + p.cbhi),
  employerRssb: _francs(p.employerContributions),
  advanceRecovery: _francs(p.advanceRecovery),
  otherDeductions: _francs(p.otherDeductions),
  voidedAt: p.isVoid ? (p.voidedAt ?? p.createdAt ?? p.periodEnd) : null,
);

PayrollPaymentRecord paymentRecord(PayPayment p) => PayrollPaymentRecord(
  id: p.id,
  createdAt: p.createdAt,
  paidOn: p.paidOn,
  kind: payrollPaymentKind(p.kind),
  amount: _francs(p.amount),
  funding: payrollFunding(p.method),
  voidedAt: p.voided ? (p.voidedAt ?? p.paidOn) : null,
);

/// What was still owed on an advance when it was written off; null for any
/// advance not written off.
PayrollWriteOffRecord? writeOffRecord(Advance a) {
  if (a.status != AdvanceStatus.writtenOff) return null;
  final owed = _francs(a.amount - a.recovered);
  if (owed <= 0) return null;
  return PayrollWriteOffRecord(
    advanceId: a.id,
    createdAt: a.createdAt,
    writtenOffAt: a.writtenOffAt ?? a.createdAt ?? a.givenOn,
    amount: owed,
  );
}

/// Posts a business's pay book to its ledger and returns how many entries
/// were written. Overridden in tests.
typedef PayrollLedgerPoster =
    Future<int> Function({
      required String businessId,
      required List<PayrollPayslipRecord> payslips,
      required List<PayrollPaymentRecord> payments,
      required List<PayrollWriteOffRecord> writeOffs,
    });

/// Posts through Ditto, once Ditto is up. Before that it does nothing; the
/// next sync catches up.
final payrollLedgerPosterProvider = Provider<PayrollLedgerPoster>((ref) {
  return ({
    required businessId,
    required payslips,
    required payments,
    required writeOffs,
  }) async {
    if (!ref.read(dittoReadyProvider)) return 0;
    return PayrollJournalPoster(ref.read(dittoServiceProvider)).sync(
      businessId: businessId,
      payslips: payslips,
      payments: payments,
      writeOffs: writeOffs,
    );
  };
});

final payrollLedgerSyncProvider = Provider<PayrollLedgerSync>(
  PayrollLedgerSync.new,
);

class PayrollLedgerSync {
  PayrollLedgerSync(this._ref);

  final Ref _ref;

  /// Posts what [book] holds that [businessId]'s ledger does not. The caller
  /// names the business that owns the book; the current selection is never
  /// read, as it may have changed while the book loaded. Never throws.
  Future<int> syncBook(PayBook book, {required String businessId}) async {
    if (businessId.isEmpty) return 0;
    try {
      return await _ref.read(payrollLedgerPosterProvider)(
        businessId: businessId,
        payslips: [for (final p in book.payslips) payslipRecord(p)],
        payments: [for (final p in book.payments) paymentRecord(p)],
        writeOffs: [
          for (final a in book.advances)
            if (writeOffRecord(a) case final w?) w,
        ],
      );
    } catch (e) {
      debugPrint('[Payroll→Books] sync failed: $e');
      return 0;
    }
  }
}
