import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_status_pill.dart';

class MposCheckoutHeader extends StatelessWidget {
  const MposCheckoutHeader({
    super.key,
    required this.itemCount,
    required this.timeLabel,
    required this.status,
    required this.onBack,
  });

  final int itemCount;
  final String timeLabel;
  final String status;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MposTokens.head,
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          _MposBackButton(onPressed: onBack),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.01,
                    color: PosTokens.ink1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'} · $timeLabel',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: PosTokens.ink3,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          MposStatusPill(status: status),
        ],
      ),
    );
  }
}

class _MposBackButton extends StatelessWidget {
  const _MposBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.surface2,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: PosTokens.line),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 22,
            color: PosTokens.ink1,
          ),
        ),
      ),
    );
  }
}
