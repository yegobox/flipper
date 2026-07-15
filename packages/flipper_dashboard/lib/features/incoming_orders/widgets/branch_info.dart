import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// From/To flow strip. Incoming: requester → active branch.
/// Outgoing: active branch (requester) → main/fulfiller branch.
class BranchInfo extends ConsumerWidget {
  final InventoryRequest request;
  final Branch activeBranch;
  final bool isIncoming;

  const BranchInfo({
    Key? key,
    required this.request,
    required this.activeBranch,
    this.isIncoming = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isIncoming) {
      final fromAsync = request.subBranchId != null
          ? ref.watch(branchByIdProvider(branchId: request.subBranchId))
          : null;

      final fromName = fromAsync?.when(
            data: (b) => b?.name ?? request.branch?.name ?? 'Unknown',
            loading: () => request.branch?.name ?? '…',
            error: (_, __) => request.branch?.name ?? 'Unknown',
          ) ??
          request.branch?.name ??
          'Unknown';

      return _FlowStrip(
        fromName: fromName,
        toName: activeBranch.name ?? 'Unknown',
      );
    }

    // Outgoing: this store is requester (sub); destination is mainBranch.
    final toAsync = request.mainBranchId != null
        ? ref.watch(branchByIdProvider(branchId: request.mainBranchId))
        : null;
    final toName = toAsync?.when(
          data: (b) => b?.name ?? 'Unknown',
          loading: () => '…',
          error: (_, __) => 'Unknown',
        ) ??
        'Unknown';

    return _FlowStrip(
      fromName: activeBranch.name ?? request.branch?.name ?? 'Unknown',
      toName: toName,
    );
  }
}

class _FlowStrip extends StatelessWidget {
  const _FlowStrip({required this.fromName, required this.toName});

  final String fromName;
  final String toName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: OmTokens.surface2,
        borderRadius: BorderRadius.circular(OmTokens.radius),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: OmTokens.surface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: OmTokens.line2),
            ),
            child: const Icon(
              Icons.swap_horiz,
              size: 17,
              color: OmTokens.accentStrong,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FlowLine(
                  label: 'From: ',
                  value: fromName,
                  valueColor: OmTokens.greenStrong,
                ),
                const SizedBox(height: 4),
                _FlowLine(
                  label: 'To: ',
                  value: toName,
                  valueColor: OmTokens.accentStrong,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowLine extends StatelessWidget {
  const _FlowLine({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: OmTokens.text(fontSize: 14, color: OmTokens.ink2),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: OmTokens.text(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
