library flipper_text;

import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String text;
  final double size;
  TextView(this.text, this.size);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
      ),
    );
  }
}
