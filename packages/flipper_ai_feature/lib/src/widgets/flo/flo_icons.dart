import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Handover SVG icons (Ic.* from design handoff).
abstract final class FloIcons {
  static const _stroke =
      'fill="none" stroke="currentColor" stroke-width="1.6" '
      'stroke-linecap="round" stroke-linejoin="round"';

  static Widget svg(String body, {required double size, Color? color}) {
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
      'viewBox="0 0 24 24">$body</svg>',
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  static Widget sparkle({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M12 3 13.7 8.6 19.5 10.5 13.7 12.4 12 18 10.3 12.4 4.5 10.5 10.3 8.6z"/>',
        size: size,
        color: color,
      );

  static Widget whatsApp({double size = 15, Color? color}) => svg(
        '<path fill="currentColor" stroke="none" '
        'd="M19.05 4.91A9.82 9.82 0 0 0 12.04 2C6.58 2 2.13 6.45 2.13 11.91c0 1.75.46 3.45 1.32 4.95L2 22l5.25-1.38a9.9 9.9 0 0 0 4.79 1.22h.01c5.46 0 9.91-4.45 9.91-9.91 0-2.65-1.03-5.14-2.91-7.02zm-7.01 15.22a8.2 8.2 0 0 1-4.18-1.15l-.3-.18-3.12.82.83-3.04-.2-.31a8.2 8.2 0 0 1-1.26-4.36c0-4.54 3.7-8.23 8.24-8.23a8.2 8.2 0 0 1 5.82 2.41 8.18 8.18 0 0 1 2.41 5.83c0 4.54-3.7 8.23-8.23 8.23zm4.52-6.16c-.25-.12-1.47-.72-1.69-.81-.23-.08-.39-.12-.56.12-.16.25-.64.81-.79.97-.14.17-.29.19-.54.06-.25-.12-1.05-.39-1.99-1.23-.74-.66-1.23-1.47-1.38-1.72-.14-.25-.01-.38.11-.5.11-.11.25-.29.37-.43.13-.14.17-.25.25-.41.08-.17.04-.31-.02-.43-.06-.12-.56-1.34-.76-1.84-.2-.48-.41-.42-.56-.43h-.48c-.17 0-.43.06-.66.31-.22.25-.86.85-.86 2.07 0 1.22.89 2.4 1.01 2.56.12.17 1.75 2.67 4.23 3.74.59.26 1.05.41 1.41.52.59.19 1.13.16 1.56.1.48-.07 1.47-.6 1.68-1.18.21-.58.21-1.07.14-1.18-.06-.11-.22-.17-.47-.29z"/>',
        size: size,
        color: color,
      );

  static Widget newChat({double size = 17, Color? color}) => svg(
        '<path $_stroke d="M20 11.5a8 8 0 0 1-11.5 7.2L4 20l1.3-4.5A8 8 0 1 1 20 11.5Z"/>'
        '<path $_stroke d="M12 8v6M9 11h6"/>',
        size: size,
        color: color,
      );

  static Widget plus({double size = 19, Color? color}) => svg(
        '<path $_stroke d="M12 5v14"/><path $_stroke d="M5 12h14"/>',
        size: size,
        color: color,
      );

  static Widget database({double size = 14, Color? color}) => svg(
        '<ellipse $_stroke cx="12" cy="5.5" rx="7" ry="2.8"/>'
        '<path $_stroke d="M5 5.5v6c0 1.5 3.1 2.8 7 2.8s7-1.3 7-2.8v-6"/>'
        '<path $_stroke d="M5 11.5v6c0 1.5 3.1 2.8 7 2.8s7-1.3 7-2.8v-6"/>',
        size: size,
        color: color,
      );

  static Widget send({double size = 19, Color? color}) => svg(
        '<path $_stroke d="M5 12h13"/><path $_stroke d="m12 5 7 7-7 7"/>',
        size: size,
        color: color,
      );

  static Widget mic({double size = 19, Color? color}) => svg(
        '<rect $_stroke x="9" y="3" width="6" height="11" rx="3"/>'
        '<path $_stroke d="M5 11a7 7 0 0 0 14 0"/>'
        '<path $_stroke d="M12 18v3"/>',
        size: size,
        color: color,
      );

  static Widget link({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M9 15 15 9"/>'
        '<path $_stroke d="M11 6.5 13 4.5a4 4 0 0 1 5.7 5.7l-2 2"/>'
        '<path $_stroke d="M13 17.5 11 19.5a4 4 0 0 1-5.7-5.7l2-2"/>',
        size: size,
        color: color,
      );

  static Widget chevDown({double size = 12, Color? color}) => svg(
        '<path $_stroke d="m6 9 6 6 6-6"/>',
        size: size,
        color: color,
      );

  static Widget copy({double size = 16, Color? color}) => svg(
        '<rect $_stroke x="9" y="9" width="11" height="11" rx="2"/>'
        '<path $_stroke d="M5 15V5a2 2 0 0 1 2-2h8"/>',
        size: size,
        color: color,
      );

  static Widget chart({double size = 19, Color? color}) => svg(
        '<path $_stroke d="M4 4v16h16"/>'
        '<path $_stroke d="m7 14 3-3 3 3 5-6"/>',
        size: size,
        color: color,
      );

  static Widget coins({double size = 19, Color? color}) => svg(
        '<ellipse $_stroke cx="9" cy="7" rx="5" ry="2.5"/>'
        '<path $_stroke d="M4 7v5c0 1.4 2.2 2.5 5 2.5s5-1.1 5-2.5V7"/>'
        '<path $_stroke d="M10 14.5c.6 1.2 2.6 2 5 2 2.8 0 5-1.1 5-2.5v-5c0-1.4-2.2-2.5-5-2.5-1 0-1.9.1-2.7.4"/>',
        size: size,
        color: color,
      );

  static Widget users({double size = 19, Color? color}) => svg(
        '<circle $_stroke cx="9" cy="9" r="3.5"/>'
        '<path $_stroke d="M3 19c0-3 3-5 6-5s6 2 6 5"/>'
        '<circle $_stroke cx="17" cy="8" r="2.5"/>'
        '<path $_stroke d="M16 14c2 0 5 1.5 5 4"/>',
        size: size,
        color: color,
      );

  static Widget trend({double size = 19, Color? color}) => svg(
        '<path $_stroke d="m4 15 5-5 4 4 7-7"/>'
        '<path $_stroke d="M16 7h4v4"/>',
        size: size,
        color: color,
      );

  static Widget bolt({double size = 14, Color? color}) => svg(
        '<path fill="currentColor" stroke="none" d="M13 2 4.5 13.5H11l-1 8.5 8.5-12H12z"/>',
        size: size,
        color: color,
      );

  static Widget edit({double size = 16, Color? color}) => svg(
        '<path $_stroke d="M4 20h4L19 9l-4-4L4 16z"/>'
        '<path $_stroke d="m14 6 4 4"/>',
        size: size,
        color: color,
      );

  static Widget check({double size = 10, Color? color}) => svg(
        '<path $_stroke d="M5 12.5 10 17 19 7.5"/>',
        size: size,
        color: color,
      );

  static Widget up({double size = 11, Color? color}) => svg(
        '<path $_stroke d="M12 19V6"/><path $_stroke d="m6 11 6-6 6 6"/>',
        size: size,
        color: color,
      );

  static Widget down({double size = 11, Color? color}) => svg(
        '<path $_stroke d="M12 5v13"/><path $_stroke d="m6 13 6 6 6-6"/>',
        size: size,
        color: color,
      );

  static Widget download({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M12 4v12"/><path $_stroke d="m7 11 5 5 5-5"/>'
        '<path $_stroke d="M5 20h14"/>',
        size: size,
        color: color,
      );

  static Widget info({double size = 17, Color? color}) => svg(
        '<circle $_stroke cx="12" cy="12" r="9"/>'
        '<path $_stroke d="M12 11v5"/><path $_stroke d="M12 7.5h.01"/>',
        size: size,
        color: color,
      );

  static Widget warn({double size = 17, Color? color}) => svg(
        '<path $_stroke d="M12 3 2.5 20h19z"/>'
        '<path $_stroke d="M12 10v4"/><path $_stroke d="M12 17.5h.01"/>',
        size: size,
        color: color,
      );

  static Widget receipt({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M6 3h12v18l-3-2-3 2-3-2-3 2z"/>'
        '<path $_stroke d="M9 8h6"/><path $_stroke d="M9 12h5"/>',
        size: size,
        color: color,
      );

  static Widget eye({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"/>'
        '<circle $_stroke cx="12" cy="12" r="3"/>',
        size: size,
        color: color,
      );

  static Widget arrowUpRight({double size = 15, Color? color}) => svg(
        '<path $_stroke d="M7 17 17 7"/><path $_stroke d="M8 7h9v9"/>',
        size: size,
        color: color,
      );

  /// Maps Handover action icon names (Chart, Download, …) to widgets.
  static Widget byName(String? name, {double size = 15, Color? color}) {
    switch (name) {
      case 'Chart':
        return chart(size: size, color: color);
      case 'Download':
        return download(size: size, color: color);
      case 'Edit':
        return edit(size: size, color: color);
      case 'Eye':
        return eye(size: size, color: color);
      case 'Receipt':
        return receipt(size: size, color: color);
      case 'Bolt':
        return bolt(size: size, color: color);
      case 'Sparkle':
        return sparkle(size: size, color: color);
      default:
        return arrowUpRight(size: size, color: color);
    }
  }

  /// Flo robot mark — gradient tile with face icon.
  static Widget floMark({required double size, required String gradientId}) {
    return SvgPicture.string(
      _floMarkSvg(gradientId),
      width: size,
      height: size,
    );
  }

  @Deprecated('Use floMark')
  static Widget flipperMark({required double size}) =>
      floMark(size: size, gradientId: 'floGrad');

  static String _floMarkSvg(String gradientId) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 56 56" role="img" aria-label="Flo">
  <defs>
    <linearGradient id="$gradientId" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#22D3EE"/>
      <stop offset="0.52" stop-color="#2563EB"/>
      <stop offset="1" stop-color="#4F46E5"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="56" height="56" rx="16" fill="url(#$gradientId)"/>
  <g transform="translate(7.6,12.6) scale(1.7)" fill="none" stroke="#fff" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
    <path d="M12 3.2v2.3"/>
    <circle cx="12" cy="2.4" r="1.25" fill="#fff" stroke="none"/>
    <rect x="4.4" y="5.6" width="15.2" height="12.4" rx="4.4"/>
    <path d="M4.4 10.2H3.1M19.6 10.2h1.3"/>
    <circle cx="9.3" cy="11.6" r="1.45" fill="#fff" stroke="none"/>
    <circle cx="14.7" cy="11.6" r="1.45" fill="#fff" stroke="none"/>
    <path d="M9.4 14.7c.7.7 1.6 1.05 2.6 1.05s1.9-.35 2.6-1.05" stroke-width="1.6"/>
  </g>
</svg>''';
}

/// Dashed pill border for "Connect WhatsApp" chip.
class FloDashedOutline extends StatelessWidget {
  const FloDashedOutline({
    super.key,
    required this.child,
    this.radius = 999,
    this.color = const Color(0xFFD6DEEA),
    this.strokeWidth = 1,
  });

  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = dist + 4;
        canvas.drawPath(metric.extractPath(dist, next.clamp(0, metric.length)), paint);
        dist += 6;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
