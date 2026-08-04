import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Full-screen "opening <app>" curtain that bridges the app switcher and the
/// chosen app.
///
/// It lives on the **root** [Overlay] rather than inside the chooser dialog, so
/// it survives both the dialog popping and the route stack being cleared under
/// it (`clearStackAndShow` during login). That is what makes branch → app read
/// as one continuous motion instead of three unrelated screens.
///
/// The caller that performs the navigation owns dismissal — every path must end
/// in one of these, including its error paths:
/// * [dismiss] — the hand-off is over (or failed); take the curtain down now.
/// * [dismissWhenSettled] — the destination was just navigated to; take it down
///   once that destination has actually landed.
///
/// There is a long safety timeout as a backstop for a path that forgets, but it
/// is deliberately far longer than any hand-off: it must never be what ends the
/// curtain in normal use, or the user gets dropped back on the screen they came
/// from while the real navigation is still pending.
abstract final class AppLaunchOverlay {
  static const Duration _fadeIn = Duration(milliseconds: 220);
  static const Duration _fadeOut = Duration(milliseconds: 260);

  /// Keeps the curtain on screen long enough to read as intentional when the
  /// hand-off happens to be instant.
  static const Duration _minHold = Duration(milliseconds: 560);

  /// Backstop for a code path that never dismisses — *not* a UX budget.
  ///
  /// It has to outlive the work it covers. The login hand-off can legitimately
  /// run ~20s before it navigates (`completeDittoAfterLoginChoices` alone is
  /// bounded at 15s, plus the commission check at 5s and the active-business /
  /// bar-mode lookups). A shorter backstop fires mid-flight, drops the curtain
  /// back onto the branch screen, and the app then appears seconds later —
  /// which is precisely the flash this overlay exists to prevent.
  static const Duration _safetyTimeout = Duration(seconds: 45);

  static OverlayEntry? _entry;
  static GlobalKey<_AppLaunchCurtainState>? _curtainKey;
  static Timer? _safetyTimer;

  /// Completes once [_minHold] has passed since [show]. A timer rather than a
  /// [Stopwatch] so it runs on the same clock as every other delay here —
  /// stopwatches measure wall time, which does not advance in widget tests.
  static Future<void>? _minHoldPassed;

  /// Set by widget tests that exercise the chooser rather than the curtain: the
  /// curtain holds a looping animation and a safety [Timer], neither of which a
  /// `pumpAndSettle` can drain.
  @visibleForTesting
  static bool suppressForTests = false;

  static bool get isVisible => _entry != null;

  /// Inserts the curtain and resolves once it has fully faded in, so callers can
  /// navigate behind it without the route change showing through.
  static Future<void> show({
    required NavigatorState navigator,
    required String appLabel,
    required Color accent,
    required String iconSvg,
    String? contextLabel,
  }) async {
    if (suppressForTests) return;
    await dismiss();

    final overlay = navigator.overlay;
    if (overlay == null) return;

    final key = GlobalKey<_AppLaunchCurtainState>();
    final entry = OverlayEntry(
      builder: (_) => _AppLaunchCurtain(
        key: key,
        appLabel: appLabel,
        accent: accent,
        iconSvg: iconSvg,
        contextLabel: contextLabel,
        fadeIn: _fadeIn,
        fadeOut: _fadeOut,
      ),
    );

    _curtainKey = key;
    _entry = entry;
    _minHoldPassed = Future<void>.delayed(_minHold);
    overlay.insert(entry);

    _safetyTimer = Timer(_safetyTimeout, () => unawaited(dismiss()));

    await Future<void>.delayed(_fadeIn);
  }

  /// Fades the curtain out and removes it. Safe to call when nothing is showing.
  static Future<void> dismiss() async {
    final entry = _entry;
    if (entry == null) return;

    final key = _curtainKey;
    final minHoldPassed = _minHoldPassed;
    _entry = null;
    _curtainKey = null;
    _minHoldPassed = null;
    _safetyTimer?.cancel();
    _safetyTimer = null;

    // Resolves immediately once the floor has already gone by.
    await minHoldPassed;

    await key?.currentState?.playExit();

    if (entry.mounted) entry.remove();
  }

  /// How long to keep the curtain up after the navigation call returns, for a
  /// destination that arrives on a pushed/replaced route.
  ///
  /// Router navigation futures resolve when the page is *pushed*, not when its
  /// entrance transition ends — and until that transition ends the page we came
  /// from is still painted underneath. Lifting the curtain on the next frame
  /// therefore flashes the previous screen. This covers Flutter's 300ms page
  /// transition with margin; after it the outgoing page is disposed, so there is
  /// nothing stale left to reveal.
  static const Duration routeSettle = Duration(milliseconds: 450);

  /// Settle window for a destination that is swapped inside the current shell
  /// (a dashboard tab): no route transition to wait out, just a frame to paint.
  static const Duration inShellSettle = Duration(milliseconds: 140);

  /// Dismisses once the destination has had time to land. Fire-and-forget.
  static void dismissWhenSettled({Duration settle = routeSettle}) {
    if (suppressForTests || _entry == null) return;
    unawaited(_settleThenDismiss(settle));
  }

