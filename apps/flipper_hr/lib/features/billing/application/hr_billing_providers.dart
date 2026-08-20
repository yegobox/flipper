import 'package:flipper_hr/features/billing/data/hr_billing_repository.dart';
import 'package:flipper_hr/features/billing/data/hr_entitlement.dart';
import 'package:flipper_hr/features/billing/data/hr_momo_gateway.dart';
import 'package:flipper_hr/features/billing/data/supabase_hr_billing_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entitlement reads and purchases. Overridden with a fake in tests.
final hrBillingRepositoryProvider = Provider<HrBillingRepository>((ref) {
  return SupabaseHrBillingRepository(Supabase.instance.client);
});

/// The Mobile Money gateway. Overridden with a fake in tests so no test can
/// reach a real payment endpoint.
final hrMomoGatewayProvider = Provider<HrMomoGateway>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return HttpHrMomoGateway(client);
});

/// Whether a business has paid, keyed by business id.
///
/// Family-keyed rather than reading flipper_web's selection directly, so the
/// rule can be exercised in a plain [ProviderContainer] and so switching
/// business re-resolves instead of inheriting the previous answer. A null key
/// asks the server for the caller's own business, which is the case where HR
/// has not been through the selector yet.
///
/// Retry is off, matching the other HR reads: the paywall offers "Try again"
/// rather than refetching invisibly behind a lock.
final hrAccessStateProvider = FutureProvider.family<HrAccessState, String?>((
  ref,
  businessId,
) async {
  try {
    return await ref
        .watch(hrBillingRepositoryProvider)
        .fetchAccessState(businessId: businessId);
  } on HrBillingSchemaMissing {
    // Migration 0008 is not applied. Opening up is the lesser evil — locking
    // every existing business out of a paywall the project cannot yet satisfy
    // would be an outage — but it is reported loudly by [HrBillingNotice]
    // rather than passing silently for "everyone is entitled".
    return const HrAccessState.schemaMissing();
  }
}, retry: (retryCount, error) => null);

/// The entitlement as a plain value, defaulting to "unknown" while it loads or
/// after it fails.
///
/// Unknown grants access on purpose: the state resolves in milliseconds, and
/// showing a paywall to a paying customer because their network blinked is
/// worse than a beat of unlocked chrome. A failure is surfaced by the notice
/// strip, which reads the [AsyncValue] itself.
final hrAccessSnapshotProvider = Provider.family<HrAccessState, String?>((
  ref,
  businessId,
) {
  return ref.watch(hrAccessStateProvider(businessId)).value ??
      const HrAccessState.unknown();
});

/// What one plan costs this business, priced by the server.
final hrPlanQuoteProvider =
    FutureProvider.family<HrPlanQuote, HrQuoteRequest>((ref, request) async {
      // Re-quoted whenever entitlement changes: a payment alters both the seats
      // in use and whether there is anything left to buy.
      ref.watch(hrAccessStateProvider(request.businessId));
      return ref
          .watch(hrBillingRepositoryProvider)
          .quote(
            businessId: request.businessId,
            slug: request.slug,
            isYearly: request.isYearly,
          );
    }, retry: (retryCount, error) => null);

/// The key of [hrPlanQuoteProvider]: which business, which tier, which period.
class HrQuoteRequest {
  const HrQuoteRequest({
    required this.businessId,
    this.slug = 'basic',
    this.isYearly = false,
  });

  final String businessId;
  final String slug;
  final bool isYearly;

  @override
  bool operator ==(Object other) =>
      other is HrQuoteRequest &&
      other.businessId == businessId &&
      other.slug == slug &&
      other.isYearly == isYearly;

  @override
  int get hashCode => Object.hash(businessId, slug, isYearly);
}
