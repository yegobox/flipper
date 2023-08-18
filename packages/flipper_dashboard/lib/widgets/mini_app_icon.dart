import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniAppIcon extends StatelessWidget {
  const MiniAppIcon(
      {super.key,
      required this.icon,
      required this.color,
      required this.page,
      this.showPageName = true,
      this.sideSize = 72.0});

  final dynamic icon;
  final Color color;
  final double sideSize;
  final String page;
  final bool showPageName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: sideSize,
          width: sideSize,
          decoration: ShapeDecoration(
              shape: ContinuousRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(80.0)),
              color: color,
              shadows: []),
          child: Center(
            child: (icon is IconData)
                ? Icon(
                    icon,
                    color: Colors.white,
                  )
                : SvgPicture.asset(
                    icon,
                    package: 'flipper_dashboard',
                  ),
          ),
        ),
        if (showPageName)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(page, style: GoogleFonts.poppins(fontSize: 13)),
          )
      ],
    );
  }
}
