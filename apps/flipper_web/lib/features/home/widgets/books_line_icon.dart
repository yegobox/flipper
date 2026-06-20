import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke icons extracted from Flipper-Books-Handoff/reference/home.html.
enum BooksIcon {
  cart('assets/svg/books/cart.svg'),
  book('assets/svg/books/book.svg'),
  flow('assets/svg/books/flow.svg'),
  arrowRight('assets/svg/books/arrow_right.svg'),
  arrowConnector('assets/svg/books/arrow_connector.svg'),
  shield('assets/svg/books/shield.svg'),
  trendUp('assets/svg/books/trend_up.svg'),
  card('assets/svg/books/card.svg'),
  clock('assets/svg/books/clock.svg'),
  listLines('assets/svg/books/list_lines.svg'),
  refreshLoop('assets/svg/books/refresh_loop.svg'),
  shieldCheck('assets/svg/books/shield_check.svg'),
  alert('assets/svg/books/alert.svg'),
  chartLine('assets/svg/books/chart_line.svg'),
  bankLines('assets/svg/books/bank_lines.svg'),
  dollar('assets/svg/books/dollar.svg'),
  doc('assets/svg/books/doc.svg'),
  building('assets/svg/books/building.svg'),
  grid('assets/svg/books/grid.svg'),
  journal('assets/svg/books/journal.svg'),
  layers('assets/svg/books/layers.svg'),
  search('assets/svg/books/search.svg'),
  plus('assets/svg/books/plus.svg'),
  check('assets/svg/books/check.svg'),
  flame('assets/svg/books/flame.svg');

  const BooksIcon(this.assetPath);

  final String assetPath;
}

class BooksLineIcon extends StatelessWidget {
  const BooksLineIcon(
    this.icon, {
    super.key,
    this.size = 16,
    this.color = AppColors.ink2,
  });

  final BooksIcon icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
