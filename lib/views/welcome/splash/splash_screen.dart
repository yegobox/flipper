import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        color: HexColor('#955be9'),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Colors.white.withOpacity(1.0),
            ),
            height: 60,
            child: Image.asset('assets/graphics/icon.png'),
          ),
        ),
      )),
    );
  }
}
