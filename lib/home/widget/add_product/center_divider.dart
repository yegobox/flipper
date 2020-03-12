import 'package:flutter/material.dart';

class CenterDivider extends StatefulWidget {
  CenterDivider({Key key, this.width}) : super(key: key);
  final double width;

  @override
  _CenterDividerState createState() => _CenterDividerState();
}

class _CenterDividerState extends State<CenterDivider> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        child: Divider(
          color: Colors.black,
        ),
      ),
    );
  }
}
