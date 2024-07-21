import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';

class NotificationWidget extends StatefulWidget {
  final List<AppNotification> notifications;
  final Function(int) onAcknowledge;
  final Function() onClearAll;

  const NotificationWidget({
    Key? key,
    required this.notifications,
    required this.onAcknowledge,
    required this.onClearAll,
  }) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showNotifications(context));

    // Check for empty notifications in the build method
    if (widget.notifications.isEmpty) {
      return const SizedBox.shrink(); // Don't render anything if empty
    }

    // Render the notification content if there are notifications
    return const SizedBox.shrink(); // Placeholder for the snackbar to be added.
  }

  void _showNotifications(BuildContext context) {
    if (widget.notifications.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return;
    }

    final notificationWidget = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: _buildNotificationContent(context),
      duration: const Duration(days: 1),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(notificationWidget);
  }

  Widget _buildNotificationContent(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, setState),
              if (_expanded) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Colors.grey[300]),
                ),
                _buildNotificationList(context, setState),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, StateSetter setState) {
    final notificationCount = widget.notifications.length;
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  '$notificationCount ${notificationCount == 1 ? 'Notification' : 'Notifications'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _handleClearAll,
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, StateSetter setState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          final notification = widget.notifications[index];
          return ListTile(
            title: Text(
              notification.message ?? 'New Notification',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () =>
                  _handleAcknowledge(notification, index, setState),
            ),
          );
        },
      ),
    );
  }

  void _handleClearAll() {
    setState(() {
      for (var notification in widget.notifications) {
        notification.completed = true;
        widget.onAcknowledge(notification.id!);
      }
      widget.notifications.clear();
    });
    widget.onClearAll();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _handleAcknowledge(
      AppNotification notification, int index, StateSetter setState) {
    widget.onAcknowledge(notification.id!);
    setState(() {
      widget.notifications.removeAt(index);
    });

    // Update the state to hide the parent snackbar if all notifications are cleared
    if (widget.notifications.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } else {
      _showNotifications(context);
    }
  }
}
