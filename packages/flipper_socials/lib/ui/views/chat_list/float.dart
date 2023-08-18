import 'package:flutter/material.dart';

class CustomFABAnimator extends FloatingActionButtonAnimator {
  final AnimationController progressController;

  CustomFABAnimator({required this.progressController});

  @override
  Offset getOffset(
      {required Offset begin, required Offset end, required double progress}) {
    final curve = CurvedAnimation(
        parent: progressController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut));

    final TweenSequence<Offset> tween = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: begin, end: const Offset(0.0, -0.15)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(
              begin: const Offset(0.0, -0.15), end: const Offset(0.0, 0.0)),
          weight: 50),
    ]);

    return tween.animate(curve).value;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: parent, curve: Curves.easeInOut));
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: parent, curve: Curves.easeInOut));
  }
}
