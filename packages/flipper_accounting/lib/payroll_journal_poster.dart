/// Posts HR payroll to the Books ledger.
///
/// HR keeps its pay book in Supabase (`hr_payslips`, `hr_payments`,
/// `hr_advances`). Books never saw it, so salaries were missing from profit
/// and nothing showed what is owed to RRA (PAYE) and RSSB. This poster writes
/// one posted entry per pay-book record:
///
/// | Record | Debit | Credit |
/// |---|---|---|
/// | Payslip | 6020 gross, 6025 employer RSSB | 2310 PAYE, 2320 all RSSB, 1150 advance recovered, 2300 the rest |
/// | Salary paid | 2300 | cash / MoMo / bank |
/// | Advance given | 1150 | cash / MoMo / bank |
/// | Other or reimbursement paid | 6000 | cash / MoMo / bank |
/// | Advance written off | 6020 | 1150 |
/// | Any of these voided | the original entry, sides swapped |
///
/// Ids are deterministic, so posting is idempotent: [PayrollJournalPoster.sync]
/// can run after every pay action and on every Pay page load, from any device,
/// and each record is posted once.
///
/// Only records created on or after [payrollLedgerStart] are posted: anything
/// older may already be in Books by hand, and posting it would count it twice.
///
/// Memos never name the employee: Books users are not necessarily allowed to
/// see who earns what.
library;

import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/journal_entry_id.dart';
import 'package:flipper_accounting/statutory_accounts.dart';
import 'package:flutter/foundation.dart';

/// Pay-book records created before this are never posted (see library doc).
final payrollLedgerStart = DateTime.utc(2026, 11, 17);

/// How money left the business.
enum PayrollFunding { cash, mobileMoney, bank }

/// What a pay-book payment was for.
enum PayrollPaymentKind { salary, advance, reimbursement, other }

/// A payslip's figures, in whole francs.
class PayrollPayslipRecord {
  const PayrollPayslipRecord({
    required this.id,
    required this.createdAt,
    required this.periodEnd,
    required this.gross,
    required this.paye,
    required this.employeeRssb,
    required this.employerRssb,
    required this.advanceRecovery,
    this.voidedAt,
  });

  final String id;
  final DateTime? createdAt;
  final DateTime periodEnd;
  final DateTime? voidedAt;
  final int gross;
  final int paye;

  /// Pension, maternity and CBHI withheld from the employee.
  final int employeeRssb;

  /// Pension, maternity and occupational hazards the employer adds.
  final int employerRssb;
  final int advanceRecovery;
}

/// Money handed over from the pay book.
class PayrollPaymentRecord {
  const PayrollPaymentRecord({
    required this.id,
    required this.createdAt,
    required this.paidOn,
    required this.kind,
    required this.amount,
    required this.funding,
    this.voidedAt,
  });

  final String id;
  final DateTime? createdAt;
  final DateTime paidOn;
  final DateTime? voidedAt;
  final PayrollPaymentKind kind;
  final int amount;
  final PayrollFunding funding;
}

/// An advance the business gave up on recovering.
class PayrollWriteOffRecord {
  const PayrollWriteOffRecord({
    required this.advanceId,
    required this.createdAt,
    required this.writtenOffAt,
    required this.amount,
  });

  final String advanceId;

  /// When the advance was given (decides [payrollLedgerStart]).
  final DateTime? createdAt;
  final DateTime writtenOffAt;

  /// What was still owed when it was written off.
  final int amount;
}

/// One entry [PayrollJournalPoster.sync] wants in the ledger.
class PayrollPosting {
  const PayrollPosting({
    required this.entryId,
    required this.ref,
    required this.date,
    required this.memo,
    required this.lines,
  });

  final String entryId;

  /// Short reference shown in the Journal (`PAY-1a2b3c4d`).
  final String ref;
  final DateTime date;
  final String memo;
  final List<JournalLine> lines;
}

