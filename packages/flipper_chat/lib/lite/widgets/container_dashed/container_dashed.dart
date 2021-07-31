library dashed_container;

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
part 'dash_painter.dart';

class ContainerDashed extends StatelessWidget {
  ContainerDashed({
    required this.child,
    this.strokeCap = StrokeCap.butt,
    this.strokeColor = Colors.black,
    this.strokeWidth = 1.0,
    this.blankLength = 5.0,
    this.numLines = 10,
    this.borderRadius = 0.0,
    this.boxShape = BoxShape.rectangle,
    this.padding = 0.0,
  });

  final StrokeCap strokeCap;
  final Color strokeColor;
  final double strokeWidth;
  final double blankLength;
  final int numLines;
  final Widget child;
  final double borderRadius;
  final BoxShape boxShape;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final Paint mPaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    return CustomPaint(
      painter: DashPainter(
        mPaint: mPaint,
        blankWidth: blankLength,
        numberChild: numLines,
        borderRadius: borderRadius,
        boxShape: boxShape,
      ),
      child: Padding(
        padding: EdgeInsets.all((strokeWidth / 2) + padding),
        child: boxShape == BoxShape.rectangle
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: child,
              )
            : LayoutBuilder(
                builder: (_, BoxConstraints boxConstraints) {
                  final r = boxConstraints.maxHeight / 2;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: child,
                  );
                },
              ),
      ),
    );
  }
}
