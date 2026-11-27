import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

import '../../../theme/pos_tokens.dart';
import '../models/production_output_models.dart';
import 'production_dialogs.dart' show productionPrimaryButtonStyle;

/// The white, hairline-bordered card every Production section sits in.
BoxDecoration productionCardDecoration() => BoxDecoration(
  color: PosTokens.surface,
  borderRadius: BorderRadius.circular(PosTokens.radiusLg),
  border: Border.all(color: PosTokens.line),
  boxShadow: PosTokens.shadow1,
);

/// Status pill for a work order (planned / in progress / completed …).
class WorkOrderStatusBadge extends StatelessWidget {
  const WorkOrderStatusBadge({super.key, required this.status});

  final WorkOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = Color(status.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.localizedLabel(context.flipperL10n),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty / error card: an icon in a tinted circle, a title, a hint and an
/// optional action.
class ProductionEmptyState extends StatelessWidget {
  const ProductionEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.tone = PosTokens.blue,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.framed = true,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color tone;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  /// False when it already sits inside a card (the table's empty body).
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tone.withValues(alpha: 0.10),
            ),
            child: Icon(icon, size: 28, color: tone),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: PosTokens.sectionTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: PosTokens.body.copyWith(color: PosTokens.ink3),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon ?? Icons.add, size: 18),
              label: Text(actionLabel!),
              style: productionPrimaryButtonStyle(),
            ),
          ],
        ],
      ),
    );
    if (!framed) return Center(child: body);
    return Container(
      decoration: productionCardDecoration(),
      child: Center(child: body),
    );
  }
}
