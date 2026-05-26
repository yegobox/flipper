import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Shared layout breakpoints for POS / dashboard desktop shell.
/// Keep in sync with [DeviceTypeExtension.isSmallDevice] (< 600) in flipper_models.
abstract final class PosLayoutBreakpoints {
  static const double mobileLayoutMaxWidth = 600;

  /// Left rail width; must match [EnhancedSideMenu] and the header logo column
  /// in [DashboardLayout].
  static const double sideMenuWidth = 80;

  /// Desktop shell header row ([UnifiedTopBar] + logo column); keep in sync with
  /// [UnifiedTopBar] vertical sizing.
  static const double desktopTopBarHeight = 70;

  /// Horizontal inset for search strip above checkout (see [UnifiedTopBar]).
  static const double contentSearchLeadingInset = 8;

  /// Below this total dashboard width, POS uses an end drawer for the cart
  /// instead of a permanent split (desktop only; [mobileLayoutMaxWidth] still
  /// uses [MobileView]).
  static const double desktopSplitMinWidth = 1100;

  /// Primary accent from POS mock (blue-600).
  static const Color posAccentBlue = Color(0xFF2563EB);

  /// Product grid column count from **pane** width (not full window).
  /// Wide panes use 5 columns to match the desktop POS reference.
  static int productGridCrossAxisCountForPaneWidth(double paneWidth) {
    if (paneWidth < 520) return 2;
    if (paneWidth < 720) return 3;
    if (paneWidth < 1000) return 4;
    return 5;
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

  /// Below this checkout-pane height, cart + form use one vertical scroll
  /// ([QuickSellingView._buildSharedView]).
  static const double sharedViewScrollHeightThreshold = 560;

  /// Above [sharedViewScrollHeightThreshold] but below this, favor cart lines
  /// over the payment form (5:1 vs 3:2) — typical 720p desktop windows.
  static const double checkoutShortDesktopMaxHeight = 800;

  /// Flex weights for cart vs form when pane height is tall enough for 3:2.
  static const int checkoutItemsFormFlexTallItems = 3;
  static const int checkoutItemsFormFlexTallForm = 2;

  /// Flex weights for short desktop panes (more room for line items / expand).
  static const int checkoutItemsFormFlexShortItems = 5;
  static const int checkoutItemsFormFlexShortForm = 1;

  /// List viewport height under which expanded row fields stack vertically.
  static const double expandedCartRowCompactHeight = 380;

  /// Narrow cart column: stack expanded qty/price fields vertically.
  static const double expandedCartRowCompactWidth = 360;

  /// Approximate [PayableView] footer + padding in checkout column (layout math).
  static const double payableFooterReservedHeight = 138;

  /// Checkout bar uses stacked Tickets/Pay below this **pane** width.
  static const double payableVerticalBarMaxWidth = 560;

  /// Stacked bar when landscape and pane height is below this.
  static const double payableVerticalBarMaxLandscapeHeight = 600;

  /// True when the checkout pane should use a single vertical scroll.
  static bool useSingleScrollCheckoutPane(double maxHeight) =>
      maxHeight < sharedViewScrollHeightThreshold;

  /// Cart vs payment-form flex for a bounded checkout pane height.
  static ({int items, int form}) checkoutFlexForPaneHeight(double maxHeight) {
    if (maxHeight < checkoutShortDesktopMaxHeight) {
      return (
        items: checkoutItemsFormFlexShortItems,
        form: checkoutItemsFormFlexShortForm,
      );
    }
    return (
      items: checkoutItemsFormFlexTallItems,
      form: checkoutItemsFormFlexTallForm,
    );
  }
}
