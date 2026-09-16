import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/bar_mode_branch_settings_service.dart';
import 'package:flipper_models/services/hotel_mode_branch_settings_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

/// Bumped whenever a service-mode master toggle (Bar / Hotel) flips, or this
/// device changes which surface it runs.
///
/// The two admin sections are sibling [State]s, so one changing shared state
/// would otherwise leave a stale badge on the sibling card until the admin
/// screen was reopened. Each section listens and re-reads its cache.
/// The POS sales pane listens too, so a mode switched from the hotkey swaps
/// the surface without a reopen.
final ValueNotifier<int> serviceModeRevision = ValueNotifier<int>(0);

void notifyServiceModeChanged() => serviceModeRevision.value++;

/// A service surface a terminal can run.
///
/// Bar and Hotel each replace the whole POS sales pane, so one *device* runs
/// exactly one of them; [pos] is the plain catalog+cart surface. The branch,
/// however, may offer both — a hotel with a bar runs the front desk on the
/// desk terminal and the tables on the bar counter at the same time.
enum ServiceMode {
  pos,
  bar,
  hotel;

  String get label => switch (this) {
    ServiceMode.pos => 'POS',
    ServiceMode.bar => 'Bar Mode',
    ServiceMode.hotel => 'Hotel Mode',
  };

  /// What the device picker calls this surface.
  String get deviceLabel => switch (this) {
    ServiceMode.pos => 'POS',
    ServiceMode.bar => 'Bar counter',
    ServiceMode.hotel => 'Front desk',
  };

  static ServiceMode? fromName(String? raw) => switch (raw?.trim()) {
    'bar' => ServiceMode.bar,
    'hotel' => ServiceMode.hotel,
    'pos' => ServiceMode.pos,
    _ => null,
  };
}

/// Local-only key: which surface this terminal runs.
///
/// Never persisted to the branch document — that is the whole point. The
/// branch says which services exist; the device says which one it is.
const deviceServiceModeKey = 'deviceServiceMode';

/// This terminal's pick, or null when it just follows the branch.
ServiceMode? get deviceServiceMode => ServiceMode.fromName(
  ProxyService.box.readString(key: deviceServiceModeKey),
);

/// Pins this terminal to [mode]; null hands it back to the branch default.
void setDeviceServiceMode(ServiceMode? mode) {
  ProxyService.box.writeString(
    key: deviceServiceModeKey,
    value: mode?.name ?? '',
  );
  notifyServiceModeChanged();
}

/// Resolves the surface a terminal shows from what the branch offers and what
/// the device asked for.
///
/// The device pick wins, but only for a service the branch actually runs — a
/// terminal left pinned to the bar after the bar was shut down must fall back
/// rather than show a floor plan nobody maintains. With no pick (every device
/// before this existed, and every single-service branch) the old rule stands:
/// hotel first, so a branch that moved from bar to hotel is not dropped onto a
/// stale `bar_branch_settings` document's table floor.
ServiceMode resolveServiceMode({
  required bool hotelEnabled,
  required bool barEnabled,
  ServiceMode? deviceMode,
}) {
  switch (deviceMode) {
    case ServiceMode.hotel when hotelEnabled:
      return ServiceMode.hotel;
    case ServiceMode.bar when barEnabled:
      return ServiceMode.bar;
    // An explicit "just POS" is honoured even in a hotel: that is how a plain
    // cashier terminal opts out of the front desk taking over its screen.
    case ServiceMode.pos:
      return ServiceMode.pos;
    case _:
      break;
  }
  if (hotelEnabled) return ServiceMode.hotel;
  if (barEnabled) return ServiceMode.bar;
  return ServiceMode.pos;
}

/// The mode this device currently runs, from the local cache.
ServiceMode get activeServiceMode => resolveServiceMode(
  hotelEnabled: HotelModeSettings.enabled,
  barEnabled: BarModeSettings.enabled,
  deviceMode: deviceServiceMode,
);

/// Services the branch offers, in the order the pickers show them.
List<ServiceMode> availableServiceModes({
  required bool hotelEnabled,
  required bool barEnabled,
}) => [
  ServiceMode.pos,
  if (barEnabled) ServiceMode.bar,
  if (hotelEnabled) ServiceMode.hotel,
];

/// Next mode in the hotkey cycle: bar → hotel → POS → bar.
///
/// POS is in the cycle because the hotkey is otherwise a one-way door — a
/// terminal switched into a service mode would have to go back to the admin
/// screen to get its plain sales pane back.
ServiceMode nextServiceMode(ServiceMode current) => switch (current) {
  ServiceMode.bar => ServiceMode.hotel,
  ServiceMode.hotel => ServiceMode.pos,
  ServiceMode.pos => ServiceMode.bar,
};

/// Points this device at [mode], turning the service on for the branch if it
/// was not offered yet, and seeds whatever that surface needs.
///
/// Returns whether the device actually moved, so a caller does not announce a
/// switch that did not happen.
///
/// Enabling no longer disables the sibling: a property can run both, and the
/// terminal-level choice is what decides which surface this screen shows.
///
/// Ordered so a failure leaves the terminal where it was:
///
///  1. Seed the target surface's rooms / tables. Both seeds are idempotent and
///     read no toggle, so doing this first is safe — and a seed that throws
///     here has changed nothing yet, rather than parking the device on a
///     surface with no tables.
///  2. Offer the service on the branch if it was not offered yet, and record
///     the device's pick.
///  3. Persist the branch document, awaited, when step 2 changed it. The mode
///     hosts hydrate from Ditto in `initState`, so navigating while that write
///     was still in flight let a stale remote document turn the service back
///     off under the device's pick. The wait is capped so a hotkey never hangs
///     on an unreachable Ditto.
///
/// If step 3 fails, the enable and the device pick are both put back: a
/// terminal pinned to a service the branch never heard about would fall back
/// on the next hydrate anyway, so claiming the switch worked is worse than
/// refusing it.
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

  // `persist: false`: the awaited save below is the only branch write, so the
  // document is written once per switch rather than twice.
  final enablingHotel = mode == ServiceMode.hotel && !HotelModeSettings.enabled;
  final enablingBar = mode == ServiceMode.bar && !BarModeSettings.enabled;
  if (enablingHotel) HotelModeSettings.setEnabled(true, persist: false);
  if (enablingBar) BarModeSettings.setEnabled(true, persist: false);

  final previousDeviceMode = deviceServiceMode;
  setDeviceServiceMode(mode);

  // Nothing was asked of the branch — the pick is local, so there is no write
  // to wait on and the switch is already complete.
  if (!enablingHotel && !enablingBar) return true;

  final saved = enablingHotel
      ? await HotelModeBranchSettingsService.persistCurrentBranch(
          timeout: persistTimeout,
        )
      : await BarModeBranchSettingsService.persistCurrentBranch(
          timeout: persistTimeout,
        );
  if (saved) return true;

  if (enablingHotel) HotelModeSettings.setEnabled(false, persist: false);
  if (enablingBar) BarModeSettings.setEnabled(false, persist: false);
  setDeviceServiceMode(previousDeviceMode);
  talker.warning(
    'Service mode switch to ${mode.label} rolled back: turning the service on '
    'for the branch did not persist within ${persistTimeout.inSeconds}s',
  );
  return false;
}
