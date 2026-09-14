import 'package:flipper_payments/flipper_payments.dart';

/// What the paywall wants written to the business's `plans` row before a
/// charge goes out.
///
/// The shape is the mobile app's (`CoreSync.saveOrUpdatePaymentPlan`): the
/// template's *name* in `selected_plan`, the cadence as `rule`, the client-side
/// total in `total_price`. Keeping the two writers identical is what lets a
/// phone and a browser agree on the same row.
class BooksPlanDraft {
  const BooksPlanDraft({
    required this.businessId,
    required this.selectedPlan,
    required this.cadence,
    required this.totalPrice,
    required this.paymentMethod,
    this.branchId,
    this.planTemplateId,
    this.additionalDevices = 0,
    this.addonNames = const [],
    this.numberOfPayments = 1,
    this.phoneNumber,
    this.existing,
  });

  final String businessId;
  final String? branchId;

  /// The catalogue template's display name — what mobile stores.
  final String selectedPlan;
  final String? planTemplateId;
  final int additionalDevices;
  final BillingCadence cadence;

  /// Whole francs; `plans.total_price` is an integer column.
  final int totalPrice;

  /// A [PaymentRail] wire value: `MTNMOMO` or `DODO`.
  final String paymentMethod;
  final List<String> addonNames;
  final int numberOfPayments;

  /// Stored on the row so a renewal can offer the number that paid last time.
  final String? phoneNumber;

  /// The row being replaced, when the business already has one. Its id and
  /// `created_at` are kept so the business keeps one plan, not a history.
  final Plan? existing;

  bool get isYearly => cadence.isYearly;
}

/// The business's subscription row and the two best-effort nudges that keep
/// the rest of the system in step with it.
abstract class BooksPlanRepository {
  /// The current row, or null for a business that has never subscribed.
  Future<Plan?> fetchPlan(String businessId);

  /// Live view of the row. Emits null while there is none.
  Stream<Plan?> watchPlan(String businessId);

  /// Writes the row (and any new add-ons) and returns what was written.
  Future<Plan> savePlan(BooksPlanDraft draft);

  /// Asks the backend to push this row into Ditto now rather than on its next
  /// sweep, so a phone that is offline-first sees the new plan promptly.
  Future<void> nudgeDittoSync(String planId);

  /// Tells the backend a MoMo charge succeeded so the row is settled now
  /// rather than on the next settlement sweep.
  Future<void> finalizeOnSuccess({
    required String planId,
    required String reference,
  });
}
