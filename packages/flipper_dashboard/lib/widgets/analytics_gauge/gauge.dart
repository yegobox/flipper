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
    this.areValueColumnsVisible = true, // Default startPadding value is 0.0
  })  : maxDataValue = math.max(dataOnGreenSide, dataOnRedSide),
        super(key: key);

  @override
  State<SemiCircleGauge> createState() => _SemiCircleGaugeState();
}

class _SemiCircleGaugeState extends State<SemiCircleGauge> {
  @override
  Widget build(BuildContext context) {
    double radius = widget.areValueColumnsVisible
        ? MediaQuery.of(context).size.width / 3
        : MediaQuery.of(context).size.width / 3.5;
    double totalData = widget.dataOnGreenSide + widget.dataOnRedSide;
    double greenAngle = 0;
    double redAngle = 0;
    double greyAngle = math.pi;

    if ((widget.dataOnGreenSide == 0) && (widget.dataOnRedSide == 0)) {
      greenAngle = math.pi / 30;
      redAngle = math.pi / 30;
    } else {
      greenAngle = (widget.dataOnGreenSide / totalData) * math.pi;
      redAngle = (widget.dataOnRedSide / totalData) * math.pi;
    }

    Widget resultText;
    double profitOrLoss = 0;
    if (widget.dataOnGreenSide > widget.dataOnRedSide) {
      resultText = Text(widget.profitType,
          style: GoogleFonts.poppins(
              fontSize: widget.areValueColumnsVisible ? 18 : 15,
              color: Colors.grey));
      if (widget.profitType == "Gross Profit") {
        profitOrLoss = widget.dataOnGreenSide;
      } else {
        profitOrLoss = widget.dataOnGreenSide - widget.dataOnRedSide;
      }
    } else if (widget.dataOnRedSide > widget.dataOnGreenSide) {
      resultText = Text('Loss',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey));
      profitOrLoss = widget.dataOnRedSide - widget.dataOnGreenSide;
    } else if ((widget.dataOnRedSide == widget.dataOnGreenSide) &&
        (widget.dataOnRedSide > 0)) {
      resultText = Text('Balanced',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey));
      profitOrLoss = widget.dataOnRedSide - widget.dataOnGreenSide;
    } else {
      resultText = Text('No transactions',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey));
    }
    return SizedBox(
      height: (widget.areValueColumnsVisible) ? radius * 1.6 : radius * 1.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            painter: _GaugePainter(
                greenAngle, redAngle, radius, widget.maxDataValue, greyAngle),
            child: Padding(
              padding: EdgeInsets.only(
                  top:
                      widget.startPadding), // Adjust the top padding as desired
              child: Column(
                children: [
                  Text(
                      NumberFormat('#,###')
                              .format(double.parse(profitOrLoss.toString())) +
                          ' RWF',
                      style: GoogleFonts.poppins(
                          fontSize: widget.areValueColumnsVisible ? 28 : 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  resultText,
                ],
              ),
            ),
          ),
          if (widget.areValueColumnsVisible)
            Padding(
              padding: const EdgeInsets.only(left: 41.0, right: 41.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                          NumberFormat('#,###').format(double.parse(
                                  widget.dataOnGreenSide.toString())) +
                              " RWF",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              height: 3,
                              color:
                                  Colors.black.withOpacity(0.4099999964237213),
                              fontWeight: FontWeight.w600)),
                      widget.profitType == "Net Profit"
                          ? Text("Gross Profit",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.lightBlue.shade200,
                                  fontWeight: FontWeight.w600))
                          : Text("Total Sales",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.lightBlue.shade200,
                                  fontWeight: FontWeight.w600))
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                          textAlign: TextAlign.center,
                          NumberFormat('#,###').format(double.parse(
                                  widget.dataOnRedSide.toString())) +
                              " RWF",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              height: 3,
                              color:
                                  Colors.black.withOpacity(0.4099999964237213),
                              fontWeight: FontWeight.w600)),
                      Text("Expenses",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.lightBlue.shade200,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double greenAngle;
  final double redAngle;
  final double radius;
  final double maxDataValue;
  final double greyAngle;

  _GaugePainter(this.greenAngle, this.redAngle, this.radius, this.maxDataValue,
      this.greyAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final greyPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      greyAngle,
      false,
      greyPaint,
    );
    // Draw the green semi-circle
    final greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      greenAngle,
      false,
      greenPaint,
    );

    // Draw the red semi-circle
    final redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
