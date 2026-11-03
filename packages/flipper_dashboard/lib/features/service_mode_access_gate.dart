import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The module that grants [mode]; null for plain POS, which is gated on Sales.
String? serviceModeFeature(ServiceMode mode) => switch (mode) {
  ServiceMode.bar => AppFeature.BarMode,
  ServiceMode.hotel => AppFeature.HotelMode,
  ServiceMode.pos => null,
};

/// The grants to decide with right now: the fresh ones once loaded, else the
/// offline copy, else none (every mode open, as before grants existed).
///
/// [listen] false reads without subscribing, for callers outside `build`.
ServiceModeGrants currentServiceModeGrants(
  WidgetRef ref, {
  bool listen = true,
}) {
  final loaded = listen
      ? ref.watch(serviceModeGrantsProvider).value
      : ref.read(serviceModeGrantsProvider).value;
  if (loaded != null) return loaded;
  final box = ref.read(barServicesProvider).box;
  final businessId = box.getBusinessId();
  if (businessId == null || businessId.isEmpty) {
    return const ServiceModeGrants();
  }
  return cachedServiceModeGrants(businessId: businessId, box: box) ??
      const ServiceModeGrants();
}

/// Whether the user signed in to the app may run [mode] on this device.
///
/// The Admin user type counts through [featureViewAccessProvider], the owner
/// through [ServiceModeGrants.admins]. [listen] as for
/// [currentServiceModeGrants].
bool signedInUserMayRun(WidgetRef ref, ServiceMode mode, {bool listen = true}) {
  final feature = serviceModeFeature(mode);
  if (feature == null) return true;
  final grants = currentServiceModeGrants(ref, listen: listen);
  if (!grants.isRestricted(feature)) return true;
  final userId = ref.read(barServicesProvider).box.getUserId()?.trim();
  if (userId == null || userId.isEmpty) return false;
  if (grants.allows(feature, userId)) return true;
  final viewAccess = featureViewAccessProvider(
    userId: userId,
    featureName: feature,
  );
  return listen ? ref.watch(viewAccess) : ref.read(viewAccess);
}

/// [serviceModeRevision] as a provider, so a widget that reads a mode's
/// branch flag rebuilds when Settings or another device flips it.
final serviceModeRevisionProvider = Provider<int>((ref) {
  void bump() => ref.invalidateSelf();
  serviceModeRevision.addListener(bump);
  ref.onDispose(() => serviceModeRevision.removeListener(bump));
  return serviceModeRevision.value;
});

/// Whether this branch offers [mode], from the local cache. POS always.
final serviceModeOfferedProvider = Provider.family<bool, ServiceMode>((
  ref,
  mode,
) {
  ref.watch(serviceModeRevisionProvider);
  return switch (mode) {
    ServiceMode.bar => BarModeSettings.enabled,
    ServiceMode.hotel => HotelModeSettings.enabled,
    ServiceMode.pos => true,
  };
});

/// The phone dashboard page (More sheet and home grid tile) that opens a mode.
const barModeDashboardPage = 'BarMode';
const hotelModeDashboardPage = 'HotelMode';

/// The mode a dashboard [page] opens, or null for any other page.
ServiceMode? serviceModeForDashboardPage(String? page) => switch (page) {
  barModeDashboardPage => ServiceMode.bar,
  hotelModeDashboardPage => ServiceMode.hotel,
  _ => null,
};

/// Whether the phone dashboard offers [mode]'s tile to the signed-in user: the
/// branch runs the mode and the user may run it.
///
/// Not a [featureAccessProvider] check: while nobody holds the grant the mode
/// is open to all staff, and they hold no Access row for it.
bool serviceModeTileVisible(WidgetRef ref, ServiceMode mode) =>
    ref.watch(serviceModeOfferedProvider(mode)) &&
    signedInUserMayRun(ref, mode);

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
    // A phone opened the mode from its home, so Back returns there. A pinned
    // desktop would only be sent straight back here by the shell guard.
    final canLeave =
        isPhoneWidth(MediaQuery.sizeOf(context).width) &&
        (ModalRoute.of(context)?.canPop ?? false);
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
              if (canLeave) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(context.flipperL10n.back),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
