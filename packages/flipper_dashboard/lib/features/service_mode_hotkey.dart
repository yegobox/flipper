import 'dart:async';

import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

/// Cycles this device Bar Mode → Hotel Mode → POS without a trip through the
/// admin screen.
///
/// `Ctrl/Cmd + Shift + M`. Shift is part of the combination so it cannot be
/// hit while typing, and `M` is free on every surface the modes run on.
const serviceModeHotkeyLabel = 'Ctrl/Cmd + Shift + M';

/// Listens for the service-mode hotkey anywhere below it.
///
/// Registered on [HardwareKeyboard] rather than as a [Shortcuts] entry because
/// the mode hosts open on a PIN lock with nothing focused, and a [Shortcuts]
/// map is only consulted along the focus path — the hotkey would silently do
/// nothing until the operator happened to tap something first.
///
/// Mounting several of these (the dashboard shell plus a mode host nested
/// inside it) is harmless: the handler is installed once and reference
/// counted, so one keypress switches the mode once.
class ServiceModeHotkeyScope extends StatefulWidget {
  const ServiceModeHotkeyScope({super.key, required this.child});

  final Widget child;

  @override
  State<ServiceModeHotkeyScope> createState() => _ServiceModeHotkeyScopeState();
}

class _ServiceModeHotkeyScopeState extends State<ServiceModeHotkeyScope> {
  static int _mounted = 0;
  static bool _switching = false;

  @override
  void initState() {
    super.initState();
    if (_mounted++ == 0) {
      HardwareKeyboard.instance.addHandler(_handleKey);
    }
  }

  @override
  void dispose() {
    if (--_mounted == 0) {
      HardwareKeyboard.instance.removeHandler(_handleKey);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  static bool _handleKey(KeyEvent event) {
    // KeyRepeatEvent is deliberately excluded: holding the combination must
    // not walk the branch through every mode.
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != LogicalKeyboardKey.keyM) return false;

    final keyboard = HardwareKeyboard.instance;
    if (!keyboard.isShiftPressed) return false;
    if (!keyboard.isControlPressed && !keyboard.isMetaPressed) return false;

    unawaited(cycleServiceMode());
    return true;
  }
}

/// Moves this device to [nextServiceMode] and lands on that mode's surface.
///
/// The pick itself is local to the terminal, but cycling onto a service the
/// branch does not offer yet turns it on for the whole branch — so this stays
/// admin-gated on [AppFeature.Settings], the same right the admin screen's
/// master toggles need.
Future<void> cycleServiceMode() async {
  if (_ServiceModeHotkeyScopeState._switching) return;
  _ServiceModeHotkeyScopeState._switching = true;
  try {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return;

    final allowed = await ProxyService.strategy.isAdmin(
      userId: userId,
      appFeature: AppFeature.Settings,
    );
    if (!allowed) {
      _toast(
        'Only an admin can switch this device\'s service mode.',
        type: NotificationType.error,
      );
      return;
    }

    final target = nextServiceMode(activeServiceMode);
    if (!await applyServiceMode(target)) {
      // The switch rolled itself back, so the device is still on the old
      // surface — navigating there would strand it on a mode it is not in.
      _toast(
        'Could not switch to ${target.label}: the branch settings did not '
        'save. Check your connection and try again.',
        type: NotificationType.error,
      );
      return;
    }
    _navigateTo(target);
    _toast(
      'This device switched to ${target.label} · '
      '$serviceModeHotkeyLabel to cycle',
    );
  } catch (e, s) {
    talker.error('Service mode hotkey switch failed', e, s);
    _toast('Could not switch service mode.', type: NotificationType.error);
  } finally {
    _ServiceModeHotkeyScopeState._switching = false;
  }
}

void _navigateTo(ServiceMode mode) {
  final router = locator<RouterService>();
  final wanted = switch (mode) {
    ServiceMode.bar => BarModeHostRoute.name,
    ServiceMode.hotel => HotelModeHostRoute.name,
    ServiceMode.pos => FlipperAppRoute.name,
  };
  // Already on the right surface (the modes also render inside the POS sales
  // pane, which rebuilds off [serviceModeRevision]) — remounting it would
  // throw away the operator's place for nothing.
  if (router.router.current.name == wanted) return;

  switch (mode) {
    case ServiceMode.bar:
      router.replaceWith(BarModeHostRoute());
    case ServiceMode.hotel:
      router.replaceWith(HotelModeHostRoute());
    case ServiceMode.pos:
      router.replaceWith(FlipperAppRoute());
  }
}

void _toast(
  String message, {
  NotificationType type = NotificationType.success,
}) {
  // The root messenger outlives the route swap, so the confirmation is still
  // on screen once the new mode has taken over.
  final context = StackedService.navigatorKey?.currentContext;
  if (context == null || !context.mounted) return;
  showCustomSnackBarUtil(
    context,
    message,
    type: type,
    duration: const Duration(seconds: 3),
  );
}
