import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LNotification {
  void initialize();
  void display(RemoteMessage message);
  Future<void> saveTokenToDatabase(String token);
}

class UnSupportedLocalNotification implements LNotification {
  @override
  void display(RemoteMessage message) {
    // TODO: implement display
  }

  @override
  void initialize() {
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final log = getLogger('LocalNotificationService');
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
  Future<void> initialize() async {
    log.i('getting token');
    // get permission
    // getting permission on android does not matter!
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await FirebaseMessaging.instance.getToken();
    ProxyService.firestore.saveTokenToDatabase(token!);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        // Navigator.of(context).pushNamed(route);
      }
    });
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {}
}
