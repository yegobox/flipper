import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

abstract class Messaging {
  Future<void> init();
  Future<String?> token();
}

class FirebaseMessagingDesktop implements Messaging {
  @override
  Future<void> init() async {}

  @override
  Future<String> token() async {
    return "fakeToken";
  }
}

class FirebaseMessagingService implements Messaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> init() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(ProxyService.box.getBusinessId()!.toString());

    /// make sure we only register the token once and we are not sending token when in debug mode
    if (ProxyService.box.getIsTokenRegistered() == null && !kDebugMode) {
      String? _token = await token();
      ProxyService.remoteApi.create(collection: {
        "deviceToken": _token,
        "businessId": ProxyService.box.getBusinessId()!
      }, collectionName: 'messagings');

      ProxyService.box.write(key: 'getIsTokenRegistered', value: true);
    }
  }

  @override
  Future<String?> token() async {
    return await _firebaseMessaging.getToken();
  }
}
