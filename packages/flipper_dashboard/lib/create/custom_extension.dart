import 'package:flutter/material.dart';

extension TextEditingControllerExtensions on TextEditingController {
  void safeClear() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.clear();
    });
  }
}

extension StringExtension on String {
  String toLower() {
    return this.toLowerCase();
  }
}
