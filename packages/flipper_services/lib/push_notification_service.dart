library flipper_services;

import 'dart:io';

// import 'package:flipper_services/locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_services/locator.dart';
import 'flipperNavigation_service.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _navigationService = locator<FlipperNavigationService>();

  Future initialise() async {
    if (Platform.isIOS) {
      // request permissions if we're on android
      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    }
    // _fcm.configure(
    //   // Called when the app is in the foreground and we receive a push notification
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onMessage: $message');
    //   },
    //   // Called when the app has been closed comlpetely and it's opened
    //   // from the push notification.
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //     _serialiseAndNavigate(message);
    //   },
    //   // Called when the app is in the background and it's opened
    //   // from the push notification.
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     _serialiseAndNavigate(message);
    //   },
    // );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    final notificationData = message['data'];
    final view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'create_post') {
        // _navigationService.navigateTo(CreatePostViewRoute);
      }
    }
  }
}
