import 'package:flipper_design_system/src/theme/flipper_theme_extension.dart';
import 'package:flipper_design_system/src/tokens/flipper_colors.dart';
import 'package:flipper_design_system/src/tokens/flipper_radii.dart';
import 'package:flipper_design_system/src/tokens/flipper_spacing.dart';
import 'package:flipper_design_system/src/tokens/flipper_typography.dart';
import 'package:flutter/material.dart';

/// Dashboard stat card: a headline number with an optional trend delta.
/// This is a stat tile, not a chart — it carries no series color, so a
/// legend/hover layer doesn't apply. Delta color is always paired with a
/// direction arrow, never conveyed by color alone.
class FlipperStatTile extends StatelessWidget {
  const FlipperStatTile({
    super.key,
    required this.label,
    required this.value,
    this.deltaPercent,
    this.icon,
  });

  final String label;
  final String value;

  /// Positive = improvement, negative = decline. Null hides the delta row.
  final double? deltaPercent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ext = FlipperThemeExtension.of(context);
    final delta = deltaPercent;

    return Container(
      padding: EdgeInsets.all(Insets.m),
      decoration: BoxDecoration(
        color: ext.background,
        borderRadius: Corners.s12Border,
        border: Border.all(color: ext.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: FontSizes.s12,
                    fontWeight: FontWeight.w500,
                    color: ext.secondaryTextColor,
                  ),
                ),
              ),
              if (icon != null)
                Icon(icon, size: FontSizes.s18, color: ext.secondaryTextColor),
            ],
          ),
          SizedBox(height: Insets.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.s24,
              fontWeight: FontWeight.w700,
              color: ext.strongText,
            ),
          ),
          if (delta != null) ...[
            SizedBox(height: Insets.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  delta >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: FontSizes.s12,
                  color: delta >= 0 ? FlipperColors.success : FlipperColors.error,
                ),
                const SizedBox(width: 2),
                Text(
                  '${delta.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: FontSizes.s12,
                    fontWeight: FontWeight.w600,
                    color: delta >= 0 ? FlipperColors.success : FlipperColors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
