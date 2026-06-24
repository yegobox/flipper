import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Official Flipper ring logo (same asset as [flipper_dashboard] POS handoff).
class FlipperLogo extends StatelessWidget {
  const FlipperLogo({super.key, this.size = 30});

  final double size;

  static const _assetPath = 'assets/icons/flipper-logo.svg';

  /// Host app: assets at `assets/…`. Embedded in Flipper POS: `packages/flipper_web/…`.
  static String? get _package => flipperWebIsHostApp ? null : 'flipper_web';

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
