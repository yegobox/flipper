library flipper_login;

import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final VoidCallback onPress;
  ButtonView(this.text, this.onPress, this.textColor, this.buttonColor);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          color: buttonColor,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
