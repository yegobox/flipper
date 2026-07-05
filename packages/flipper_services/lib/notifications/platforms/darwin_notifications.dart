import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide RepeatInterval;
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/notification.dart';
import '../notification_manager.dart';
import 'base_notifications.dart';

/// iOS and macOS (Darwin) specific notification implementation
class DarwinNotifications extends BaseNotifications {
  static const darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  DarwinNotifications(super.notificationsPlugin);

  @override
  Future<void> initialize() async {
    await super.initialize();

    const initSettingsDarwin = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      iOS: initSettingsDarwin,
      macOS: initSettingsDarwin,
    );

    await notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundCallback,
      onDidReceiveNotificationResponse: notificationCallback,
    );
  }

  @override
  Future<bool?> requestPermission() async {
    // macOS/iOS require explicit UNUserNotificationCenter authorization;
    // without it show() silently does nothing.
    final macOS = notificationsPlugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();
    if (macOS != null) {
      permissionGranted = await macOS.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      return permissionGranted;
    }

    final iOS = notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iOS != null) {
      permissionGranted = await iOS.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      return permissionGranted;
    }

    permissionGranted = true;
    return permissionGranted;
  }

  @override
  Future<void> scheduleNotification(Conversation conversation) async {
    final createdAt = conversation.createdAt ?? DateTime.now().toLocal();
    final String? dueDateFormatted;

    final iConversation = IConversation(
        id: conversation.id,
        body: conversation.title,
        createdAt: conversation.createdAt,
        userName: conversation.title);

    dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final notification = Notification(
      id: conversation.id.toString().codeUnitAt(0),
      title: iConversation.body,
      body: dueDateFormatted,
      payload: jsonEncode(iConversation),
    );

    await _scheduleNotificationDarwin(notification);
  }

  Future<void> _scheduleNotificationDarwin(Notification notification) async {
    final conversation =
        IConversation.fromJson(jsonDecode(notification.payload!));

    final createdAt = conversation.createdAt;
    if (createdAt == null) {
      return;
    }

    if (createdAt.isBefore(DateTime.now())) {
      await showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
      );
      return;
    }

    await scheduleNotificationWithSystem(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: createdAt,
      payload: notification.payload,
    );
  }

  @override
  Future<void> scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final notificationDetails = createPlatformNotificationDetails();

    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  @override
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    id ??= generateNotificationId();
    final notificationDetails = createPlatformNotificationDetails();

    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  @override
  Future<void> setNotificationBadge(int count) async {
    // iOS and macOS handle badges through the notification details
    // No additional action needed
  }

  @override
  NotificationDetails createPlatformNotificationDetails() {
    return const NotificationDetails(
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
  }

  @override
  Future<void> showOrderNotification(InventoryRequest order) async {
    // Use the base implementation from BaseNotifications
    await super.showOrderNotification(order);
  }

  @override
  Future<void> showDelegationNotification(
    TransactionDelegation delegation,
  ) async {
    await super.showDelegationNotification(delegation);
  }
}
