import 'package:flutter/material.dart';
import 'dart:math';

class DeviceType {
  static String getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final diagonalSize = sqrt(
      (screenWidth * screenWidth) + (screenHeight * screenHeight),
    );

    const thresholdPhone = 700.0;
    const thresholdPhablet = 1100.0;
    const thresholdTablet = 1500.0;

    if (diagonalSize < thresholdPhone) {
      return 'Phone';
    } else if (diagonalSize < thresholdPhablet) {
      return 'Phablet';
    } else if (diagonalSize < thresholdTablet) {
      return 'Tablet';
    } else {
      return 'Larger Device';
    }
  }
}
