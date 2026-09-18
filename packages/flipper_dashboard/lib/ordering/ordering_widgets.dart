import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

/// `RWF 12,345` — whole units, grouped, as the handoff formats every amount on
/// the purchase-order screen.
String orderingMoney(num amount) {
  return amount.toCurrencyFormatted(
    symbol: ProxyService.box.defaultCurrency(),
    decimalDigits: 0,
  );
}

/// Currency prefix for the editable cost field, where the amount is a bare
/// number the operator types over.
String get orderingCurrencySymbol {
  final symbol = ProxyService.box.defaultCurrency().trim();
  return symbol.isEmpty ? 'RWF' : symbol;
}

/// Grouped integer without a currency symbol (quantities, stock on hand).
String orderingCount(num value) {
  return value.round().toCurrencyFormatted(symbol: '', decimalDigits: 0).trim();
}

/// Rebuilds [builder] with the pointer's hover state.
///
/// The handoff carries a `style-hover` on most interactive surfaces; this keeps
/// each of them from growing its own StatefulWidget.
class OrderingHover extends StatefulWidget {
  const OrderingHover({
    super.key,
    required this.builder,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final bool enabled;
  final MouseCursor cursor;

  @override
  State<OrderingHover> createState() => _OrderingHoverState();
}

class _OrderingHoverState extends State<OrderingHover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.builder(context, false);
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(context, _hovered),
    );
  }
}

/// Uppercase section label.
class OrderingEyebrow extends StatelessWidget {
  const OrderingEyebrow(this.text, {super.key, this.padding = EdgeInsets.zero});

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text.toUpperCase(), style: OrderingTokens.eyebrow),
    );
  }
}

