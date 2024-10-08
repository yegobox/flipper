import 'package:flutter/material.dart';

abstract class Remote {
  void setDefault();
  void fetch();
  bool isChatAvailable();
  bool isSpennPaymentAvailable();
  bool isReceiptOnEmail();
  bool isAddCustomerToSaleAvailable();
  bool isPrinterAvailable();
  bool forceDateEntry();
  bool isAnalyticFeatureAvailable();
  bool isSubmitDeviceTokenEnabled();
  bool scannSelling();
  void config();
  bool isMenuAvailable();
  bool isDiscountAvailable();
  bool isOrderAvailable();
  bool isBackupAvailable();
  bool isRemoteLoggingDynamicLinkEnabled();
  bool isAccessiblityFeatureAvailable();
  bool isMapAvailable();
  bool isAInvitingMembersAvailable();
  bool isSyncAvailable();
  bool isGoogleLoginAvailable();
  bool isTwitterLoginAvailable();
  bool isFacebookLoginAvailable();
  bool isResetSettingEnabled();
  bool isLinkedDeviceAvailable();
  bool isMarketingFeatureEnabled();
  bool isLocalAuthAvailable();
  String supportLine();
  int sessionTimeOutMinutes();
  Widget bannerAd();
  bool enableTakingScreenShoot();
  bool isOrderFeatureOrderEnabled();
  bool isFirestoreEnabled();
  bool isHttpSyncAvailable();
  String bcc();
  bool isEmailLogEnabled();
  bool isMultiUserEnabled();
}
