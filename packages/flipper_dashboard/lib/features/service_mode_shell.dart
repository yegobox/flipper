import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// Keeps the route stack on the shell this device's service mode asks for.
//
// A service mode has its own full-screen route ([BarModeHostRoute],
// [HotelModeHostRoute]). The POS sales pane can also render a mode host, but
// that draws the bar floor or front desk inside the POS chrome — side menu,
// status strip — which is not where a mode belongs. Only the hotkey used to
// navigate; switching from Settings changed the mode under the POS shell and
// left the device there. Every path that changes the mode now ends here.

/// The route that shows [mode].
String serviceModeShellRouteName(ServiceMode mode) => switch (mode) {
  ServiceMode.pos => FlipperAppRoute.name,
  ServiceMode.bar => BarModeHostRoute.name,
  ServiceMode.hotel => HotelModeHostRoute.name,
};

ServiceMode? _shellOf(String? routeName) => switch (routeName) {
  FlipperAppRoute.name => ServiceMode.pos,
  BarModeHostRoute.name => ServiceMode.bar,
  HotelModeHostRoute.name => ServiceMode.hotel,
  _ => null,
};

bool _isShellRoute(Route<dynamic> route) =>
    _shellOf(route.settings.name) != null;

/// Moves this device onto the shell [activeServiceMode] asks for, if it is
/// sitting on a different one.
///
/// Does nothing while something other than a shell is on top. On a phone it
/// only ever leaves a mode that was turned off (see [serviceModeShellTarget]).
/// Safe to call from anywhere and as often as you like: it only navigates
/// when the shell is actually wrong.
void syncServiceModeShell() {
  final router = locator<RouterService>().router;
  final routeName = router.current.name;
  final currentShell = _shellOf(routeName);
  final wanted = activeServiceMode;
  final target = serviceModeShellTarget(
    currentShell: currentShell,
    wanted: wanted,
    isPhone: isPhoneLayout,
    currentShellOffered: switch (currentShell) {
      ServiceMode.bar => BarModeSettings.enabled,
      ServiceMode.hotel => HotelModeSettings.enabled,
      ServiceMode.pos || null => true,
    },
  );
  if (currentShell == null) {
    talker.debug('Service mode shell sync deferred: $routeName is on top');
  }
  if (target == null) return;
  talker.info(
    'Service mode shell: $routeName -> ${serviceModeShellRouteName(target)} '
    '(resolved ${wanted.name}; bar=${BarModeSettings.enabled}, '
    'hotel=${HotelModeSettings.enabled}, device=${deviceServiceMode?.name})',
  );
  _showShell(target);
}

/// Opens [mode]'s shell because someone asked for it (the hotkey, an "Open"
/// button), from wherever they are.
///
/// Settings or a report on top is closed first, so the operator lands on the
/// mode rather than on a screen with the mode behind it.
void openServiceModeShell(ServiceMode mode) {
  final router = locator<RouterService>().router;
  final hasShell = router.stack.any(
    (page) => _shellOf(page.routeData.name) != null,
  );
  if (hasShell && _shellOf(router.current.name) == null) {
    router.popUntil(_isShellRoute);
  }
  _showShell(mode);
}

void _showShell(ServiceMode mode) {
  final routerService = locator<RouterService>();
  final router = routerService.router;
  final current = router.current.name;
  if (current == serviceModeShellRouteName(mode)) return;

  switch (mode) {
    case ServiceMode.pos:
      // The startup redirect pushes the mode host over the dashboard, so the
      // dashboard is usually still underneath: go back to it rather than
      // stacking a second one (and a second round of startup work).
      if (router.stack.any(
        (page) => page.routeData.name == FlipperAppRoute.name,
      )) {
        router.popUntilRouteWithName(FlipperAppRoute.name);
      } else {
        routerService.replaceWith(FlipperAppRoute());
      }
    case ServiceMode.bar:
      _openHost(routerService, current, BarModeHostRoute());
    case ServiceMode.hotel:
      _openHost(routerService, current, HotelModeHostRoute());
  }
}

/// Opens a mode host. Over the dashboard it is pushed, like the startup
/// redirect does, so the dashboard keeps running underneath; over the other
/// mode's host it replaces it, so hosts never pile up.
void _openHost(
  RouterService routerService,
  String? current,
  PageRouteInfo host,
) {
  if (current == FlipperAppRoute.name) {
    routerService.navigateTo(host);
  } else {
    routerService.replaceWith(host);
  }
}

/// Wraps the POS sales pane and hands the device over to its mode's own route
/// whenever that pane would otherwise draw the mode inside the POS shell.
///
/// The pane still renders the mode host for the frame before the handover,
/// and on a phone, where nothing is handed over. Re-checked on every mode
/// change and whenever this route is uncovered again — Back from a host lands
/// here, and a terminal pinned to a mode goes straight back to it.
///
/// A separate widget so a dialog opening over the POS rebuilds only this, not
/// the catalog and cart it wraps.
class ServiceModeShellGuard extends HookWidget {
  const ServiceModeShellGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final revision = useValueListenable(serviceModeRevision);
    final isTopRoute = ModalRoute.isCurrentOf(context) ?? false;
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => syncServiceModeShell(),
      );
      return null;
    }, [revision, isTopRoute]);
    return child;
  }
}
