import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_models/services/hotel_mode_branch_settings_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

/// Bumped whenever a service-mode master toggle (Bar / Hotel) flips.
///
/// The two admin sections are sibling [State]s, so one turning the other off
/// would otherwise leave a stale "ON" badge on the sibling card until the
/// admin screen was reopened. Each section listens and re-reads its cache.
/// The POS sales pane listens too, so a mode switched from the hotkey swaps
/// the surface without a reopen.
final ValueNotifier<int> serviceModeRevision = ValueNotifier<int>(0);

void notifyServiceModeChanged() => serviceModeRevision.value++;

/// The one service mode a branch is running.
///
/// Bar and Hotel both replace the same POS sales pane, so they are mutually
/// exclusive; [pos] is the plain catalog+cart surface with neither enabled.
enum ServiceMode {
  pos,
  bar,
  hotel;

  String get label => switch (this) {
    ServiceMode.pos => 'POS',
    ServiceMode.bar => 'Bar Mode',
    ServiceMode.hotel => 'Hotel Mode',
  };
}

/// Resolves the active mode from the two master toggles.
///
/// Hotel wins: the modes are mutually exclusive, but a branch that switched
/// from bar to hotel can still hold a stale `enabled: true` bar setting.
ServiceMode resolveServiceMode({
  required bool hotelEnabled,
  required bool barEnabled,
}) {
  if (hotelEnabled) return ServiceMode.hotel;
  if (barEnabled) return ServiceMode.bar;
  return ServiceMode.pos;
}

/// The mode the local cache currently reports.
ServiceMode get activeServiceMode => resolveServiceMode(
  hotelEnabled: HotelModeSettings.enabled,
  barEnabled: BarModeSettings.enabled,
);

/// Next mode in the hotkey cycle: bar → hotel → POS → bar.
///
/// POS is in the cycle because the hotkey is otherwise a one-way door — a
/// branch that switched into a service mode would have to go back to the admin
/// screen to get its plain sales pane back.
ServiceMode nextServiceMode(ServiceMode current) => switch (current) {
  ServiceMode.bar => ServiceMode.hotel,
  ServiceMode.hotel => ServiceMode.pos,
  ServiceMode.pos => ServiceMode.bar,
};

/// Writes [mode] as the branch's service mode and seeds whatever it needs.
///
/// Returns whether the branch actually moved, so a caller does not announce a
/// switch that did not happen.
///
/// Ordered so a failure leaves the branch where it was:
///
///  1. Seed the target surface's rooms / tables. Both seeds are idempotent and
///     read no toggle, so doing this first is safe — and a seed that throws
///     here has changed nothing yet, rather than leaving the branch on a
///     surface with nothing to serve on.
///  2. Flip the master toggles in the local cache.
///  3. Persist the branch documents, awaited. The mode hosts hydrate from Ditto
///     in `initState`, so navigating while that write was still in flight let a
///     stale remote document flip the mode straight back. The wait is capped so
///     a hotkey never hangs on an unreachable Ditto.
///
/// If step 3 fails, step 2 is put back: a local cache claiming hotel mode while
/// the branch document still says bar is undone by the next hydrate anyway, so
/// claiming the switch worked is worse than refusing it.
Future<bool> applyServiceMode(
  ServiceMode mode, {
  Duration persistTimeout = const Duration(seconds: 3),
}) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId != null) {
    final sync = ProxyService.getStrategy(Strategy.capella);
    switch (mode) {
      case ServiceMode.bar:
        await sync.seedDefaultFloorPlan(branchId: branchId);
      case ServiceMode.hotel:
        await sync.seedDefaultRooms(branchId: branchId);
      case ServiceMode.pos:
        break;
    }
  }

  final previousHotel = HotelModeSettings.enabled;
  final previousBar = BarModeSettings.enabled;
  final hotel = mode == ServiceMode.hotel;
  final bar = mode == ServiceMode.bar;
  // Already there — nothing to write, and so nothing that can fail.
  if (previousHotel == hotel && previousBar == bar) return true;

  // `persist: false`: the awaited saves below are the only branch writes, so
  // each document is written once per switch rather than twice.
  HotelModeSettings.setEnabled(hotel, persist: false);
  BarModeSettings.setEnabled(bar, persist: false);
  notifyServiceModeChanged();

  final saved = await Future.wait([
    if (previousHotel != hotel)
      HotelModeBranchSettingsService.persistCurrentBranch(
        timeout: persistTimeout,
      ),
    if (previousBar != bar)
      BarModeBranchSettingsService.persistCurrentBranch(
        timeout: persistTimeout,
      ),
  ]);
  if (saved.every((ok) => ok)) return true;

  // Put the cache back, and push the restored values at the branch on the
  // fire-and-forget deadline — one of the two documents may well have landed
  // before the other gave up, and that one now disagrees with the cache.
  HotelModeSettings.setEnabled(previousHotel, persist: previousHotel != hotel);
  BarModeSettings.setEnabled(previousBar, persist: previousBar != bar);
  notifyServiceModeChanged();
  talker.warning(
    'Service mode switch to ${mode.label} rolled back: the branch settings did '
    'not persist within ${persistTimeout.inSeconds}s',
  );
  return false;
}
