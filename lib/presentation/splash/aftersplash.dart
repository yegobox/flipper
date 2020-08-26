import 'package:flipper/presentation/splash/responsive/button_landscape.dart';
import 'package:flipper/presentation/splash/responsive/button_portrait.dart';
import 'package:flipper/presentation/splash/responsive/logo_landscape.dart';
import 'package:flipper/presentation/splash/responsive/portrait_logo.dart';
import 'package:flipper_login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: unused_field
  VoidCallback _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _showBottomSheetCallback = null; //make bottomSheet not clickable
    });
    _scaffoldKey.currentState
        .showBottomSheet(
          (context) {
            return new Container(
              color: Colors.white,
              height: 300.0,
              child: new Center(
                child: Login(),
              ),
            );
          },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: Colors.blue,
            ),
          ),
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showBottomSheetCallback =
                  _showBottomSheet; //is still in three then keep showing it.
            });
          }
        });
  }

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
          LandscapeButton(showBottomSheetCallback: _showBottomSheetCallback),
        ],
      );

    if (!landscape)
      child = Wrap(
        children: <Widget>[
          PortraitLogo(),
          ButtonPortrait(showBottomSheetCallback: _showBottomSheetCallback),
        ],
      );
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: child,
    );
  }
}
