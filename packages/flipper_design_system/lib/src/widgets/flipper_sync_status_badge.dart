import 'package:flipper_design_system/src/tokens/flipper_radii.dart';
import 'package:flipper_design_system/src/tokens/flipper_spacing.dart';
import 'package:flipper_design_system/src/tokens/flipper_sync_status.dart';
import 'package:flipper_design_system/src/tokens/flipper_typography.dart';
import 'package:flutter/material.dart';

/// Compact icon+label indicator for an offline-first record's sync state.
/// Always pairs the status color with an icon and text — status must never
/// be conveyed by color alone.
class FlipperSyncStatusBadge extends StatelessWidget {
  final FlipperSyncStatus status;
  final bool showLabel;

  const FlipperSyncStatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.sm,
        vertical: Insets.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: Corners.s16Border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: FontSizes.s14, color: color),
          if (showLabel) ...[
            SizedBox(width: Insets.xs),
            Text(
              status.label,
              style: TextStyle(
                fontSize: FontSizes.s12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
