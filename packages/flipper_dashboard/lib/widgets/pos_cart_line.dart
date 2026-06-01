import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Compact cart line matching desktop POS handoff.
class PosCartLine extends StatelessWidget {
  const PosCartLine({
    super.key,
    required this.name,
    required this.unitPriceText,
    required this.lineTotalText,
    required this.qtyText,
    required this.onDecrement,
    required this.onIncrement,
    required this.onDelete,
    this.decrementEnabled = true,
    this.incrementEnabled = true,
    this.isSaving = false,
  });

  final String name;
  final String unitPriceText;
  final String lineTotalText;
  final String qtyText;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final VoidCallback? onDelete;
  final bool decrementEnabled;
  final bool incrementEnabled;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 2),
                Text(
                  unitPriceText,
                  style: textTheme.bodySmall?.copyWith(
                    color: PosTokens.ink3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _QtyStepper(
            qtyText: qtyText,
            onDecrement: isSaving ? null : onDecrement,
            onIncrement: isSaving ? null : onIncrement,
            decrementEnabled: decrementEnabled,
            incrementEnabled: incrementEnabled,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 88,
            child: Text(
              lineTotalText,
              textAlign: TextAlign.end,
              style: PosTokens.posPriceStyle(
                textTheme,
                fontSize: 16,
                color: PosTokens.blue,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Remove line',
            onPressed: isSaving ? null : onDelete,
            icon: Icon(
              FluentIcons.delete_24_regular,
              size: 20,
              color: isSaving ? PosTokens.ink4 : PosTokens.ink3,
            ),
            style: IconButton.styleFrom(
              foregroundColor: PosTokens.loss,
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(10),
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

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
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
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PosTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperBtn(
            icon: FluentIcons.subtract_24_regular,
            onPressed: decrementEnabled ? onDecrement : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              qtyText,
              style: PosTokens.posMonoStyle(
                Theme.of(context).textTheme,
                fontSize: 14,
              ),
            ),
          ),
          _StepperBtn(
            icon: FluentIcons.add_24_regular,
            onPressed: incrementEnabled ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatefulWidget {
  const _StepperBtn({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  State<_StepperBtn> createState() => _StepperBtnState();
}

class _StepperBtnState extends State<_StepperBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered && enabled ? PosTokens.blueTint : Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          child: SizedBox(
            width: 36,
            height: 36,
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
