import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniAppIcon extends StatelessWidget {
  const MiniAppIcon(
      {super.key,
      required this.icon,
      required this.gradientColorOne,
      required this.page,
      this.showPageName = true,
      this.sideSize = 72.0});

  final IconData icon;
  final Color gradientColorOne;
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
              color: gradientColorOne,
              shadows: []),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Visibility(
            visible: showPageName,
            child: Text(page, style: GoogleFonts.poppins(fontSize: 13)),
          ),
        )
      ],
    );
  }
}
