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
    this.iconSize = 32.0, // Add icon size property
  });

  final dynamic icon;
  final Color color;
  final double sideSize;
  final String page;
  final bool showPageName;
  final double iconSize; // Add icon size property

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Add this line
      children: [
        Container(
          height: sideSize,
          width: sideSize,
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              side: BorderSide(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(80.0),
            ),
            color: color,
            shadows: [],
          ),
          child: Center(
            child: (icon is IconData)
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize, // Use iconSize here
                  )
                : SvgPicture.asset(
                    icon,
                    package: 'flipper_dashboard',
                    height: iconSize, // Use iconSize here
                    width: iconSize, // Use iconSize here
                  ),
          ),
        ),
        if (showPageName)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
            child: Text(
              page, // Add weight
            ),
          )
      ],
    );
  }
}
