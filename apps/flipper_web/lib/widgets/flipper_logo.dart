import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Flipper's ring mark (`assets/icons/flipper-logo.svg`) — the same mark as
/// the favicon, the web splash, the landing page and the mobile app header.
class FlipperLogo extends StatelessWidget {
  const FlipperLogo({super.key, this.size = 30});

  final double size;

  static const assetPath = 'assets/icons/flipper-logo.svg';

  /// Host app: assets at `assets/…`. Embedded in Flipper POS: `packages/flipper_web/…`.
  static String? get package => flipperWebIsHostApp ? null : 'flipper_web';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      package: package,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}
