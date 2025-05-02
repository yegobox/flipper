import 'package:flutter/material.dart';
import 'utils/snack_bar_utils.dart';

mixin SnackBarMixin {
  void showCustomSnackBar(BuildContext context, String message,
      {Color? backgroundColor}) {
    showCustomSnackBarUtil(context, message, backgroundColor: backgroundColor);
  }
}
