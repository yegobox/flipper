import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
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
  final appService = loc.locator<AppService>();
  @override
  Future<void> init() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(ProxyService.box.getBusinessId()!.toString());
    String? _token = await token();
    ProxyService.box.remove(key: 'getIsTokenRegistered');
    if (ProxyService.box.getIsTokenRegistered() != null) {
      if (await appService.isSocialLoggedin() && kDebugMode) {
        log(_token!, name: "deviceToken");
        ProxyService.isarApi.patchSocialSetting(token: _token);
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
}
