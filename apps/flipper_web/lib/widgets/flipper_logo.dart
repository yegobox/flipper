import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Official Flipper ring logo (same asset as [flipper_dashboard] POS handoff).
class FlipperLogo extends StatelessWidget {
  const FlipperLogo({super.key, this.size = 30});

  final double size;

  static const _assetPath = 'assets/icons/flipper-logo.svg';
  static const _package = 'flipper_web';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath,
      package: _package,
      width: size,
      height: size,
    );
  }
}
