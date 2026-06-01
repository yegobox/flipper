import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

/// Shared layout breakpoints for POS / dashboard desktop shell.
/// Keep in sync with [DeviceTypeExtension.isSmallDevice] (< 600) in flipper_models.
abstract final class PosLayoutBreakpoints {
  static const double mobileLayoutMaxWidth = 600;

  /// Left rail width; must match [EnhancedSideMenu] and the header logo column
  /// in [DashboardLayout].
  static const double sideMenuWidth = PosTokens.sideMenuWidth;

  /// Desktop shell header row ([UnifiedTopBar] + logo column).
  static const double desktopTopBarHeight = PosTokens.topBarHeight;

  /// Fixed cart column width on wide desktop split (handoff).
  static const double cartPanelWidth = PosTokens.cartPanelWidth;

  /// Horizontal inset for search strip above checkout (see [UnifiedTopBar]).
  static const double contentSearchLeadingInset = 8;

  /// Below this total dashboard width, POS uses an end drawer for the cart
  /// instead of a permanent split (desktop only; [mobileLayoutMaxWidth] still
  /// uses [MobileView]).
  static const double desktopSplitMinWidth = 1100;

  /// Primary accent from POS mock (blue-600).
  static const Color posAccentBlue = PosTokens.blue;

  /// Product grid column count from **pane** width (not full window).
  /// Wide panes cap at 4 columns per handoff.
  static int productGridCrossAxisCountForPaneWidth(double paneWidth) {
    if (paneWidth < 520) return 2;
    if (paneWidth < 720) return 3;
    return 4;
  }

  static double desktopGridSpacing(double paneWidth) =>
      paneWidth < 720 ? 12.0 : PosTokens.gridGap;

  /// Body below the 104px thumb (padding + name + bcd + price row).
  static const double productCardBodyHeight = 88;

  static double productCardTotalHeight() =>
      PosTokens.productThumbHeight + productCardBodyHeight;

  /// Aspect ratio from pane width so grid cells match handoff card proportions.
  static double desktopGridChildAspectRatioForPane(double paneWidth) {
    final cols = productGridCrossAxisCountForPaneWidth(paneWidth);
    final spacing = desktopGridSpacing(paneWidth);
    final tileWidth = (paneWidth - spacing * (cols - 1)) / cols;
    return tileWidth / productCardTotalHeight();
  }

  /// Child aspect ratio for product cards in the grid (~104px thumb + body).
  static double desktopGridChildAspectRatio(int crossAxisCount) {
    // Legacy callers: approximate width for column count.
    const refWidth = 900.0;
    return desktopGridChildAspectRatioForPane(refWidth);
  }

  static double cartDrawerWidth(double maxWidth) =>
      math.min(cartPanelWidth, maxWidth * 0.48).clamp(320.0, cartPanelWidth).toDouble();

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
