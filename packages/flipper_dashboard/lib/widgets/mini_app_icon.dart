import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MiniAppIcon extends StatelessWidget {
  const MiniAppIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.page,
    this.showPageName = true,
    this.sideSize = 72.0,
    this.iconSize = 32.0,
    this.textStyle,
    this.shadows = const [
      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))
    ], // Default shadow
  });

  final Object? icon;
  final Color color;
  final double sideSize;
  final String page;
  final bool showPageName;
  final double iconSize;
  final TextStyle? textStyle;
  final List<BoxShadow> shadows;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: sideSize,
          width: sideSize,
          decoration: BoxDecoration(
            /// it used to be             shape: ContinuousRectangleBorder(
            /// but I think it is not beautiful anymore!
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: shadows,
          ),
          child: Center(
            child: _buildIcon(),
          ),
        ),
        if (showPageName)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              page,
              style: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        color: Colors.white,
        size: iconSize,
        semanticLabel: page,
      );
    } else if (icon is String) {
      return SvgPicture.asset(
        icon as String,
        package: 'flipper_dashboard',
        height: iconSize,
        width: iconSize,
        semanticsLabel: page,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
