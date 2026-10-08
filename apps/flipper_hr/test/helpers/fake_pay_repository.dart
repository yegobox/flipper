import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/people/data/employee.dart';

/// In-memory pay book that keeps the same derived state the database's
/// triggers keep (paid amount, recovered amount, statuses), so pages under test
/// see what they would see against Postgres.
class FakePayRepository implements PayRepository {
  FakePayRepository({
    List<Payslip>? payslips,
    List<PayPayment>? payments,
    List<Advance>? advances,
    List<AdvanceRequest>? requests,
    this.failWith,
  }) : payslips = [...?payslips],
       payments = [...?payments],
       advances = [...?advances],
       requests = [...?requests];

  final List<Payslip> payslips;
  final List<PayPayment> payments;
  final List<Advance> advances;
  final List<AdvanceRequest> requests;
  final Map<String, List<AdvanceRecovery>> recoveriesBySlip = {};
  Object? failWith;
  int _id = 0;
  int createCount = 0;

  String _next() => 'fake-${++_id}';

  void _check() {
    final f = failWith;
    if (f != null) throw f;
  }

  PayBook _book(bool Function(String employeeId) include) => PayBook(
    payslips: [
      for (final p in payslips)
        if (include(p.employeeId)) p,
    ],
    payments: [
      for (final p in payments)
        if (include(p.employeeId)) p,
    ],
    advances: [
      for (final a in advances)
        if (include(a.employeeId)) a,
    ],
    requests: [
      for (final r in requests)
        if (include(r.employeeId)) r,
    ],
  );

  @override
  Future<PayBook> fetchForBranch({
    required String branchId,
    required DateTime since,
  }) async {
    _check();
    return _book((_) => true);
  }

