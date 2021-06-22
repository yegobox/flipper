import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'abstractions/remote.dart';

class RemoteConfigService implements Remote {
  RemoteConfig remoteConfig = RemoteConfig.instance;

  void setDefault() {
    remoteConfig.setDefaults(<String, dynamic>{
      'welcome_message': 'Welcome to flipper',
      'chat_feature': kDebugMode ? true : false,
      'spenn_payment': false,
      'email_receipt': false,
      'add_customer_to_sale': false,
      'printer_receipt': false,
      'force_remote_add_data': false
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

  @override
  bool isEmailReceiptAvailable() {
    return remoteConfig.getBool('email_receipt');
  }

  @override
  bool isAddCustomerToSaleAvailable() {
    return remoteConfig.getBool('add_customer_to_sale');
  }

  @override
  bool isPrinterAvailable() {
    return remoteConfig.getBool('printer_receipt');
  }

  @override
  bool forceDateEntry() {
    return remoteConfig.getBool('force_remote_add_data');
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
    return true;
  }

  @override
  void setDefault() {
    // TODO: implement setDefault
  }

  @override
  bool isSpennPaymentAvailable() {
    return false;
  }

  @override
  bool isEmailReceiptAvailable() {
    return false;
  }

  @override
  bool isAddCustomerToSaleAvailable() {
    return false;
  }

  @override
  bool isPrinterAvailable() {
    return false;
  }

  @override
  bool forceDateEntry() {
    return false;
  }
}
