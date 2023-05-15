import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/foundation.dart';

abstract class Messaging {
  Future<void> initializeFirebaseMessagingAndSubscribeToBusinessNotifications();
  Future<void> listenTapOnNotificationFromBackground();
  Future<void> listenTapOnNotificationForeground();
  Future<String?> token();
}

class FirebaseMessagingDesktop implements Messaging {
  @override
  Future<void>
      initializeFirebaseMessagingAndSubscribeToBusinessNotifications() async {}

  @override
  Future<String> token() async {
    return "fakeToken";
  }

  @override
  Future<void> listenTapOnNotificationFromBackground() async {
    // TODO: implement listenTapOnNotificationFromBackground
    print("listenTapOnNotificationFromBackground");
  }

  @override
  Future<void> listenTapOnNotificationForeground() async {
    // TODO: implement listenTapOnNotificationForeground
    print("listenTapOnNotificationForeground");
  }
}

class FirebaseMessagingService implements Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final _routerService = locator<RouterService>();
  final appService = loc.locator<AppService>();
  @override
  Future<void>
      initializeFirebaseMessagingAndSubscribeToBusinessNotifications() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(ProxyService.box.getBusinessId()!.toString());
    String? _token = await token();
    log(_token!, name: "deviceToken");
    if (ProxyService.box.getDefaultApp() == 2) {
      bool isSocialLoggedIn = await appService.isSocialLoggedin();
      if (isSocialLoggedIn == true) {
        Setting? setting = await ProxyService.isarApi.getSocialSetting();
        if (setting == null) return;
        setting.deviceToken = _token;
        setting.token = setting.bToken;
        ProxyService.isarApi.patchSocialSetting(setting: setting);
      } else {
        await appService.logSocial();
      }
      if (!kDebugMode) {
        try {
          ProxyService.remoteApi.create(collection: {
            "deviceToken": _token,
            "businessId": ProxyService.box.getBusinessId()!
          }, collectionName: 'messagings');
        } catch (e) {
          ProxyService.box.write(key: 'getIsTokenRegistered', value: true);
        }
      }
    }
  }

  @override
  Future<String?> token() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  Future<void> listenTapOnNotificationFromBackground() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await handleTapOnNotification(message);
    });
  }

  @override
  Future<void> listenTapOnNotificationForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // int id = message.messageId.hashCode;
      // final title = message.data['title'];
      // final body = message.data['body'];
      await handleTapOnNotification(message);
    });
  }

  Future<void> handleTapOnNotification(RemoteMessage message) async {
    // int id = message.messageId.hashCode;
    // final title = message.data['title'];
    // final body = message.data['body'];
    final type = message.data['type'];
    if (type == "whatsapp") {
      final conversationKey = message.data['conversation'];
      Map<String, dynamic> conversationMap = json.decode(conversationKey);

      Conversation conversation = Conversation.fromJson(conversationMap);
      Conversation? conversationExistOnLocal = await ProxyService.isarApi
          .getConversation(messageId: conversation.messageId!);
      if (conversationExistOnLocal == null) {
        await ProxyService.isarApi.create(data: conversation);
      }
      //TODO: This should be done on click of the notification
      // _routerService.navigateTo(ConversationHistoryRoute(
      //     conversationId: conversation.conversationId!));
    } else {
      // ProxyService.notification.sendLocalNotification(
      //   id: id,
      //   title: title,
      //   body: body,
      //   date: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      // );
    }
  }
}
