// ignore_for_file: unused_result

import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Compact location chip used by Inventory Dashboard (and similar surfaces).
///
/// Replaces the stock [DropdownButton] chrome with a PosTokens pill: store
/// icon, truncated branch name, and chevron. Opens a checked menu of branches.
class BranchDropdown extends ConsumerWidget {
  const BranchDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBranches = ref.watch(
      branchesProvider(businessId: ProxyService.box.getBusinessId()),
    );
    final selected = ref.watch(selectedBranchProvider);

    return asyncBranches.when(
      loading: () => const _BranchChipFrame(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Tooltip(
        message: '$error',
        child: const _BranchChipFrame(
          child: Icon(Icons.error_outline, size: 16, color: PosTokens.loss),
        ),
      ),
      data: (branches) {
        Branch? current = selected;
        if (current == null && branches.isNotEmpty) {
          final activeId = ProxyService.box.getBranchId();
          current = branches.cast<Branch?>().firstWhere(
                (b) => b?.id == activeId,
                orElse: () => branches.first,
              );
        }
        final label = (current?.name?.trim().isNotEmpty ?? false)
            ? current!.name!.trim()
            : 'Select branch';

        return PopupMenuButton<Branch>(
          tooltip: 'Switch branch',
          offset: const Offset(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            side: const BorderSide(color: PosTokens.line),
          ),
          color: PosTokens.surface,
          elevation: 8,
          shadowColor: const Color(0x33103240),
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
          onSelected: (branch) {
            ref.read(selectedBranchProvider.notifier).state = branch;
          },
          itemBuilder: (context) => [
            for (final branch in branches)
              PopupMenuItem<Branch>(
                value: branch,
                height: 44,
                child: Row(
                  children: [
                    Icon(
                      branch.id == current?.id
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 18,
                      color: branch.id == current?.id
                          ? PosTokens.blue
                          : PosTokens.ink4,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        (branch.name?.trim().isNotEmpty ?? false)
                            ? branch.name!.trim()
                            : 'Unnamed branch',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: branch.id == current?.id
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: PosTokens.ink1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          child: _BranchChip(label: label),
        );
      },
    );
  }
}

class _BranchChip extends StatelessWidget {
  const _BranchChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _BranchChipFrame(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PosTokens.blueTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              size: 15,
              color: PosTokens.blue,
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PosTokens.ink1,
              ),
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: PosTokens.ink3,
          ),
        ],
      ),
    );
  }
}

class _BranchChipFrame extends StatelessWidget {
  const _BranchChipFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.fromLTRB(6, 0, 8, 0),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PosTokens.line),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
