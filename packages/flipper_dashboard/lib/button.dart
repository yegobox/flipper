import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  final Color backgroundColor;
  RPSCustomPainter({required this.backgroundColor});
  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4554453, size.height * 0.002941176);
    path_0.lineTo(size.width * 0.5436894, size.height * 0.002941176);
    path_0.cubicTo(
        size.width * 0.6277529,
        size.height * 0.002941176,
        size.width * 0.6906118,
        size.height * 0.002943859,
        size.width * 0.7403353,
        size.height * 0.007342588);
    path_0.cubicTo(
        size.width * 0.7900118,
        size.height * 0.01173782,
        size.width * 0.8262941,
        size.height * 0.02050465,
        size.width * 0.8572706,
        size.height * 0.03786824);
    path_0.cubicTo(
        size.width * 0.9012118,
        size.height * 0.06249882,
        size.width * 0.9375000,
        size.height * 0.09878529,
        size.width * 0.9621294,
        size.height * 0.1427271);
    path_0.cubicTo(
        size.width * 0.9794941,
        size.height * 0.1737047,
        size.width * 0.9882647,
        size.height * 0.2099859,
        size.width * 0.9926588,
        size.height * 0.2596671);
    path_0.cubicTo(
        size.width * 0.9970588,
        size.height * 0.3093865,
        size.width * 0.9970588,
        size.height * 0.3722447,
        size.width * 0.9970588,
        size.height * 0.4563106);
    path_0.lineTo(size.width * 0.9970588, size.height * 0.4954953);
    path_0.cubicTo(
        size.width * 0.9970588,
        size.height * 0.5771612,
        size.width * 0.9970588,
        size.height * 0.6382529,
        size.width * 0.9935294,
        size.height * 0.6869059);
    path_0.cubicTo(
        size.width * 0.9900059,
        size.height * 0.7355294,
        size.width * 0.9829706,
        size.height * 0.7715000,
        size.width * 0.9690235,
        size.height * 0.8029529);
    path_0.cubicTo(
        size.width * 0.9361824,
        size.height * 0.8769941,
        size.width * 0.8769941,
        size.height * 0.9361824,
        size.width * 0.8029529,
        size.height * 0.9690235);
    path_0.cubicTo(
        size.width * 0.7715000,
        size.height * 0.9829706,
        size.width * 0.7355294,
        size.height * 0.9900059,
        size.width * 0.6869059,
        size.height * 0.9935294);
    path_0.cubicTo(
        size.width * 0.6382529,
        size.height * 0.9970588,
        size.width * 0.5771612,
        size.height * 0.9970588,
        size.width * 0.4954953,
        size.height * 0.9970588);
    path_0.cubicTo(
        size.width * 0.4152876,
        size.height * 0.9970588,
        size.width * 0.3552882,
        size.height * 0.9970588,
        size.width * 0.3075065,
        size.height * 0.9935941);
    path_0.cubicTo(
        size.width * 0.2597529,
        size.height * 0.9901294,
        size.width * 0.2244312,
        size.height * 0.9832235,
        size.width * 0.1935488,
        size.height * 0.9695294);
    path_0.cubicTo(
        size.width * 0.1208435,
        size.height * 0.9372765,
        size.width * 0.06272059,
        size.height * 0.8791588,
        size.width * 0.03047324,
        size.height * 0.8064529);
    path_0.cubicTo(
        size.width * 0.01677594,
        size.height * 0.7755706,
        size.width * 0.009868059,
        size.height * 0.7402471,
        size.width * 0.006406588,
        size.height * 0.6924941);
    path_0.cubicTo(
        size.width * 0.002942976,
        size.height * 0.6447118,
        size.width * 0.002941176,
        size.height * 0.5847124,
        size.width * 0.002941176,
        size.height * 0.5045047);
    path_0.lineTo(size.width * 0.002941176, size.height * 0.4554453);
    path_0.cubicTo(
        size.width * 0.002941176,
        size.height * 0.3689753,
        size.width * 0.002944135,
        size.height * 0.3043241,
        size.width * 0.007681706,
        size.height * 0.2532929);
    path_0.cubicTo(
        size.width * 0.01241541,
        size.height * 0.2023035,
        size.width * 0.02185624,
        size.height * 0.1652076,
        size.width * 0.04055288,
        size.height * 0.1337718);
    path_0.cubicTo(
        size.width * 0.06336765,
        size.height * 0.09541235,
        size.width * 0.09541235,
        size.height * 0.06336765,
        size.width * 0.1337718,
        size.height * 0.04055288);
    path_0.cubicTo(
        size.width * 0.1652076,
        size.height * 0.02185624,
        size.width * 0.2023035,
        size.height * 0.01241541,
        size.width * 0.2532929,
        size.height * 0.007681706);
    path_0.cubicTo(
        size.width * 0.3043241,
        size.height * 0.002944135,
        size.width * 0.3689753,
        size.height * 0.002941176,
        size.width * 0.4554453,
        size.height * 0.002941176);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_0_stroke.color = backgroundColor.withOpacity(1.0);
    paint_0_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = backgroundColor.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
