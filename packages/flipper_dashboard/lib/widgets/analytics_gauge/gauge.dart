import 'dart:math' as math;

import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [standard] preserves layout and strings relied on by cashbook and tests.
/// [dashboardHome] applies the mobile dashboard home visual treatment only.
enum GaugePresentation {
  standard,
  dashboardHome,
}

class SemiCircleGauge extends StatefulWidget {
  final double dataOnGreenSide;
  final double dataOnRedSide;
  final double maxDataValue;
  final double startPadding;
  final String profitType;
  final bool areValueColumnsVisible;
  final GaugePresentation presentation;

  SemiCircleGauge({
    Key? key,
    required this.dataOnGreenSide,
    required this.dataOnRedSide,
    required this.profitType,
    this.startPadding = 0.0,
    this.areValueColumnsVisible = true,
    this.presentation = GaugePresentation.standard,
  }) : maxDataValue = math.max(dataOnGreenSide, dataOnRedSide),
       super(key: key);

  @override
  State<SemiCircleGauge> createState() => _SemiCircleGaugeState();
}

class _SemiCircleGaugeState extends State<SemiCircleGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  static const Color _dashboardGreen = Color(0xFF2ECC71);
  static const Color _dashboardRed = Color(0xFFE74C3C);

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

  bool get _isDashboard => widget.presentation == GaugePresentation.dashboardHome;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double radius = widget.areValueColumnsVisible
        ? size.width / 3.2
        : size.width / 3.8;

    radius = math.max(radius, 20.0);

    final double totalData = widget.dataOnGreenSide + widget.dataOnRedSide;
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

    final calc = _calculateResults();
    final resultText = calc.$1;
    final profitOrLoss = calc.$2;
    final color = calc.$3;

    String profitOrLossStr = formatNumber(profitOrLoss);
    int numberLength = profitOrLossStr.length;
    double fontSize = 28;

    if (numberLength > 13) {
      fontSize = widget.areValueColumnsVisible ? 14 : 12;
    } else if (numberLength > 10) {
      fontSize = widget.areValueColumnsVisible ? 18 : 14;
    } else if (numberLength > 7) {
      fontSize = widget.areValueColumnsVisible ? 22 : 18;
    }

    final gaugeStack = SizedBox(
      width: double.infinity,
      height: radius * 2,
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
              showArcThumb: _isDashboard && totalData > 0,
              dashboardArcGreen: _isDashboard ? _dashboardGreen : null,
              dashboardArcRed: _isDashboard ? _dashboardRed : null,
            ),
            child: _isDashboard
                ? _buildDashboardCenter(
                    profitOrLoss: profitOrLoss,
                    fontSize: fontSize,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatNumber(profitOrLoss) + ' RWF',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: fontSize,
                          color: color,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      resultText,
                    ],
                  ),
          );
        },
      ),
    );

    final bottomSection =
        widget.areValueColumnsVisible
            ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.grey.withValues(alpha: 0.2)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _isDashboard
                          ? _buildDashboardValueColumn(
                            amount: widget.dataOnGreenSide,
                            label: 'GROSS PROFIT',
                            valueColor: _dashboardGreen,
                          )
                          : _buildValueColumn(
                            amount: widget.dataOnGreenSide,
                            label: 'Gross Profit',
                            color: Colors.green,
                          ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                      _isDashboard
                          ? _buildDashboardValueColumn(
                            amount: widget.dataOnRedSide,
                            label: 'TAX & EXPENSES',
                            valueColor: _dashboardRed,
                          )
                          : _buildValueColumn(
                            amount: widget.dataOnRedSide,
                            label: 'Tax & Expenses',
                            color: Colors.red,
                          ),
                    ],
                  ),
                ),
              ],
            )
            : const SizedBox.shrink();

    if (_isDashboard) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [gaugeStack, bottomSection],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [gaugeStack, bottomSection],
        ),
      ),
    );
  }

  Widget _buildDashboardCenter({
    required double profitOrLoss,
    required double fontSize,
  }) {
    final String mainNumber = formatNumber(profitOrLoss);
    final Color numberColor;
    if (widget.dataOnRedSide > widget.dataOnGreenSide) {
      numberColor = _dashboardRed;
    } else if (widget.dataOnGreenSide == widget.dataOnRedSide &&
        widget.dataOnRedSide > 0) {
      numberColor = Colors.grey.shade700;
    } else if (widget.dataOnGreenSide == 0 && widget.dataOnRedSide == 0) {
      numberColor = Colors.grey.shade700;
    } else {
      numberColor = Colors.black;
    }

    String upperLabel;
    if (widget.dataOnGreenSide > widget.dataOnRedSide) {
      upperLabel = widget.profitType.toUpperCase();
    } else if (widget.dataOnRedSide > widget.dataOnGreenSide) {
      upperLabel = 'LOSS';
    } else if (widget.dataOnRedSide == widget.dataOnGreenSide &&
        widget.dataOnRedSide > 0) {
      upperLabel = 'BALANCED';
    } else {
      upperLabel = 'NO TRANSACTIONS';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'RWF',
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.08 * 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          mainNumber,
          style: GoogleFonts.jetBrainsMono(
            fontSize: fontSize.clamp(22, 36),
            color: numberColor,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          upperLabel,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.08 * 11,
          ),
        ),
      ],
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
          formatNumber(amount) + ' RWF',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardValueColumn({
    required double amount,
    required String label,
    required Color valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            formatNumber(amount),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: valueColor,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.08 * 10,
            ),
          ),
        ],
      ),
    );
  }

  (Widget, double, Color) _calculateResults() {
    Widget resultText;
    double profitOrLoss;
    Color valueColor;

    if (widget.dataOnGreenSide > widget.dataOnRedSide) {
      resultText = Text(
        widget.profitType,
        style: GoogleFonts.outfit(
          fontSize: widget.areValueColumnsVisible ? 16 : 14,
          color: Colors.green.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = widget.profitType == 'Gross Profit'
          ? widget.dataOnGreenSide
          : widget.dataOnGreenSide - widget.dataOnRedSide;
      valueColor = Colors.green;
    } else if (widget.dataOnRedSide > widget.dataOnGreenSide) {
      resultText = Text(
        'Loss',
        style: GoogleFonts.outfit(
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
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      );
      profitOrLoss = 0;
      valueColor = Colors.grey;
    } else {
      resultText = Text(
        'No transactions',
        style: GoogleFonts.outfit(
          fontSize: 14,
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
  final bool showArcThumb;
  final Color? dashboardArcGreen;
  final Color? dashboardArcRed;

  _GaugePainter({
    required this.greenAngle,
    required this.redAngle,
    required this.radius,
    required this.maxDataValue,
    required this.greyAngle,
    this.showArcThumb = false,
    this.dashboardArcGreen,
    this.dashboardArcRed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - (size.height / 3));
    const strokeWidth = 12.0;

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

    final greenPaint = Paint()
      ..color = (dashboardArcGreen ?? Colors.green).withValues(alpha: 0.8)
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

    final redPaint = Paint()
      ..color = (dashboardArcRed ?? Colors.red).withValues(alpha: 0.8)
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

    if (showArcThumb && greenAngle + redAngle > 0.01) {
      final thumbTheta = math.pi + greenAngle;
      final thumbX = center.dx + radius * math.cos(thumbTheta);
      final thumbY = center.dy + radius * math.sin(thumbTheta);
      final thumbCenter = Offset(thumbX, thumbY);
      canvas.drawCircle(
        thumbCenter,
        7,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        thumbCenter,
        7,
        Paint()
          ..color = Colors.grey.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
