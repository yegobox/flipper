library flipper_top;

import 'package:flutter/material.dart';

import './logo_view.dart';
import './text_view.dart';

class TopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.purpleAccent[400],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoView(),
              Container(
                padding: EdgeInsets.all(20),
                child: TextView('Flipper', 32),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextView('Interact and grow your business', 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
