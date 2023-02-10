import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

abstract class LNotification {
  void localNotification(int id, String title, String body, TZDateTime? date);
}

class UnSupportedLocalNotification implements LNotification {
  @override
  void localNotification(int id, String title, String body, TZDateTime? date) {
    // TODO: implement localNotification
  }
}

class LocalNotificationService implements LNotification {
  @override
  void localNotification(int id, String title, String body, TZDateTime? date) {
    if (date == null) {
      return;
    }
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'flipper.rw',
      'Tasks',
      priority: Priority.max,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      date,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'notlification-payload',
    );
  }
}
