import 'dart:async';

import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    this.grantedModeOff,
    this.onLeave,
    required this.child,
  }) : assert(deskAdmin != null || target != null);

  final FutureOr<bool?> Function()? deskAdmin;
  final bool Function()? promptOpen;

  /// The mode the hotkey goes to from here; null when none is the user's to
  /// open. Replaces the admin-only cycle.
  final FutureOr<ServiceMode?> Function()? target;

  /// Asked when [target] finds none: a mode the user holds that this branch
  /// does not run ([grantedServiceModeOff]), so the refusal asks for the
  /// branch to run it rather than for a grant they already have.
  final ServiceMode? Function()? grantedModeOff;

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

  /// From a [ServiceModeDesk.target] surface: the user holds Bar or Hotel,
  /// but this branch does not run it and only an admin may turn it on.
  modeOffHere,
}

/// What the hotkey does now: a [refusal], or the mode to go to (null: the
/// next one in the cycle) and what to run before landing there.
///
/// For [ServiceModeHotkeyRefusal.modeOffHere], [target] is the mode the
/// branch does not run.
typedef _HotkeySwitch = ({
  ServiceModeHotkeyRefusal? refusal,
  ServiceMode? target,
  VoidCallback? onLeave,
});

_HotkeySwitch _refuse(ServiceModeHotkeyRefusal refusal, {ServiceMode? mode}) =>
    (refusal: refusal, target: mode, onLeave: null);

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
    if (target == null) {
      final off = widget.grantedModeOff?.call();
      return off == null
          ? _refuse(ServiceModeHotkeyRefusal.noAllowedMode)
          : _refuse(ServiceModeHotkeyRefusal.modeOffHere, mode: off);
    }
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

/// The first service (Bar, Hotel) the user holds ([mayRun]) that the branch
/// does not run ([offered]); null when they hold none such. When
/// [pickPermittedServiceMode] finds nothing for someone who is not an admin,
/// this is what stands in their way.
ServiceMode? grantedServiceModeOff({
  required bool Function(ServiceMode mode) mayRun,
  required bool Function(ServiceMode mode) offered,
}) {
  for (final mode in ServiceMode.values) {
    if (mode != ServiceMode.pos && mayRun(mode) && !offered(mode)) return mode;
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
///
/// From the keypress until the new mode has drawn, a scrim over the whole app
/// says the switch is under way ([_SwitchingOverlay]), so the operator does
/// not press again; presses while it is up are swallowed.
Future<void> cycleServiceMode() async {
  if (_ServiceModeHotkeyScopeState._switching) return;
  _ServiceModeHotkeyScopeState._switching = true;
  final overlay = _SwitchingOverlay.show(
    FlipperL10n.current.serviceModeSwitching,
  );
  try {
    final plan = await _planHotkeySwitch();
    final refusal = plan.refusal;
    if (refusal != null) {
      overlay?.hide();
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
        ServiceModeHotkeyRefusal.modeOffHere =>
          FlipperL10n.current.serviceModeHotkeyModeOff(plan.target!.label),
      }, type: NotificationType.error);
      return;
    }

    final target = plan.target ?? nextServiceMode(activeServiceMode);
    overlay?.label = FlipperL10n.current.serviceModeSwitchingTo(target.label);
    // Back to the mode the device already runs (from Books) needs no switch.
    if (target != activeServiceMode && !await serviceModeHotkeyApply(target)) {
      // The switch rolled itself back, so the device is still on the old
      // surface — navigating there would strand it on a mode it is not in.
      overlay?.hide();
      _toast(
        FlipperL10n.current.serviceModeSwitchNotSaved(target.label),
        type: NotificationType.error,
      );
      return;
    }
    plan.onLeave?.call();
    serviceModeHotkeyOpen(target);
    // Hold the scrim until the mode is on screen: one frame pushes the route,
    // the next draws the host.
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    overlay?.hide();
    _toast(
      FlipperL10n.current.serviceModeSwitched(
        target.label,
        serviceModeHotkeyLabel,
      ),
    );
  } catch (e, s) {
    talker.error('Service mode hotkey switch failed', e, s);
    overlay?.hide();
    _toast(
      FlipperL10n.current.serviceModeSwitchFailed,
      type: NotificationType.error,
    );
  } finally {
    overlay?.hide();
    _ServiceModeHotkeyScopeState._switching = false;
  }
}

