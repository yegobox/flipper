import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Desktop POS product tile (handoff grid card).
class PosCatalogGridCard extends StatefulWidget {
  const PosCatalogGridCard({
    super.key,
    required this.productName,
    required this.bcdLabel,
    required this.currencySymbol,
    required this.priceAmount,
    required this.stockVisual,
    required this.stockLabel,
    required this.inCartQty,
    required this.showSelectionBorder,
    required this.isOutOfStock,
    required this.thumb,
    required this.onTap,
    required this.onLongPress,
  });

  final String productName;
  final String? bcdLabel;
  final String currencySymbol;
  final num priceAmount;
  final PosStockVisual stockVisual;
  final String stockLabel;
  final int inCartQty;
  final bool showSelectionBorder;
  final bool isOutOfStock;
  final Widget thumb;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<PosCatalogGridCard> createState() => _PosCatalogGridCardState();
}

class _PosCatalogGridCardState extends State<PosCatalogGridCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = PosTokens.prefersReducedMotion(context);
    final lift = !reducedMotion && _hovered && !widget.isOutOfStock;
    final scale = !reducedMotion && _pressed && !widget.isOutOfStock
        ? PosTokens.cardPressScale
        : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.isOutOfStock
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: widget.isOutOfStock
            ? null
            : (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.isOutOfStock ? null : widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: scale,
          duration: PosTokens.pressTransition,
          curve: Curves.ease,
          child: AnimatedContainer(
            duration: PosTokens.hoverTransition,
            curve: Curves.ease,
            transform: Matrix4.translationValues(
              0,
              lift ? -PosTokens.cardHoverLift : 0,
              0,
            ),
            decoration: BoxDecoration(
              color: PosTokens.surface,
              borderRadius: BorderRadius.circular(PosTokens.radiusMd),
              border: Border.all(
                color: widget.showSelectionBorder
                    ? PosTokens.blue
                    : (lift ? PosTokens.lineStrong : PosTokens.line),
                width: widget.showSelectionBorder ? 2 : 1.5,
              ),
              boxShadow: lift ? PosTokens.shadow2 : PosTokens.shadow1,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: PosTokens.productThumbHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.thumb,
                      if (widget.inCartQty > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: _InCartPill(qty: widget.inCartQty),
                        ),
                      if (widget.stockVisual == PosStockVisual.low)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: _StockBadge(label: 'Low', isLow: true),
                        ),
                      if (widget.stockVisual == PosStockVisual.out)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: _StockBadge(label: 'Out', isLow: false),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: PosTokens.ink1,
                            letterSpacing: -0.01,
                          ),
                        ),
                        if (widget.bcdLabel != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.bcdLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PosTokens.posMonoStyle(
                              Theme.of(context).textTheme,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: PosTokens.ink4,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            _PosCardPrice(
                              currencySymbol: widget.currencySymbol,
                              amount: widget.priceAmount,
                            ),
                            const Spacer(),
                            Text(
                              widget.stockLabel,
                              style: PosTokens.posMonoStyle(
                                Theme.of(context).textTheme,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: posStockTextColor(widget.stockVisual),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Handoff price row: gray `RWF` + bold amount (no decimals).
class _PosCardPrice extends StatelessWidget {
  const _PosCardPrice({
    required this.currencySymbol,
    required this.amount,
  });

  final String currencySymbol;
  final num amount;

  @override
  Widget build(BuildContext context) {
    final n = amount is int ? amount : amount.round();
    final formatted = NumberFormat('#,###').format(n);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$currencySymbol ',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: PosTokens.ink3,
            ),
          ),
          TextSpan(
            text: formatted,
            style: PosTokens.posPriceStyle(
              Theme.of(context).textTheme,
              fontSize: 15,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _InCartPill extends StatelessWidget {
  const _InCartPill({required this.qty});

  final int qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: const Color(0xEBFFFFFF),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            FluentIcons.checkmark_12_regular,
            size: 12,
            color: PosTokens.blue,
          ),
          const SizedBox(width: 3),
          Text(
            '$qty',
            style: PosTokens.posMonoStyle(
              Theme.of(context).textTheme,
              fontSize: 13,
              color: PosTokens.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.label, required this.isLow});

  final String label;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isLow ? PosTokens.warnTint : PosTokens.lossTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLow)
            const Icon(
              FluentIcons.warning_16_regular,
              size: 11,
              color: PosTokens.warnAmber,
            ),
          if (isLow) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isLow ? PosTokens.warnAmber : PosTokens.lossInk,
            ),
          ),
        ],
      ),
    );
  }
}

/// Colored initials thumb or desaturated when out of stock.
Widget posCatalogThumb({
  required String name,
  required bool hasImage,
  required Widget? image,
  required bool isOutOfStock,
}) {
  if (hasImage && image != null) {
    return ColorFiltered(
      colorFilter: isOutOfStock
          ? const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 0.6, 0,
            ])
          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
      child: image,
    );
  }

  final bg = isOutOfStock
      ? const Color(0xFF9AA3B2)
      : posTileColorForName(name);

  return ColoredBox(
    color: bg,
    child: Center(
      child: Text(
        posTileAbbr(name),
        style: TextStyle(
          color: Colors.white.withValues(alpha: isOutOfStock ? 0.85 : 1),
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          shadows: const [
            Shadow(
              color: Color(0x24000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    ),
  );
}