class PayrollJournalPoster {
  PayrollJournalPoster(this._ditto);

  final AccountingDittoStore _ditto;

  static String payslipEntryId(String businessId, String payslipId) =>
      'je_${businessId}_payslip_${slugifyJournalIdPart(payslipId)}';

  static String paymentEntryId(String businessId, String paymentId) =>
      'je_${businessId}_hrpay_${slugifyJournalIdPart(paymentId)}';

  static String writeOffEntryId(String businessId, String advanceId) =>
      'je_${businessId}_advwo_${slugifyJournalIdPart(advanceId)}';

  static String voidEntryId(String entryId) => '${entryId}_void';

  static bool _inScope(DateTime? createdAt) =>
      createdAt != null && !createdAt.isBefore(payrollLedgerStart);

  static String _funding(PayrollFunding f) => switch (f) {
    PayrollFunding.cash => '1010',
    PayrollFunding.mobileMoney => '1030',
    PayrollFunding.bank => '1020',
  };

  /// The accrual: what the period cost and who is owed it.
  ///
  /// Net pay owed (2300) is whatever balances the entry, so it absorbs any
  /// other deduction and the entry can never be off by a rounding franc.
  static List<JournalLine> payslipLines(PayrollPayslipRecord p) {
    final debit = p.gross + p.employerRssb;
    final rssb = p.employeeRssb + p.employerRssb;
    final wages = debit - p.paye - rssb - p.advanceRecovery;
    return [
      if (p.gross > 0) JournalLine(ac: salariesCode, dr: p.gross),
      if (p.employerRssb > 0)
        JournalLine(ac: employerRssbCode, dr: p.employerRssb),
      if (p.paye > 0) JournalLine(ac: payePayableCode, cr: p.paye),
      if (rssb > 0) JournalLine(ac: rssbPayableCode, cr: rssb),
      if (p.advanceRecovery > 0)
        JournalLine(ac: staffAdvancesCode, cr: p.advanceRecovery),
      if (wages > 0) JournalLine(ac: wagesPayableCode, cr: wages),
      if (wages < 0) JournalLine(ac: wagesPayableCode, dr: -wages),
    ];
  }

  static List<JournalLine> paymentLines(PayrollPaymentRecord p) {
    final debit = switch (p.kind) {
      PayrollPaymentKind.salary => wagesPayableCode,
      PayrollPaymentKind.advance => staffAdvancesCode,
      PayrollPaymentKind.reimbursement || PayrollPaymentKind.other => '6000',
    };
    return [
      JournalLine(ac: debit, dr: p.amount),
      JournalLine(ac: _funding(p.funding), cr: p.amount),
    ];
  }

  static List<JournalLine> writeOffLines(PayrollWriteOffRecord w) => [
    JournalLine(ac: salariesCode, dr: w.amount),
    JournalLine(ac: staffAdvancesCode, cr: w.amount),
  ];

  static List<JournalLine> reversed(List<JournalLine> lines) => [
    for (final l in lines) JournalLine(ac: l.ac, dr: l.cr, cr: l.dr),
  ];

