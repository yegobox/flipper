import 'package:apptheme/HexColor.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flutter/material.dart';

class LandscapeLogo extends StatefulWidget {
  LandscapeLogo({Key key}) : super(key: key);

  @override
  _LandscapeLogoState createState() => _LandscapeLogoState();
}

class _LandscapeLogoState extends State<LandscapeLogo> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          color: HexColor('#955be9'),
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
              ),
              Container(
                height: 60,
                child: Image.asset('assets/graphics/logo.png'),
              ),
              Container(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'B',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              Text(
                S.of(context).interactandgrowyourbusiness,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      );
  }
}