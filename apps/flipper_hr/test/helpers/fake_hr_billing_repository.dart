import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';

/// In-memory billing backend.
///
/// Holds one access state and one quote, and records what was asked of it, so a
/// test can assert both what the screen showed and what it sent.
class FakeHrBillingRepository implements HrBillingRepository {
  FakeHrBillingRepository({
    HrAccessState? access,
    HrPlanQuote? quote,
    this.startResult,
    this.failure,
  }) : access = access ?? entitledState(),
       planQuote = quote ?? basicQuote();

  HrAccessState access;

  /// Named to avoid colliding with the repository's own `quote()` call.
  HrPlanQuote planQuote;
  HrSubscriptionStart? startResult;

  /// Thrown by every call when set.
  Object? failure;

  final List<String?> accessReads = [];
  final List<Map<String, Object?>> starts = [];

  @override
  Future<HrAccessState> fetchAccessState({String? businessId}) async {
    accessReads.add(businessId);
    if (failure != null) throw failure!;
    return access;
  }

  @override
  Future<HrPlanQuote> quote({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
  }) async {
    if (failure != null) throw failure!;
    return planQuote;
  }

  @override
  Future<HrSubscriptionStart> startSubscription({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
    String? phoneNumber,
  }) async {
    starts.add({
      'businessId': businessId,
      'slug': slug,
      'isYearly': isYearly,
      'phoneNumber': phoneNumber,
    });
    if (failure != null) throw failure!;
    return startResult ??
        const HrSubscriptionStart(planId: 'plan-1', amountRwf: 350000);
  }
}

/// The Basic package as `hr_plan_quote()` returns it.
HrPlanQuote basicQuote({
  int amountRwf = 350000,
  int? fullAmountRwf,
  bool testMode = false,
  bool isYearly = false,
  HrPlanAllowance allowance = const HrPlanAllowance(
    maxPosUsers: 5,
    maxBranches: 1,
    maxHrEmployees: 50,
    posUsersUsed: 2,
    branchesUsed: 1,
    employeesUsed: 12,
  ),
}) {
  return HrPlanQuote(
    businessId: 'biz-1',
    templateId: 'a0000004-0000-4000-8000-000000000004',
    slug: 'basic',
    name: 'Basic',
    description: 'Flipper POS, Books and HR for one branch',
    features: const [
      'All Flipper apps — POS, Books and HR',
      'Up to 5 POS users',
      '1 branch',
      'Up to 50 HR employees',
    ],
    monthlyPrice: 350000,
    isYearly: isYearly,
    amountRwf: amountRwf,
    fullAmountRwf: fullAmountRwf ?? 350000,
    testMode: testMode,
    periodDays: isYearly ? 365 : 30,
    allowance: allowance,
  );
}

HrAccessState entitledState({DateTime? validUntil}) => HrAccessState(
  status: HrAccessStatus.entitled,
  businessId: 'biz-1',
  planId: 'plan-1',
  planName: 'Basic',
  slug: 'basic',
  amountRwf: 350000,
  paymentStatus: 'COMPLETED',
  validUntil: validUntil ?? DateTime.now().add(const Duration(days: 20)),
);

HrAccessState unpaidState({DateTime? validUntil, String? paymentStatus}) =>
    HrAccessState(
      status: validUntil == null
          ? HrAccessStatus.needsSetup
          : HrAccessStatus.needsPayment,
      businessId: 'biz-1',
      planId: validUntil == null ? null : 'plan-1',
      slug: 'basic',
      paymentStatus: paymentStatus,
      validUntil: validUntil,
    );
