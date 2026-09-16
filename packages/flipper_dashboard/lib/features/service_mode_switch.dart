import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_models/SyncStrategy.dart';
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
/// The branch document is persisted before this returns — the mode hosts
/// hydrate from Ditto in `initState`, so navigating there while the write was
/// still in flight let a stale remote document flip the mode straight back.
/// The wait is capped so a hotkey never hangs on an unreachable Ditto; the
/// fire-and-forget persist started by `setEnabled` still retries for longer.
Future<void> applyServiceMode(
  ServiceMode mode, {
  Duration persistTimeout = const Duration(seconds: 3),
}) async {
  HotelModeSettings.setEnabled(mode == ServiceMode.hotel);
  BarModeSettings.setEnabled(mode == ServiceMode.bar);
  notifyServiceModeChanged();

  await Future.wait([
    HotelModeBranchSettingsService.persistCurrentBranch(
      timeout: persistTimeout,
    ),
    BarModeBranchSettingsService.persistCurrentBranch(timeout: persistTimeout),
  ]);

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return;
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
