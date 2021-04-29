library flipper_dashboard;

import 'package:flutter/material.dart';

class LoaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      key: Key('loaderView'),
      child: Text('hello loader'),
    ));
  }
}
