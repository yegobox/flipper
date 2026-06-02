import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Motion spec from [design_handoff_mobile_pos/ANIMATIONS.md] — do not infer from CSS.
abstract final class MposMotion {
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve overshoot = Curves.elasticOut;

  static const Duration scrimFade = Duration(milliseconds: 200);
  static const Duration sheetSlide = Duration(milliseconds: 320);
  static const Duration toastEnter = Duration(milliseconds: 300);
  static const Duration toastDismiss = Duration(milliseconds: 2600);

  static const Duration checkPop = Duration(milliseconds: 500);
  static const Duration receiptIn = Duration(milliseconds: 420);
  static const Duration receiptDelay = Duration(milliseconds: 200);

  static const Duration pressShort = Duration(milliseconds: 100);
  static const Duration pressMedium = Duration(milliseconds: 120);
  static const Duration focusRing = Duration(milliseconds: 150);

  static bool reducedMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context) ||
        SchedulerBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;
  }
}
