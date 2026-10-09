import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/employee_row_mapper.dart';
import 'package:flipper_hr/features/people/data/supabase_employee_repository.dart'
    show describeBackendError;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-backed pay book. Tables, triggers and RPCs live in
/// `supabase/migrations/0011_hr_payroll.sql`.
class SupabasePayRepository implements PayRepository {
  const SupabasePayRepository(this._client);

  final SupabaseClient _client;

  static String _d(DateTime d) => EmployeeRowMapper.formatDate(d);

  Future<T> _guard<T>(String friendly, Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw PayRepositoryException(describeBackendError(friendly, e), cause: e);
    }
  }

  @override
  Future<PayBook> fetchForBranch({
    required String branchId,
    required DateTime since,
  }) => _guard(FlipperL10n.current.hrPayErrorLoad, () async {
    final from = _d(since);
    final results = await Future.wait([
      _client
          .from('hr_payslips')
          .select()
          .eq('branch_id', branchId)
          .gte('period_end', from)
          .order('period_end', ascending: false),
      _client
          .from('hr_payments')
          .select()
          .eq('branch_id', branchId)
          .gte('paid_on', from)
          .order('paid_on', ascending: false),
      // Open advances are owed however old they are; closed ones only matter
      // within the window.
      _client
          .from('hr_advances')
          .select()
          .eq('branch_id', branchId)
          .or('status.eq.open,given_on.gte.$from')
          .order('given_on', ascending: false),
      _client
          .from('hr_advance_requests')
          .select()
          .eq('branch_id', branchId)
          .order('created_at', ascending: false)
          .limit(200),
    ]);
    return PayBook(
      payslips: [for (final r in results[0]) Payslip.fromRow(r)],
      payments: [for (final r in results[1]) PayPayment.fromRow(r)],
      advances: [for (final r in results[2]) Advance.fromRow(r)],
      requests: [for (final r in results[3]) AdvanceRequest.fromRow(r)],
    );
  });

  @override
  Future<PayBook> fetchForEmployee({required String employeeId}) =>
      _guard(FlipperL10n.current.hrPayErrorLoad, () async {
        final results = await Future.wait([
          _client
              .from('hr_payslips')
              .select()
              .eq('employee_id', employeeId)
              .order('period_end', ascending: false),
          _client
              .from('hr_payments')
              .select()
              .eq('employee_id', employeeId)
              .order('paid_on', ascending: false),
          _client
              .from('hr_advances')
              .select()
              .eq('employee_id', employeeId)
              .order('given_on', ascending: false),
          _client
              .from('hr_advance_requests')
              .select()
              .eq('employee_id', employeeId)
              .order('created_at', ascending: false),
        ]);
        return PayBook(
          payslips: [for (final r in results[0]) Payslip.fromRow(r)],
          payments: [for (final r in results[1]) PayPayment.fromRow(r)],
          advances: [for (final r in results[2]) Advance.fromRow(r)],
          requests: [for (final r in results[3]) AdvanceRequest.fromRow(r)],
        );
      });

  @override
  Future<Payslip> createPayslip({
    required String employeeId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required PayslipFigures figures,
    List<AdvanceRecovery> recoveries = const [],
    PaymentDraft? payment,
    int? workedMinutes,
    String? note,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    final row = await _client.rpc(
      'hr_create_payslip',
      params: {
        'p_employee_id': employeeId,
        'p_period_start': _d(periodStart),
        'p_period_end': _d(periodEnd),
        'p_base_pay': figures.basePay,
        'p_allowances': figures.allowances,
        'p_extra_earnings': figures.extraEarnings,
        'p_paye': figures.paye,
        'p_pension_employee': figures.pensionEmployee,
        'p_maternity_employee': figures.maternityEmployee,
        'p_cbhi': figures.cbhi,
        'p_other_deductions': figures.otherDeductions,
        'p_pension_employer': figures.pensionEmployer,
        'p_maternity_employer': figures.maternityEmployer,
        'p_occupational_hazards': figures.occupationalHazards,
        'p_rates_version': figures.rates.version,
        'p_worked_minutes': workedMinutes,
        'p_note': note,
        'p_recoveries': [
          for (final r in recoveries)
            if (r.amount > 0) {'advance_id': r.advanceId, 'amount': r.amount},
        ],
        'p_payment': payment == null || payment.amount <= 0
            ? null
            : {
                'amount': payment.amount,
                'method': payment.method.wire,
                'reference': payment.reference,
                'paid_on': _d(payment.paidOn),
              },
      },
    );
    return Payslip.fromRow(Map<String, dynamic>.from(row as Map));
  });

  @override
  Future<PayPayment> recordPayment({
    required String employeeId,
    required PaymentKind kind,
    required double amount,
    required PaymentMethod method,
    required DateTime paidOn,
    String? payslipId,
    String? reference,
    String? note,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    final row = await _client
        .from('hr_payments')
        .insert({
          'employee_id': employeeId,
          'kind': kind.wire,
          'amount': amount,
          'method': method.wire,
          'paid_on': _d(paidOn),
          'payslip_id': payslipId,
          'reference': _blankToNull(reference),
          'note': _blankToNull(note),
        })
        .select()
        .single();
    return PayPayment.fromRow(row);
  });

  @override
  Future<Advance> giveAdvance({
    required String employeeId,
    required double amount,
    required PaymentMethod method,
    required DateTime givenOn,
    String? reference,
    String? reason,
    double? installmentAmount,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    final row = await _client.rpc(
      'hr_give_advance',
      params: {
        'p_employee_id': employeeId,
        'p_amount': amount,
        'p_given_on': _d(givenOn),
        'p_method': method.wire,
        'p_reference': _blankToNull(reference),
        'p_reason': _blankToNull(reason),
        'p_installment_amount': installmentAmount,
      },
    );
    return Advance.fromRow(Map<String, dynamic>.from(row as Map));
  });

  Future<void> _void(String table, String id, String reason) =>
      _guard(FlipperL10n.current.hrPayErrorSave, () async {
        await _client
            .from(table)
            .update({
              'voided_at': DateTime.now().toUtc().toIso8601String(),
              'void_reason': reason.trim(),
            })
            .eq('id', id);
      });

  @override
  Future<void> voidPayslip({required String id, required String reason}) =>
      _void('hr_payslips', id, reason);

  @override
  Future<void> voidPayment({required String id, required String reason}) =>
      _void('hr_payments', id, reason);

  @override
  Future<void> voidAdvance({required String id, required String reason}) =>
      _void('hr_advances', id, reason);

  @override
  Future<void> writeOffAdvance({required String id, required String reason}) =>
      _guard(FlipperL10n.current.hrPayErrorSave, () async {
        await _client
            .from('hr_advances')
            .update({
              'written_off_at': DateTime.now().toUtc().toIso8601String(),
              'write_off_reason': reason.trim(),
            })
            .eq('id', id);
      });

  @override
  Future<AdvanceRequest> requestAdvance({
    required String employeeId,
    required double amount,
    String? reason,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    final row = await _client
        .from('hr_advance_requests')
        .insert({
          'employee_id': employeeId,
          'amount': amount,
          'reason': _blankToNull(reason),
        })
        .select()
        .single();
    return AdvanceRequest.fromRow(row);
  });

  @override
  Future<void> cancelAdvanceRequest({required String id}) =>
      _guard(FlipperL10n.current.hrPayErrorSave, () async {
        await _client
            .from('hr_advance_requests')
            .update({'status': AdvanceRequestStatus.cancelled.wire})
            .eq('id', id);
      });

  @override
  Future<void> approveAdvanceRequest({
    required String id,
    required PaymentMethod method,
    String? decidedBy,
    String? reference,
    double? installmentAmount,
    String? note,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    await _client.rpc(
      'hr_approve_advance_request',
      params: {
        'p_request_id': id,
        'p_decided_by': decidedBy,
        'p_method': method.wire,
        'p_reference': _blankToNull(reference),
        'p_installment_amount': installmentAmount,
        'p_note': _blankToNull(note),
      },
    );
  });

  @override
  Future<void> declineAdvanceRequest({
    required String id,
    String? decidedBy,
    String? note,
  }) => _guard(FlipperL10n.current.hrPayErrorSave, () async {
    await _client
        .from('hr_advance_requests')
        .update({
          'status': AdvanceRequestStatus.declined.wire,
          'decided_by': decidedBy,
          'decided_at': DateTime.now().toUtc().toIso8601String(),
          'decision_note': _blankToNull(note),
        })
        .eq('id', id);
  });

  static String? _blankToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
