import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';

/// Reads entitlement and starts subscriptions. Faked in tests.
abstract class HrBillingRepository {
  /// The business's subscription state. [businessId] null asks the server for
  /// the caller's own business, which is the single-business case.
  Future<HrAccessState> fetchAccessState({String? businessId});

  /// What [slug] costs for this business right now, priced server-side.
  Future<HrPlanQuote> quote({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
  });

  /// Writes the plan row at the quoted price and returns the id to charge.
  Future<HrSubscriptionStart> startSubscription({
    required String businessId,
    String slug = 'basic',
    bool isYearly = false,
    String? phoneNumber,
  });
}

/// A billing call that failed with something worth showing the user.
class HrBillingException implements Exception {
  const HrBillingException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

/// Supabase answered, but the billing functions are not there: migration 0008
/// has not been applied to this project.
///
/// Distinguished from a network failure on purpose. Treating the two the same
/// is what would make an unapplied migration look exactly like a healthy
/// unpaywalled app — nobody billed, nothing explaining why.
class HrBillingSchemaMissing implements Exception {
  const HrBillingSchemaMissing();

  @override
  String toString() =>
      'The billing schema is not installed on this Supabase project. Run '
      'supabase/migrations/0008_hr_billing.sql.';
}
