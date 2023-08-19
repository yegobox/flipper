import 'package:flutter/material.dart';

class ListDivider extends StatefulWidget {
  const ListDivider({Key? key, required this.height}) : super(key: key);

  @override
  _ListDividerState createState() => _ListDividerState();
  final double height;
}

class _ListDividerState extends State<ListDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
    );
  }
}
