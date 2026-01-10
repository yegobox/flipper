import 'package:flutter/material.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

mixin SnackBarMixin {
  void showCustomSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    NotificationType? type,
  }) {
    showCustomSnackBarUtil(
      context,
      message,
      backgroundColor: backgroundColor,
      type: type ?? NotificationType.success,
    );
  }
}
