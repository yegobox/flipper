import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Clear + Transfer actions shown when checkout is in transfer mode.
class CheckoutTransferFooter extends ConsumerWidget {
  const CheckoutTransferFooter({
    super.key,
    required this.itemCount,
    required this.onClear,
    required this.onTransfer,
    this.busy = false,
  });

  final int itemCount;
  final VoidCallback onClear;
  final VoidCallback onTransfer;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dest = ref.watch(transferDestinationBranchProvider);
    final canTransfer =
        !busy && itemCount > 0 && dest != null && dest.id.isNotEmpty;
    final label = canTransfer &&
            dest.name != null &&
            dest.name!.isNotEmpty
        ? 'Transfer to ${dest.name}'
        : 'Transfer';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            itemCount == 0
                ? 'No items selected'
                : '$itemCount item${itemCount == 1 ? '' : 's'} selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PosTokens.ink2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: busy || itemCount == 0 ? null : onClear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PosTokens.ink1,
                    side: const BorderSide(
                      color: PosTokens.lineStrong,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(88, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Clear',
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: canTransfer ? onTransfer : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: PosTokens.blue,
                      disabledBackgroundColor: PosTokens.line,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            label,
                            softWrap: false,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
