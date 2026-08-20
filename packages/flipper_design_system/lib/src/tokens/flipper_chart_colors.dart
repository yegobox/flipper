import 'package:flutter/material.dart';

/// Categorical chart series colors for fl_chart usage (Reports, Branch
/// Performance, dashboard analytics). Slot 1 is the brand primary; the
/// remaining seven hold a fixed order chosen for colorblind-safe adjacent
/// separation — never reorder or cycle them per-chart.
///
/// Series identity must never rely on color alone: pair every series with a
/// legend entry and, for <=4 series, a direct label.
abstract final class FlipperChartColors {
  static const List<Color> light = [
    Color(0xFF00C2E8), // 1 brand teal
    Color(0xFFEB6834), // 2 orange
    Color(0xFF1BAF7A), // 3 aqua
    Color(0xFFEDA100), // 4 yellow
    Color(0xFFE87BA4), // 5 magenta
    Color(0xFF008300), // 6 green
    Color(0xFF4A3AA7), // 7 violet
    Color(0xFFE34948), // 8 red
  ];

  static const List<Color> dark = [
    Color(0xFF00A5C4), // 1 brand teal
    Color(0xFFD95926), // 2 orange
    Color(0xFF199E70), // 3 aqua
    Color(0xFFC98500), // 4 yellow
    Color(0xFFD55181), // 5 magenta
    Color(0xFF008300), // 6 green
    Color(0xFF9085E9), // 7 violet
    Color(0xFFE66767), // 8 red
  ];

  /// Fixed-order palette for the current theme brightness.
  static List<Color> of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  /// Color for series [index]. Never generate a 9th hue — fold extra series
  /// into "Other" or a small multiple instead.
  static Color forSeries(BuildContext context, int index) =>
      of(context)[index % of(context).length];
}