  /// Every entry the records call for, whether or not it is posted yet.
  static List<PayrollPosting> plan({
    required String businessId,
    Iterable<PayrollPayslipRecord> payslips = const [],
    Iterable<PayrollPaymentRecord> payments = const [],
    Iterable<PayrollWriteOffRecord> writeOffs = const [],
  }) {
    final out = <PayrollPosting>[];

    void add(
      String id,
      String recordId,
      DateTime date,
      String memo,
      List<JournalLine> lines,
      DateTime? voidedAt,
    ) {
      if (lines.isEmpty) return;
      final short = slugifyJournalIdPart(recordId);
      final ref = 'PAY-${short.length > 8 ? short.substring(0, 8) : short}';
      out.add(
        PayrollPosting(
          entryId: id,
          ref: ref,
          date: date,
          memo: memo,
          lines: lines,
        ),
      );
      if (voidedAt != null) {
        out.add(
          PayrollPosting(
            entryId: voidEntryId(id),
            ref: '$ref-VOID',
            date: voidedAt,
            memo: 'Void: $memo',
            lines: reversed(lines),
          ),
        );
      }
    }

    for (final p in payslips) {
      if (!_inScope(p.createdAt)) continue;
      add(
        payslipEntryId(businessId, p.id),
        p.id,
        p.periodEnd,
        'Payroll ${billDateFormat.format(p.periodEnd)}',
        payslipLines(p),
        p.voidedAt,
      );
    }
    for (final p in payments) {
      if (!_inScope(p.createdAt) || p.amount <= 0) continue;
      add(
        paymentEntryId(businessId, p.id),
        p.id,
        p.paidOn,
        switch (p.kind) {
          PayrollPaymentKind.salary => 'Salary paid',
          PayrollPaymentKind.advance => 'Salary advance given',
          PayrollPaymentKind.reimbursement => 'Staff reimbursement',
          PayrollPaymentKind.other => 'Staff payment',
        },
        paymentLines(p),
        p.voidedAt,
      );
    }
    for (final w in writeOffs) {
      if (!_inScope(w.createdAt) || w.amount <= 0) continue;
      add(
        writeOffEntryId(businessId, w.advanceId),
        w.advanceId,
        w.writtenOffAt,
        'Salary advance written off',
        writeOffLines(w),
        null,
      );
    }
    return out;
  }

  /// Posts whatever [plan] wants that the ledger does not hold yet. Returns
  /// how many entries were written.
  ///
  /// Two reads however many records there are: one for the entries already
  /// posted and one for the chart, so a long pay book costs no per-record
  /// Ditto round trip.
  Future<int> sync({
    required String businessId,
    Iterable<PayrollPayslipRecord> payslips = const [],
    Iterable<PayrollPaymentRecord> payments = const [],
    Iterable<PayrollWriteOffRecord> writeOffs = const [],
  }) async {
    if (businessId.isEmpty || !_ditto.isReady()) return 0;
    final wanted = plan(
      businessId: businessId,
      payslips: payslips,
      payments: payments,
      writeOffs: writeOffs,
    );
    if (wanted.isEmpty) return 0;

    final posted = await _ditto.queryCollection(
      'journal_entries',
      'SELECT _id FROM journal_entries WHERE _id IN :ids',
      {
        'ids': [for (final p in wanted) p.entryId],
      },
    );
    final have = {for (final r in posted) (r['_id'] ?? r['id']).toString()};
    final missing = [
      for (final p in wanted)
        if (!have.contains(p.entryId)) p,
    ];
    if (missing.isEmpty) return 0;

    final ledger = DittoAccountingLedgerRepository(_ditto);
    await ledger.ensureSeeded(businessId: businessId);
    final chart = await _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT code FROM chart_of_accounts WHERE businessId = :businessId',
      {'businessId': businessId},
    );
    await ensureChartAccounts(
      ledger,
      businessId: businessId,
      codes: [
        for (final p in missing)
          for (final l in p.lines) l.ac,
      ],
      existingCodes: {for (final r in chart) '${r['code']}'},
    );

    var written = 0;
    for (final p in missing) {
      try {
        await ledger.createJournalEntry(
          businessId: businessId,
          entry: JournalEntry(
            id: p.ref,
            date: billDateFormat.format(p.date),
            memo: p.memo,
            ref: p.ref,
            status: JournalStatus.posted,
            src: 'Payroll',
            lines: p.lines,
          ),
          journalCode: 'misc',
          entryId: p.entryId,
        );
        await ledger.postJournalEntry(
          businessId: businessId,
          entryId: p.entryId,
        );
        written++;
      } catch (e) {
        // The next sync retries it; one bad record must not stop the rest.
        debugPrint('[Payroll→Books] ${p.entryId} not posted: $e');
      }
    }
    return written;
  }
}
