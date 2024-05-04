import 'package:flipper_services/locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
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
    _business = await ProxyService.realm
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
    _setting = await ProxyService.realm.getSetting(businessId: businessId);
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
    return ProxyService.realm
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

    isSubscribed = ProxyService.realm
        .isSubscribed(businessId: businessId, feature: feature);
    if (isSubscribed) {
      callback(isSubscribed);
    } else {
      /// subscribe to the feature
      isSubscribed = ProxyService.realm.subscribe(
        businessId: businessId,
        feature: feature,
        agentCode: agentCode,
      );
      callback(isSubscribed);
    }
  }

  /// enable report on user's email, the user should be admin not additonal users added to the account.
  /// the email have to be gmail for now, in future release we might add other email providers
  /// if for some reason the report is not shared to user's email but the report google sheet document has been created.
  /// a user can toggle the report on/off from the settings page. the report will be sent to the user's email.
  /// the backend is built in a way to reshare the report to the user's email.
  void enableDailyReport(Function callback) async {
    kSetting.toggleDailyReportSetting();
    Setting? setting = await kSetting.settings();
    if (setting != null && setting.email!.isNotEmpty) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$").hasMatch(setting.email!)) {
        callback(1);
      } else {
        await ProxyService.realm.createGoogleSheetDoc(email: setting.email!);
        ProxyService.realm.realm!.writeAsync(() async {
          Business business = await ProxyService.realm.getBusiness();
          business.email = setting.email;
        });
      }
    } else {
      callback(2);
    }
  }

  Future<void> enableAttendance(Function callback) async {
    kSetting.toggleAttendanceSetting();
    Setting? setting = await kSetting.settings();
    if (setting != null && setting.email!.isNotEmpty) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$").hasMatch(setting.email!)) {
        callback(1);
      } else {
        /// the
        Business business = await ProxyService.realm.getBusiness();
        ProxyService.realm
            .enableAttendance(businessId: business.id!, email: setting.email!);
      }
    } else {
      callback(2);
    }
  }

  Pin? pin;
  Future<void> createPin() async {
    // pin = await ProxyService.isar.createPin();
    notifyListeners();
  }

  /// if the callback return with 1 that is a failure
  void activateFlipperPro(String text, Function success) async {
    _isProceeding = true;
    notifyListeners();
    try {
      int userId = ProxyService.box.readInt(key: 'userId')!;

      Voucher? voucher = await ProxyService.billing
          .useVoucher(voucher: int.parse(text), userId: userId);
      if (voucher != null) {
        // ProxyService.billing.addPoints(points: voucher.value, userId: userId);
        // List<Feature> features = [];

        _isProceeding = false;
        notifyListeners();
        success(0);
      } else {
        _isProceeding = false;
        notifyListeners();
        success(1);
      }
    } catch (e) {
      _isProceeding = false;
      notifyListeners();
      success(1);
    }
  }

  bool _isEbmActive = false;

  /// create setter and getter for the _isProceeding
  bool get isEbmActive => _isEbmActive;
  // now create setter
  set isEbmActive(bool value) {
    _isEbmActive = value;
    notifyListeners();
  }

  bool get isProformaModeEnabled => ProxyService.box.isPoroformaMode();
  set isProformaModeEnabled(bool value) {
    if (!ProxyService.box.isTrainingMode()) {
      ProxyService.box.writeBool(key: 'isPoroformaMode', value: value);
      notifyListeners();
    }
  }

  bool get isTrainingModeEnabled => ProxyService.box.isTrainingMode();
  set isTrainingModeEnabled(bool value) {
    if (!ProxyService.box.isPoroformaMode()) {
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

  void setIsprocessing({required bool value}) {
    _isProceeding = value;
    notifyListeners();
  }
}
