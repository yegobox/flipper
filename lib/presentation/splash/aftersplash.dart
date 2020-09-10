import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/presentation/splash/responsive/button_landscape.dart';
import 'package:flipper/presentation/splash/responsive/button_portrait.dart';
import 'package:flipper/presentation/splash/responsive/logo_landscape.dart';
import 'package:flipper/presentation/splash/responsive/portrait_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
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
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: const LandscapeButton(),
          )
        ],
      );

    if (!landscape)
      child = Wrap(
        children: <Widget>[
          PortraitLogo(),
          Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: const ButtonPortrait(),
          )
        ],
      );
    return WillPopScope(
          onWillPop: _onWillPop,
          child: StoreConnector<AppState, CommonViewModel>(
          distinct: true,
          converter: CommonViewModel.fromStore,
          builder: (BuildContext context, CommonViewModel vm) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
              body: child,
            );
          }),
    );
  }
}
