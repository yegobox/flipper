import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TimeSegmentUI extends StatefulWidget {
  final DateTime targetDateTime;
  final VoidCallback onCycleComplete;
  final double strokeWidth;

  TimeSegmentUI({
    required this.targetDateTime,
    required this.onCycleComplete,
    this.strokeWidth = 25.0,
  });

  @override
  _TimeSegmentUIState createState() => _TimeSegmentUIState();
}

class _TimeSegmentUIState extends State<TimeSegmentUI>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration remainingTime;
  late AnimationController _animationController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.targetDateTime.difference(DateTime.now());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed && _isAnimating) {
          _animationController.forward();
        }
      });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = widget.targetDateTime.difference(DateTime.now());
        if (remainingTime.isNegative) {
          remainingTime = Duration.zero;
          _timer.cancel();
          if (!_isAnimating) {
            _isAnimating = true;
            _animationController.forward();
            widget.onCycleComplete();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animationController.value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CustomPaint(
              size: Size(250, 250),
              painter: TimeSegmentPainter(
                segments: List.generate(4, (index) => TimeSegment()),
                remainingTime: remainingTime,
                strokeWidth: widget.strokeWidth,
                totalDuration: widget.targetDateTime
                    .difference(DateTime.now().subtract(Duration(minutes: 10))),
                isComplete: _isAnimating,
              ),
            ),
          ),
        );
      },
    );
  }
}

class TimeSegmentPainter extends CustomPainter {
  final List<TimeSegment> segments;
  final Duration remainingTime;
  final double strokeWidth;
  final Duration totalDuration;
  final bool isComplete;

  TimeSegmentPainter({
    required this.segments,
    required this.remainingTime,
    required this.strokeWidth,
    required this.totalDuration,
    required this.isComplete,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - strokeWidth / 2;

    // Define colors
    Color plantGreen = Color(0xFF4CAF50);
    Color lightGrey = Color(0xFFE0E0E0);
    Color separatorColor = Colors.white;

    // Draw the outline circle with light grey color
    Paint outlinePaint = Paint()
      ..color = lightGrey
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, outlinePaint);

    // Calculate the segment angles and filling logic
    double totalTimeInMilliseconds = totalDuration.inMilliseconds.toDouble();
    double elapsedTimeInMilliseconds =
        (totalDuration - remainingTime).inMilliseconds.toDouble();
    double progressPercentage =
        elapsedTimeInMilliseconds / totalTimeInMilliseconds;
    double totalSweepAngle = 2 * pi;
    double startAngle = -pi / 2;
    double segmentAngle = totalSweepAngle / segments.length;

    if (isComplete) {
      // Draw a full green circle when complete
      Paint completePaint = Paint()
        ..color = plantGreen
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, completePaint);
    } else {
      for (int i = 0; i < segments.length; i++) {
        // Calculate the fill percentage for this segment
        double segmentStartPercentage = i / segments.length;
        double segmentEndPercentage = (i + 1) / segments.length;
        double segmentFillPercentage =
            (progressPercentage - segmentStartPercentage) /
                (segmentEndPercentage - segmentStartPercentage);
        segmentFillPercentage = segmentFillPercentage.clamp(0.0, 1.0);

        // Draw the filled part of the segment
        if (segmentFillPercentage > 0) {
          Paint filledPaint = Paint()
            ..color = plantGreen
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            startAngle,
            segmentAngle * segmentFillPercentage,
            false,
            filledPaint,
          );
        }

        // Draw the unfilled part of the segment
        if (segmentFillPercentage < 1) {
          Paint unfilledPaint = Paint()
            ..color = lightGrey
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            startAngle + segmentAngle * segmentFillPercentage,
            segmentAngle * (1 - segmentFillPercentage) - 0.03,
            false,
            unfilledPaint,
          );
        }

        // Draw the separator with increased width
        Paint separatorPaint = Paint()
          ..color = separatorColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + segmentAngle - 0.03,
          0.03, // Increased angle for separator
          false,
          separatorPaint,
        );

        // Move to the next segment
        startAngle += segmentAngle;
      }
    }

    // Draw the time text in the center
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: isComplete ? 'Done!' : _formatDuration(remainingTime),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2 - 20)); // Adjust text position

    // Draw the "Until Delivered" text below
    TextPainter untilDeliveredPainter = TextPainter(
      text: TextSpan(
        text: isComplete ? 'Delivered!' : 'Until Delivered',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF757575),
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    untilDeliveredPainter.layout();
    untilDeliveredPainter.paint(
        canvas,
        Offset(center.dx - untilDeliveredPainter.width / 2,
            center.dy + textPainter.height / 2)); // Position below time text
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays >= 1) {
      return "${duration.inDays} Days";
    } else if (duration.inHours >= 1) {
      return "${duration.inHours} Hours";
    } else if (duration.inMinutes >= 1) {
      return "${duration.inMinutes} MIN";
    } else {
      return "${duration.inSeconds} SEC";
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TimeSegment {
  // Placeholder for segment information (can be extended if needed)
}
