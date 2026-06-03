import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke icons for the transaction detail screen (from design_handoff_pos/icons).
class TransactionDetailSvgs {
  TransactionDetailSvgs._();

  static const _xmlns = 'xmlns="http://www.w3.org/2000/svg"';

  static String _strokeIcon(String body) =>
      '<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">$body</svg>';

  static Widget icon(String svg, {double size = 24, Color? color}) {
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static String chevronLeft() =>
      _strokeIcon('<path d="m15 6-6 6 6 6"/>');

  static String chevronDown() => _strokeIcon('<path d="m6 9 6 6 6-6"/>');

  static String more() =>
      '<svg viewBox="0 0 24 24" fill="none" $_xmlns><circle cx="5" cy="12" r="1.2" fill="currentColor"/><circle cx="12" cy="12" r="1.2" fill="currentColor"/><circle cx="19" cy="12" r="1.2" fill="currentColor"/></svg>';

  static String trendUp() =>
      _strokeIcon('<path d="M7 17 17 7"/><path d="M8 7h9v9"/>');

  static String trendDown() =>
      _strokeIcon('<path d="M7 7 17 17"/><path d="M8 17h9V8"/>');

  static String wallet() =>
      _strokeIcon(
        '<path d="M3 7a2 2 0 012-2h12v3"/><path d="M3 7v10a2 2 0 002 2h14a1 1 0 001-1V9a1 1 0 00-1-1H5a2 2 0 01-2-2Z"/><circle cx="17" cy="13.5" r="1.3" fill="currentColor" stroke="none"/>',
      );

  static String cart() =>
      _strokeIcon(
        '<path d="M3 4h2l2.5 11a2 2 0 002 1.6h7.5a2 2 0 002-1.6L21 8H6"/><circle cx="9" cy="20" r="1.2" fill="currentColor" stroke="none"/><circle cx="18" cy="20" r="1.2" fill="currentColor" stroke="none"/>',
      );

  static String clock() =>
      _strokeIcon('<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>');

  static String check() => _strokeIcon('<path d="M5 12.5 10 17 19 7.5"/>');

  static String receipt() =>
      _strokeIcon(
        '<path d="M6 3h12v18l-3-2-3 2-3-2-3 2z"/><path d="M9 8h6"/><path d="M9 12h6"/>',
      );

  static String share() =>
      _strokeIcon(
        '<path d="M4 12v7a1 1 0 001 1h14a1 1 0 001-1v-7"/><path d="m8 8 4-4 4 4"/><path d="M12 4v12"/>',
      );
}
