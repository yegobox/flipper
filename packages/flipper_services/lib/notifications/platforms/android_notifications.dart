import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/notification.dart';
import '../notification_manager.dart';
import 'base_notifications.dart';

/// Android-specific notification implementation
class AndroidNotifications extends BaseNotifications {
  static const androidNotificationDetails = AndroidNotificationDetails(
    kPackageId,
    'App notifications',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: DefaultStyleInformation(true, true),
  );

  AndroidNotifications(super.notificationsPlugin);

  @override
  Future<void> initialize() async {
    await super.initialize();
    
    const initSettingsAndroid = AndroidInitializationSettings('app_icon');
    
    final initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundCallback,
      onDidReceiveNotificationResponse: notificationCallback,
    );
  }

  @override
  Future<bool?> requestPermission() async {
    final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    permissionGranted = await androidPlugin.requestNotificationsPermission() ?? false;
    return permissionGranted;
  }

  @override
  Future<void> scheduleNotification(Conversation conversation) async {
    if (!(await requestPermission())!) {
      return;
    }

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

    await _scheduleNotificationMobile(notification);
  }

  Future<void> _scheduleNotificationMobile(Notification notification) async {
    final conversation = IConversation.fromJson(jsonDecode(notification.payload!));

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
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
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
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  @override
  Future<void> setNotificationBadge(int count) async {
    // Android doesn't need special badge handling
  }

  @override
  NotificationDetails createPlatformNotificationDetails() {
    return const NotificationDetails(
      android: androidNotificationDetails,
    );
  }
}
