import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
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
    final body = _delegationBody(delegation);

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

  String _delegationBody(TransactionDelegation delegation) {
    final amount = NumberFormat('#,##0', 'en_US').format(delegation.subTotal);
    final customerName = delegation.customerName?.trim();
    final fromDevice = delegation.delegatedFromDevice;

    if (customerName != null && customerName.isNotEmpty) {
      return '${delegation.receiptType} receipt for $customerName · '
          'RWF $amount · from $fromDevice';
    }
    return '${delegation.receiptType} receipt · RWF $amount · from $fromDevice';
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
