import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';

class RequestHeader extends StatelessWidget {
  final InventoryRequest request;
  final bool isIncoming;
  final bool expanded;
  final VoidCallback onToggle;

  const RequestHeader({
    Key? key,
    required this.request,
    required this.isIncoming,
    required this.expanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fromName = request.branch?.name ?? 'Unknown';
    final lineCount = request.transactionItems?.length ??
        request.itemCounts?.toInt() ??
        0;
    final items = request.transactionItems ?? const <TransactionItem>[];
    final isOutgoingPending =
        !isIncoming && request.status == RequestStatus.pending;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: OmTokens.accentWash,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 19,
            color: OmTokens.accentStrong,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: OmTokens.text(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.01 * 16,
              ),
              children: [
                TextSpan(text: 'Request From $fromName '),
                TextSpan(
                  text: '($lineCount item${lineCount == 1 ? '' : 's'})',
                  style: OmTokens.text(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: OmTokens.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _QtyPill(
          items: items,
          itemCount: lineCount,
          showRatio: !isOutgoingPending,
        ),
        const SizedBox(width: 8),
        _ExpandButton(expanded: expanded, onTap: onToggle),
      ],
    );
  }
}

class _QtyPill extends StatelessWidget {
  const _QtyPill({
    required this.items,
    required this.itemCount,
    required this.showRatio,
  });

  final List<TransactionItem> items;
  final int itemCount;
  final bool showRatio;

  @override
  Widget build(BuildContext context) {
    final requested = items.isEmpty
        ? itemCount
        : items.fold<int>(
            0,
            (sum, item) => sum + (item.quantityRequested ?? 0),
          );
    final approved = items.fold<int>(
      0,
      (sum, item) => sum + (item.quantityApproved ?? 0),
    );
    final label = showRatio
        ? '$approved/$requested Item${requested == 1 ? '' : 's'}'
        : '$requested Item${requested == 1 ? '' : 's'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: OmTokens.greenWash,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: OmTokens.text(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: OmTokens.greenStrong,
        ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: expanded ? OmTokens.accentWash : OmTokens.surface,
      borderRadius: BorderRadius.circular(OmTokens.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OmTokens.radiusSm),
            border: Border.all(
              color: expanded ? Colors.transparent : OmTokens.line2,
            ),
          ),
          child: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: expanded ? OmTokens.accentStrong : OmTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}
