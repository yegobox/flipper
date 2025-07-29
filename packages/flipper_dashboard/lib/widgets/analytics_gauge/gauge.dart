import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SemiCircleGauge extends StatefulWidget {
  final double dataOnGreenSide;
  final double dataOnRedSide;
  final double maxDataValue;
  final double startPadding;
  final String profitType;
  final bool areValueColumnsVisible;

  SemiCircleGauge({
    Key? key,
    required this.dataOnGreenSide,
    required this.dataOnRedSide,
    required this.profitType,
    this.startPadding = 0.0,
    this.areValueColumnsVisible = true,
  })  : maxDataValue = math.max(dataOnGreenSide, dataOnRedSide),
        super(key: key);

  @override
  State<SemiCircleGauge> createState() => _SemiCircleGaugeState();
}

class _SemiCircleGaugeState extends State<SemiCircleGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatNumber(double number) {
    if (number.abs() >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    } else if (number.abs() >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number.abs() >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number.abs() >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return NumberFormat('#,###').format(number);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double radius =
        widget.areValueColumnsVisible ? size.width / 3.2 : size.width / 3.8;

    // Ensure minimum radius
    radius = math.max(radius, 20.0);

    double totalData = widget.dataOnGreenSide + widget.dataOnRedSide;
    double greenAngle = 0;
    double redAngle = 0;
    double greyAngle = math.pi;

    if (totalData == 0) {
      greenAngle = math.pi / 30;
      redAngle = math.pi / 30;
    } else {
      greenAngle = (widget.dataOnGreenSide / totalData) * math.pi;
      redAngle = (widget.dataOnRedSide / totalData) * math.pi;
    }

    // Calculate profit/loss and determine display text
    final (resultText, profitOrLoss, color) = _calculateResults();

    // Determine font size based on length
    String profitOrLossStr =
        _formatNumber(profitOrLoss); // Use formatted string for length check
    int numberLength = profitOrLossStr.length;
    double fontSize = 28; // Default font size

    if (numberLength > 7) {
      fontSize =
          widget.areValueColumnsVisible ? 22 : 18; // Adjust for visibility
    } else if (numberLength > 10) {
      fontSize = widget.areValueColumnsVisible
          ? 18
          : 14; // Further reduction for very large numbers
    } else if (numberLength > 13) {
      fontSize =
          widget.areValueColumnsVisible ? 14 : 12; // Minimum font size cap
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: radius * 2, // Added extra space for the gauge
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(double.infinity, radius * 1.2),
                    painter: _GaugePainter(
                      greenAngle: greenAngle * _animation.value,
                      redAngle: redAngle * _animation.value,
                      radius: radius,
                      maxDataValue: widget.maxDataValue,
                      greyAngle: greyAngle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatNumber(profitOrLoss) + ' RWF',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        resultText,
                      ],
                    ),
                  );
                },
              ),
            ),
            if (widget.areValueColumnsVisible) ...[
              Divider(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildValueColumn(
                      amount: widget.dataOnGreenSide,
                      label: widget.profitType == "Net Profit"
                          ? "Gross Profit"
                          : "Total Sales",
                      color: Colors.green,
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    _buildValueColumn(
                      amount: widget.dataOnRedSide,
                      label: "Expenses",
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn({
    required double amount,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          _formatNumber(amount) + " RWF",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  (Widget, double, Color) _calculateResults() {
    Widget resultText;
    double profitOrLoss;
    Color valueColor;

    if (widget.dataOnGreenSide > widget.dataOnRedSide) {
      resultText = Text(
        widget.profitType,
        style: GoogleFonts.poppins(
          fontSize: widget.areValueColumnsVisible ? 16 : 14,
          color: Colors.green.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = widget.profitType == "Gross Profit"
          ? widget.dataOnGreenSide
          : widget.dataOnGreenSide - widget.dataOnRedSide;
      valueColor = Colors.green;
    } else if (widget.dataOnRedSide > widget.dataOnGreenSide) {
      resultText = Text(
        'Loss',
        style: GoogleFonts.poppins(
          fontSize: widget.areValueColumnsVisible ? 16 : 14,
          color: Colors.red.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = widget.dataOnRedSide - widget.dataOnGreenSide;
      valueColor = Colors.red;
    } else if (widget.dataOnRedSide == widget.dataOnGreenSide &&
        widget.dataOnRedSide > 0) {
      resultText = Text(
        'Balanced',
        style: GoogleFonts.poppins(
          fontSize: widget.areValueColumnsVisible ? 16 : 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = 0;
      valueColor = Colors.grey;
    } else {
      resultText = Text(
        'No transactions',
        style: GoogleFonts.poppins(
          fontSize: widget.areValueColumnsVisible ? 16 : 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = 0;
      valueColor = Colors.grey;
    }

    return (resultText, profitOrLoss, valueColor);
  }
}

class _GaugePainter extends CustomPainter {
  final double greenAngle;
  final double redAngle;
  final double radius;
  final double maxDataValue;
  final double greyAngle;

  _GaugePainter({
    required this.greenAngle,
    required this.redAngle,
    required this.radius,
    required this.maxDataValue,
    required this.greyAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Move the center point down to show full semi-circle
    final center = Offset(size.width / 2, size.height - (size.height / 3));
    const strokeWidth = 12.0;

    // Draw background arc
    final greyPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      greyAngle,
      false,
      greyPaint,
    );

    // Draw the green arc
    final greenPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      greenAngle,
      false,
      greenPaint,
    );

    // Draw the red arc
    final redPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      -redAngle,
      false,
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
