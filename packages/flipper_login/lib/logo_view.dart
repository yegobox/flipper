library flipper_logo;

import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.purpleAccent,
        child: Text(
          'F',
          style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontFamily: 'Arial, Helvetica, sans-serif',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
