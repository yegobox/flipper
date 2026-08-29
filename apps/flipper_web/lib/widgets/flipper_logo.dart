import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flutter/material.dart';

/// Official Flipper Accounting logo (same asset as favicon, launcher icons and
/// the startup splash).
class FlipperLogo extends StatelessWidget {
  const FlipperLogo({super.key, this.size = 30});

  final double size;

  static const assetPath = 'assets/accounting_logo_transparent.png';

  /// Host app: assets at `assets/…`. Embedded in Flipper POS: `packages/flipper_web/…`.
  static String? get package => flipperWebIsHostApp ? null : 'flipper_web';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      package: package,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
