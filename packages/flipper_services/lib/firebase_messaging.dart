import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flipper_models/helpers/personal_goal_contribution_device_key.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/notification_manager.dart';
import 'package:flipper_services/personal_goal_fcm_background.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:stacked_services/stacked_services.dart';

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
    if (isMacOs) return;

    final businessId = ProxyService.box.getBusinessId()?.toString();
    if (businessId == null || businessId.isEmpty) return;

    try {
      await FirebaseMessaging.instance.subscribeToTopic(businessId);
    } catch (e) {
      print('FCM business topic subscribe failed: $e');
    }

    final branchId = ProxyService.box.getBranchId()?.toString();
    if (branchId != null && branchId.isNotEmpty) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(
          'branch_${_fcmTopicSegment(branchId)}',
        );
      } catch (e) {
        print('FCM branch topic subscribe failed: $e');
      }
    }

    await token();
  }

  static String _fcmTopicSegment(String value) =>
      value.replaceAll(RegExp(r'[^a-zA-Z0-9\-_.~%]'), '_');

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
    final type = message.data['type']?.toString();
    if (type == kPersonalGoalContributionFcmType) {
      final sourceKey = message.data['sourceDeviceKey']?.toString();
      if (sourceKey != null && sourceKey.isNotEmpty) {
        final localKey = await personalGoalContributionDeviceKey();
        if (localKey.isNotEmpty && localKey == sourceKey) return;
      }

      final body = message.notification?.body ??
          message.data['body']?.toString() ??
          message.data['message']?.toString();
      if (body != null &&
          body.isNotEmpty &&
          showLocalNotification &&
          !isNotificationClicked) {
        try {
          await NotificationManager.instance.showNotification(
            title: 'Personal goal',
            body: body,
          );
        } catch (_) {}
      }
      return;
    }
    if (type == "whatsapp") {
      final conversationKey = message.data['conversation'];
      Map<String, dynamic> conversationMap = json.decode(conversationKey);

      // Conversation conversation = Conversation.fromJson(conversationMap);
      // // delay so if there is other transaction going on to complete first e.g from pubnub
      // Future.delayed(Duration(seconds: 20));
      // Conversation? conversationExistOnLocal = await ProxyService.isar
      //     .getConversation(messageId: conversation.messageId!);
      // if (conversationExistOnLocal == null) {
      //   if (showLocalNotification) {
      //     await NotificationsCubit.instance.scheduleNotification(conversation);
      //   }
      //   await ProxyService.isar.create(data: conversation);
      // }
      // if (isNotificationClicked) {
      //   _routerService.navigateTo(ConversationHistoryRoute(
      //       conversationId: conversation.conversationId!));
      // }
    }
  }
}
