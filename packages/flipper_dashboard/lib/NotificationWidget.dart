import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final List<AppNotification> notifications;
  final Function(String) onAcknowledge;

  NotificationWidget({
    required this.notifications,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    // Only show the most recent notification in the snackbar
    if (notifications.isNotEmpty) {
      final latestNotification = notifications.last;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(latestNotification.message ?? 'New Notification'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                onAcknowledge(latestNotification.id.toString());
              },
            ),
          ),
        );
      });
    }

    // Return an empty container since the snackbar is handled by ScaffoldMessenger
    return SizedBox.shrink();
  }
}
