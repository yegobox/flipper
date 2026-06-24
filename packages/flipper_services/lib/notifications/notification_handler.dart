import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_manager.dart';

/// Service to handle notification responses and route appropriately
class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  RouterService get _routerService => locator<RouterService>();

  /// Initialize the notification handler to listen for notification taps
  void initialize() {
    // Listen to the notification response stream
    notificationResponseStream.stream.listen(_handleNotificationResponse);
  }

  /// Handle notification response when user taps on a notification
  void _handleNotificationResponse(NotificationResponse response) async {
    if (response.payload != null) {
      try {
        // Parse the payload to determine the type of notification
        final payload = jsonDecode(response.payload!);

        // Check if this is an order notification
        if (payload['type'] == 'inventory_request') {
          // Navigate to the inventory request view
          _routerService.navigateTo(const InventoryRequestMobileViewRoute());
        }
      } catch (e) {
        // If parsing fails, just log the error and continue
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Show a notification for a new incoming order
  Future<void> showOrderNotification(InventoryRequest order) async {
    await NotificationManager.instance.showOrderNotification(order);
  }
}
