import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:timezone/timezone.dart' as tz;

final isWindows = UniversalPlatform.isWindows;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

abstract class LNotification {
  void localNotification(int id, String title, String body, DateTime? date);
}

class UnSupportedLocalNotification implements LNotification {
  @override
  void localNotification(int id, String title, String body, DateTime? date) {
    // TODO: implement localNotification
  }
}

class LocalNotificationService implements LNotification {
  @override
  void localNotification(int id, String title, String body, DateTime? date) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'flipper.rw',
      'Tasks',
      priority: Priority.max,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    var scheduledTime = tz.TZDateTime.from(date!, tz.local);
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'notlification-payload',
    );
  }
}
