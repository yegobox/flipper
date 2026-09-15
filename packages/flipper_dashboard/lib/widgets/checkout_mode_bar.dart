import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Segmented Sale | Transfer control for the checkout cart panel.
///
/// [inline] renders only the segmented control (no "MODE" strip) so the
/// desktop checkout header can host it next to the invoice / txn meta.
class CheckoutModeBar extends ConsumerWidget {
  const CheckoutModeBar({super.key, this.enabled = true, this.inline = false});

  /// When false (e.g. warehouse ordering), hide transfer switching.
  final bool enabled;

  /// Bare segmented control, for embedding in a header row.
  final bool inline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return const SizedBox.shrink();

    final mode = ref.watch(checkoutCartModeProvider);

    final segmented = Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        border: Border.all(color: PosTokens.line),
        borderRadius: BorderRadius.circular(PosTokens.radiusSm + 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModePill(
            label: context.flipperL10n.sale,
            selected: mode == CheckoutCartMode.sale,
            onTap: () {
              ref.read(checkoutCartModeProvider.notifier).state =
                  CheckoutCartMode.sale;
            },
          ),
          _ModePill(
            label: context.flipperL10n.transfer,
            selected: mode == CheckoutCartMode.transfer,
            onTap: () {
              ref.read(checkoutCartModeProvider.notifier).state =
                  CheckoutCartMode.transfer;
            },
          ),
        ],
      ),
    );

    if (inline) return segmented;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: PosTokens.surface2,
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      child: Row(
        children: [
          Text(
            context.flipperL10n.mode.toUpperCase(),
            style: PosTokens.eyebrow,
          ),
          const Spacer(),
          segmented,
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
      borderRadius: BorderRadius.circular(PosTokens.radiusSm - 1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm - 1),
        hoverColor: selected ? null : PosTokens.blueTint,
        child: SizedBox(
          height: 26,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : PosTokens.ink2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
