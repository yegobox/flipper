import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {Key? key, required this.mobile, required this.desktop})
      : super(key: key);
  final Widget mobile;
  final Widget desktop;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobile;
      } else {
        return desktop;
      }
    }));
  }
}
