import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'abstractions/remote.dart';

class RemoteConfigService implements Remote {
  RemoteConfig remoteConfig = RemoteConfig.instance;

  void setDefault() {
    remoteConfig.setDefaults(<String, dynamic>{
      'welcome_message': 'Welcome to flipper',
      'chat_feature': true,
      'spenn_payment': false,
      'email_receipt': false,
      'add_customer_to_sale': false,
      'printer_receipt': false,
      'force_remote_add_data': true,
      'is_submit_device_token_enabled': false,
      'analytic_feature_available': true,
      'scann_selling': true,
      'is_menu_available': false,
      'is_discount_available': false,
      'is_order_available': false
    });
  }

  void fetch() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(minutes: 10),
    ));
    await remoteConfig.fetchAndActivate();
  }

  bool isChatAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('chat_feature');
  }

  @override
  bool isSubmitDeviceTokenEnabled() {
    return remoteConfig.getBool('is_submit_device_token_enabled');
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

  @override
  bool isAnalyticFeatureAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('analytic_feature_available');
  }

  @override
  bool scann_selling() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('scann_selling');
  }

  @override
  bool isMenuAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('is_menu_available');
  }

  @override
  bool isDiscountAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('is_discount_available');
  }

  @override
  bool isOrderAvailable() {
    return false;
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

  @override
  bool isSubmitDeviceTokenEnabled() {
    return false;
  }

  @override
  bool isAnalyticFeatureAvailable() {
    if (kDebugMode) {
      return true;
    }
    return true;
  }

  @override
  bool scann_selling() {
    return true;
  }

  @override
  bool isMenuAvailable() {
    return false;
  }

  @override
  bool isDiscountAvailable() {
    if (kDebugMode) {
      return true;
    }
    return true;
  }

  @override
  bool isOrderAvailable() {
    return false;
  }
}
