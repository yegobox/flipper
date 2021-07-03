import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LNotification {
  void initialize(BuildContext context);
  void display(RemoteMessage message);
  Future<void> saveTokenToDatabase(String token);
}

class UnSupportedLocalNotification implements LNotification {
  @override
  void display(RemoteMessage message) {
    // TODO: implement display
  }

  @override
  void initialize(BuildContext context) {
    // TODO: implement initialize
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {
    // TODO: implement saveTokenToDatabase
    // throw UnimplementedError();
  }
}

class LocalNotificationService implements LNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "easyapproach",
        "easyapproach channel",
        "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        // Navigator.of(context).pushNamed(route);
      }

      String? token = await FirebaseMessaging.instance.getToken();
      ProxyService.firestore.saveTokenToDatabase(token!);
    });
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {}
}
