import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_rw/bottom_sheets/activate_subscription.dart';
import 'package:flipper_rw/bottom_sheets/subscription_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flipper_dashboard/bottom_sheet.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:universal_platform/universal_platform.dart';

final isWindows = UniversalPlatform.isWindows;

abstract class LNotification {
  void initialize(BuildContext context);
  void display(RemoteMessage message);
  Future<void> saveTokenToDatabase(String token);
  void listen(BuildContext context);
  void onDidReceiveLocalNotification(
      int id, String title, String body, Map<String, String> payload);
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

  @override
  void listen(BuildContext context) {
    // TODO: implement listen
  }

  @override
  void onDidReceiveLocalNotification(
      int id, String title, String body, Map<String, String> payload) {
    // TODO: implement onDidReceiveLocalNotification
  }
}

class LocalNotificationService implements LNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final log = getLogger('LocalNotificationService');
  final NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
    "flipper",
    "channel",
    // icon: "ic_launcher",
    importance: Importance.max,
    priority: Priority.high,
  ));

  @override
  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      String action = message.data['route'] + '_' + message.data['id'];

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: action,
      );
    } on Exception catch (e) {}
  }

  @override
  Future<void> initialize(BuildContext context) async {
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

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? id) async {
      if (id != null) {
        // split  id based on '_'
        final List<String> split = id.split('_');
        final String action = split[0];
        final String Id = split[1];
        await navigationLogic(action, Id, context);
      }
    });

    int? businessId = await ProxyService.box.read(key: 'businessId');
    String? userId = ProxyService.box.read(key: 'userId');

    log.d('businessId: $businessId');

    /// subscribe to general notification
    await FirebaseMessaging.instance.subscribeToTopic('all');

    /// only notification for this specific user
    if (userId != null) {
      await FirebaseMessaging.instance.subscribeToTopic(userId);
    }

    /// use firebase authId to subscribe to message send to user.
    // User? user = await ProxyService.auth.getCurrentUserId();
    // if (user != null) {
    //   await FirebaseMessaging.instance.subscribeToTopic(user.uid);
    // }

    if (businessId != null) {
      await FirebaseMessaging.instance.subscribeToTopic(businessId.toString());
    }
  }

  Future<void> navigationLogic(
      String action, String kId, BuildContext context) async {
    switch (action) {
      case 'chat':
        types.Room? room = await FirebaseChatCore.instance.roomFromId(kId);
        GoRouter.of(context).go(Routes.convo + '/' + room!.id);

        break;
      case 'order':
        //TODOnavigate to chat with this message of requesting order being last message
        // on item, should add the item to the order can add as many item to order
        // then navigate to the page to increase quantity and confirm order
        // once the order is comfired, navigate to chat where the order is sent in form of message
        // taping to the message should take you back to the order page for more details, this is special message!

        // ProxyService.nav.navigateTo(Routes.order);
        GoRouter.of(context).go(Routes.order);

        break;
      case 'payment':
        activateSubscription(
          context: context,
          body: <Widget>[const SubscriptionWidget()],
          header: header(title: 'Renew flipper subscription', context: context),
        );
        break;
      default:
    }
  }

  @override
  Future<void> saveTokenToDatabase(String token) async {}

  @override
  void listen(BuildContext context) {
    if (!isWindows) {
      ///gives you the message on which user taps
      ///and it opened the app from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // final routeFromMessage = message.data["route"];
          log.i(message.data);
          handleTheMessage(message);
        }
      });

      ///forground work
      FirebaseMessaging.onMessage.listen((message) {
        log.d(message.data);
        handleTheMessage(message);
      });

      ///When the app is in background but opened and user taps
      ///on the notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        String id = message.data['action'] + '_' + message.data['id'];
        final List<String> split = id.split('_');
        final String action = split[0];
        final String kId = split[1];
        await navigationLogic(action, kId, context);
      });
    }
  }

  void handleTheMessage(RemoteMessage message) {
    return display(message);
  }

  @override
  String toString() => 'LocalNotificationService(messaging: $messaging)';

  @override
  void onDidReceiveLocalNotification(
      int id, String title, String body, Map<String, String> payload) async {
    String action = payload['route']! + '_' + id.toString();
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: action,
    );
  }
}
