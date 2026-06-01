import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// POS cart line with optional expanded qty/price editor (handoff).
class PosCartExpandedLine extends StatelessWidget {
  const PosCartExpandedLine({
    super.key,
    required this.name,
    required this.currency,
    required this.unitPriceText,
    required this.lineTotalText,
    required this.qtyText,
    required this.isExpanded,
    required this.isSaving,
    required this.onToggleExpand,
    required this.onDelete,
    required this.onDecrement,
    required this.onIncrement,
    this.decrementEnabled = true,
    this.incrementEnabled = true,
    this.hasError = false,
    this.errorText,
    this.stockHint,
    this.priceHint,
    this.expandedQuantityStepper,
    this.expandedPriceField,
    this.subtotalDetailText,
  });

  final String name;
  final String currency;
  final String unitPriceText;
  final String lineTotalText;
  final String qtyText;
  final String? subtotalDetailText;
  final bool isExpanded;
  final bool isSaving;
  final bool hasError;
  final String? errorText;
  final String? stockHint;
  final String? priceHint;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onDelete;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool decrementEnabled;
  final bool incrementEnabled;
  final Widget? expandedQuantityStepper;
  final Widget? expandedPriceField;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (!isExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CollapsedHeader(
            name: name,
            unitPriceText: unitPriceText,
            lineTotalText: lineTotalText,
            qtyText: qtyText,
            isSaving: isSaving,
            decrementEnabled: decrementEnabled,
            incrementEnabled: incrementEnabled,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
            onDelete: onDelete,
            onEdit: isSaving ? null : onToggleExpand,
          ),
          if (hasError && errorText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                errorText!,
                style: const TextStyle(fontSize: 12, color: PosTokens.loss),
              ),
            ),
        ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PosTokens.surface,
          borderRadius: BorderRadius.circular(PosTokens.radiusMd),
          border: Border.all(color: PosTokens.blue, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CollapsedHeader(
                name: name,
                unitPriceText: unitPriceText,
                lineTotalText: lineTotalText,
                qtyText: qtyText,
                isSaving: isSaving,
                decrementEnabled: decrementEnabled,
                incrementEnabled: incrementEnabled,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
                onDelete: onDelete,
                onEdit: isSaving ? null : onToggleExpand,
                showHideDetails: true,
              ),
              if (hasError && errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorText!,
                  style: const TextStyle(fontSize: 12, color: PosTokens.loss),
                ),
              ],
              if (expandedQuantityStepper != null ||
                  expandedPriceField != null) ...[
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stack = constraints.maxWidth < 360;
                    if (stack) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (expandedQuantityStepper != null)
                            _FieldBlock(
                              label: 'Quantity',
                              hint: stockHint,
                              child: expandedQuantityStepper!,
                            ),
                          if (expandedPriceField != null) ...[
                            const SizedBox(height: 14),
                            _FieldBlock(
                              label: 'Unit price',
                              hint: priceHint,
                              child: expandedPriceField!,
                            ),
                          ],
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (expandedQuantityStepper != null)
                          Expanded(
                            child: _FieldBlock(
                              label: 'Quantity',
                              hint: stockHint,
                              child: expandedQuantityStepper!,
                            ),
                          ),
                        if (expandedQuantityStepper != null &&
                            expandedPriceField != null)
                          const SizedBox(width: 14),
                        if (expandedPriceField != null)
                          Expanded(
                            child: _FieldBlock(
                              label: 'Unit price',
                              hint: priceHint,
                              child: expandedPriceField!,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 14),
              _DottedDivider(),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Line subtotal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: PosTokens.ink1,
                          ),
                        ),
                        if (subtotalDetailText != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtotalDetailText!,
                            style: PosTokens.posMonoStyle(
                              textTheme,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: PosTokens.ink3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '$currency $lineTotalText',
                    style: PosTokens.posPriceStyle(
                      textTheme,
                      fontSize: 18,
                      color: PosTokens.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    required this.name,
    required this.unitPriceText,
    required this.lineTotalText,
    required this.qtyText,
    required this.isSaving,
    required this.decrementEnabled,
    required this.incrementEnabled,
    required this.onDecrement,
    required this.onIncrement,
    required this.onDelete,
    this.onEdit,
    this.showHideDetails = false,
  });

  final String name;
  final String unitPriceText;
  final String lineTotalText;
  final String qtyText;
  final bool isSaving;
  final bool decrementEnabled;
  final bool incrementEnabled;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool showHideDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Swatch(name: name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.ink1,
                    ),
                  ),
                  if (!showHideDetails) ...[
                    const SizedBox(height: 2),
                    Text(
                      unitPriceText,
                      style: PosTokens.posMonoStyle(
                        Theme.of(context).textTheme,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: PosTokens.ink3,
                      ),
                    ),
                  ],
                  if (showHideDetails && onEdit != null) ...[
                    const SizedBox(height: 6),
                    _HideDetailsButton(onPressed: onEdit!),
                  ],
                ],
              ),
            ),
            _CompactQtyStepper(
              qtyText: qtyText,
              onDecrement: isSaving ? null : onDecrement,
              onIncrement: isSaving ? null : onIncrement,
              decrementEnabled: decrementEnabled,
              incrementEnabled: incrementEnabled,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 72,
              child: Text(
                lineTotalText,
                textAlign: TextAlign.end,
                style: PosTokens.posMonoStyle(
                  Theme.of(context).textTheme,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink1,
                ),
              ),
            ),
            const SizedBox(width: 2),
            _TrashButton(onPressed: isSaving ? null : onDelete),
          ],
        ),
        if (!showHideDetails && onEdit != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                foregroundColor: PosTokens.blue,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Edit qty/price',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}

class _HideDetailsButton extends StatelessWidget {
  const _HideDetailsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Hide details',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PosTokens.blue,
              ),
            ),
            const Icon(
              FluentIcons.chevron_down_24_regular,
              size: 14,
              color: PosTokens.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: posTileColorForName(name),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        posTileAbbr(name),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CompactQtyStepper extends StatelessWidget {
  const _CompactQtyStepper({
    required this.qtyText,
    required this.onDecrement,
    required this.onIncrement,
    required this.decrementEnabled,
    required this.incrementEnabled,
  });

  final String qtyText;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool decrementEnabled;
  final bool incrementEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PosTokens.line),
        color: PosTokens.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperSide(
            icon: FluentIcons.subtract_24_regular,
            onPressed: decrementEnabled ? onDecrement : null,
            width: 34,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              qtyText,
              style: PosTokens.posMonoStyle(
                Theme.of(context).textTheme,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperSide(
            icon: FluentIcons.add_24_regular,
            onPressed: incrementEnabled ? onIncrement : null,
            width: 34,
          ),
        ],
      ),
    );
  }
}

