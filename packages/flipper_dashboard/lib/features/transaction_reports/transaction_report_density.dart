import 'package:flutter/material.dart';

/// Vertical density tiers for Transaction Reports.
///
/// The report chrome (date header, KPI cards, filter row, cashier row) and the
/// grid used hard-coded sizes, so the transaction table only got whatever
/// height was left over. That reads fine on a 14"/16" MacBook (≈950–1000
/// logical px of body height) but a Windows laptop — 1366×768, or a 1080p panel
/// at 125/150% Windows display scaling (1536×864 / 1280×720 logical) — has
/// 150–300 fewer logical pixels and ended up showing only 2–3 rows before
/// scrolling.
///
/// Density scales the chrome and the grid rows to the height the report
/// actually gets, so each form factor shows a comparable number of rows.
enum ReportDensity { compact, cozy, comfortable }

/// Resolved sizes for one [ReportDensity].
///
/// [ReportMetrics.comfortable] intentionally reproduces the pre-density values
/// verbatim, so large screens (and any caller that does not opt in) render
/// exactly as before.
@immutable
class ReportMetrics {
  const ReportMetrics({
    required this.density,
    required this.pageVerticalPadding,
    required this.headerTopSpacing,
    required this.sectionGap,
    required this.tightGap,
    required this.cardVerticalPadding,
    required this.cardHorizontalPadding,
    required this.actionButtonSize,
    required this.actionIconSize,
    required this.primaryButtonVerticalPadding,
    required this.datePillVerticalPadding,
    required this.dateFontSize,
    required this.kpiBarHeight,
    required this.kpiCardVerticalPadding,
    required this.kpiLabelFontSize,
    required this.kpiValueFontSize,
    required this.kpiLabelValueGap,
    required this.kpiGap,
    required this.filterFieldWidth,
    required this.filterFieldVerticalPadding,
    required this.toggleVerticalPadding,
    required this.toggleHorizontalPadding,
    required this.toggleFontSize,
    required this.viewModeButtonSize,
    required this.chipVerticalPadding,
    required this.chipAvatarRadius,
    required this.chipFontSize,
    required this.gridRowHeight,
    required this.gridHeaderRowHeight,
    required this.pagerHeight,
    required this.pagerItemSize,
    required this.footerVerticalPadding,
    required this.preferFooterPagerOnly,
    required this.appBarHeight,
  });

  final ReportDensity density;

  /// Outer page padding (top + bottom) around the whole report body.
  final double pageVerticalPadding;

  /// Leading gap above the date pill in the top header row.
  final double headerTopSpacing;

  /// Gap between major blocks (header ↔ KPI ↔ filters).
  final double sectionGap;

  /// Gap between adjacent chrome cards (filters ↔ cashier ↔ table).
  final double tightGap;

  final double cardVerticalPadding;
  final double cardHorizontalPadding;

  /// Square size / icon size of the outlined toolbar icon buttons.
  final double actionButtonSize;
  final double actionIconSize;

  /// Vertical padding of the filled "Change Date" button.
  final double primaryButtonVerticalPadding;

  final double datePillVerticalPadding;
  final double dateFontSize;

  /// Height of the colored accent bar in a KPI card — it sets the card height.
  final double kpiBarHeight;
  final double kpiCardVerticalPadding;
  final double kpiLabelFontSize;
  final double kpiValueFontSize;
  final double kpiLabelValueGap;

  /// Horizontal gutter between / around KPI cards.
  final double kpiGap;

  final double filterFieldWidth;
  final double filterFieldVerticalPadding;

  final double toggleVerticalPadding;
  final double toggleHorizontalPadding;
  final double toggleFontSize;

  /// Square size of the chart / table view-mode buttons.
  final double viewModeButtonSize;

  final double chipVerticalPadding;
  final double chipAvatarRadius;
  final double chipFontSize;

  final double gridRowHeight;
  final double gridHeaderRowHeight;

  /// Height reserved for [SfDataPager] and the size of its items.
  final double pagerHeight;
  final double pagerItemSize;

  final double footerVerticalPadding;

  /// When the sticky footer already carries a working pager, drop the separate
  /// [SfDataPager] strip instead of showing two pagers stacked — worth ~60px of
  /// grid height on short screens. Callers must still verify the footer pager is
  /// actually present and functional for the current mode.
  final bool preferFooterPagerOnly;

  /// Toolbar extent for the report's [CustomAppBar] (default bar is 80).
  final double appBarHeight;

  bool get isCompact => density == ReportDensity.compact;

  /// Multiplier [CustomAppBar] applies to its nominal 80px toolbar.
  double get appBarMulti => appBarHeight / nominalAppBarHeight;

  /// Legacy sizing: what the screen looked like before density existed.
  static const ReportMetrics comfortable = ReportMetrics(
    density: ReportDensity.comfortable,
    pageVerticalPadding: 16,
    headerTopSpacing: 8,
    sectionGap: 16,
    tightGap: 12,
    cardVerticalPadding: 12,
    cardHorizontalPadding: 16,
    actionButtonSize: 44,
    actionIconSize: 22,
    primaryButtonVerticalPadding: 12,
    datePillVerticalPadding: 8,
    dateFontSize: 13,
    kpiBarHeight: 70,
    kpiCardVerticalPadding: 12,
    kpiLabelFontSize: 10,
    kpiValueFontSize: 20,
    kpiLabelValueGap: 6,
    kpiGap: 12,
    filterFieldWidth: 150,
    filterFieldVerticalPadding: 12,
    toggleVerticalPadding: 10,
    toggleHorizontalPadding: 20,
    toggleFontSize: 14,
    viewModeButtonSize: 40,
    chipVerticalPadding: 6,
    chipAvatarRadius: 12,
    chipFontSize: 13,
    gridRowHeight: 56,
    gridHeaderRowHeight: 44,
    pagerHeight: 60,
    pagerItemSize: 50,
    footerVerticalPadding: 12,
    preferFooterPagerOnly: false,
    appBarHeight: nominalAppBarHeight,
  );

