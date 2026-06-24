import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// Handoff quick-cash buttons: Exact + common RWF denominations.
class PosQuickCashRow extends StatelessWidget {
  const PosQuickCashRow({
    super.key,
    required this.exactAmount,
    required this.onSelect,
    this.enabled = true,
  });

  final double exactAmount;
  final ValueChanged<double> onSelect;
  final bool enabled;

  static const List<int> _denominations = [5000, 10000, 20000];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickCashButton(
            label: 'Exact',
            onPressed: enabled && exactAmount > 0
                ? () => onSelect(exactAmount)
                : null,
          ),
        ),
        ..._denominations.map(
          (amount) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _QuickCashButton(
                label: _formatAmount(amount),
                onPressed: enabled ? () => onSelect(amount.toDouble()) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatAmount(int n) {
    if (n >= 1000) {
      return '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}';
    }
    return '$n';
  }
}

class _QuickCashButton extends StatefulWidget {
  const _QuickCashButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  State<_QuickCashButton> createState() => _QuickCashButtonState();
}

class _QuickCashButtonState extends State<_QuickCashButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered && enabled ? PosTokens.blueTint : PosTokens.surface2,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          child: Ink(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PosTokens.radiusSm),
              border: Border.all(color: PosTokens.line),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? (_hovered ? PosTokens.blue : PosTokens.ink2)
                      : PosTokens.ink4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
