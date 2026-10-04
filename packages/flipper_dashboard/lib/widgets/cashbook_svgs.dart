import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke glyphs the Cash Book needs that the shared icon sets lack. Same
/// 24px / 1.5 stroke / `currentColor` style as [TransactionDetailSvgs], whose
/// wallet, receipt, trend and chevron icons the Cash Book reuses directly.
abstract final class CashbookSvgs {
  static const _xmlns = 'xmlns="http://www.w3.org/2000/svg"';

  static String _strokeIcon(String body, {double strokeWidth = 1.5}) =>
      '<svg viewBox="0 0 24 24" fill="none" $_xmlns stroke="currentColor" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round">$body</svg>';

  /// Money coming in (mirror of [TransactionDetailSvgs.trendUp]).
  static String arrowDownLeft({double strokeWidth = 1.5}) => _strokeIcon(
    '<path d="M17 7 7 17"/><path d="M16 17H7V8"/>',
    strokeWidth: strokeWidth,
  );

  /// Money going out.
  static String arrowUpRight({double strokeWidth = 1.5}) => _strokeIcon(
    '<path d="M7 17 17 7"/><path d="M8 7h9v9"/>',
    strokeWidth: strokeWidth,
  );

  /// Category tag.
  static String tag() => _strokeIcon(
    '<path d="M3 12.6V5a2 2 0 0 1 2-2h7.6a2 2 0 0 1 1.4.6l7.4 7.4a2 2 0 0 1 0 2.8l-7.6 7.6a2 2 0 0 1-2.8 0L3.6 14a2 2 0 0 1-.6-1.4Z"/><circle cx="8" cy="8" r="1.4" fill="currentColor" stroke="none"/>',
  );

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
}
