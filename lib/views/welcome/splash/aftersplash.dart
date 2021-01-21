import 'package:flipper/views/welcome/splash/responsive/signup_login_buttons.dart';
import 'package:flipper/views/welcome/splash/responsive/uper_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AfterSplash extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return false;
  }
 
  @override
  Widget build(BuildContext context) {
    final bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    Widget child;
    if (landscape)
      child = ListView(
        children: <Widget>[
          const UperBody(),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: SignUpLoginButton(
              portrait: landscape,
            ),
          )
        ],
      );

    if (!landscape)
      child = ListView(
        children: <Widget>[
          const UperBody(),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: SignUpLoginButton(
              portrait: landscape,
            ),
          )
        ],
      );
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: Container(
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }
}
