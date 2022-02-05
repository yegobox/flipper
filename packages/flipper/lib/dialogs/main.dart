import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class FlipperDialogs {
  static showSuccessDialog(BuildContext, String type, String message) {
    showSimpleNotification(
      Text(message),
      background: Colors.green,
      position: NotificationPosition.top,
    );
  }

  static showErrorDialog(BuildContext, String type, String message) {
    showSimpleNotification(
      Text(message),
      background: Colors.red,
      position: NotificationPosition.top,
    );
  }
}
