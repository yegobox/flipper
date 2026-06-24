import 'package:flutter/material.dart';

import '../../widgets/pos_handoff_icon.dart';

/// Stroke SVG icons from the stock-recount / POS design handoffs
/// (`design_handoff_stock_recount/onboarding/icons.jsx`, `design_handoff_pos/icons/`).
abstract final class StockRecountIcons {
  StockRecountIcons._();

  static Widget svg(
    String name, {
    double size = 24,
    Color? color,
  }) =>
      PosHandoffIcons.svg(name, size: size, color: color);

  static Widget search({double size = 19, Color? color}) =>
      svg('search', size: size, color: color);

  static Widget download({double size = 18, Color? color}) =>
      svg('download', size: size, color: color);

  static Widget check({double size = 18, Color? color}) =>
      svg('check', size: size, color: color);

  static Widget chevronLeft({double size = 18, Color? color}) =>
      svg('chevron-left', size: size, color: color);

  static Widget chevronRight({double size = 20, Color? color}) =>
      svg('chevron-right', size: size, color: color);

  static Widget filter({double size = 15, Color? color}) =>
      svg('filter', size: size, color: color);

  static Widget clock({double size = 13, Color? color}) =>
      svg('clock', size: size, color: color);

  static Widget stack({double size = 13, Color? color}) =>
      svg('stack', size: size, color: color);

  static Widget archive({double size = 22, Color? color}) =>
      svg('archive', size: size, color: color);

  static Widget box({double size = 22, Color? color}) =>
      svg('box', size: size, color: color);

  static Widget plus({double size = 20, Color? color}) =>
      svg('plus', size: size, color: color);

  static Widget x({double size = 16, Color? color}) =>
      svg('x', size: size, color: color);

  static Widget info({double size = 18, Color? color}) =>
      svg('info', size: size, color: color);

  static Widget receipt({double size = 17, Color? color}) =>
      svg('receipt', size: size, color: color);

  static Widget barcode({double size = 24, Color? color}) =>
      svg('barcode', size: size, color: color);

  static Widget trash({double size = 17, Color? color}) =>
      svg('trash', size: size, color: color);

  static Widget monitor({double size = 13, Color? color}) =>
      svg('monitor', size: size, color: color);

  static Widget trendUp({double size = 13, Color? color}) =>
      svg('trend-up', size: size, color: color);

  static Widget arrowUp({double size = 13, Color? color}) =>
      svg('arrow-up', size: size, color: color);

  static Widget arrowDown({double size = 13, Color? color}) =>
      svg('arrow-down', size: size, color: color);

  static Widget minus({double size = 18, Color? color}) =>
      svg('minus', size: size, color: color);
}
