import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'bubble_type.dart';

///https://fluttershapemaker.com/
class CustomPainte extends CustomPainter {
  ///The values assigned to the clipper types [BubbleType.sendBubble] and
  ///[BubbleType.receiverBubble] are distinct.
  final BubbleType? type;

  CustomPainte({this.type});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.8744185, 0);
    path.lineTo(size.width * 0.1255815, 0);
    path.cubicTo(size.width * 0.05622500, 0, 0, size.height * 0.09271741, 0,
        size.height * 0.2070926);
    path.lineTo(0, size.height * 0.5892037);
    path.cubicTo(
        0,
        size.height * 0.7035796,
        size.width * 0.05622500,
        size.height * 0.7962963,
        size.width * 0.1255815,
        size.height * 0.7962963);
    path.lineTo(size.width * 0.6094609, size.height * 0.8310463);
    path.cubicTo(
        size.width * 0.6304185,
        size.height * 0.8325519,
        size.width * 0.6509065,
        size.height * 0.8421056,
        size.width * 0.6693924,
        size.height * 0.8589944);
    path.lineTo(size.width * 0.7935163, size.height * 0.9723870);
    path.cubicTo(
        size.width * 0.8301152,
        size.height * 1.005824,
        size.width * 0.8744185,
        size.height * 0.9606519,
        size.width * 0.8744185,
        size.height * 0.8898981);
    path.cubicTo(
        size.width * 0.8744185,
        size.height * 0.8382037,
        size.width * 0.9001065,
        size.height * 0.7981519,
        size.width * 0.9277304,
        size.height * 0.7767630);
    path.cubicTo(size.width * 0.9704315, size.height * 0.7437000, size.width,
        size.height * 0.6721463, size.width, size.height * 0.5892037);
    path.lineTo(size.width, size.height * 0.2070926);
    path.cubicTo(size.width, size.height * 0.09271741, size.width * 0.9437750,
        0, size.width * 0.8744185, 0);
    path.close();

    Paint fill = Paint()..style = PaintingStyle.fill;
    fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.2282609, size.height * 0.1203704),
        Offset(size.width * 1.500000, size.height * 0.7500000), [
      const Color(0xffDFF6FF).withOpacity(1),
      const Color(0xffB6F2FF).withOpacity(1)
    ], [
      0,
      0.536458
    ]);
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
