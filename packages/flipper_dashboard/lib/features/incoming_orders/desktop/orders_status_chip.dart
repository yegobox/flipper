import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart'
    show requestStatusLabel;
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';

/// Status pill for a stock request row or detail header (desktop).
///
/// Colour carries meaning only: amber waits on someone, blue is in motion,
/// green is done, red is closed without stock moving.
class OrdersStatusChip extends StatelessWidget {
  const OrdersStatusChip({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final value = status ?? RequestStatus.pending;
    final (bg, fg) = switch (value) {
      RequestStatus.pending => (PosTokens.warnTint, OmTokens.amber),
      RequestStatus.processing ||
      RequestStatus.partiallyApproved => (PosTokens.blueTint, PosTokens.blue),
      RequestStatus.approved ||
      RequestStatus.fulfilled => (OmTokens.greenWash, PosTokens.gainInk),
      RequestStatus.rejected ||
      RequestStatus.voided => (PosTokens.lossTint, PosTokens.lossInk),
      _ => (PosTokens.surface2, PosTokens.ink2),
    };

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              requestStatusLabel(context.flipperL10n, value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PosTokens.meta.copyWith(
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
