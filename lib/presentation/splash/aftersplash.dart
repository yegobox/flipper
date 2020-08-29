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
    _showLoginBottomSheet = _showBottomSheet;
  }

  void _showOtpBottomSheet({String phone, String verificationCode}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          _scaffoldKey.currentState.showBottomSheet((context) {
            return Container(
              color: Colors.white,
              height: 300.0,
              child: Center(
                child: OtpPage(
                  phone: phone,
                  verificationId: verificationCode,
                ),
              ),
            );
          })
        });
  }

  void _showBottomSheet() {
    setState(() {
      _showLoginBottomSheet = null; //make bottomSheet not clickable
    });
    _scaffoldKey.currentState
        .showBottomSheet(
          (BuildContext context) {
            return Container(
              color: Colors.white,
              height: 300.0,
              child: Center(
                child: Login(),
              ),
            );
          },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              color: Colors.blue,
            ),
          ),
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showLoginBottomSheet =
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
          LandscapeButton(showBottomSheetCallback: _showLoginBottomSheet),
        ],
      );

    if (!landscape)
      child = Wrap(
        children: <Widget>[
          PortraitLogo(),
          ButtonPortrait(showBottomSheetCallback: _showLoginBottomSheet),
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
