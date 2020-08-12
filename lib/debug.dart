import 'package:flutter/material.dart';

class Debug extends StatefulWidget {
  Debug({Key key}) : super(key: key);

  @override
  _DebugState createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(child: Container(child: Text("66"),)),
    );
  }
}