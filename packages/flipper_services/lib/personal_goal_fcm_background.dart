import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:flipper_services/notifications/notification_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// FCM [type] for personal-goal credits (server must send this data payload).
const String kPersonalGoalContributionFcmType = 'personal_goal_contribution';

/// Handles FCM while the app is backgrounded or terminated (data message with
/// notification payload or `body` in data). Requires your backend to send FCM
/// to the device or business topic when a goal is credited.
@pragma('vm:entry-point')
Future<void> handlePersonalGoalFcmBackgroundMessage(RemoteMessage message) async {
  final type = message.data['type']?.toString();
  if (type != kPersonalGoalContributionFcmType) return;

  final sourceKey = message.data['sourceDeviceKey']?.toString();
  if (sourceKey != null && sourceKey.isNotEmpty) {
    final localKey = await personalGoalContributionDeviceKey();
    if (localKey.isNotEmpty && localKey == sourceKey) return;
  }

  final body = message.notification?.body ??
      message.data['body']?.toString() ??
      message.data['message']?.toString();
  if (body == null || body.isEmpty) return;

  try {
    await NotificationManager.create(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
    await NotificationManager.instance.showNotification(
      title: 'Personal goal',
      body: body,
    );
  } catch (_) {
    // Plugin may already be initialized in process.
    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Personal goal',
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            kPackageId,
            'App notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (_) {}
  }
}
