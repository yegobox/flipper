import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'abstractions/remote.dart';

class RemoteConfigWindows implements Remote {
  @override
  void config() {}

  @override
  void fetch() {}

  @override
  bool isChatAvailable() {
    return false;
  }

  @override
  void setDefault() {}

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
    return true;
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

  @override
  int sessionTimeOutMinutes() {
    return 10;
  }

  @override
  bool isLocalAuthAvailable() {
    return true;
  }

  @override
  Widget bannerAd() {
    return SizedBox.shrink();
  }

  @override
  bool enableTakingScreenShoot() {
    return false;
  }

  @override
  bool isOrderFeatureOrderEnabled() {
    return false;
  }

  @override
  bool isFirestoreEnabled() {
    return true;
  }

  @override
  bool isHttpSyncAvailable() {
    return false;
  }

  @override
  String bcc() {
    return "yegobox@gmail.com";
  }

  @override
  bool isEmailLogEnabled() {
    return true;
  }

  @override
  bool isMultiUserEnabled() {
    return true;
  }
}
