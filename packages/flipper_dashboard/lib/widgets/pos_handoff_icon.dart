import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG icons from [flipper/design_handoff_pos/icons].
abstract final class PosHandoffIcons {
  static const String package = 'flipper_dashboard';

  static String assetPath(String name) => 'assets/pos_handoff/icons/$name.svg';

  static Widget svg(
    String name, {
    double size = 24,
    Color? color,
  }) {
    final picture = SvgPicture.asset(
      assetPath(name),
      package: package,
      width: size,
      height: size,
    );
    if (color == null) return picture;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: picture,
    );
  }
}
