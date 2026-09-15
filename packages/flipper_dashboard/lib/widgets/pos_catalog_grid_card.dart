import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Desktop POS product tile.
///
/// Neutral surface, hairline border, no shadow; colour is reserved for
/// semantic state — selected (blue), low stock (amber), out of stock (red),
/// already-in-cart (blue pill). Hierarchy: name → price · stock → code.
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
    this.showPrice = true,
    this.stockLabelColor,
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
  final bool showPrice;
  final Color? stockLabelColor;

  @override
  State<PosCatalogGridCard> createState() => _PosCatalogGridCardState();
}

class _PosCatalogGridCardState extends State<PosCatalogGridCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = PosTokens.prefersReducedMotion(context);
    final interactive = !widget.isOutOfStock;
    final hover = _hovered && interactive;
    final scale = !reducedMotion && _pressed && interactive
        ? PosTokens.cardPressScale
        : 1.0;
    final selected = widget.showSelectionBorder;

    final borderColor = selected
        ? PosTokens.blue
        : (hover ? PosTokens.lineStrong : PosTokens.line);
    final background = selected
        ? PosTokens.blueTint
        : (hover ? PosTokens.surface2 : PosTokens.surface);

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
            decoration: BoxDecoration(
              color: background,
              borderRadius: PosTokens.cardRadius,
              border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Opacity(
              opacity: widget.isOutOfStock ? 0.62 : 1,
              // Thumb flexes so the text body keeps its intrinsic height.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.thumb,
                        if (widget.inCartQty > 0)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: _InCartPill(qty: widget.inCartQty),
                          ),
                        if (widget.stockVisual == PosStockVisual.low)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: _StockTag(
                              label: context.flipperL10n.stockLow,
                              isLow: true,
                            ),
                          ),
                        if (widget.stockVisual == PosStockVisual.out)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: _StockTag(
                              label: context.flipperL10n.stockOutBadge,
                              isLow: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fixed two-line slot so price rows align across the grid.
                        SizedBox(
                          height: 34,
                          child: Text(
                            widget.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PosTokens.ink1,
                              height: 1.3,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Price leads; the stock label yields first when the
                        // cell is narrow (both ellipsise rather than overflow).
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (widget.showPrice)
                              Flexible(
                                flex: 3,
                                child: _PosCardPrice(
                                  currencySymbol: widget.currencySymbol,
                                  amount: widget.priceAmount,
                                ),
                              ),
                            if (widget.showPrice &&
                                widget.stockLabel.isNotEmpty)
                              const SizedBox(width: 6),
                            if (!widget.showPrice) const Spacer(),
                            // Empty label hides the stock quantity (e.g. a user
                            // with the Hide Stock Quantity grant).
                            if (widget.stockLabel.isNotEmpty)
                              Flexible(
                                flex: 2,
                                child: Text(
                                  widget.stockLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: PosTokens.posMonoStyle(
                                    Theme.of(context).textTheme,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        widget.stockLabelColor ??
                                        posStockTextColor(widget.stockVisual),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (widget.bcdLabel != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.bcdLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: PosTokens.posMonoStyle(
                              Theme.of(context).textTheme,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: PosTokens.ink4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Price row: quiet currency + tabular amount (no decimals).
class _PosCardPrice extends StatelessWidget {
  const _PosCardPrice({required this.currencySymbol, required this.amount});

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
              fontWeight: FontWeight.w500,
              color: PosTokens.ink3,
            ),
          ),
          TextSpan(
            text: formatted,
            style: PosTokens.posPriceStyle(
              Theme.of(context).textTheme,
              fontSize: 14,
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
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: PosTokens.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            FluentIcons.checkmark_12_regular,
            size: 11,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            '$qty',
            style: PosTokens.posMonoStyle(
              Theme.of(context).textTheme,
              fontSize: 11.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Low / Out tag — a small square-cornered label, not a pill.
class _StockTag extends StatelessWidget {
  const _StockTag({required this.label, required this.isLow});

  final String label;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isLow ? PosTokens.warnTint : PosTokens.lossTint,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          height: 1,
          color: isLow ? PosTokens.warnAmber : PosTokens.lossInk,
        ),
      ),
    );
  }
}

/// Product thumb, in priority order:
///   1. the product image when there is one (desaturated when out of stock),
///   2. the colour the customer picked for this product ([userColor]),
///   3. a neutral band with the product initials.
///
/// Customer-chosen colour counts as semantic, not decoration — it is how the
/// operator finds the product — so it is kept even though the redesign
/// dropped the old hash-assigned tile colours.
Widget posCatalogThumb({
  required String name,
  required bool hasImage,
  required Widget? image,
  required bool isOutOfStock,
  Color? userColor,
}) {
  if (hasImage && image != null) {
    return ColorFiltered(
      colorFilter: isOutOfStock
          ? const ColorFilter.matrix(<double>[
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              0.6,
              0,
            ])
          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
      child: image,
    );
  }

  final hasColor = userColor != null;
  // Out of stock always desaturates, so a bright tile never reads as sellable.
  final background = isOutOfStock
      ? (hasColor ? const Color(0xFF9AA3B2) : PosTokens.neutralThumb)
      : (userColor ?? PosTokens.neutralThumb);
  final ink = hasColor && !isOutOfStock
      ? posInkOn(background)
      : (isOutOfStock && hasColor ? Colors.white : PosTokens.neutralThumbInk);

  return DecoratedBox(
    decoration: BoxDecoration(
      color: background,
      border: hasColor
          ? null
          : const Border(bottom: BorderSide(color: PosTokens.line)),
    ),
    child: Center(
      child: Text(
        posTileAbbr(name).toUpperCase(),
        style: TextStyle(
          color: ink,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    ),
  );
}
