import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flipper_web/features/custom_payment/data/billing_staff_repository.dart';
import 'package:flipper_web/features/custom_payment/data/business_search_repository.dart';
import 'package:flipper_web/features/custom_payment/data/custom_payment_api.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the signed-in user's `billing_staff` row. Overridden in tests.
final billingStaffRepositoryProvider = Provider<BillingStaffRepository>((ref) {
  return SupabaseBillingStaffRepository(ref.watch(supabaseProvider));
});

/// Finds businesses by name / phone / email / id. Overridden in tests.
final businessSearchRepositoryProvider = Provider<BusinessSearchRepository>((
  ref,
) {
  return SupabaseBusinessSearchRepository(ref.watch(supabaseProvider));
});

/// Builds the connector client for a staff member. Overridden in tests so
/// nothing can reach a real payment route.
final customPaymentApiFactoryProvider =
    Provider<CustomPaymentApi Function(BillingStaffMember member)>((ref) {
      return (member) =>
          FlipperPaymentsCustomPaymentApi(staffToken: member.staffToken);
    });

/// The signed-in user as billing staff, or null. Re-resolves on sign-in /
/// sign-out, which is what `authStateProvider` changes on.
final billingStaffMemberProvider = FutureProvider<BillingStaffMember?>((
  ref,
) async {
  final auth = ref.watch(authStateProvider).value;
  if (auth != AuthState.authenticated) return null;
  return ref.watch(billingStaffRepositoryProvider).current();
}, retry: (retryCount, error) => null);

/// The API for the signed-in staff member, or null when they are not staff.
final customPaymentApiProvider = Provider<CustomPaymentApi?>((ref) {
  final member = ref.watch(billingStaffMemberProvider).value;
  if (member == null) return null;
  return ref.watch(customPaymentApiFactoryProvider)(member);
});

/// Whether this build may offer the card rail for a negotiated price: the
/// connector must have Dodo on-demand subscriptions enabled *and* a product
/// for the mode this build transacts in. Otherwise the request would 400.
final customPaymentCardAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    final health = await dodoRailHealth();
    return health.onDemandReadyForThisBuild;
  } catch (_) {
    return false;
  }
}, retry: (retryCount, error) => null);

/// Search results for a query string. The page debounces before watching.
final businessSearchProvider = FutureProvider.family<List<BusinessHit>, String>(
  (ref, query) {
    if (query.trim().length < 2) return Future.value(const <BusinessHit>[]);
    return ref.watch(businessSearchRepositoryProvider).search(query);
  },
  retry: (retryCount, error) => null,
);

/// How often the payment is polled. Zero in tests.
final customPaymentPollIntervalProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 5),
);

/// How long to keep polling before reporting a timeout. The charge may still
/// settle afterwards — the timeout wording never says it failed.
final customPaymentPollTimeoutProvider = Provider<Duration>(
  (ref) => const Duration(minutes: 10),
);
