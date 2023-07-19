import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SemiCircleGauge extends StatefulWidget {
  final double dataOnGreenSide;
  final double dataOnRedSide;
  final double maxDataValue;
  final double startPadding;
  final String profitType;

  SemiCircleGauge({
    Key? key,
    required this.dataOnGreenSide,
    required this.dataOnRedSide,
    required this.profitType,
    this.startPadding = 0.0, // Default startPadding value is 0.0
  })  : maxDataValue = math.max(dataOnGreenSide, dataOnRedSide),
        super(key: key);

  @override
  State<SemiCircleGauge> createState() => _SemiCircleGaugeState();
}

class _SemiCircleGaugeState extends State<SemiCircleGauge> {
  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.height / 6;
    double totalData = widget.dataOnGreenSide + widget.dataOnRedSide;
    double greenAngle = 0;
    double redAngle = 0;

    if ((widget.dataOnGreenSide == 0) && (widget.dataOnRedSide == 0)) {
      greenAngle = math.pi / 2;
      redAngle = math.pi / 2;
    } else {
      greenAngle = (widget.dataOnGreenSide / totalData) * math.pi;
      redAngle = (widget.dataOnRedSide / totalData) * math.pi;
    }

    Widget resultText;
    double profitOrLoss = 0;
    if (widget.dataOnGreenSide > widget.dataOnRedSide) {
      resultText = Text(widget.profitType,
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey));
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
      resultText = Text('No transactions found',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey));
    }
    return SizedBox(
      width: radius *
          2, // Make width equal to twice the radius for a circular gauge
      height: radius * 1.3,
      child: CustomPaint(
        painter:
            _GaugePainter(greenAngle, redAngle, radius, widget.maxDataValue),
        child: Padding(
          padding: EdgeInsets.only(
              top: widget.startPadding), // Adjust the top padding as desired
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(profitOrLoss.toString() + ' RWF',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                resultText,
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(widget.dataOnGreenSide.toString() + " RWF",
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        widget.profitType == "Net Profit"
                            ? Text("Gross Profit",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.lightBlue.shade200,
                                    fontWeight: FontWeight.w600))
                            : Text("Total Sales",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.lightBlue.shade200,
                                    fontWeight: FontWeight.w600))
                      ],
                    ),
                    Column(
                      children: [
                        Text(widget.dataOnRedSide.toString() + " RWF",
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        Text("Expenses",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.lightBlue.shade200,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double greenAngle;
  final double redAngle;
  final double radius;
  final double maxDataValue;

  _GaugePainter(this.greenAngle, this.redAngle, this.radius, this.maxDataValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw the green semi-circle
    final greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
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
      ..strokeWidth = 5.0
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
