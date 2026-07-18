import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';

/// Dashed CTA below customer search ([customer_side_by_side.html] `.m-add`).
class AddNewCustomerButton extends StatelessWidget {
  const AddNewCustomerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return Material(
      color: PosTokens.blueTint,
      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        splashColor: PosTokens.blue.withValues(alpha: 0.12),
        highlightColor: PosTokens.blue.withValues(alpha: 0.08),
        child: CustomPaint(
          painter: _AddCustomerDashedBorderPainter(
            color: enabled ? PosTokens.blue : PosTokens.ink4,
            borderRadius: MposTokens.radiusMd,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: PosTokens.blue,
                    ),
                  )
                else
                  Icon(
                    Icons.person_add_outlined,
                    size: 18,
                    color: enabled ? PosTokens.blue : PosTokens.ink4,
                  ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isLoading ? 'Opening…' : label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: enabled ? PosTokens.blue : PosTokens.ink4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddCustomerDashedBorderPainter extends CustomPainter {
  const _AddCustomerDashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 6.0;
    const gap = 4.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    ).deflate(.75);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AddCustomerDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
