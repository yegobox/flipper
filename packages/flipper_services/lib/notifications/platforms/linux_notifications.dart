import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/system_tray/system_tray_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:launcher_entry/launcher_entry.dart';

import '../models/notification.dart';
import '../notification_manager.dart';
import 'base_notifications.dart';

/// Linux-specific notification implementation
class LinuxNotifications extends BaseNotifications {
  static const linuxNotificationDetails = LinuxNotificationDetails(
    actions: [
      LinuxNotificationAction(
        key: 'complete',
        label: 'Complete',
      ),
      LinuxNotificationAction(
        key: 'snooze',
        label: 'Snooze',
      ),
    ],
    defaultActionName: 'Open notification',
    urgency: LinuxNotificationUrgency.critical,
  );

  LinuxNotifications(super.notificationsPlugin);

  @override
  Future<void> initialize() async {
    await super.initialize();

    final initSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon(AppIcons.linux),
    );

    final initSettings = InitializationSettings(
      linux: initSettingsLinux,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse:
          notificationBackgroundCallback,
      onDidReceiveNotificationResponse: notificationCallback,
    );
  }

  @override
  Future<bool?> requestPermission() async {
    // Linux doesn't need explicit permission requests
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

    await _scheduleNotificationDesktop(notification);
  }

  Future<void> _scheduleNotificationDesktop(Notification notification) async {
    final task = IConversation.fromJson(jsonDecode(notification.payload!));

    final dueDate = task.createdAt;
    if (dueDate == null) {
      return;
    }

    if (dueDate.isBefore(DateTime.now())) {
      await showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
      );
      return;
    }

    final timer = Timer(
      dueDate.difference(DateTime.now()),
      () async {
        await showNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
        );
      },
    );

    timers[task.id.toString()] = timer;
  }

  @override
  Future<void> scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Linux uses timers for scheduling, which is handled in _scheduleNotificationDesktop
    throw UnimplementedError('Linux uses timers for scheduling');
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
    await _setNotificationBadgeLinuxTaskbar(count);
    await _setNotificationBadgeLinuxSystemTray(count);
  }

  Future<void> _setNotificationBadgeLinuxTaskbar(int count) async {
    final service = LauncherEntryService(
      appUri: 'application://$kPackageId.desktop',
    );
    await service.update(count: count, countVisible: true);
  }

  Future<void> _setNotificationBadgeLinuxSystemTray(int count) async {
    final icon = (count > 0)
        ? AppIcons.linuxSymbolicWithNotificationBadge
        : AppIcons.linuxSymbolic;

    await SystemTrayManager.instance.setIcon(icon);
  }

  @override
  NotificationDetails createPlatformNotificationDetails() {
    return const NotificationDetails(
      linux: linuxNotificationDetails,
    );
  }
}
