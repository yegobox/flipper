import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show ProviderListenable;
import 'package:supabase_models/brick/models/tenant.model.dart';

/// The module that grants [mode]; null for plain POS, which is gated on Sales.
String? serviceModeFeature(ServiceMode mode) => switch (mode) {
  ServiceMode.bar => AppFeature.BarMode,
  ServiceMode.hotel => AppFeature.HotelMode,
  ServiceMode.pos => null,
};

/// The grants to decide with right now: the fresh ones once loaded, else the
/// offline copy. Null while the first fetch is still running on a device
/// with no offline copy, i.e. nothing is known yet.
///
/// [listen] false reads without subscribing, for callers outside `build`.
ServiceModeGrants? knownServiceModeGrants(WidgetRef ref, {bool listen = true}) {
  final state = listen
      ? ref.watch(serviceModeGrantsProvider)
      : ref.read(serviceModeGrantsProvider);
  final loaded = state.value;
  if (loaded != null) return loaded;
  final box = ref.read(barServicesProvider).box;
  final businessId = box.getBusinessId();
  final cached = businessId == null || businessId.isEmpty
      ? null
      : cachedServiceModeGrants(businessId: businessId, box: box);
  if (cached != null) return cached;
  // Settled with nothing (the fetch itself never throws, but be safe):
  // every mode open, as before grants existed.
  return state.isLoading ? null : const ServiceModeGrants();
}

/// [knownServiceModeGrants], treating "not known yet" as no grants (open).
ServiceModeGrants currentServiceModeGrants(
  WidgetRef ref, {
  bool listen = true,
}) => knownServiceModeGrants(ref, listen: listen) ?? const ServiceModeGrants();

/// Waits until the grants fetch has settled (fresh, cached or open fallback;
/// bounded by its timeout). Check `mounted` before using [ref] again.
Future<void> serviceModeGrantsSettled(WidgetRef ref) async {
  try {
    await ref.read(serviceModeGrantsProvider.future);
  } catch (_) {
    // The fetch falls back instead of throwing; nothing more to wait for.
  }
}

/// Whether the user signed in to the app may run [mode] on this device.
///
/// Admin-type users and the owner are in [ServiceModeGrants.admins]. [listen]
/// as for [currentServiceModeGrants].
bool signedInUserMayRun(WidgetRef ref, ServiceMode mode, {bool listen = true}) {
  final feature = serviceModeFeature(mode);
  if (feature == null) return true;
  final grants = currentServiceModeGrants(ref, listen: listen);
  if (!grants.isRestricted(feature)) return true;
  final userId = ref.read(barServicesProvider).box.getUserId()?.trim();
  return grants.allows(feature, userId);
}

/// Whether [clerk], signed in on a Bar or Hotel lock screen, may still run
/// [mode].
///
/// The Admin bypass reads the clerk's entry in the current roster: the
/// [Tenant] kept at sign-in still says Admin after a demotion. A loaded
/// roster without the clerk gives no bypass; an unloaded or empty one (a
/// failed read) falls back to the kept copy, so a missing admin row cannot
/// lock an admin out.
bool clerkMayRun(WidgetRef ref, ServiceMode mode, Tenant clerk) {
  final feature = serviceModeFeature(mode);
  if (feature == null) return true;
  final grants = currentServiceModeGrants(ref, listen: false);
  if (!grants.isRestricted(feature)) return true;
  final roster = ref.read(barStaffProvider).value;
  Tenant? current = clerk;
  if (roster != null && roster.isNotEmpty) {
    current = null;
    for (final tenant in roster) {
      if (tenant.id == clerk.id) current = tenant;
    }
  }
  return grants.allows(
    feature,
    clerk.userId?.trim(),
    isAdminOrOwner: current != null && barTenantIsAdmin(current),
  );
}

/// Signs the desk's clerk out the moment they may no longer run [mode]:
/// when the desk opens with one already bound, when they sign in with a
/// pick made before the grants changed, and when the grants or the roster
/// refresh. Call from `build`.
void signOutIneligibleClerk(
  WidgetRef ref,
  ServiceMode mode, {
  required ProviderListenable<Tenant?> clerk,
  required void Function() signOut,
}) {
  bool ineligible() {
    final current = ref.read(clerk);
    return current != null && !clerkMayRun(ref, mode, current);
  }

  void check() {
    if (ineligible()) signOut();
  }

  ref.listen(clerk, (_, _) => check());
  ref.listen(serviceModeGrantsProvider, (_, _) => check());
  ref.listen(barStaffProvider, (_, _) => check());

  // A clerk still bound from an earlier visit (Bar → Hotel → Bar keeps the
  // Bar notifier) who lost access meanwhile: nothing changes to fire the
  // listeners above. Signing out is a provider write, so it waits for the
  // build to finish.
  if (ineligible()) {
    Future.microtask(() {
      if (ref.context.mounted) check();
    });
  }
}

/// Shows [child] (a Bar or Hotel host) only to a signed-in user who may run
/// [mode], and a "no access" notice to anyone else.
///
/// The notice stays on the host's route rather than falling back to POS: the
/// device is pinned to [mode], so the shell guard would only send it back.
class ServiceModeAccessGate extends ConsumerWidget {
  const ServiceModeAccessGate({
    super.key,
    required this.mode,
    required this.child,
  });

  final ServiceMode mode;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (signedInUserMayRun(ref, mode)) return child;
    return ServiceModeNoAccess(mode: mode);
  }
}

class ServiceModeNoAccess extends StatelessWidget {
  const ServiceModeNoAccess({super.key, required this.mode});

  final ServiceMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  context.flipperL10n.serviceModeNoAccess(mode.label),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
