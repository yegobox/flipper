import 'package:flutter/material.dart';
import 'package:flipper_overlay/flipper_overlay.dart';

class FlipperDialogs {
  static showSuccessDialog(BuildContext context, String type, String message) {
    showSimpleNotification(
      Text(message),
      background: Colors.green,
      position: NotificationPosition.top,
    );
  }

  static showErrorDialog(BuildContext context, String type, String message) {
    showSimpleNotification(
      Text(message),
      background: Colors.red,
      position: NotificationPosition.top,
    );
  }
}
