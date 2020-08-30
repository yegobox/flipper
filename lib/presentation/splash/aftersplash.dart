import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/presentation/splash/responsive/button_landscape.dart';
import 'package:flipper/presentation/splash/responsive/button_portrait.dart';
import 'package:flipper/presentation/splash/responsive/logo_landscape.dart';
import 'package:flipper/presentation/splash/responsive/portrait_logo.dart';
import 'package:flipper_login/login.dart';
import 'package:flipper_login/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  VoidCallback _showLoginBottomSheet;

  @override
  void initState() {
    super.initState();
    
  }

  void _showOtpBottomSheet({String phone, String verificationCode}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: OtpPage(
            phone: phone,
                  verificationId: verificationCode,
          ),
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        );
      },
    );
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
    return StoreConnector<AppState, CommonViewModel>(
        distinct: true,
        converter: CommonViewModel.fromStore,
        builder: (BuildContext context, CommonViewModel vm) {
          if (vm.navigate == 'otp') {
            _showOtpBottomSheet(phone: vm.phone, verificationCode: vm.otpcode);
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            body: child,
          );
        });
  }
}
