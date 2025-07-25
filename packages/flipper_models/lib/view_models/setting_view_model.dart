import 'package:flipper_services/locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends CoreViewModel {
  ThemeMode themeMode = ThemeMode.system;
  final kSetting = getIt<SettingsService>();
  final languageService = getIt<Language>();
  bool _updateStarted = false;
  Setting? _setting;
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;

  Business? _business;
  Business? get business => _business;
  getBusiness() async {
    _business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    notifyListeners();
  }

  String? defaultLanguage;

  Locale? klocale;

  Locale? get locale => klocale;

  bool _isProceeding = false;

  get isProcessing => _isProceeding;

  String? getSetting() {
    klocale =
        Locale(ProxyService.box.readString(key: 'defaultLanguage') ?? 'en');
    setLanguage(ProxyService.box.readString(key: 'defaultLanguage') ?? 'en');
    return ProxyService.box.readString(key: 'defaultLanguage');
  }

  void setLanguage(String lang) {
    defaultLanguage = null;
    klocale = Locale(lang);
    ProxyService.box.writeString(key: 'defaultLanguage', value: lang);
    defaultLanguage = lang;
    languageService.setLocale(lang: defaultLanguage!);
    notifyListeners();
  }

  Future<bool> updateSettings({required Map map}) async {
    _updateStarted = true;
    return await kSetting.updateSettings(map: map);
  }

  // Future<Profile?> updateProfile({required Profile profile}) async {
  //   _updateStarted = true;
  //   return ProxyService.isar.updateProfile(profile: profile);
  // }

  loadUserSettings() async {
    int businessId = ProxyService.box.getBusinessId()!;
    _setting = await ProxyService.strategy.getSetting(businessId: businessId);
    notifyListeners();
  }

  void enablePrint() {
    kSetting.enablePrint(bool: !kSetting.enablePrinter);
  }

  bool get getIsSyncSubscribed => isSubscribedOnSync();

  bool isSubscribedOnSync() {
    int businessId = 0;
    if (ProxyService.box.getBusinessId().runtimeType is int) {
      businessId = ProxyService.box.getBusinessId()!;
    } else if (ProxyService.box.getBusinessId().runtimeType is String) {
      businessId = ProxyService.box.getBusinessId()!;
    }
    return ProxyService.strategy
        .isSubscribed(feature: 'sync', businessId: businessId);
  }

  /// enable sync
  /// check if there is no subscription
  /// check if existing subscription has the feature that is being requested
  /// if not, subscribe to the feature
  void enableSync({
    required String feature,
    required int agentCode,
    required Function callback,
  }) {
    // settingService.enableSync(bool: !settingService.enableSync);
    int businessId = ProxyService.box.getBusinessId()!;
    bool isSubscribed = false;

    /// do we have a subscription on the feature

    isSubscribed = ProxyService.strategy
        .isSubscribed(businessId: businessId, feature: feature);
    if (isSubscribed) {
      callback(isSubscribed);
    } else {
      /// subscribe to the feature
      // isSubscribed = ProxyService.strategy.subscribe(
      //   businessId: businessId,
      //   feature: feature,
      //   agentCode: agentCode,
      // );
      callback(isSubscribed);
    }
  }

  /// enable report on user's email, the user should be admin not additonal users added to the account.
  /// the email have to be gmail for now, in future release we might add other email providers
  /// if for some reason the report is not shared to user's email but the report google sheet document has been created.
  /// a user can toggle the report on/off from the settings page. the report will be sent to the user's email.
  /// the backend is built in a way to reshare the report to the user's email.

  Future<void> enableAttendance(Function callback) async {
    kSetting.toggleAttendanceSetting();
    Setting? setting = await kSetting.settings();
    if (setting != null && setting.email!.isNotEmpty) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$").hasMatch(setting.email!)) {
        callback(1);
      } else {
        /// the
        // Business? business = await ProxyService.strategy.getBusiness();
        // ProxyService.strategy.enableAttendance(
        //     businessId: business!.serverId, email: setting.email!);
      }
    } else {
      callback(2);
    }
  }

  Pin? pin;
  Future<void> createPin() async {
    notifyListeners();
  }

  bool _isEbmActive = false;

  /// create setter and getter for the _isProceeding
  bool get isEbmActive => _isEbmActive;
  // now create setter
  set isEbmActive(bool value) {
    _isEbmActive = value;
    notifyListeners();
  }

  bool get isProformaModeEnabled => ProxyService.box.isProformaMode();
  bool get printA4 => ProxyService.box.A4();
  bool get exportAsPdf => ProxyService.box.exportAsPdf();
  set isProformaModeEnabled(bool value) {
    if (!ProxyService.box.isTrainingMode()) {
      ProxyService.box.writeBool(key: 'isProformaMode', value: value);
      notifyListeners();
    }
  }

  set exportAsPdf(bool value) {
    ProxyService.box.writeBool(key: 'exportAsPdf', value: value);
    notifyListeners();
  }

  set printA4(bool value) {
    if (!ProxyService.box.isTrainingMode()) {
      ProxyService.box.writeBool(key: 'A4', value: value);
      notifyListeners();
    }
  }

  bool get isTrainingModeEnabled => ProxyService.box.isTrainingMode();
  set isTrainingModeEnabled(bool value) {
    if (!ProxyService.box.isProformaMode()) {
      ProxyService.box.writeBool(key: 'isTrainingMode', value: value);
      notifyListeners();
    }
  }

  bool get isAutoPrintEnabled => ProxyService.box.isAutoPrintEnabled();
  set isAutoPrintEnabled(bool value) {
    ProxyService.box.writeBool(key: 'isAutoPrintEnabled', value: value);
    notifyListeners();
  }

  bool get isAutoBackupEnabled => ProxyService.box.isAutoBackupEnabled();
  set isAutoBackupEnabled(bool value) {
    ProxyService.box.writeBool(key: 'isAutoBackupEnabled', value: value);
    notifyListeners();
  }

  String get systemCurrency => ProxyService.box.defaultCurrency();
  set systemCurrency(String value) {
    ProxyService.box.writeString(key: 'defaultCurrency', value: value);
    notifyListeners();
  }

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
