import 'dart:math' as math;

import 'package:flipper_design_system/flipper_design_system.dart'
    show FlipperColors;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The boot screen shown while the startup logic brings Ditto, the local
/// database and the session online: one mark, one line of copy, one hairline
/// bar.
///
/// The mark picks up where the native splash (white canvas, app icon) leaves
/// off, so the hand-off between the two reads as one screen rather than a flash.
///
/// [progress] is the *stepped* value the startup logic publishes (0.0 → 0.2 →
/// 0.4 …). [StartupProgressCounter] does the work of turning those steps into a
/// number that counts 0, 1, 2, 3 … so the screen never looks stuck on a round
/// number.
class StartupProgressScreen extends StatelessWidget {
  const StartupProgressScreen({super.key, required this.progress});

  final double progress;

  /// Column width. Wide enough for the tagline on two lines, narrow enough that
  /// the bar stays a detail rather than a banner on desktop.
  static const double contentWidth = 320;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final canvas = isLight ? Colors.white : FlipperColors.surfaceDark;
    final ink = isLight ? const Color(0xFF10161C) : Colors.white;
    final muted = isLight
        ? const Color(0xFF6B7580)
        : FlipperColors.onSurfaceDark;

    // Blended to an opaque colour on purpose: a translucent gradient stop makes
    // the alpha ramp, not the colour, do the fading, which tints the whole
    // canvas instead of just the halo behind the mark.
    final halo = Color.alphaBlend(
      FlipperColors.primary.withValues(alpha: isLight ? 0.10 : 0.22),
      canvas,
    );

