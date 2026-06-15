import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';
import 'flo_icons.dart';

/// Flo robot brand mark (gradient tile + face icon).
class FloMark extends StatelessWidget {
  const FloMark({super.key, this.size = 38, this.small = false});

  final double size;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final radius = size * 16 / 56;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [FloTheme.markShadow],
      ),
      child: FloIcons.floMark(size: size, gradientId: 'floGrad_$hashCode'),
    );
  }
}

class FloGradientText extends StatelessWidget {
  const FloGradientText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => FloTheme.gradBrand.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style?.copyWith(color: Colors.white)),
    );
  }
}

class FloLiveDot extends StatelessWidget {
  const FloLiveDot({super.key, this.color = FloTheme.gain, this.glow = FloTheme.gainTint});

  final Color color;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glow, blurRadius: 0, spreadRadius: 3),
        ],
      ),
    );
  }
}
