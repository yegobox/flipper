import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.data, this.height = 180});

  final List<TrendPoint> data;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height);

    final maxVal = data.fold<int>(0, (m, p) => p.rev > m ? p.rev : (p.exp > m ? p.exp : m));
    final barMax = maxVal * 1.1;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in data)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Bar(value: point.rev, max: barMax, color: AccountingTokens.accent),
                          const SizedBox(width: 3),
                          _Bar(value: point.exp, max: barMax, color: AccountingTokens.ink4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(point.m, style: AccountingTokens.sans(fontSize: 11, color: AccountingTokens.ink3)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.max, required this.color});

  final int value;
  final double max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = max == 0 ? 0.0 : value / max;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 10,
          height: constraints.maxHeight * fraction,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        );
      },
    );
  }
}

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.segments,
    this.size = 148,
    this.center,
  });

  final List<({String label, int value, Color color})> segments;
  final double size;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (s, seg) => s + seg.value);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(segments: segments, total: total),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.segments, required this.total});

  final List<({String label, int value, Color color})> segments;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var start = -3.14159 / 2;
    for (final seg in segments) {
      if (total == 0) continue;
      final sweep = (seg.value / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.14
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect.deflate(size.width * 0.07), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.total != total;
}
