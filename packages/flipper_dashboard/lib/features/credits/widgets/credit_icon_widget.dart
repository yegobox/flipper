import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'credit_ring_painter.dart';

class CreditIconWidget extends StatelessWidget {
  final int credits;
  final int maxCredits;
  final double size;
  final TextStyle? textStyle;

  const CreditIconWidget({
    Key? key,
    required this.credits,
    required this.maxCredits,
    this.size = 60.0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate percentage of credits remaining
    final percentage = maxCredits > 0 ? credits / maxCredits : 0.0;

    // Clamp the percentage between 0 and 1
    final clampedPercentage = percentage.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CreditRingPainter(
          percentage: clampedPercentage,
          strokeWidth: size * 0.1,
        ),
        child: Center(
          child: Text(
            '$credits',
            style: textStyle ??
                TextStyle(
                  color: _getTextColor(clampedPercentage),
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(double percentage) {
    if (percentage > 0.6) {
      return const Color(0xFF2E7D32); // Dark green for high credits
    } else if (percentage > 0.3) {
      return const Color(0xFFF57F17); // Amber for medium credits
    } else {
      return const Color(0xFFB71C1C); // Dark red for low credits
    }
  }
}
