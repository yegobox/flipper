import 'package:flutter/material.dart';

class AppleLogo extends StatelessWidget {
  final Color color;
  final double? size; // Make size optional
  final double? width; // Allow explicit width
  final double? height; // Allow explicit height
  final VoidCallback? onTap; // Optional tap handler
  final bool useShadow; // Toggle shadow
  final bool useGradient; // Toggle gradient

  const AppleLogo({
    Key? key,
    required this.color,
    this.size,
    this.width,
    this.height,
    this.onTap,
    this.useShadow = false,
    this.useGradient = false,
  })  : assert(
            (size == null && width == null && height == null) ||
                (size != null && width == null && height == null) ||
                (size == null && width != null && height != null),
            "Either size, or both width and height must be provided."),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the size to use
    double? usedWidth = size ?? width;
    double? usedHeight = size ?? height;

    // If width and height are still null, default to 100
    usedWidth ??= 100;
    usedHeight ??= 100;

    Widget logo = SizedBox(
      width: usedWidth,
      height: usedHeight,
      child: FittedBox(
        fit: BoxFit.contain, // Maintain aspect ratio
        child: CustomPaint(
          painter: AppleLogoPainter(
            color: color,
            gradient: useGradient
                ? LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            shadowColor: useShadow ? Colors.black26 : null,
          ),
        ),
      ),
    );

    // Wrap with InkWell for touch responsiveness
    if (onTap != null) {
      logo = Material(
        //Add material widget to allow InkWell to paint
        color: Colors.transparent, // Make it invisible
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10), // Optional rounding
          child: Padding(
            // Optional padding around the logo
            padding: const EdgeInsets.all(8.0),
            child: logo,
          ),
        ),
      );
    }

    return logo;
  }
}

class AppleLogoPainter extends CustomPainter {
  const AppleLogoPainter({
    required this.color,
    this.gradient,
    this.shadowColor,
    Listenable? repaint,
  }) : super(repaint: repaint);

  final Color color;
  final Gradient? gradient;
  final Color? shadowColor;

