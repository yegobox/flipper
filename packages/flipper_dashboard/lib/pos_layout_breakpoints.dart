import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Shared layout breakpoints for POS / dashboard desktop shell.
/// Keep in sync with [DeviceTypeExtension.isSmallDevice] (< 600) in flipper_models.
abstract final class PosLayoutBreakpoints {
  static const double mobileLayoutMaxWidth = 600;

  /// Left rail width; must match [EnhancedSideMenu] and [UnifiedTopBar] logo rail.
  static const double sideMenuWidth = 80;

  /// Horizontal inset for search strip above checkout (see [UnifiedTopBar]).
  static const double contentSearchLeadingInset = 8;

  /// Below this total dashboard width, POS uses an end drawer for the cart
  /// instead of a permanent split (desktop only; [mobileLayoutMaxWidth] still
  /// uses [MobileView]).
  static const double desktopSplitMinWidth = 1100;

  /// Primary accent from POS mock (blue-600).
  static const Color posAccentBlue = Color(0xFF2563EB);

  /// Product grid column count from **pane** width (not full window).
  static int productGridCrossAxisCountForPaneWidth(double paneWidth) {
    if (paneWidth < 520) return 2;
    if (paneWidth < 720) return 3;
    if (paneWidth < 1000) return 4;
    return 6;
  }

  static double desktopGridSpacing(double paneWidth) =>
      paneWidth < 720 ? 12.0 : 16.0;

  /// Child aspect ratio for product cards in the grid.
  static double desktopGridChildAspectRatio(int crossAxisCount) {
    if (crossAxisCount <= 2) return 0.72;
    if (crossAxisCount <= 3) return 0.76;
    if (crossAxisCount <= 4) return 0.78;
    return 0.78;
  }

  static double cartDrawerWidth(double maxWidth) =>
      math.min(440, maxWidth * 0.48).clamp(320.0, 440.0).toDouble();
}
