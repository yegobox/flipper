import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'abstractions/remote.dart';

class RemoteConfigService implements Remote {
  RemoteConfig remoteConfig = RemoteConfig.instance;

  void setDefault() {
    remoteConfig.setDefaults(<String, dynamic>{
      'welcome_message': 'this is the default welcome message',
      'chat_feature': false,
      'spenn_payment': false
    });
  }

  void fetch() async {
    await remoteConfig.fetchAndActivate();
  }

  bool isChatAvailable() {
    return remoteConfig.getBool('chat_feature');
  }

  void config() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval:
          kDebugMode ? Duration(hours: 0) : Duration(hours: 4),
    ));
  }

  @override
  bool isSpennPaymentAvailable() {
    return remoteConfig.getBool('spenn_payment');
  }
}

class RemoteConfigWindows implements Remote {
  @override
  void config() {
    // TODO: implement config
  }

  @override
  void fetch() {
    // TODO: implement fetch
  }

  @override
  bool isChatAvailable() {
    return false;
  }

  @override
  void setDefault() {
    // TODO: implement setDefault
  }

  @override
  bool isSpennPaymentAvailable() {
    return false;
  }
}
