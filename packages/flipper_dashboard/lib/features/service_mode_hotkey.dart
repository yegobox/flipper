import 'dart:async';

import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
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
    // A phone is never a mode's terminal: the hotkey would pin it to one (and
    // could turn the service on for the branch) from a hardware keyboard.
    if (isPhoneLayout) return false;

    unawaited(cycleServiceMode());
    return true;
  }
}

/// Marks [child] as a desk the hotkey may switch from: the POS sales pane, or
/// the Bar or Hotel desk.
///
/// The hotkey acts for the person at the desk on screen, never for the
/// account the app is signed in with: a shared register is usually signed in
/// as an admin, so that account would let anyone at the till switch (and land
/// a Bar-only waiter on POS). Anywhere else (Reports, a lock screen, a page
/// or dialog pushed over the desk) there is nobody to judge, so no switch.
///
/// [deskAdmin] answers null while nobody is signed in at the desk, else
/// whether that person is an admin. [promptOpen], when given, says the desk
/// is asking for something (the manager PIN) that a switch would throw away.
/// Nesting is harmless: the desk mounted last wins, so a Bar route pushed
/// over the dashboard beats POS under it.
///
/// A surface that is not itself a mode (Books) passes [target] instead of
/// [deskAdmin]: it picks the mode for the person using it, by their own
/// grants ([pickPermittedServiceMode]), and [onLeave] closes the surface
/// once the switch is saved so the mode does not open underneath it.
class ServiceModeDesk extends StatefulWidget {
  const ServiceModeDesk({
    super.key,
    this.deskAdmin,
    this.promptOpen,
    this.target,
    this.onLeave,
    required this.child,
  }) : assert(deskAdmin != null || target != null);

  final FutureOr<bool?> Function()? deskAdmin;
  final bool Function()? promptOpen;

  /// The mode the hotkey goes to from here; null when none is the user's to
  /// open. Replaces the admin-only cycle.
  final FutureOr<ServiceMode?> Function()? target;

  /// Runs after the switch is saved, before the mode's surface opens.
  final VoidCallback? onLeave;
  final Widget child;

  @override
  State<ServiceModeDesk> createState() => _ServiceModeDeskState();
}

class _ServiceModeDeskState extends State<ServiceModeDesk> {
  static final List<_ServiceModeDeskState> _desks = [];

  ModalRoute<Object?>? _route;

  /// Not under a page or dialog pushed over it.
  bool get _onScreen => mounted && (_route?.isCurrent ?? true);

