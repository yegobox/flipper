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
        child: OutlinedButton(
          onPressed: onPress,
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith<OutlinedBorder?>((states) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10));
            }),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) return buttonColor;
              return buttonColor; // Defer to the widget's default.
            }),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
