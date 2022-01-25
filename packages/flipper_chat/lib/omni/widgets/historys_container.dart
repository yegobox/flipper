import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HistorysContainer extends StatelessWidget {
  HistorysContainer({
    Key? key,
    required this.index,
    required this.pageNotifier,
    required this.child,
  }) : super(key: key);
  final int index;
  final double pageNotifier;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool isLeaving = (index - pageNotifier) <= 0;
    double t = (index - pageNotifier);
    double rotationY = lerpDouble(0, 90, t)!;
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    final degToRad = rotationY * (math.pi / 180.0);
    transform.rotateY(-degToRad);
    return Transform(
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: child,
    );
  }
}
