import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/push/push_actions.dart';
import 'package:flipper/model/in_app_notification.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createPushMiddleware(
  
  FirebaseMessaging firebaseMessaging,
) {
  return [
   
    TypedMiddleware<AppState, OnPushNotificationReceivedAction>(
        _onPushNotificationReceived()),
  ];
}



void Function(
  Store<AppState> store,
  OnPushNotificationReceivedAction action,
  NextDispatcher next,
) _onPushNotificationReceived() {
  return (store, action, next) async {
    next(action);

    try {
      final message = _verifyedMessage(action.message, store);
      if (message == null) {
        return;
      }
      final notification = message['notification'];
      final inAppNotification =
          InAppNotification((n) => n..message = notification['body']);

      store.dispatch(ShowPushNotificationAction(inAppNotification));
    } catch (e) {
      // Logger.e('Failed to display push notification',
      //     e: e, s: StackTrace.current);
    }
  };
}

Map<String, dynamic> _verifyedMessage(
    Map<String, dynamic> message, Store<AppState> store) {
  var notification = message['notification'];
  var data = message['data'];

  // Necessary because the payload format is different per platform
  // See: https://github.com/flutter/flutter/issues/29027
  if (Platform.isIOS) {
    data = message;
    final aps = (data != null) ? data['aps'] : null;
    notification = (aps != null) ? aps['alert'] : null;
  }

  final results = {'data': 'delete-after', 'notification': notification};

  // final results = {'data': data, 'notification': notification};

  if (notification == null) {
    // there was  || data == null here but removed it for fast testing
    // Logger.d('Empty message payload');
    return null;
  }

  // final groupId = data['groupId'];
  // final channelId = data['channelId'];

  // if (groupId == null || channelId == null) {
  //   Logger.d('Missing properties channelId and groupId');
  //   return null;
  // }

  // final messageType = data['type'];

  // if (messageType != 'message') {
  //   Logger.d('No action required for type: $messageType');
  //   return null;
  // }

  return results;
}
