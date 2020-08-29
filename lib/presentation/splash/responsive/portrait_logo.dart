import 'package:flipper/generated/l10n.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';

class PortraitLogo extends StatefulWidget {
  PortraitLogo({Key key}) : super(key: key);

  @override
  _PortraitLogoState createState() => _PortraitLogoState();
}

class _PortraitLogoState extends State<PortraitLogo> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 2,
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
                'Flipper',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
            const Text(
              'Interact and  grow your business',
              style:  TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
