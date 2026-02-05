import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../interfaces/notification_interface.dart';

/// Base implementation of notification functionality shared across platforms
abstract class BaseNotifications implements NotificationInterface {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final Map<String, Timer> timers = {};
  bool permissionGranted = false;

  BaseNotifications(this.notificationsPlugin);

  @override
  Future<void> initialize() async {
    tz.initializeTimeZones();
    final localTimeZoneName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(localTimeZoneName));

    // Platform-specific initialization will be implemented in subclasses
  }

  @override
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  @override
  Future<void> showOrderNotification(InventoryRequest order) async {
    final payload = jsonEncode({
      'type': 'inventory_request',
      'id': order.id,
      'branchId': order.branchId,
      'mainBranchId': order.mainBranchId,
      'subBranchId': order.subBranchId,
    });

    String requesterInfo = "Unknown";
    if (order.branch != null && order.branch!.name != null) {
      requesterInfo = order.branch!.name!;
    } else if (order.subBranchId != null) {
      requesterInfo = "Branch ${order.subBranchId}";
    }

    await showNotification(
      id: order.id.hashCode,
      title: 'New Order Request',
      body: 'You have a new order request from $requesterInfo',
      payload: payload,
    );
  }

  @override
  Future<void> snoozeTask(Conversation task) async {
    await cancelNotification(task.id.toString().codeUnitAt(0));
  }

  /// Generate a random notification ID
  int generateNotificationId() {
    return Random().nextInt(1 << 30);
  }

  /// Schedule a notification with the system
  Future<void> scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // This will be implemented by platform-specific subclasses
    throw UnimplementedError('Must be implemented by subclasses');
  }

  /// Create notification details for the current platform
  NotificationDetails createPlatformNotificationDetails();
}
