import 'package:flipper/presentation/splash/responsive/button_landscape.dart';
import 'package:flipper/presentation/splash/responsive/button_portrait.dart';
import 'package:flipper/presentation/splash/responsive/logo_landscape.dart';
import 'package:flipper/presentation/splash/responsive/portrait_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    Widget child;
    if (landscape)
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LandscapeLogo(),
          LandscapeButton(),
        ],
      );
    if (!landscape)
      child = Wrap(
        children: <Widget>[
          PortraitLogo(),
          ButtonPortrait(),
        ],
      );
    return Scaffold(
      body: child,
    );
  }
}