    return Scaffold(
      backgroundColor: canvas,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.35),
            radius: 0.75,
            colors: [halo, canvas],
          ),
        ),
        child: SafeArea(
          child: Center(
            // Scrolls rather than overflows when the window is short — desktop
            // users can resize while this screen is still up.
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              // The scroll view hands its child a *tight* width, which a bare
              // ConstrainedBox would have to honour; this loosens it again so
              // the column keeps [contentWidth] and stays centred.
              child: Center(
                child: StartupProgressCounter(
                  target: progress,
                  builder: (context, value, clock) {
                    final percent = (value * 100).floor().clamp(0, 100);
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: contentWidth),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Mark(clock: clock, isLight: isLight),
                          const SizedBox(height: 26),
                          Text(
                            'Flipper',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                              height: 1.1,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A revolutionary business software...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.45,
                              color: muted,
                            ),
                          ),
                          const SizedBox(height: 34),
                          Semantics(
                            label: 'Startup progress',
                            value: '$percent%',
                            child: _ProgressBar(value: value, isLight: isLight),
                          ),
                          const SizedBox(height: 14),
                          _StatusLine(
                            // "Ready" only once the counter has caught up —
                            // startup finishing does not make 48% ready.
                            label: percent >= 100
                                ? 'Ready'
                                : startupStageLabel(progress),
                            percent: percent,
                            ink: ink,
                            muted: muted,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Names the step the startup logic is actually running — not the step the
/// counter has crept into. Mirrors the milestones in
/// `StartupViewModel.runStartupLogic`.
String startupStageLabel(double target) {
  if (target >= 1.0) return 'Finishing up';
  if (target >= 0.8) return 'Confirming your plan';
  if (target >= 0.6) return 'Syncing your data';
  if (target >= 0.4) return 'Starting services';
  if (target >= 0.2) return 'Checking your workspace';
  return 'Connecting';
}

/// Turns stepped progress into a value that moves one percent at a time, and
/// hands the frame clock to the decorative parts of the screen.
///
/// Three rules, in order of importance:
///  * **Never overtake real work.** The value may run at most [lead] past the
///    last milestone published, so 40% still means "requirements checked" and
///    never "nearly done".
///  * **Never go backwards.** The startup logic resets progress to 0 when it
///    retries after a timeout; a counter that drops back to 0% reads as a crash
///    rather than a retry, so it holds where it is instead.
///  * **Go quiet when there is nothing left to say.** Once the value reaches its
///    ceiling the ticker stops, so the screen stops scheduling frames — which
///    also keeps `pumpAndSettle` usable in tests.
class StartupProgressCounter extends StatefulWidget {
  const StartupProgressCounter({
    super.key,
    required this.target,
    required this.builder,
  });

  final double target;
  final Widget Function(BuildContext context, double value, Duration clock)
  builder;

  /// How far past the last published milestone the counter may creep.
  /// Milestones are 20% apart, so this stops 4% short of claiming the next one.
  static const double lead = 0.16;

  /// Seconds the counter takes to spend [lead] while a stage is still running —
  /// roughly one percent per second, which reads as "working", not "hung".
  static const double leadSeconds = 14;

  /// Progress per second used to catch up to work that has actually finished: a
  /// 20% milestone lands in about two thirds of a second.
  static const double catchUpRate = 0.3;

  @override
  State<StartupProgressCounter> createState() => _StartupProgressCounterState();
}

class _StartupProgressCounterState extends State<StartupProgressCounter>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _clock = Duration.zero;
  Duration _lastTick = Duration.zero;
  double _value = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(covariant StartupProgressCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A milestone landed after the counter had already settled: resume.
    if (widget.target != oldWidget.target && !_ticker.isActive) {
      _lastTick = _clock;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// The highest value the counter is allowed to show right now.
  double get _ceiling {
    final target = widget.target.clamp(0.0, 1.0);
    return target >= 1.0
        ? 1.0
        : math.min(1.0, target + StartupProgressCounter.lead);
  }

  void _onTick(Duration elapsed) {
    _clock = elapsed;
    final seconds =
        (elapsed - _lastTick).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;
    if (seconds <= 0) return;

    final ceiling = _ceiling;
    if (_value >= ceiling) {
      _ticker.stop();
      return;
    }

    // Fast while catching up to finished work, slow while only guessing.
    final rate = _value < widget.target
        ? StartupProgressCounter.catchUpRate
        : StartupProgressCounter.lead / StartupProgressCounter.leadSeconds;
    setState(() => _value = math.min(ceiling, _value + rate * seconds));
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value, _clock);
}

/// The logo tile — a rounded square that breathes while progress moves.
class _Mark extends StatelessWidget {
  const _Mark({required this.clock, required this.isLight});

  final Duration clock;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    // A 2% breathe: enough to feel alive, small enough that freezing mid-cycle
    // (the ticker stops once progress settles) is invisible.
    final phase = clock.inMilliseconds / 2600 * 2 * math.pi;
    final breathe = MediaQuery.disableAnimationsOf(context)
        ? 0.5
        : (1 + math.sin(phase)) / 2;

    return Transform.scale(
      scale: 1 + 0.02 * breathe,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: isLight ? Colors.white : const Color(0xFF232B36),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isLight ? FlipperColors.border : FlipperColors.borderDark,
          ),
          boxShadow: [
            BoxShadow(
              color: FlipperColors.primary.withValues(
                alpha: 0.10 + 0.12 * breathe,
              ),
              blurRadius: 30,
              spreadRadius: -2,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Image.asset(
            'assets/logo.png',
            package: 'flipper_dashboard',
            filterQuality: FilterQuality.medium,
            // Decoding costs a frame or two on a cold start; fade in rather than
            // popping the mark into an empty tile.
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 220),
                child: child,
              );
            },
            // The screen must still render when the asset bundle is unavailable
            // (widget tests, a stripped build), so fall back to the initial.
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                'F',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: FlipperColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 6px determinate bar with a soft glow, so the fill reads at a glance even at
/// low percentages.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.isLight});

  final double value;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final fraction = value.clamp(0.0, 1.0);
    return SizedBox(
      height: 6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Keep the first percent visible as a dot rather than a hairline.
          final filled = fraction == 0
              ? 0.0
              : math.max(6.0, constraints.maxWidth * fraction);
          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isLight
                      ? const Color(0xFFE9ECEF)
                      : const Color(0xFF2C3440),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              if (filled > 0)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: filled,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0090E0), FlipperColors.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: FlipperColors.primary.withValues(alpha: 0.45),
                          blurRadius: 12,
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Stage name on the left, percentage on the right — monospaced so the digits do
/// not shift the row as they count.
class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.label,
    required this.percent,
    required this.ink,
    required this.muted,
  });

  final String label;
  final int percent;
  final Color ink;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: muted,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$percent%',
          style: TextStyle(
            // Geist Mono ships with this package, so the digits are guaranteed
            // to render; the platform families are only a safety net.
            fontFamily: 'packages/flipper_dashboard/Geist Mono',
            fontFamilyFallback: const [
              'Menlo',
              'SF Mono',
              'Roboto Mono',
              'Courier New',
              'monospace',
            ],
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
      ],
    );
  }
}
