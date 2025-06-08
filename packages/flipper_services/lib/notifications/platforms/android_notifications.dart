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
    // First call the parent initialization
    await super.initialize();

    // Use a microtask to slightly defer initialization to allow UI to render first
    await Future<void>.microtask(() async {
      // Use the launcher icon for notifications
      const initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final initSettings = InitializationSettings(
        android: initSettingsAndroid,
      );

      // Initialize with a timeout to prevent blocking the main thread too long
      await notificationsPlugin
          .initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse:
            notificationBackgroundCallback,
        onDidReceiveNotificationResponse: notificationCallback,
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Log timeout but don't crash - we'll retry permission later when needed
          print('Notification initialization timed out');
          return;
        },
      );
    });
  }

  @override
  Future<bool?> requestPermission() async {
    // Wrap in a microtask to prevent blocking the UI thread
    return await Future<bool?>.microtask(() async {
      final androidPlugin =
          notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin == null) return false;

      try {
        // Add timeout to prevent indefinite waiting
        permissionGranted = await androidPlugin
                .requestNotificationsPermission()
                .timeout(const Duration(seconds: 3), onTimeout: () => false) ??
            false;
        return permissionGranted;
      } catch (e) {
        print('Error requesting notification permission: $e');
        return false;
      }
    });
  }

  @override
  Future<void> scheduleNotification(Conversation conversation) async {
    // Check permission first, but don't block if it fails
    final hasPermission = await requestPermission();
    if (hasPermission != true) {
      print('Notification permission not granted');
      return;
    }

    // Prepare notification data - this could be moved to a compute function
    // for very heavy processing if needed
    await Future<void>.microtask(() async {
      try {
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
      } catch (e) {
        print('Error scheduling notification: $e');
      }
    });
  }

  Future<void> _scheduleNotificationMobile(Notification notification) async {
    // Use a microtask to prevent blocking the main thread
    await Future<void>.microtask(() async {
      try {
        final conversation =
            IConversation.fromJson(jsonDecode(notification.payload!));

        final createdAt = conversation.createdAt;
        if (createdAt == null) {
          return;
        }

        if (createdAt.isBefore(DateTime.now())) {
          // For past dates, show immediately
          await showNotification(
            id: notification.id,
            title: notification.title,
            body: notification.body,
            payload: notification.payload,
          );
        } else {
          // For future dates, schedule
          await scheduleNotificationWithSystem(
            id: notification.id,
            title: notification.title,
            body: notification.body,
            scheduledDate: createdAt,
            payload: notification.payload,
          );
        }
      } catch (e) {
        print('Error in _scheduleNotificationMobile: $e');
      }
    });
  }

  @override
  Future<void> scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Use a microtask to prevent blocking the main thread
    await Future<void>.microtask(() async {
      try {
        final notificationDetails = createPlatformNotificationDetails();

        await notificationsPlugin
            .zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        )
            .timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            print('Scheduling notification timed out');
            return;
          },
        );
      } catch (e) {
        print('Error scheduling notification with system: $e');
      }
    });
  }

  @override
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Check permission but don't block if it fails
    final hasPermission = await requestPermission();
    if (hasPermission != true) {
      print('Notification permission not granted');
      return;
    }

    // Use a microtask to prevent blocking the main thread
    await Future<void>.microtask(() async {
      try {
        final notificationDetails = const NotificationDetails(
          android: androidNotificationDetails,
        );

        // Generate a unique ID if none provided
        final notificationId =
            id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

        await notificationsPlugin
            .show(
          notificationId,
          title,
          body,
          notificationDetails,
          payload: payload,
        )
            .timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            print('Showing notification timed out');
            return;
          },
        );
      } catch (e) {
        print('Error showing notification: $e');
      }
    });
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
