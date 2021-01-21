library subscription;

import 'package:flutter/material.dart';

class SubscribeClient extends StatefulWidget {
  SubscribeClient({Key key}) : super(key: key);

  @override
  _SubscribeClientState createState() => _SubscribeClientState();
}

class _SubscribeClientState extends State<SubscribeClient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Subscribe to montly subs"),
    );
  }
}
