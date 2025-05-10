import 'package:flutter/material.dart';

class QuickAmountsSelector extends StatelessWidget {
  final Function(int) onAmountSelected;

  const QuickAmountsSelector({
    Key? key,
    required this.onAmountSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickAmountButton(context, 50, colorScheme, isLightMode),
            _buildQuickAmountButton(context, 100, colorScheme, isLightMode),
            _buildQuickAmountButton(context, 500, colorScheme, isLightMode),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAmountButton(
    BuildContext context,
    int amount,
    ColorScheme colorScheme,
    bool isLightMode,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton(
          onPressed: () => onAmountSelected(amount),
          style: OutlinedButton.styleFrom(
            backgroundColor: isLightMode ? Colors.white : colorScheme.surface,
            side: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            '+$amount',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
