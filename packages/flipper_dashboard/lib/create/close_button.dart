import 'package:flutter/material.dart';

class BuildCloseButton extends StatefulWidget {
  const BuildCloseButton({Key? key}) : super(key: key);

  @override
  _BuildCloseButtonState createState() => _BuildCloseButtonState();
}

class _BuildCloseButtonState extends State<BuildCloseButton> {
  @override
  Widget build(BuildContext context) {
    return const IconButton(
        alignment: Alignment.topLeft,
        icon: Icon(Icons.close),
        color: Colors.white,
        onPressed: null);
  }
}
