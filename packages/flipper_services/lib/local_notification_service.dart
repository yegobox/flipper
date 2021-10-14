import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LNotification {
  void initialize();
  void display(RemoteMessage message);
  Future<void> saveTokenToDatabase(String token);
  void listen();
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

  @override
  void listen() {
    // TODO: implement listen
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
        "flipper",
        "channel",
        "channel",
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

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      log.i(route);
      if (route != null) {
        switch (route) {
          case 'message':
            ProxyService.box.write(key: pageKey, value: 'social');
            ProxyService.nav.navigateTo(Routes.chat);
            break;
          default:
            log.i('routes point to nowhere!');
        }
      }
    });
    int businessId = await ProxyService.box.read(key: 'businessId');
    String userId = ProxyService.box.read(key: 'userId');

    /// subscribe to general notification
    await FirebaseMessaging.instance.subscribeToTopic('all');

    /// only notification for this specific user
    await FirebaseMessaging.instance.subscribeToTopic(userId);

    /// use firebase authId to subscribe to message send to user.
    User? user = await ProxyService.auth.getCurrentUserId();

    await FirebaseMessaging.instance.subscribeToTopic(user!.uid);

    await FirebaseMessaging.instance.subscribeToTopic(businessId.toString());
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {}

  @override
  void listen() {
    if (!isWindows) {
      ///gives you the message on which user taps
      ///and it opened the app from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // final routeFromMessage = message.data["route"];
          handleTheMessage(message);
        }
      });

      ///forground work
      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          handleTheMessage(message);
        }
      });

      ///When the app is in background but opened and user taps
      ///on the notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        if (message.data["route"] != null) {
          handleTheMessage(message);
        }
      });
    }
  }

  void handleTheMessage(RemoteMessage message) {
    // log.i(message.data);
    // log.i(message.notification!.body);
    // log.i(message.notification!.title);
    display(message);
  }
}
