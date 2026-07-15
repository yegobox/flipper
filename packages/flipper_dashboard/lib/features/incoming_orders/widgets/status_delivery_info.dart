import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusDeliveryInfo extends StatelessWidget {
  final InventoryRequest request;

  const StatusDeliveryInfo({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = request.status ?? RequestStatus.pending;
    final isApproved = status == RequestStatus.approved ||
        status == RequestStatus.partiallyApproved ||
        status == RequestStatus.fulfilled;
    final date = request.createdAt ?? DateTime.now();
    final dateLabel = DateFormat('MMM d, yyyy HH:mm').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STATUS & DELIVERY',
          style: OmTokens.text(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: OmTokens.muted,
            letterSpacing: 0.05 * 12,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoCol = constraints.maxWidth >= 400;
            final tiles = [
              _MetaTile(
                icon: Icons.more_horiz,
                iconBg: isApproved ? OmTokens.greenWash : OmTokens.amberWash,
                iconColor:
                    isApproved ? OmTokens.greenStrong : OmTokens.amber,
                label: 'Status',
                value: status.toUpperCase(),
                valueColor:
                    isApproved ? OmTokens.greenStrong : OmTokens.amber,
              ),
              _MetaTile(
                icon: Icons.calendar_today_outlined,
                iconBg: OmTokens.dateWash,
                iconColor: OmTokens.dateIcon,
                label: 'Requested On',
                value: dateLabel,
                valueColor: OmTokens.ink,
              ),
            ];

            if (twoCol) {
              return Row(
                children: [
                  Expanded(child: tiles[0]),
                  const SizedBox(width: 10),
                  Expanded(child: tiles[1]),
                ],
              );
            }
            return Column(
              children: [
                tiles[0],
                const SizedBox(height: 10),
                tiles[1],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        border: Border.all(color: OmTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: OmTokens.text(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: OmTokens.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: OmTokens.text(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ).copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderNote extends StatelessWidget {
  final InventoryRequest request;

  const OrderNote({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORDER NOTE',
          style: OmTokens.text(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: OmTokens.muted,
            letterSpacing: 0.05 * 12,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: OmTokens.surface,
            borderRadius: BorderRadius.circular(OmTokens.radiusSm),
            border: Border.all(color: OmTokens.line),
          ),
          child: Text(
            request.orderNote ?? '',
            style: OmTokens.text(
              fontSize: 14,
              color: OmTokens.ink2,
            ),
          ),
        ),
      ],
    );
  }
}
