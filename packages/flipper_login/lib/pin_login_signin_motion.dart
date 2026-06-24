import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Durations, curves, and tweens from `design_handoff_signin/ANIMATIONS.md`.
/// Do not infer timing from CSS `@keyframes`.
abstract final class SignInMotion {
  // Durations
  static const Duration shake = Duration(milliseconds: 400);
  static const Duration cellTransition = Duration(milliseconds: 150);
  static const Duration dotPop = Duration(milliseconds: 120);
  static const Duration statusReveal = Duration(milliseconds: 200);
  static const Duration pressFeedback = Duration(milliseconds: 120);
  static const Duration floatCycle = Duration(milliseconds: 6000);

  // Curves (easing table in ANIMATIONS.md)
  static const Curve shakeCurve = Curves.ease;
  static const Curve cellCurve = Curves.ease;
  static const Curve dotPopCurve = Curves.easeOut;
  static const Curve statusRevealCurve = Curves.easeOutCubic;
  static const Curve pressCurve = Curves.ease;
  static const Curve floatCurve = Curves.easeInOut;

  static const double floatAmplitude = 9;
  static const double pressScale = 0.97;

  /// PIN row shake: 0 → −6 (20%) → +6 (40%) → −6 (60%) → +6 (80%) → 0 (100%).
  static Animation<double> pinShake(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -6), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -6, end: 6), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 6, end: -6), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -6, end: 6), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 6, end: 0), weight: 20),
    ]).animate(
      CurvedAnimation(parent: controller, curve: shakeCurve),
    );
  }

  /// Brand-panel card bob: translateY 0 → −9px (50%) → 0, ease-in-out, 6s loop.
  /// [phase] offsets the cycle (e.g. 600ms → 0.1 on a 6000ms period).
  static double floatTranslateY(double controllerValue, {double phase = 0}) {
    final t = (controllerValue + phase) % 1.0;
    final eased = floatCurve.transform(t);
    return -floatAmplitude * math.sin(eased * math.pi);
  }
}
