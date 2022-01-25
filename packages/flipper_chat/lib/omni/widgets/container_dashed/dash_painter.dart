part of dashed_container;

class DashPainter extends CustomPainter {
  DashPainter({
    required this.mPaint,
    required this.blankWidth,
    required this.numberChild,
    required this.borderRadius,
    this.boxShape = BoxShape.rectangle,
  });
  final Paint mPaint;
  final double blankWidth;
  final int numberChild;
  final double borderRadius;
  final BoxShape boxShape;

  @override
  bool shouldRepaint(DashPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Path p;
    double bRadius = borderRadius;

    if (boxShape == BoxShape.rectangle) {
      if (bRadius == 0)
        p = Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      else {
        Radius radius = Radius.circular(bRadius);
        p = Path()
          ..addRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(0.0, 0.0, size.width, size.height),
              bottomLeft: radius,
              bottomRight: radius,
              topLeft: radius,
              topRight: radius,
            ),
          );
      }
    } else {
      bRadius = size.width / 2;
      Radius radius = Radius.circular(bRadius);
      p = Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            bottomLeft: radius,
            bottomRight: radius,
            topLeft: radius,
            topRight: radius,
          ),
        );
    }
    canvas.drawPath(
      dashPath(
        p,
        blankWidth: blankWidth,
        numberChild: numberChild,
        boxShape: boxShape,
      ),
      mPaint,
    );
  }

  Path dashPath(
    Path source, {
    required double blankWidth,
    required int numberChild,
    required BoxShape boxShape,
  }) {
    Path dest = Path();

    int nc = numberChild < 2 ? 0 : (numberChild.clamp(0, 20) + 1);
    double bw = numberChild < 2 ? 0 : (blankWidth + 1);

    double diameter = 0;
    double fragment = 0;
    if (boxShape == BoxShape.circle) {
      double radio = source.getBounds().size.width / 2;
      diameter = (2 * math.pi * radio);
      fragment = (diameter / nc) - bw;
    } else {
      double w = source.getBounds().size.width * 2;
      double h = source.getBounds().size.height * 2;
      diameter = w + h;
      fragment = (diameter / nc) - bw;
    }

    final dashArray = CircularIntervalList<double>([fragment, bw]);

    for (final PathMetric metric in source.computeMetrics()) {
      bool draw = true;
      double distance = 0.00;
      while (distance < diameter) {
        final double len = dashArray.next;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }

    return dest;
  }
}

class CircularIntervalList<T> {
  CircularIntervalList(this._vals);

  final List<T> _vals;
  int _idx = 0;

  T get next {
    if (_idx >= _vals.length) {
      _idx = 0;
    }
    return _vals[_idx++];
  }
}
