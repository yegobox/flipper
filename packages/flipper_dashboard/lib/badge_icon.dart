import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {required this.icon,
      this.badgeCount = 0,
      this.showIfZero = false,
      this.badgeColor,
      required this.badgeTextStyle});
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color? badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: badgeColor ?? Color(0xff006AFE),
            borderRadius: BorderRadius.circular(7.5),
          ),
          constraints: BoxConstraints(
            minWidth: 15,
            minHeight: 15,
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
