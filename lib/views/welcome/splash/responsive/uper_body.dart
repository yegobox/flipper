import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

class UperBody extends StatelessWidget {
  const UperBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#955be9'),
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Colors.white.withOpacity(1.0),
            ),
            margin: const EdgeInsets.only(top: 120),
            child: Image.asset('assets/graphics/icon.png'),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(
                'Flipper',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  'Interact and  grow your business .',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
