import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';

import 'package:flipper_ui/system_tray/system_tray_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:window_manager/window_manager.dart';

import '../models/notification.dart';
import '../notification_manager.dart';
import 'base_notifications.dart';

/// Windows-specific notification implementation
class WindowsNotifications extends BaseNotifications {
  WindowsNotifications(super.notificationsPlugin);

  @override
  Future<void> initialize() async {
    await super.initialize();

    final localTimeZoneName = tz.local.name;
    final windowsInitializationSettings = WindowsInitializationSettings(
        appName: "flipper",
        appUserModelId: localTimeZoneName,
        guid: "0E6A8A0A-B5A6-4E0B-A9B8-D1D5D0D3D4D5");

    final initializationSettings = InitializationSettings(
      android: null,
      iOS: null,
      macOS: null,
      linux: null,
      windows: windowsInitializationSettings,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundCallback,
      onDidReceiveNotificationResponse: notificationCallback,
    );
  }

  @override
  Future<bool?> requestPermission() async {
    // Windows doesn't need explicit permission requests
    permissionGranted = true;
    return permissionGranted;
  }

  @override
  Future<void> scheduleNotification(Conversation conversation) async {
    final createdAt = conversation.createdAt ?? DateTime.now().toLocal();
    final String? dueDateFormatted;

    final iConversation = IConversation(
        id: conversation.id,
        body: conversation.body ?? "",
        createdAt: conversation.createdAt,
        userName: conversation.userName ?? "");

    dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final notification = Notification(
      id: conversation.id.toString().codeUnitAt(0),
      title: iConversation.body,
      body: dueDateFormatted,
      payload: jsonEncode(iConversation),
    );

    await _scheduleNotificationWindows(notification);
  }

  Future<void> _scheduleNotificationWindows(Notification notification) async {
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

    final timer = Timer(
      createdAt.difference(DateTime.now()),
      () async {
        await showNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
        );
      },
    );

    timers[conversation.id.toString()] = timer;
  }

  @override
  Future<void> scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Windows uses timers for scheduling, which is handled in _scheduleNotificationWindows
    throw UnimplementedError('Windows uses timers for scheduling');
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
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  @override
  Future<void> setNotificationBadge(int count) async {
    await _setNotificationBadgeWindowsTaskbar(count);
    await _setNotificationBadgeWindowsSystemTray(count);
  }

  Future<void> _setNotificationBadgeWindowsTaskbar(int count) async {
    final icon = (count > 0)
        ? 'assets/icons/windows_with_badge.ico'
        : 'assets/icons/windows.ico';

    await windowManager.setIcon(icon);
  }

  Future<void> _setNotificationBadgeWindowsSystemTray(int count) async {
    final icon = (count > 0)
        ? 'assets/icons/windows_with_badge.ico'
        : 'assets/icons/windows.ico';

    await SystemTrayManager.instance.setIcon(icon);
  }

  @override
  NotificationDetails createPlatformNotificationDetails() {
    return const NotificationDetails(
      windows: WindowsNotificationDetails(),
    );
  }
}