  @override
  void initState() {
    super.initState();
    _desks.add(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
  }

  @override
  void dispose() {
    _desks.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Why the hotkey did not switch.
enum ServiceModeHotkeyRefusal {
  /// Not on POS, Bar or Hotel (or something is open over the desk).
  noDesk,

  /// On a desk's lock: nobody signed in to judge.
  signInFirst,

  /// The person at the desk is not an admin.
  notAdmin,

  /// The desk is asking for the manager PIN; switching would drop it.
  promptOpen,

  /// From a [ServiceModeDesk.target] surface: the user may open none of
  /// POS, Bar and Hotel.
  noAllowedMode,
}

/// What the hotkey does now: a [refusal], or the mode to go to (null: the
/// next one in the cycle) and what to run before landing there.
typedef _HotkeySwitch = ({
  ServiceModeHotkeyRefusal? refusal,
  ServiceMode? target,
  VoidCallback? onLeave,
});

_HotkeySwitch _refuse(ServiceModeHotkeyRefusal refusal) =>
    (refusal: refusal, target: null, onLeave: null);

/// Judges the hotkey on the desk on screen.
Future<_HotkeySwitch> _planHotkeySwitch() async {
  _ServiceModeDeskState? desk;
  for (final candidate in _ServiceModeDeskState._desks.reversed) {
    if (candidate._onScreen) {
      desk = candidate;
      break;
    }
  }
  if (desk == null) return _refuse(ServiceModeHotkeyRefusal.noDesk);
  final widget = desk.widget;
  bool prompting() => widget.promptOpen?.call() ?? false;
  if (prompting()) return _refuse(ServiceModeHotkeyRefusal.promptOpen);

  final pick = widget.target;
  if (pick != null) {
    final target = await pick();
    if (!desk._onScreen) return _refuse(ServiceModeHotkeyRefusal.noDesk);
    if (target == null) return _refuse(ServiceModeHotkeyRefusal.noAllowedMode);
    return (refusal: null, target: target, onLeave: widget.onLeave);
  }

  final admin = await widget.deskAdmin!();
  // The answer was for the desk as it was: a user switch or a page opened
  // over it while the lookup ran leaves nobody it applies to.
  if (!desk._onScreen) return _refuse(ServiceModeHotkeyRefusal.noDesk);
  if (prompting()) return _refuse(ServiceModeHotkeyRefusal.promptOpen);
  if (admin == null) return _refuse(ServiceModeHotkeyRefusal.signInFirst);
  if (!admin) return _refuse(ServiceModeHotkeyRefusal.notAdmin);
  return (refusal: null, target: null, onLeave: widget.onLeave);
}

/// Whether the hotkey may switch now, judged on the desk on screen; null
/// when it may.
@visibleForTesting
Future<ServiceModeHotkeyRefusal?> serviceModeHotkeyRefusal() async =>
    (await _planHotkeySwitch()).refusal;

/// The next mode after [current], in the hotkey's order, that the user may
/// open: one they hold ([mayRun]) that the branch already offers ([offered]),
/// or, for an admin ([isAdmin]), one it does not offer yet, since switching
/// onto it turns it on for the whole branch. [current] comes last, so with
/// nothing else allowed the hotkey still goes back to it. Null when none is.
Future<ServiceMode?> pickPermittedServiceMode({
  required ServiceMode current,
  required bool Function(ServiceMode mode) mayRun,
  required bool Function(ServiceMode mode) offered,
  required FutureOr<bool?> Function() isAdmin,
}) async {
  bool? admin;
  var mode = current;
  for (var i = 0; i < ServiceMode.values.length; i++) {
    mode = nextServiceMode(mode);
    if (!mayRun(mode)) continue;
    if (offered(mode)) return mode;
    admin ??= await isAdmin() ?? false;
    if (admin) return mode;
  }
  return null;
}

/// The POS desk's [ServiceModeDesk.deskAdmin]. POS runs as the account the
/// app is signed in with (the POS user switch changes it), so that is the
/// person at the desk.
///
/// Admin means [AppFeature.Settings], the right the admin screen's master
/// toggles need: cycling onto a service the branch does not offer yet turns
/// it on for the whole branch.
Future<bool?> posDeskAdmin() async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) return null;
  return ProxyService.strategy.isAdmin(
    userId: userId,
    appFeature: AppFeature.Settings,
  );
}

/// How the hotkey applies a mode; replaceable in tests.
@visibleForTesting
Future<bool> Function(ServiceMode mode) serviceModeHotkeyApply =
    applyServiceMode;

/// How the hotkey lands on a mode's surface; replaceable in tests.
@visibleForTesting
void Function(ServiceMode mode) serviceModeHotkeyOpen = openServiceModeShell;

/// Moves this device to the next mode and lands on that mode's surface.
///
/// The pick itself is local to the terminal, but cycling onto a service the
/// branch does not offer yet turns it on for the whole branch — so this is
/// admin-only, judged on the person at the desk ([ServiceModeDesk]). From
/// Books it follows the user's own grants instead ([ServiceModeDesk.target]).
Future<void> cycleServiceMode() async {
  if (_ServiceModeHotkeyScopeState._switching) return;
  _ServiceModeHotkeyScopeState._switching = true;
  try {
    final plan = await _planHotkeySwitch();
    final refusal = plan.refusal;
    if (refusal != null) {
      _toast(switch (refusal) {
        ServiceModeHotkeyRefusal.noDesk =>
          FlipperL10n.current.serviceModeHotkeyOpenDesk,
        ServiceModeHotkeyRefusal.signInFirst =>
          FlipperL10n.current.serviceModeHotkeySignInFirst,
        ServiceModeHotkeyRefusal.notAdmin =>
          FlipperL10n.current.serviceModeAdminOnly,
        ServiceModeHotkeyRefusal.promptOpen =>
          FlipperL10n.current.serviceModeHotkeyPromptOpen,
        ServiceModeHotkeyRefusal.noAllowedMode =>
          FlipperL10n.current.serviceModeHotkeyNoMode,
      }, type: NotificationType.error);
      return;
    }

    final target = plan.target ?? nextServiceMode(activeServiceMode);
    // Back to the mode the device already runs (from Books) needs no switch.
    if (target != activeServiceMode && !await serviceModeHotkeyApply(target)) {
      // The switch rolled itself back, so the device is still on the old
      // surface — navigating there would strand it on a mode it is not in.
      _toast(
        FlipperL10n.current.serviceModeSwitchNotSaved(target.label),
        type: NotificationType.error,
      );
      return;
    }
    plan.onLeave?.call();
    serviceModeHotkeyOpen(target);
    _toast(
      FlipperL10n.current.serviceModeSwitched(
        target.label,
        serviceModeHotkeyLabel,
      ),
    );
  } catch (e, s) {
    talker.error('Service mode hotkey switch failed', e, s);
    _toast(
      FlipperL10n.current.serviceModeSwitchFailed,
      type: NotificationType.error,
    );
  } finally {
    _ServiceModeHotkeyScopeState._switching = false;
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
