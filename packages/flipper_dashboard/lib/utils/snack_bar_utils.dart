import 'package:flutter/material.dart';

/// Shows a custom SnackBar with consistent styling.
void showCustomSnackBarUtil(
  BuildContext context,
  String message, {
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.only(
        left: 350.0,
        right: 350.0,
        bottom: 20.0,
      ),
      content: Text(message),
      backgroundColor: backgroundColor ?? Colors.green[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
