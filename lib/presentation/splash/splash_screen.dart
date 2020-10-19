import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/presentation/splash/splash_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModel>(
      distinct: true,
      converter: SplashViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: Wrap(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Container(
                  color: HexColor('#955be9'),
                  child: Center(
                    child: Container(
                      height: 60,
                      child: Image.asset('assets/graphics/logo.png'),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 2 / 2,
                child: Container(
                  color: HexColor('#955be9'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
