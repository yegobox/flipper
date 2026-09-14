import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/features/billing/data/books_entitlement.dart';
import 'package:flipper_web/features/billing/data/books_payment_rails.dart';
import 'package:flipper_web/features/billing/data/books_plan_repository.dart';
import 'package:flipper_web/features/billing/data/supabase_books_plan_repository.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// The business's `plans` row. Overridden with a fake in tests.
final booksPlanRepositoryProvider = Provider<BooksPlanRepository>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return SupabaseBooksPlanRepository(
    ref.watch(supabaseProvider),
    client,
    // Ditto holds a mirrored copy for the offline case; it answers only when
    // Supabase cannot, and is never allowed to override a fresh row.
    offlineFallback: (businessId) =>
        ref.read(dittoServiceProvider).getPaymentPlanFromDitto(businessId),
  );
});

/// MoMo and card, behind one seam. Overridden with a fake in tests so no test
/// can reach a real payment endpoint.
final booksPaymentRailsProvider = Provider<BooksPaymentRails>((ref) {
  return FlipperPaymentsRails();
});

/// The plans on sale — the same catalogue the mobile app shows, so a business
/// subscribed from a browser holds a plan the phone recognises.
final booksCatalogProvider = FutureProvider<SubscriptionPlanCatalog>((ref) {
  return SubscriptionPlanCatalog.fetchFromSupabase();
}, retry: (retryCount, error) => null);

/// Whether this build can offer a card option at all.
final booksCardRailAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.watch(booksPaymentRailsProvider).isCardAvailable();
  } catch (_) {
    return false;
  }
}, retry: (retryCount, error) => null);

/// How often the MoMo request-to-pay status is read. Shrunk to zero in tests.
final booksMomoPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 6),
);

/// How long to wait for the payer's PIN before giving up on the *poll*. The
/// charge may still settle afterwards, which is why the timeout wording never
/// says the payment failed.
final booksMomoPollTimeoutProvider = Provider<Duration>(
  (ref) => const Duration(minutes: 5),
);

/// How long to keep asking after the card checkout opened. Generous: a
/// 3-D Secure step on a phone is not done in thirty seconds.
final booksCardPollTimeoutProvider = Provider<Duration>(
  (ref) => DodoCardCheckout.defaultTimeout,
);

/// Whether a business has paid, keyed by business id.
///
/// Family-keyed so the rule can be exercised in a plain [ProviderContainer]
/// and so switching business re-resolves instead of inheriting the previous
/// answer. The selected business is watched too: on a page reload the
/// selection starts as a placeholder and is enriched from the profile a moment
/// later, and the Individual-business waiver depends on those fields.
///
/// Retry is off: the gate fails open on an error and offers "Try again"
/// rather than refetching invisibly behind a lock.
final booksAccessStateProvider =
    FutureProvider.family<BooksAccessState, String?>((ref, businessId) async {
  if (businessId == null || businessId.isEmpty) {
    return const BooksAccessState.unknown();
  }
  final business = ref.watch(selectedBusinessProvider);
  final plan = await ref.watch(booksPlanRepositoryProvider).fetchPlan(businessId);
  return evaluateBooksEntitlement(
    plan,
    now: DateTime.now(),
    businessTypeId: business?.id == businessId ? business?.businessTypeId : null,
    isDefault: business?.id == businessId ? (business?.isDefault ?? false) : false,
  );
}, retry: (retryCount, error) => null);

/// The entitlement as a plain value, "unknown" while it loads or after it
/// fails. Unknown grants access on purpose — see [BooksAccessState.grantsAccess].
final booksAccessSnapshotProvider =
    Provider.family<BooksAccessState, String?>((ref, businessId) {
  return ref.watch(booksAccessStateProvider(businessId)).value ??
      const BooksAccessState.unknown();
});

/// Live view of the business's plan row.
///
/// Watched by the gate for as long as it is on screen, so a payment settled
/// elsewhere — a phone paying for the same business, data-connector's sweep
/// landing a MoMo charge — re-reads entitlement and unlocks this tab without
/// a reload.
final booksPlanRealtimeProvider =
    StreamProvider.family<Plan?, String>((ref, businessId) {
  final repo = ref.watch(booksPlanRepositoryProvider);
  // Only a *change* in the row re-reads entitlement. The stream's first
  // emission is the row as it already stands, which the access read has seen.
  var seenFirst = false;
  var lastSignature = '';
  return repo.watchPlan(businessId).map((plan) {
    final signature = plan == null
        ? ''
        : '${plan.paymentCompletedByUser}|${plan.paymentStatus}|'
            '${plan.nextBillingDate?.toIso8601String()}';
    if (seenFirst && signature != lastSignature) {
      ref.invalidate(booksAccessStateProvider(businessId));
    }
    seenFirst = true;
    lastSignature = signature;
    return plan;
  });
}, retry: (retryCount, error) => null);