/// A keycap, as in the top bar's `/ search` hint.
class OrderingKbd extends StatelessWidget {
  const OrderingKbd(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: const BoxDecoration(
        color: OrderingTokens.surface,
        borderRadius: BorderRadius.all(Radius.circular(OrderingTokens.rSm)),
        border: Border(
          top: BorderSide(color: OrderingTokens.lineStrong),
          left: BorderSide(color: OrderingTokens.lineStrong),
          right: BorderSide(color: OrderingTokens.lineStrong),
          bottom: BorderSide(color: OrderingTokens.lineStrong, width: 2),
        ),
      ),
      child: Text(
        label,
        style: OrderingTokens.monoStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 18px square checkbox used by the rail filters.
class OrderingCheckbox extends StatelessWidget {
  const OrderingCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return OrderingHover(
      builder: (context, hovered) => GestureDetector(
        onTap: onChanged,
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          checked: value,
          label: label,
          child: Row(
            children: [
              AnimatedContainer(
                duration: OrderingTokens.hover,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: value
                      ? OrderingTokens.blue
                      : OrderingTokens.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(OrderingTokens.rSm),
                  ),
                  border: Border.all(
                    color: value
                        ? OrderingTokens.blue
                        : (hovered
                              ? OrderingTokens.ink6
                              : OrderingTokens.ink8),
                    width: 1.5,
                  ),
                ),
                child: value
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: OrderingTokens.bodyStrong,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square icon button with a hairline border (top-bar back, clear supplier).
class OrderingIconButton extends StatelessWidget {
  const OrderingIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 36,
    this.iconSize = 18,
    this.bordered = true,
    this.background = OrderingTokens.surface,
    this.hoverBackground = OrderingTokens.bg,
    this.foreground = OrderingTokens.ink2,
    this.hoverForeground = OrderingTokens.ink1,
    this.radius = OrderingTokens.rControl,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final bool bordered;
  final Color background;
  final Color hoverBackground;
  final Color foreground;
  final Color hoverForeground;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final button = OrderingHover(
      enabled: onPressed != null,
      builder: (context, hovered) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: hovered ? hoverBackground : background,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            border: bordered
                ? Border.all(color: OrderingTokens.line)
                : null,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: hovered ? hoverForeground : foreground,
          ),
        ),
      ),
    );

    // Tooltip, not Tooltip-the-widget: a Tooltip under a LayoutBuilder trips
    // OverlayPortal's !_skipMarkNeedsLayout assert, and this screen nests both.
    return tooltip == null
        ? button
        : Semantics(button: true, label: tooltip, child: button);
  }
}

/// Filled primary action (Place order, Start another order).
class OrderingPrimaryButton extends StatelessWidget {
  const OrderingPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return OrderingHover(
      enabled: enabled,
      cursor: enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      builder: (context, hovered) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          width: expand ? double.infinity : null,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: !enabled
                ? OrderingTokens.ink7
                : (hovered ? OrderingTokens.blueHover : OrderingTokens.blue),
            borderRadius: const BorderRadius.all(Radius.circular(11)),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  style: OrderingTokens.submit,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary action (Add, View order).
class OrderingSecondaryButton extends StatelessWidget {
  const OrderingSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 40,
    this.horizontalPadding = 14,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double horizontalPadding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return OrderingHover(
      enabled: onPressed != null,
      builder: (context, hovered) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: hovered
                ? OrderingTokens.blueRow
                : OrderingTokens.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(OrderingTokens.rStepper),
            ),
            border: Border.all(
              color: hovered
                  ? OrderingTokens.blue
                  : OrderingTokens.lineStrong,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: hovered
                      ? OrderingTokens.blue
                      : const Color(0xFF2E3B4A),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: OrderingTokens.sans,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: hovered
                      ? OrderingTokens.blue
                      : const Color(0xFF2E3B4A),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill carrying a semantic note (cost change, over-stock warning).
class OrderingBadge extends StatelessWidget {
  const OrderingBadge({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(
          Radius.circular(OrderingTokens.rMd),
        ),
      ),
      child: Text(
        label,
        style: OrderingTokens.badge.copyWith(color: foreground),
      ),
    );
  }
}

/// Centred icon + headline + hint, used by every empty state on the screen.
class OrderingEmptyState extends StatelessWidget {
  const OrderingEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.hintWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
    this.iconSize = 34,
  });

  final IconData icon;
  final String title;
  final String? hint;
  final Widget? hintWidget;
  final EdgeInsetsGeometry padding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: OrderingTokens.ink8),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: OrderingTokens.sans,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: OrderingTokens.ink1,
              height: 1.25,
            ),
          ),
          if (hintWidget != null) ...[
            const SizedBox(height: 6),
            hintWidget!,
          ] else if (hint != null) ...[
            const SizedBox(height: 6),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: OrderingTokens.body.copyWith(
                color: OrderingTokens.ink4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Search field shared by the supplier picker and the catalogue header.
class OrderingSearchField extends StatelessWidget {
  const OrderingSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.filled = false,
    this.verticalPadding = 11,
    this.fontSize = 14.5,
    this.iconSize = 17,
  });

  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final ValueChanged<String>? onSubmitted;

  /// The catalogue header sits the field on [OrderingTokens.bg]; the picker
  /// leaves it white.
  final bool filled;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? OrderingTokens.bg : OrderingTokens.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(filled ? OrderingTokens.rControl : 12),
        ),
        border: Border.all(color: OrderingTokens.line, width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: filled ? 13 : 16),
      child: Row(
        children: [
          Icon(Icons.search, size: iconSize, color: OrderingTokens.ink4),
          SizedBox(width: filled ? 11 : 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              cursorColor: OrderingTokens.blue,
              style: TextStyle(
                fontFamily: OrderingTokens.sans,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: OrderingTokens.ink1,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: OrderingTokens.sans,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: OrderingTokens.ink4,
                ),
              ),
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: 8),
            OrderingIconButton(
              icon: Icons.close,
              iconSize: 12,
              size: 20,
              radius: OrderingTokens.rSm,
              bordered: false,
              background: OrderingTokens.lineStrong,
              hoverBackground: const Color(0xFFC9D1DD),
              foreground: const Color(0xFF5B6674),
              hoverForeground: const Color(0xFF5B6674),
              tooltip: 'Clear search',
              onPressed: onClear,
            ),
          ],
        ],
      ),
    );
  }
}
