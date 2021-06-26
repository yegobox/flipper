import 'package:flutter/material.dart';

extension TextEditingControllerExtensions on TextEditingController {
  void safeClear() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.clear();
    });
  }
}
