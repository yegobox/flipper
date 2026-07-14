import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_manager.dart';
import 'utils/notification_utils.dart';

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
        } else if (payload['type'] == 'delegation') {
          await _openDelegationsDashboard();
        }
      } catch (e) {
        // If parsing fails, just log the error and continue
        talker.error('Error parsing notification payload: $e');
      }
    }
  }

  /// Show a notification for a new incoming order
  Future<void> showOrderNotification(InventoryRequest order) async {
    await NotificationManager.instance.showOrderNotification(order);
  }

  /// Show a notification for a new print delegation.
  ///
  /// Always fires [DelegationReceivedEvent] for an in-app banner (visible while
  /// Flipper is focused). Also attempts an OS notification for background use.
  Future<void> showDelegationNotification(
    TransactionDelegation delegation,
  ) async {
    final title = 'New Print Delegation';
    final body = NotificationUtils.formatDelegationBody(delegation);

    EventBus().fire(
      DelegationReceivedEvent(
        transactionId: delegation.transactionId,
        title: title,
        body: body,
      ),
    );

    try {
      await NotificationManager.instance.requestPermission();
      await NotificationManager.instance.showDelegationNotification(delegation);
      talker.info(
        '[delegation-notify] OS notification shown for '
        '${delegation.transactionId}',
      );
    } catch (e, stackTrace) {
      talker.error(
        '[delegation-notify] OS notification failed for '
        '${delegation.transactionId}: $e',
        stackTrace,
      );
    }
  }

  /// Source or destination alert for a completed / incoming branch stock transfer.
  ///
  /// Fires [StockTransferNotificationEvent] (in-app banner on desktop + mobile)
  /// and shows an OS local notification via [NotificationManager].
  Future<void> showStockTransferNotification({
    required String requestId,
    required String title,
    required String body,
  }) async {
    EventBus().fire(
      StockTransferNotificationEvent(
        requestId: requestId,
        title: title,
        body: body,
      ),
    );

    try {
      await NotificationManager.instance.requestPermission();
      await NotificationManager.instance.showNotification(
        id: requestId.hashCode,
        title: title,
        body: body,
        payload: jsonEncode({
          'type': 'inventory_request',
          'id': requestId,
        }),
      );
      // Also go through the Conversation path used elsewhere in the app.
      await ProxyService.notification.sendLocalNotification(body: '$title: $body');
      talker.info('[transfer-notify] shown for $requestId');
    } catch (e, stackTrace) {
      talker.error(
        '[transfer-notify] OS notification failed for $requestId: $e',
        stackTrace,
      );
    }
  }

  Future<void> _openDelegationsDashboard() async {
    const page = 'delegations';
    await ProxyService.box.writeString(
      key: kPendingDashboardPageKey,
      value: page,
    );
    EventBus().fire(const OpenDashboardPageEvent(page));

    try {
      final currentName = _routerService.router.current.name;
      if (currentName != FlipperAppRoute.name) {
        await _routerService.navigateTo(const FlipperAppRoute());
      }
    } catch (e) {
      talker.error('Error navigating to delegations dashboard: $e');
    }
  }
}
