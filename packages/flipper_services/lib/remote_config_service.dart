import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'abstractions/remote.dart';

class RemoteConfigService implements Remote {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void setDefault() {
    remoteConfig.setDefaults(<String, dynamic>{
      'welcome_message': 'Welcome to flipper',
      'chat_feature': false,
      'spenn_payment': false,
      'email_receipt': false,
      'add_customer_to_sale': false,
      'printer_receipt': false,
      'force_remote_add_data': true,
      'is_submit_device_token_enabled': false,
      'analytic_feature_available': true,
      'scannSelling': true,
      'is_menu_available': false,
      'is_discount_available': false,
      'is_order_available': false,
      'is_backup_available': false,
      'isRemoteLoggingDynamicLinkEnabled': true,
      'isAccessiblityFeatureAvailable': false,
      'isMapAvailable': false,
      'isAInvitingMembersAvailable': false,
      'isSyncAvailable': false,
      'isChatAvailable': false,
      'isGoogleLoginAvailable': true,
      'isResetSettingEnabled': false,
      'isLinkedDeviceAvailable': true,
      'isTwitterLoginAvailable': false,
      'isFacebookLoginAvailable': false,
      'supportLine': "+250783054874",
      'isMarketingFeatureEnabled': true
    });
  }

  @override
  void fetch() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {}
  }

  @override
  bool isChatAvailable() {
    if (kDebugMode) {
      return false;
    }
    return remoteConfig.getBool('isChatAvailable');
  }

  @override
  bool isSubmitDeviceTokenEnabled() {
    return remoteConfig.getBool('is_submit_device_token_enabled');
  }

  @override
  void config() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval:
          kDebugMode ? const Duration(hours: 0) : const Duration(hours: 4),
    ));
  }

  @override
  bool isSpennPaymentAvailable() {
    return remoteConfig.getBool('spenn_payment');
  }

  @override
  bool isReceiptOnEmail() {
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
  bool scannSelling() {
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

  @override
  bool isBackupAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('is_backup_available');
  }

  @override
  bool isRemoteLoggingDynamicLinkEnabled() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('isRemoteLoggingDynamicLinkEnabled');
  }

  @override
  bool isAccessiblityFeatureAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('isAccessiblityFeatureAvailable');
  }

  @override
  bool isMapAvailable() {
    if (kDebugMode) {
      return false;
    }
    return remoteConfig.getBool('isMapAvailable');
  }

  @override
  bool isAInvitingMembersAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('isAInvitingMembersAvailable');
  }

  @override
  bool isSyncAvailable() {
    if (kDebugMode) {
      return false;
    }
    return remoteConfig.getBool('isSyncAvailable');
  }

  @override
  bool isGoogleLoginAvailable() {
    if (kDebugMode) {
      return true;
    }
    return remoteConfig.getBool('isGoogleLoginAvailable');
  }

  @override
  bool isResetSettingEnabled() {
    if (kDebugMode) {
      return false;
    }
    return remoteConfig.getBool('isResetSettingEnabled');
  }

  @override
  bool isLinkedDeviceAvailable() {
    return remoteConfig.getBool('isLinkedDeviceAvailable');
  }

  @override
  bool isFacebookLoginAvailable() {
    return remoteConfig.getBool('isFacebookLoginAvailable');
  }

  @override
  bool isTwitterLoginAvailable() {
    return remoteConfig.getBool('isTwitterLoginAvailable');
  }

  @override
  String supportLine() {
    return remoteConfig.getString('supportLine');
  }

  @override
  bool isMarketingFeatureEnabled() {
    return remoteConfig.getBool('isMarketingFeatureEnabled');
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
  bool isReceiptOnEmail() {
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
      return false;
    }
    return false;
  }

  @override
  bool scannSelling() {
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

  @override
  bool isBackupAvailable() {
    return false;
  }

  @override
  bool isRemoteLoggingDynamicLinkEnabled() {
    return false;
  }

  @override
  bool isAccessiblityFeatureAvailable() {
    return false;
  }

  @override
  bool isMapAvailable() {
    return false;
  }

  @override
  bool isAInvitingMembersAvailable() {
    return false;
  }

  @override
  bool isSyncAvailable() {
    return false;
  }

  @override
  bool isGoogleLoginAvailable() {
    return true;
  }

  @override
  bool isResetSettingEnabled() {
    return false;
  }

  @override
  bool isLinkedDeviceAvailable() {
    return false;
  }

  @override
  bool isFacebookLoginAvailable() {
    return false;
  }

  @override
  bool isTwitterLoginAvailable() {
    return false;
  }

  @override
  String supportLine() {
    return "+250783054874";
  }

  @override
  bool isMarketingFeatureEnabled() {
    return false;
  }
}
