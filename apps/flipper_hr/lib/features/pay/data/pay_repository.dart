import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/rwanda_payroll.dart';
import 'package:flipper_hr/features/people/data/employee.dart';

/// Everything the pay book holds for one scope.
class PayBook {
  const PayBook({
    this.payslips = const [],
    this.payments = const [],
    this.advances = const [],
    this.requests = const [],
  });

  final List<Payslip> payslips;
  final List<PayPayment> payments;
  final List<Advance> advances;
  final List<AdvanceRequest> requests;
}

/// One advance taken back on a payslip.
class AdvanceRecovery {
  const AdvanceRecovery({required this.advanceId, required this.amount});
  final String advanceId;
  final double amount;
}

/// Money handed over with a payslip, in the same write.
class PaymentDraft {
  const PaymentDraft({
    required this.amount,
    required this.method,
    required this.paidOn,
    this.reference,
  });

  final double amount;
  final PaymentMethod method;
  final DateTime paidOn;
  final String? reference;
}

/// Backend-agnostic contract for the pay book.
///
/// Reads are by branch (the manager) or by employee (the person themselves);
/// RLS backs each, as for leave. Writes are the 0011 RPCs, so a payslip and its
/// recoveries and payment land together or not at all.
abstract class PayRepository {
  /// The branch's pay book since [since] (by payslip period end, payment date,
  /// advance date). Open advances are always included, however old.
  Future<PayBook> fetchForBranch({
    required String branchId,
    required DateTime since,
  });

  /// One person's whole pay book.
  Future<PayBook> fetchForEmployee({required String employeeId});

  Future<Payslip> createPayslip({
    required String employeeId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required PayslipFigures figures,
    List<AdvanceRecovery> recoveries = const [],
    PaymentDraft? payment,
    int? workedMinutes,
    String? note,
  });

  Future<PayPayment> recordPayment({
    required String employeeId,
    required PaymentKind kind,
    required double amount,
    required PaymentMethod method,
    required DateTime paidOn,
    String? payslipId,
    String? reference,
    String? note,
  });

  Future<Advance> giveAdvance({
    required String employeeId,
    required double amount,
    required PaymentMethod method,
    required DateTime givenOn,
    String? reference,
    String? reason,
    double? installmentAmount,
  });

  Future<void> voidPayslip({required String id, required String reason});
  Future<void> voidPayment({required String id, required String reason});
  Future<void> voidAdvance({required String id, required String reason});
  Future<void> writeOffAdvance({required String id, required String reason});

  /// The signed-in person asks for an advance.
  Future<AdvanceRequest> requestAdvance({
    required String employeeId,
    required double amount,
    String? reason,
  });

  Future<void> cancelAdvanceRequest({required String id});

  Future<void> approveAdvanceRequest({
    required String id,
    required PaymentMethod method,
    String? decidedBy,
    String? reference,
    double? installmentAmount,
    String? note,
  });

  Future<void> declineAdvanceRequest({
    required String id,
    String? decidedBy,
    String? note,
  });
}

/// Thrown when a pay call fails, so the UI shows one message rather than a
/// PostgrestException.
class PayRepositoryException implements Exception {
  PayRepositoryException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'PayRepositoryException: $message';
}
