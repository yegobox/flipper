import 'package:flutter/material.dart';

class CenterDivider extends StatefulWidget {
  const CenterDivider({Key? key, required this.width}) : super(key: key);
  final double width;

  @override
  _CenterDividerState createState() => _CenterDividerState();
}

class _CenterDividerState extends State<CenterDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 0,
      child: const Divider(),
    );
  }
}