  static Path? _cachedPath;
  static Size? _cachedSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (shadowColor != null) {
      // Add a shadow
      final shadowPaint = Paint()
        ..color = shadowColor!
        ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal, 2); // Adjust blur radius as needed
      canvas.drawPath(getPath(size.width, size.height), shadowPaint);
    }

    final paint = Paint()
      ..shader = (gradient != null)
          ? gradient!.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          : null
      ..color = color;

    // Use cached path if size hasn't changed
    if (_cachedPath == null || _cachedSize != size) {
      _cachedPath = getPath(size.width, size.height);
      _cachedSize = size;
    }

    canvas.drawPath(_cachedPath!, paint);
  }

  Path getPath(double w, double h) {
    // Key proportions - makes the code much more readable and maintainable.
    final double moveX = w * .50779;
    final double moveY = h * .28732;

    final double cubic1ControlX1 = w * .4593;
    final double cubic1ControlY1 = h * .28732;
    final double cubic1ControlX2 = w * .38424;
    final double cubic1ControlY2 = h * .24241;
    final double cubic1EndX = w * .30519;
    final double cubic1EndY = h * .24404;

    final double cubic2ControlX1 = w * .2009;
    final double cubic2ControlY1 = h * .24512;
    final double cubic2ControlX2 = w * .10525;
    final double cubic2ControlY2 = h * .29328;
    final double cubic2EndX = w * .05145;
    final double cubic2EndY = h * .36957;

    final double cubic3ControlX1 = w * -.05683;
    final double cubic3ControlY1 = h * .5227;
    final double cubic3ControlX2 = w * .02355;
    final double cubic3ControlY2 = h * .74888;
    final double cubic3EndX = w * .12916;
    final double cubic3EndY = h * .87333;

    final double cubic4ControlX1 = w * .18097;
    final double cubic4ControlY1 = h * .93394;
    final double cubic4ControlX2 = w * .24209;
    final double cubic4ControlY2 = h * 1.00211;
    final double cubic4EndX = w * .32313;
    final double cubic4EndY = h * .99995;

    final double cubic5ControlX1 = w * .40084;
    final double cubic5ControlY1 = h * .99724;
    final double cubic5ControlX2 = w * .43007;
    final double cubic5ControlY2 = h * .95883;
    final double cubic5EndX = w * .52439;
    final double cubic5EndY = h * .95883;

    final double cubic6ControlX1 = w * .61805;
    final double cubic6ControlY1 = h * .95883;
    final double cubic6ControlX2 = w * .64462;
    final double cubic6ControlY2 = h * .99995;
    final double cubic6EndX = w * .72699;
    final double cubic6EndY = h * .99833;

    final double cubic7ControlX1 = w * .81069;
    final double cubic7ControlY1 = h * .99724;
    final double cubic7ControlX2 = w * .86383;
    final double cubic7ControlY2 = h * .93664;
    final double cubic7EndX = w * .91498;
    final double cubic7EndY = h * .8755;

    final double cubic8ControlX1 = w * .97409;
    final double cubic8ControlY1 = h * .80515;
    final double cubic8ControlX2 = w * .99867;
    final double cubic8ControlY2 = h * .73698;
    final double cubic8EndX = w * 1;
    final double cubic8EndY = h * .73319;

    final double cubic9ControlX1 = w * .99801;
    final double cubic9ControlY1 = h * .73265;
    final double cubic9ControlX2 = w * .83726;
    final double cubic9ControlY2 = h * .68233;
    final double cubic9EndX = w * .83526;
    final double cubic9EndY = h * .53082;

    final double cubic10ControlX1 = w * .83394;
    final double cubic10ControlY1 = h * .4042;
    final double cubic10ControlX2 = w * .96214;
    final double cubic10ControlY2 = h * .3436;
    final double cubic10EndX = w * .96812;
    final double cubic10EndY = h * .34089;

    final double cubic11ControlX1 = w * .89505;
    final double cubic11ControlY1 = h * .25378;
    final double cubic11ControlX2 = w * .78279;
    final double cubic11ControlY2 = h * .24404;
    final double cubic11EndX = w * .7436;
    final double cubic11EndY = h * .24187;

    final double cubic12ControlX1 = w * .6413;
    final double cubic12ControlY1 = h * .23538;
    final double cubic12ControlX2 = w * .55561;
    final double cubic12ControlY2 = h * .28732;
    final double cubic12EndX = w * .50779;
    final double cubic12EndY = h * .28732;

    final double move2X = w * .68049;
    final double move2Y = h * .15962;

    final double cubic13ControlX1 = w * .72367;
    final double cubic13ControlY1 = h * .11742;
    final double cubic13ControlX2 = w * .75223;
    final double cubic13ControlY2 = h * .05844;
    final double cubic13EndX = w * .74426;
    final double cubic13EndY = 0;

    final double cubic14ControlX1 = w * .68249;
    final double cubic14ControlY1 = h * .00216;
    final double cubic14ControlX2 = w * .60809;
    final double cubic14ControlY2 = h * .03355;
    final double cubic14EndX = w * .56359;
    final double cubic14EndY = h * .07575;

    final double cubic15ControlX1 = w * .52373;
    final double cubic15ControlY1 = h * .11309;
    final double cubic15ControlX2 = w * .48919;
    final double cubic15ControlY2 = h * .17315;
    final double cubic15EndX = w * .49849;
    final double cubic15EndY = h * .23051;

    final double cubic16ControlX1 = w * .56691;
    final double cubic16ControlY1 = h * .23484;
    final double cubic16ControlX2 = w * .63732;
    final double cubic16ControlY2 = h * .20183;
    final double cubic16EndX = w * .68049;
    final double cubic16EndY = h * .15962;

    return Path()
      ..moveTo(moveX, moveY)
      ..cubicTo(cubic1ControlX1, cubic1ControlY1, cubic1ControlX2,
          cubic1ControlY2, cubic1EndX, cubic1EndY)
      ..cubicTo(cubic2ControlX1, cubic2ControlY1, cubic2ControlX2,
          cubic2ControlY2, cubic2EndX, cubic2EndY)
      ..cubicTo(cubic3ControlX1, cubic3ControlY1, cubic3ControlX2,
          cubic3ControlY2, cubic3EndX, cubic3EndY)
      ..cubicTo(cubic4ControlX1, cubic4ControlY1, cubic4ControlX2,
          cubic4ControlY2, cubic4EndX, cubic4EndY)
      ..cubicTo(cubic5ControlX1, cubic5ControlY1, cubic5ControlX2,
          cubic5ControlY2, cubic5EndX, cubic5EndY)
      ..cubicTo(cubic6ControlX1, cubic6ControlY1, cubic6ControlX2,
          cubic6ControlY2, cubic6EndX, cubic6EndY)
      ..cubicTo(cubic7ControlX1, cubic7ControlY1, cubic7ControlX2,
          cubic7ControlY2, cubic7EndX, cubic7EndY)
      ..cubicTo(cubic8ControlX1, cubic8ControlY1, cubic8ControlX2,
          cubic8ControlY2, cubic8EndX, cubic8EndY)
      ..cubicTo(cubic9ControlX1, cubic9ControlY1, cubic9ControlX2,
          cubic9ControlY2, cubic9EndX, cubic9EndY)
      ..cubicTo(cubic10ControlX1, cubic10ControlY1, cubic10ControlX2,
          cubic10ControlY2, cubic10EndX, cubic10EndY)
      ..cubicTo(cubic11ControlX1, cubic11ControlY1, cubic11ControlX2,
          cubic11ControlY2, cubic11EndX, cubic11EndY)
      ..cubicTo(cubic12ControlX1, cubic12ControlY1, cubic12ControlX2,
          cubic12ControlY2, cubic12EndX, cubic12EndY)
      ..close()
      ..moveTo(move2X, move2Y)
      ..cubicTo(cubic13ControlX1, cubic13ControlY1, cubic13ControlX2,
          cubic13ControlY2, cubic13EndX, cubic13EndY)
      ..cubicTo(cubic14ControlX1, cubic14ControlY1, cubic14ControlX2,
          cubic14ControlY2, cubic14EndX, cubic14EndY)
      ..cubicTo(cubic15ControlX1, cubic15ControlY1, cubic15ControlX2,
          cubic15ControlY2, cubic15EndX, cubic15EndY)
      ..cubicTo(cubic16ControlX1, cubic16ControlY1, cubic16ControlX2,
          cubic16ControlY2, cubic16EndX, cubic16EndY)
      ..close();
  }

  @override
  bool shouldRepaint(AppleLogoPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.gradient != gradient ||
      oldDelegate.shadowColor != shadowColor;
}
