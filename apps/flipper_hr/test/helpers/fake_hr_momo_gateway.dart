import 'package:flipper_hr/features/billing/data/hr_momo_gateway.dart';

/// A Mobile Money gateway that never leaves the test.
///
/// [statuses] is played back one poll at a time, the last value repeating, so a
/// test can express "pending, pending, then settled" without any timing.
class FakeHrMomoGateway implements HrMomoGateway {
  FakeHrMomoGateway({
    this.reference = 'ref-1',
    List<HrMomoStatus>? statuses,
    this.reason,
    this.payFailure,
  }) : statuses = statuses ?? [HrMomoStatus.successful];

  final String reference;
  final List<HrMomoStatus> statuses;
  final String? reason;

  /// Thrown instead of submitting the charge, when set.
  Object? payFailure;

  final List<Map<String, Object?>> charges = [];
  final List<String> finalized = [];
  int polls = 0;

  @override
  Future<String> payPlan({
    required String planId,
    required String businessId,
    required String phoneNumber,
    required int amountRwf,
  }) async {
    charges.add({
      'planId': planId,
      'businessId': businessId,
      'phoneNumber': phoneNumber,
      'amountRwf': amountRwf,
    });
    if (payFailure != null) throw payFailure!;
    return reference;
  }

  @override
  Future<HrMomoSettlement> status(String reference) async {
    final index = polls < statuses.length ? polls : statuses.length - 1;
    polls++;
    return HrMomoSettlement(
      reference: reference,
      status: statuses[index],
      reason: reason,
    );
  }

  @override
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  }) async {
    finalized.add(reference);
  }
}
