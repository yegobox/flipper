import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final List<AppNotification> notifications;
  final Function(String) onAcknowledge;
  final Function() onClearAll;

  NotificationWidget({
    required this.notifications,
    required this.onAcknowledge,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return SizedBox.shrink();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotifications(context);
    });

    return SizedBox.shrink();
  }

  void _showNotifications(BuildContext context) {
    final notificationWidgets = notifications.map((notification) {
      return SnackBar(
        content: Container(
          width: 300.0, // Define the width here
          child: Text(notification.message ?? 'New Notification'),
        ),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            onAcknowledge(notification.id.toString());
            ProxyService.local.localRealm!.write(() {
              notification.completed = true;
            });
          },
        ),
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      );
    }).toList();

    if (notificationWidgets.length > 1) {
      notificationWidgets.add(
        SnackBar(
          content: Container(
            width: 300.0,
            child: Text('Clear all notifications?'),
          ),
          action: SnackBarAction(
            label: 'Clear All',
            onPressed: onClearAll,
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    for (final snackBar in notificationWidgets.reversed) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