  /// Mid tier — typical 1536×864 (1080p at 125%) Windows desktop.
  static const ReportMetrics cozy = ReportMetrics(
    density: ReportDensity.cozy,
    pageVerticalPadding: 12,
    headerTopSpacing: 4,
    sectionGap: 10,
    tightGap: 8,
    cardVerticalPadding: 9,
    cardHorizontalPadding: 14,
    actionButtonSize: 40,
    actionIconSize: 20,
    primaryButtonVerticalPadding: 10,
    datePillVerticalPadding: 7,
    dateFontSize: 13,
    kpiBarHeight: 56,
    kpiCardVerticalPadding: 9,
    kpiLabelFontSize: 10,
    kpiValueFontSize: 17,
    kpiLabelValueGap: 4,
    kpiGap: 10,
    filterFieldWidth: 142,
    filterFieldVerticalPadding: 10,
    toggleVerticalPadding: 8,
    toggleHorizontalPadding: 16,
    toggleFontSize: 13,
    viewModeButtonSize: 36,
    chipVerticalPadding: 5,
    chipAvatarRadius: 11,
    chipFontSize: 13,
    gridRowHeight: 48,
    gridHeaderRowHeight: 40,
    pagerHeight: 52,
    pagerItemSize: 40,
    footerVerticalPadding: 10,
    preferFooterPagerOnly: true,
    appBarHeight: 68,
  );

  /// Tight tier — 1366×768 laptops and 1080p at 150% scaling (1280×720).
  static const ReportMetrics compact = ReportMetrics(
    density: ReportDensity.compact,
    pageVerticalPadding: 8,
    headerTopSpacing: 0,
    sectionGap: 8,
    tightGap: 6,
    cardVerticalPadding: 6,
    cardHorizontalPadding: 12,
    actionButtonSize: 34,
    actionIconSize: 18,
    primaryButtonVerticalPadding: 8,
    datePillVerticalPadding: 5,
    dateFontSize: 12,
    kpiBarHeight: 44,
    kpiCardVerticalPadding: 6,
    kpiLabelFontSize: 9,
    kpiValueFontSize: 15,
    kpiLabelValueGap: 2,
    kpiGap: 8,
    filterFieldWidth: 128,
    filterFieldVerticalPadding: 8,
    toggleVerticalPadding: 6,
    toggleHorizontalPadding: 12,
    toggleFontSize: 12,
    viewModeButtonSize: 32,
    chipVerticalPadding: 3,
    chipAvatarRadius: 10,
    chipFontSize: 12,
    gridRowHeight: 40,
    gridHeaderRowHeight: 36,
    pagerHeight: 40,
    pagerItemSize: 32,
    footerVerticalPadding: 8,
    preferFooterPagerOnly: true,
    appBarHeight: 56,
  );

  /// Default [CustomAppBar] toolbar extent, and the base [appBarMulti] scales.
  static const double nominalAppBarHeight = 80;

  /// Below this text-scale-adjusted body height the report uses [compact].
  static const double compactMaxHeight = 760;

  /// Below this text-scale-adjusted body height the report uses [cozy].
  static const double cozyMaxHeight = 900;

  static ReportMetrics of(ReportDensity density) => switch (density) {
    ReportDensity.compact => compact,
    ReportDensity.cozy => cozy,
    ReportDensity.comfortable => comfortable,
  };

  /// Density for the height the report body actually received.
  ///
  /// [textScale] folds OS/app font scaling into the decision: scaled-up text
  /// eats the same vertical budget as a shorter screen.
  static ReportMetrics forHeight(double height, {double textScale = 1.0}) {
    if (!height.isFinite || height <= 0) return comfortable;
    final effective = textScale > 0 ? height / textScale : height;
    if (effective < compactMaxHeight) return compact;
    if (effective < cozyMaxHeight) return cozy;
    return comfortable;
  }

  /// Density from [availableHeight], falling back to the window height when the
  /// report is laid out unbounded (e.g. hosted inside a scrolling shell).
  static ReportMetrics forViewport(
    BuildContext context, {
    required double availableHeight,
  }) {
    final height = (availableHeight.isFinite && availableHeight > 0)
        ? availableHeight
        : MediaQuery.sizeOf(context).height;
    return forHeight(
      height,
      textScale: MediaQuery.textScalerOf(context).scale(14) / 14,
    );
  }

  /// Density for a full-window height, i.e. before the report's own app bar is
  /// subtracted. Use from the screen shell (which sizes the app bar); the body
  /// then resolves the same tier through [forViewport].
  static ReportMetrics forWindow(BuildContext context) {
    final windowHeight = MediaQuery.sizeOf(context).height;
    return forHeight(
      windowHeight - nominalAppBarHeight,
      textScale: MediaQuery.textScalerOf(context).scale(14) / 14,
    );
  }
}
