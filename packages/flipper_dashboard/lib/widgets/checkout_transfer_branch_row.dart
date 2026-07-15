import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

/// Destination branch picker for outgoing POS transfer mode.
class CheckoutTransferBranchRow extends ConsumerWidget {
  const CheckoutTransferBranchRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessId = ProxyService.box.getBusinessId();
    final currentBranchId = ProxyService.box.getBranchId();
    final selected = ref.watch(transferDestinationBranchProvider);

    if (businessId == null) {
      return const SizedBox.shrink();
    }

    final branchesAsync = ref.watch(branchesProvider(businessId: businessId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      child: Row(
        children: [
          Text(
            'To branch',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: PosTokens.ink2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: branchesAsync.when(
              data: (branches) {
                final destinations = branches
                    .where((b) => b.id != currentBranchId)
                    .toList(growable: false);
                if (destinations.isEmpty) {
                  return Text(
                    'No other branches',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: PosTokens.ink3,
                    ),
                  );
                }
                final matched = destinations
                    .where((b) => b.id == selected?.id)
                    .toList(growable: false);
                final value = matched.isEmpty ? null : matched.first;
                return DropdownButtonFormField<Branch>(
                  key: ValueKey(value?.id ?? 'none'),
                  initialValue: value,
                  isExpanded: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(color: PosTokens.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(color: PosTokens.line),
                    ),
                  ),
                  hint: const Text('Select branch'),
                  items: destinations
                      .map(
                        (b) => DropdownMenuItem<Branch>(
                          value: b,
                          child: Text(
                            b.name ?? b.id,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (branch) {
                    ref
                            .read(transferDestinationBranchProvider.notifier)
                            .state =
                        branch;
                  },
                );
              },
              loading: () => const SizedBox(
                height: 34,
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (e, _) => Text(
                'Failed to load branches',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PosTokens.loss,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
