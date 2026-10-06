import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Whether the user is currently driving the app with a finger/pen or a mouse.
///
/// Hybrid devices (Windows touchscreens, tablets with a trackpad) get desktop
/// density by default — compact controls with shrunk tap targets — which are
/// hard to hit with a finger. [TouchInputDetector] flips this to `true` on the
/// first touch so controls grow to finger size, and back on the next mouse click.
class TouchInputMode extends ValueNotifier<bool> {
  TouchInputMode({bool? initial}) : super(initial ?? platformDefault);

  /// Phones start in touch mode; desktops and the web start in mouse mode.
  static bool get platformDefault {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return true;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return false;
    }
  }

  /// Whether [kind] means touch mode, mouse mode, or (null) no opinion.
  static bool? isTouchKind(PointerDeviceKind kind) {
    switch (kind) {
      case PointerDeviceKind.touch:
      case PointerDeviceKind.stylus:
      case PointerDeviceKind.invertedStylus:
        return true;
      case PointerDeviceKind.mouse:
      case PointerDeviceKind.trackpad:
        return false;
      case PointerDeviceKind.unknown:
        return null;
    }
  }

  /// True while touch is the active input. Rebuilds [context] when it changes.
  ///
  /// Without a [TouchInputDetector] above (most widget tests) this is `false`,
  /// so layouts keep their mouse sizes.
  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_TouchInputScope>()
            ?.notifier
            ?.value ??
        false;
  }
}

/// Watches every pointer in [child] and keeps a [TouchInputMode] current.
///
/// While touch is active it also raises the [ThemeData] density to
/// [VisualDensity.standard] with padded tap targets, so stock Material
/// controls are 48px even on desktop platforms.
class TouchInputDetector extends StatefulWidget {
  const TouchInputDetector({super.key, required this.child, this.mode});

  final Widget child;

  /// Supply one to share or inspect the mode; otherwise one is created.
  final TouchInputMode? mode;

  @override
  State<TouchInputDetector> createState() => _TouchInputDetectorState();
}

class _TouchInputDetectorState extends State<TouchInputDetector> {
  TouchInputMode? _ownedMode;
  bool? _pendingTouch;

  TouchInputMode get _mode => widget.mode ?? (_ownedMode ??= TouchInputMode());

  @override
  void dispose() {
    _ownedMode?.dispose();
    super.dispose();
  }

  // The switch is applied when the pointer lifts, not when it lands: resizing
  // controls under a finger mid-gesture would cancel the tap it started.
  void _onDown(PointerDownEvent event) {
    _pendingTouch = TouchInputMode.isTouchKind(event.kind);
  }

  void _onUp(PointerEvent event) {
    final touch = _pendingTouch;
    _pendingTouch = null;
    if (touch != null) _mode.value = touch;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onDown,
      onPointerUp: _onUp,
      onPointerCancel: _onUp,
      child: _TouchInputScope(
        notifier: _mode,
        child: ValueListenableBuilder<bool>(
          valueListenable: _mode,
          child: widget.child,
          // Always wrap in a [Theme] — inserting/removing it on a mode change
          // would remount the whole app (navigator state included).
          builder: (context, touch, child) {
            final theme = Theme.of(context);
            return Theme(
              data: touch
                  ? theme.copyWith(
                      visualDensity: VisualDensity.standard,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    )
                  : theme,
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

class _TouchInputScope extends InheritedNotifier<TouchInputMode> {
  const _TouchInputScope({required super.notifier, required super.child});
}
