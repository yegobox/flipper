import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

abstract class LNotification {
  Future<void> sendLocalNotification(
      {required int id,
      required String title,
      required String body,
      required TZDateTime? date,
      Conversation? payload});
}

class UnSupportedLocalNotification implements LNotification {
  @override
  Future<void> sendLocalNotification(
      {required int id,
      required String title,
      required String body,
      required TZDateTime? date,
      Conversation? payload}) {
    throw UnimplementedError();
  }
}

class LocalNotificationService implements LNotification {
  @override
  Future<void> sendLocalNotification(
      {required int id,
      required String title,
      required String body,
      required TZDateTime? date,
      Conversation? payload}) async {
    if (date == null) {
      return;
    }
    if (payload != null) {
      await ProxyService.isarApi.create(data: payload);
      // do something with payloadId
      print('Received a new message in payload: ${payload.body}');
      Conversation? localConversation = await ProxyService.isarApi
          .getConversation(messageId: payload.messageId!);
      if (localConversation == null) {
        await ProxyService.isarApi.create(data: payload);
      }
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
      payload: payload != null ? payload.messageId : null,
    );
  }
}
