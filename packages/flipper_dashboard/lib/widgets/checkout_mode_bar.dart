import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Segmented Sale | Transfer control for the checkout cart panel.
class CheckoutModeBar extends ConsumerWidget {
  const CheckoutModeBar({super.key, this.enabled = true});

  /// When false (e.g. warehouse ordering), hide transfer switching.
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return const SizedBox.shrink();

    final mode = ref.watch(checkoutCartModeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: PosTokens.surface2,
        border: Border(
          bottom: BorderSide(color: PosTokens.line),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Mode',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: PosTokens.ink3,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: PosTokens.surface2,
              border: Border.all(color: PosTokens.line),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModePill(
                  label: 'Sale',
                  selected: mode == CheckoutCartMode.sale,
                  onTap: () {
                    ref.read(checkoutCartModeProvider.notifier).state =
                        CheckoutCartMode.sale;
                  },
                ),
                _ModePill(
                  label: 'Transfer',
                  selected: mode == CheckoutCartMode.transfer,
                  onTap: () {
                    ref.read(checkoutCartModeProvider.notifier).state =
                        CheckoutCartMode.transfer;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PosTokens.blue : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: SizedBox(
          height: 26,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : PosTokens.ink3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
