import 'package:flutter/material.dart';

class MiniAppIcon extends StatelessWidget {
  const MiniAppIcon(
      {super.key,
      required this.icon,
      required this.gradientColorOne,
      required this.gradientColorTwo,
      required this.page,
      this.showPageName = true,
      this.sideSize = 59.0});

  final IconData icon;
  final Color gradientColorOne;
  final Color gradientColorTwo;
  final double sideSize;
  final String page;
  final bool showPageName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Material(
            color: gradientColorOne,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
            elevation: 0.0,
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Visibility(
            visible: showPageName,
            child: Text(
              page,
            ),
          ),
        )
      ],
    );
  }
}