  static Future<void> _settleThenDismiss(Duration settle) async {
    // One rendered frame so the destination is in the tree at all, then the
    // settle window so its entrance transition can finish behind the curtain.
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(settle);
    await dismiss();
  }
}

class _AppLaunchCurtain extends StatefulWidget {
  const _AppLaunchCurtain({
    super.key,
    required this.appLabel,
    required this.accent,
    required this.iconSvg,
    required this.contextLabel,
    required this.fadeIn,
    required this.fadeOut,
  });

  final String appLabel;
  final Color accent;
  final String iconSvg;
  final String? contextLabel;
  final Duration fadeIn;
  final Duration fadeOut;

  @override
  State<_AppLaunchCurtain> createState() => _AppLaunchCurtainState();
}

class _AppLaunchCurtainState extends State<_AppLaunchCurtain>
    with TickerProviderStateMixin {
  static const Color _ink1 = Color(0xFF0B1220);
  static const Color _ink3 = Color(0xFF7E8AA0);
  static const Color _line = Color(0xFFE6ECF5);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _app = Color(0xFFF5F8FD);
  static const Color _app2 = Color(0xFFEDF2FB);

  late final AnimationController _enter = AnimationController(
    duration: widget.fadeIn,
    vsync: this,
  );
  late final AnimationController _exit = AnimationController(
    duration: widget.fadeOut,
    vsync: this,
  );
  late final AnimationController _sweep = AnimationController(
    duration: const Duration(milliseconds: 1100),
    vsync: this,
  );

  /// The login hand-off can sit here for 15s+ while Ditto authenticates. Say so
  /// rather than letting a silent curtain read as a hang.
  static const Duration _reassureAfter = Duration(seconds: 7);
  Timer? _reassureTimer;
  bool _showReassurance = false;

  @override
  void initState() {
    super.initState();
    _enter.forward();
    _sweep.repeat();
    _reassureTimer = Timer(_reassureAfter, () {
      if (mounted) setState(() => _showReassurance = true);
    });
  }

  @override
  void dispose() {
    _reassureTimer?.cancel();
    _enter.dispose();
    _exit.dispose();
    _sweep.dispose();
    super.dispose();
  }

  /// Runs the exit animation: the curtain fades while the plate pushes slightly
  /// forward, so the destination reads as arriving *through* it.
  Future<void> playExit() async {
    if (!mounted) return;
    try {
      await _exit.forward();
    } on TickerCanceled {
      // Disposed mid-exit (route torn down) — nothing left to animate.
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_enter, _exit]),
      builder: (context, _) {
        final enter = reduceMotion
            ? 1.0
            : Curves.easeOutCubic.transform(_enter.value);
        final exit = reduceMotion
            ? 0.0
            : Curves.easeInCubic.transform(_exit.value);

        return IgnorePointer(
          child: Opacity(
            opacity: (enter * (1 - exit)).clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 1 + (0.045 * exit),
              child: _buildCurtain(context, enter: enter, exit: exit),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurtain(
    BuildContext context, {
    required double enter,
    required double exit,
  }) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        // Same radial wash as the branch/business chooser, so the curtain reads
        // as the same surface continuing rather than a new screen.
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.85),
            radius: 1.35,
            colors: [_surface, _app, _app2],
            stops: [0, 0.46, 1],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Accent bloom behind the plate, tinted by the app being opened.
            Center(
              child: Transform.scale(
                scale: 0.9 + (0.25 * enter) + (0.35 * exit),
                child: Container(
                  width: 420,
                  height: 420,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.accent.withValues(alpha: 0.16),
                        widget.accent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, 14 * (1 - enter)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 0.88 + (0.12 * enter) + (0.06 * exit),
                      child: _plate(),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Opening ${widget.appLabel}',
                      style: const TextStyle(
                        color: _ink1,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    if (widget.contextLabel != null &&
                        widget.contextLabel!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _contextPill(widget.contextLabel!),
                    ],
                    const SizedBox(height: 24),
                    _sweepBar(),
                    if (_showReassurance) ...[
                      const SizedBox(height: 18),
                      // Fades in on first build — AnimatedOpacity would not,
                      // since it starts already at its target value.
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOut,
                        builder: (context, value, child) =>
                            Opacity(opacity: value, child: child),
                        child: const SizedBox(
                          width: 300,
                          child: Text(
                            'Syncing your business — this can take a moment on '
                            'a slow connection.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _ink3,
                              fontSize: 13,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plate() {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: widget.accent.withValues(alpha: 0.26),
            blurRadius: 34,
            offset: const Offset(0, 14),
            spreadRadius: -8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: SvgPicture.string(widget.iconSvg, width: 32, height: 32),
    );
  }

  Widget _contextPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_outlined, size: 14, color: _ink3),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _ink3,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Indeterminate progress: a short accent segment sweeping a hairline track.
  Widget _sweepBar() {
    const width = 168.0;
    const segment = 62.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: width,
        height: 4,
        color: _line,
        child: AnimatedBuilder(
          animation: _sweep,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_sweep.value);
            return Stack(
              children: [
                Positioned(
                  left: (width + segment) * t - segment,
                  child: Container(
                    width: segment,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [
                          widget.accent.withValues(alpha: 0),
                          widget.accent,
                          widget.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