/// The longest the switching scrim stays up, whatever the switch is doing,
/// so it can never strand a till behind it.
@visibleForTesting
const serviceModeSwitchingOverlayCap = Duration(seconds: 10);

/// The blocking scrim and "Switching…" card the hotkey shows while it
/// switches.
///
/// It sits on the root navigator's overlay, above every route, so it stays
/// up across the route swap into the new mode. The scrim takes every tap,
/// and every key press (a typed key, Enter, or a barcode scanner, which
/// types like a keyboard), so nothing lands in the cart of the mode being
/// left. Focus is taken off that mode's field while it is up and handed
/// back on [hide] if the field is still there (a refused switch). Card and
/// tint fade in, so a refusal that comes back at once does not flash.
class _SwitchingOverlay {
  _SwitchingOverlay._(this._label)
    : _previousFocus = FocusManager.instance.primaryFocus {
    _entry = OverlayEntry(
      builder: (context) => _SwitchingScrim(label: _label, focus: _focus),
    );
    _cap = Timer(serviceModeSwitchingOverlayCap, hide);
    HardwareKeyboard.instance.addHandler(_swallowKeys);
  }

  /// The scrim's own focus, taken explicitly: autofocus does nothing while
  /// the route underneath already holds focus.
  final FocusNode _focus = FocusNode(debugLabel: 'service mode switching');

  final ValueNotifier<String> _label;
  final FocusNode? _previousFocus;
  late final OverlayEntry _entry;
  late final Timer _cap;
  bool _hidden = false;

  /// Marks every key press handled, so neither a focused field nor a
  /// shortcut of the screen underneath sees it. Key releases go through, so
  /// the keyboard's pressed-key state stays right.
  bool _swallowKeys(KeyEvent event) => event is! KeyUpEvent;

  /// Puts the scrim up with [label]; null (and nothing shown) when there is
  /// no root overlay to put it on.
  static _SwitchingOverlay? show(String label) {
    final overlay = StackedService.navigatorKey?.currentState?.overlay;
    if (overlay == null) return null;
    final shown = _SwitchingOverlay._(ValueNotifier(label));
    overlay.insert(shown._entry);
    // Attached on the next build; the request waits for it.
    shown._focus.requestFocus();
    return shown;
  }

  set label(String value) {
    // The cap may already have taken it down.
    if (!_hidden) _label.value = value;
  }

  /// Takes the scrim down; safe to call more than once.
  void hide() {
    if (_hidden) return;
    _hidden = true;
    _cap.cancel();
    HardwareKeyboard.instance.removeHandler(_swallowKeys);
    _entry.remove();
    _entry.dispose();
    _label.dispose();
    final focus = _focus..unfocus();
    // The entry leaves the tree on the next frame; its node goes after it.
    SchedulerBinding.instance.addPostFrameCallback((_) => focus.dispose());
    // A refused switch leaves the operator where they were: give the field
    // they were in its focus back. After a switch that field is gone.
    final previous = _previousFocus;
    if (previous != null &&
        previous.context != null &&
        previous.canRequestFocus) {
      previous.requestFocus();
    }
  }
}

class _SwitchingScrim extends StatelessWidget {
  const _SwitchingScrim({required this.label, required this.focus});

  final ValueNotifier<String> label;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: PosTokens.prefersReducedMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 150),
      // Takes focus, so the screen underneath has no focused field while
      // the switch runs.
      builder: (context, t, card) => Focus(
        focusNode: focus,
        onKeyEvent: (_, _) => KeyEventResult.handled,
        child: Stack(
          children: [
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.32 * t),
            ),
            Center(
              child: Opacity(opacity: t, child: card),
            ),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: PosTokens.surface,
            borderRadius: BorderRadius.all(Radius.circular(PosTokens.radiusLg)),
            boxShadow: PosTokens.shadow2,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: PosTokens.blue,
                  ),
                ),
                const SizedBox(width: 16),
                ValueListenableBuilder<String>(
                  valueListenable: label,
                  builder: (context, text, _) => Semantics(
                    liveRegion: true,
                    child: Text(text, style: PosTokens.bodyStrong),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
