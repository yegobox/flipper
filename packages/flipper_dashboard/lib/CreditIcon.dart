import 'package:flutter/material.dart';
import 'dart:math' as math;

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  final int _maxCredits = 1000; // Maximum credit limit

  int get availableCredits => _availableCredits;
  int get maxCredits => _maxCredits;

  void buyCredits(int amount) {
    _availableCredits += amount;
    if (_availableCredits > _maxCredits) {
      _availableCredits = _maxCredits;
    }
    notifyListeners();
  }

  void useCredits(int amount) {
    if (_availableCredits >= amount) {
      _availableCredits -= amount;
      notifyListeners();
    }
  }
}

class CreditRingPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;

  CreditRingPainter({
    required this.percentage,
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle (light gray)
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw colored progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Define gradient colors based on percentage
    final List<Color> gradientColors = [
      _getColorForPercentage(percentage),
      _getColorForPercentage(percentage * 0.7),
    ];

    // Create gradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    progressPaint.shader = SweepGradient(
      colors: gradientColors,
      tileMode: TileMode.clamp,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    ).createShader(rect);

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from the top
      2 * math.pi * percentage, // Sweep angle based on percentage
      false,
      progressPaint,
    );

    // Add inner shadow/glow effect
    if (percentage > 0.05) {
      final innerGlowPaint = Paint()
        ..color = _getColorForPercentage(percentage).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

      canvas.drawCircle(
        center,
        radius - strokeWidth,
        innerGlowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CreditRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  Color _getColorForPercentage(double percentage) {
    // Color transition: green -> yellow -> orange -> red
    if (percentage > 0.7) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage > 0.5) {
      return const Color(0xFF8BC34A); // Light green
    } else if (percentage > 0.3) {
      return const Color(0xFFFFC107); // Amber
    } else if (percentage > 0.2) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }
}

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