  @override
  Future<PayBook> fetchForEmployee({required String employeeId}) async {
    _check();
    return _book((id) => id == employeeId);
  }

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
  }) async {
    _check();
    createCount++;
    final recovery = recoveries.fold(0.0, (s, r) => s + r.amount);
    final net = figures.netAfter(recovery);
    final paid = payment?.amount ?? 0;
    final slip = Payslip(
      id: _next(),
      employeeId: employeeId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      currency: 'RWF',
      basePay: figures.basePay,
      allowances: figures.allowances,
      extraEarnings: figures.extraEarnings,
      gross: figures.gross,
      paye: figures.paye,
      pensionEmployee: figures.pensionEmployee,
      maternityEmployee: figures.maternityEmployee,
      cbhi: figures.cbhi,
      otherDeductions: figures.otherDeductions,
      advanceRecovery: recovery,
      netPay: net,
      pensionEmployer: figures.pensionEmployer,
      maternityEmployer: figures.maternityEmployer,
      occupationalHazards: figures.occupationalHazards,
      paidAmount: paid,
      status: paid >= net
          ? PayslipStatus.paid
          : paid > 0
          ? PayslipStatus.partiallyPaid
          : PayslipStatus.unpaid,
      ratesVersion: figures.rates.version,
      workedMinutes: workedMinutes,
      note: note,
    );
    payslips.insert(0, slip);
    recoveriesBySlip[slip.id] = recoveries;
    for (final r in recoveries) {
      final i = advances.indexWhere((a) => a.id == r.advanceId);
      final a = advances[i];
      final recovered = a.recovered + r.amount;
      advances[i] = _advance(a, recovered: recovered);
    }
    if (payment != null && payment.amount > 0) {
      payments.insert(
        0,
        PayPayment(
          id: _next(),
          employeeId: employeeId,
          kind: PaymentKind.salary,
          amount: payment.amount,
          currency: 'RWF',
          paidOn: payment.paidOn,
          method: payment.method,
          reference: payment.reference,
          payslipId: slip.id,
        ),
      );
    }
    return slip;
  }

  Advance _advance(Advance a, {double? recovered, AdvanceStatus? status}) {
    final r = recovered ?? a.recovered;
    return Advance(
      id: a.id,
      employeeId: a.employeeId,
      amount: a.amount,
      currency: a.currency,
      givenOn: a.givenOn,
      method: a.method,
      recovered: r,
      status: status ?? (r >= a.amount ? AdvanceStatus.recovered : a.status),
      reason: a.reason,
      installmentAmount: a.installmentAmount,
    );
  }

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
  }) async {
    _check();
    final p = PayPayment(
      id: _next(),
      employeeId: employeeId,
      kind: kind,
      amount: amount,
      currency: 'RWF',
      paidOn: paidOn,
      method: method,
      reference: reference,
      note: note,
      payslipId: payslipId,
    );
    payments.insert(0, p);
    return p;
  }

  @override
  Future<Advance> giveAdvance({
    required String employeeId,
    required double amount,
    required PaymentMethod method,
    required DateTime givenOn,
    String? reference,
    String? reason,
    double? installmentAmount,
  }) async {
    _check();
    final a = Advance(
      id: _next(),
      employeeId: employeeId,
      amount: amount,
      currency: 'RWF',
      givenOn: givenOn,
      method: method,
      recovered: 0,
      status: AdvanceStatus.open,
      reason: reason,
      installmentAmount: installmentAmount,
    );
    advances.insert(0, a);
    payments.insert(
      0,
      PayPayment(
        id: _next(),
        employeeId: employeeId,
        kind: PaymentKind.advance,
        amount: amount,
        currency: 'RWF',
        paidOn: givenOn,
        method: method,
        advanceId: a.id,
      ),
    );
    return a;
  }

  @override
  Future<void> voidPayslip({required String id, required String reason}) async {
    _check();
    final i = payslips.indexWhere((p) => p.id == id);
    final s = payslips[i];
    payslips[i] = Payslip(
      id: s.id,
      employeeId: s.employeeId,
      periodStart: s.periodStart,
      periodEnd: s.periodEnd,
      currency: s.currency,
      basePay: s.basePay,
      allowances: s.allowances,
      extraEarnings: s.extraEarnings,
      gross: s.gross,
      paye: s.paye,
      pensionEmployee: s.pensionEmployee,
      maternityEmployee: s.maternityEmployee,
      cbhi: s.cbhi,
      otherDeductions: s.otherDeductions,
      advanceRecovery: s.advanceRecovery,
      netPay: s.netPay,
      pensionEmployer: s.pensionEmployer,
      maternityEmployer: s.maternityEmployer,
      occupationalHazards: s.occupationalHazards,
      paidAmount: 0,
      status: PayslipStatus.voided,
      voidReason: reason,
    );
  }

  @override
  Future<void> voidPayment({required String id, required String reason}) async {
    _check();
    final i = payments.indexWhere((p) => p.id == id);
    final p = payments[i];
    payments[i] = PayPayment(
      id: p.id,
      employeeId: p.employeeId,
      kind: p.kind,
      amount: p.amount,
      currency: p.currency,
      paidOn: p.paidOn,
      method: p.method,
      payslipId: p.payslipId,
      advanceId: p.advanceId,
      voided: true,
      voidReason: reason,
    );
  }

  @override
  Future<void> voidAdvance({required String id, required String reason}) async {
    _check();
    final i = advances.indexWhere((a) => a.id == id);
    advances[i] = _advance(advances[i], status: AdvanceStatus.voided);
  }

  @override
  Future<void> writeOffAdvance({
    required String id,
    required String reason,
  }) async {
    _check();
    final i = advances.indexWhere((a) => a.id == id);
    advances[i] = _advance(advances[i], status: AdvanceStatus.writtenOff);
  }

  @override
  Future<AdvanceRequest> requestAdvance({
    required String employeeId,
    required double amount,
    String? reason,
  }) async {
    _check();
    final r = AdvanceRequest(
      id: _next(),
      employeeId: employeeId,
      amount: amount,
      status: AdvanceRequestStatus.pending,
      createdAt: DateTime(2026, 10, 20),
      reason: reason,
    );
    requests.insert(0, r);
    return r;
  }

  void _setRequest(String id, AdvanceRequestStatus status, {String? advance}) {
    final i = requests.indexWhere((r) => r.id == id);
    final r = requests[i];
    requests[i] = AdvanceRequest(
      id: r.id,
      employeeId: r.employeeId,
      amount: r.amount,
      status: status,
      createdAt: r.createdAt,
      reason: r.reason,
      advanceId: advance,
    );
  }

  @override
  Future<void> cancelAdvanceRequest({required String id}) async {
    _check();
    _setRequest(id, AdvanceRequestStatus.cancelled);
  }

  @override
  Future<void> approveAdvanceRequest({
    required String id,
    required PaymentMethod method,
    String? decidedBy,
    String? reference,
    double? installmentAmount,
    String? note,
  }) async {
    _check();
    final r = requests.firstWhere((r) => r.id == id);
    final a = await giveAdvance(
      employeeId: r.employeeId,
      amount: r.amount,
      method: method,
      givenOn: DateTime(2026, 10, 21),
      reason: r.reason,
      installmentAmount: installmentAmount,
    );
    _setRequest(id, AdvanceRequestStatus.approved, advance: a.id);
  }

  @override
  Future<void> declineAdvanceRequest({
    required String id,
    String? decidedBy,
    String? note,
  }) async {
    _check();
    _setRequest(id, AdvanceRequestStatus.declined);
  }
}