/// Large qty stepper for the expanded panel.
class PosCartExpandedQtyStepper extends StatelessWidget {
  const PosCartExpandedQtyStepper({
    super.key,
    required this.qtyText,
    required this.onDecrement,
    required this.onIncrement,
    this.decrementEnabled = true,
    this.incrementEnabled = true,
  });

  final String qtyText;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool decrementEnabled;
  final bool incrementEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PosTokens.line),
        color: PosTokens.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StepperSide(
              icon: FluentIcons.subtract_24_regular,
              onPressed: decrementEnabled ? onDecrement : null,
              width: 48,
              height: 48,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                qtyText,
                style: PosTokens.posMonoStyle(
                  Theme.of(context).textTheme,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: _StepperSide(
              icon: FluentIcons.add_24_regular,
              onPressed: incrementEnabled ? onIncrement : null,
              width: 48,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperSide extends StatefulWidget {
  const _StepperSide({
    required this.icon,
    required this.onPressed,
    required this.width,
    this.height = 34,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  State<_StepperSide> createState() => _StepperSideState();
}

class _StepperSideState extends State<_StepperSide> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered && enabled ? PosTokens.surface2 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Icon(
              widget.icon,
              size: 18,
              color: enabled
                  ? (_hovered ? PosTokens.blue : PosTokens.ink2)
                  : PosTokens.ink4,
            ),
          ),
        ),
      ),
    );
  }
}

/// Handoff unit-price field (RWF prefix + mono input).
class PosCartExpandedPriceField extends StatefulWidget {
  const PosCartExpandedPriceField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.currency,
    required this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String currency;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<PosCartExpandedPriceField> createState() =>
      _PosCartExpandedPriceFieldState();
}

class _PosCartExpandedPriceFieldState extends State<PosCartExpandedPriceField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant PosCartExpandedPriceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: focused ? PosTokens.blue : PosTokens.line,
          width: focused ? 2 : 1,
        ),
        color: PosTokens.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            widget.currency,
            style: PosTokens.posMonoStyle(
              Theme.of(context).textTheme,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink3,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              enabled: widget.enabled,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: PosTokens.posMonoStyle(
                Theme.of(context).textTheme,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: PosTokens.ink2,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: PosTokens.posMonoStyle(
              Theme.of(context).textTheme,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: PosTokens.ink3,
            ),
          ),
        ],
      ],
    );
  }
}

class _TrashButton extends StatelessWidget {
  const _TrashButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Remove line',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      icon: Icon(
        FluentIcons.delete_24_regular,
        size: 20,
        color: onPressed == null ? PosTokens.ink4 : PosTokens.ink3,
      ),
      style: IconButton.styleFrom(
        foregroundColor: PosTokens.loss,
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: PosTokens.lineStrong,
            );
          }),
        );
      },
    );
  }
}
