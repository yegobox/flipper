import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

import 'notifications/cubit/notifications_cubit.dart';

abstract class Messaging {
  Future<void> initializeFirebaseMessagingAndSubscribeToBusinessNotifications();
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
  Future<void> listenTapOnNotificationForeground() async {
    // TODO: implement listenTapOnNotificationForeground
    print("listenTapOnNotificationForeground");
  }
}

class FirebaseMessagingService implements Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _routerService = locator<RouterService>();

  ///The reason why I did not use this method is the fact that
  /// I can not access _routerService.navigateTo here on top level
  /// hence I don't even know how to accept a notification when tapped
  /// this is experiment to check if I can register for backgroun message listening
  Future<void> backgroundHandler(RemoteMessage message) async {
    await _handleMessage(message: message, isNotificationClicked: false);
  }

  final appService = loc.getIt<AppService>();
  @override
  Future<void>
      initializeFirebaseMessagingAndSubscribeToBusinessNotifications() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(ProxyService.box.getBusinessId()!.toString());
    String? _token = await token();

    int branchId = ProxyService.box.getBranchId() ?? 0;
    List<Social> activeSocialAccount =
        await ProxyService.isar.activesocialAccounts(branchId: branchId);

    if (ProxyService.box.getDefaultApp() == 2 &&
        activeSocialAccount.isNotEmpty &&
        !ProxyService.box.getIsTokenRegistered()! &&
        !kDebugMode) {
      bool isSocialLoggedIn = await appService.isSocialLoggedin();

      if (isSocialLoggedIn) {
        Setting? setting = await ProxyService.isar.getSocialSetting();
        if (setting == null) {
          throw Exception("Failed to retrieve social settings.");
        }
        setting.deviceToken = _token;
        ProxyService.isar.patchSocialSetting(setting: setting);
      } else {
        await appService.logSocial();
      }

      try {
        await ProxyService.remote.create(
          collection: {
            "deviceToken": _token,
            "businessId": branchId,
          },
          collectionName: 'messagings',
        );
        ProxyService.box.writeBool(key: 'getIsTokenRegistered', value: true);
      } catch (e) {
        ProxyService.box.writeBool(key: 'getIsTokenRegistered', value: true);
      }
    }
  }

  @override
  Future<String?> token() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  Future<void> listenTapOnNotificationForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _handleMessage(message: message, showLocalNotification: true);
    });
  }

  Future<void> _handleMessage(
      {required RemoteMessage message,
      bool isNotificationClicked = false,
      bool showLocalNotification = false}) async {
    final type = message.data['type'];
    if (type == "whatsapp") {
      final conversationKey = message.data['conversation'];
      Map<String, dynamic> conversationMap = json.decode(conversationKey);

      Conversation conversation = Conversation.fromJson(conversationMap);
      // delay so if there is other transaction going on to complete first e.g from pubnub
      Future.delayed(Duration(seconds: 20));
      Conversation? conversationExistOnLocal = await ProxyService.isar
          .getConversation(messageId: conversation.messageId!);
      if (conversationExistOnLocal == null) {
        if (showLocalNotification) {
          await NotificationsCubit.instance.scheduleNotification(conversation);
        }
        await ProxyService.isar.create(data: conversation);
      }
      if (isNotificationClicked) {
        _routerService.navigateTo(ConversationHistoryRoute(
            conversationId: conversation.conversationId!));
      }
    }
  }
}
