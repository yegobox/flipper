import 'package:flutter/material.dart';
import 'package:trellocards/kds.dart';

void main() => runApp(KDSStandalone());

class KDSStandalone extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KDS(),
    );
  }
}

// Understanding drap and drop before working on a feature.
// https://medium.com/flutter-community/a-deep-dive-into-draggable-and-dragtarget-in-flutter-487919f6f1e4
// https://docs.flutter.dev/cookbook/effects/drag-a-widget
