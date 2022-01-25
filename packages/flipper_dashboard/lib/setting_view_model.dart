import 'package:flipper_routing/routes.locator.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/material.dart';

class SettingViewModel extends ReactiveViewModel {
  ThemeMode themeMode = ThemeMode.system;
  final kSetting = locator<SettingsService>();
  final languageService = locator<LanguageService>();
  bool _updateStarted = false;
  Setting? _setting = null;
  Setting? get setting => _setting;
  bool get updateStart => _updateStarted;
  final log = getLogger('SettingViewModel');
  String? defaultLanguage = null;

  Locale? klocale = null;

  Locale? get locale => klocale;

  bool _isProceeding = false;

  get isProcessing => _isProceeding;

  String? getSetting() {
    klocale = Locale(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    setLanguage(ProxyService.box.read(key: 'defaultLanguage') ?? 'en');
    return ProxyService.box.read(key: 'defaultLanguage');
  }

  BusinessSync get business => ProxyService.api
      .getBusinessById(id: ProxyService.box.read(key: 'businessId'));

  void setLanguage(String lang) {
    defaultLanguage = null;
    klocale = Locale(lang);
    ProxyService.box.write(key: 'defaultLanguage', value: lang);
    defaultLanguage = lang;
    log.i(defaultLanguage);
    languageService.setLocale(lang: defaultLanguage!);
    notifyListeners();
  }

  Future<bool> updateSettings({required Map map}) async {
    _updateStarted = true;
    return await kSetting.updateSettings(map: map);
  }

  Future<Profile?> updateProfile({required Profile profile}) async {
    _updateStarted = true;
    return await ProxyService.api.updateProfile(profile: profile);
  }

  loadUserSettings() async {
    String userId = ProxyService.box.read(key: 'userId');
    _setting = await ProxyService.api.getSetting(userId: int.parse(userId));
    notifyListeners();
  }

  void enablePrint() {
    kSetting.enablePrint(bool: !kSetting.enablePrinter);
  }

  bool get getIsSyncSubscribed => isSubscribedOnSync();

  bool isSubscribedOnSync() {
    int businessId = int.parse(ProxyService.box.read(key: 'businessId'));
    return ProxyService.api
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
    int businessId = int.parse(ProxyService.box.read(key: 'businessId'));
    bool isSubscribed = false;

    /// do we have a subscription on the feature

    isSubscribed =
        ProxyService.api.isSubscribed(businessId: businessId, feature: feature);
    if (isSubscribed) {
      callback(isSubscribed);
    } else {
      /// subscribe to the feature
      isSubscribed = ProxyService.api.subscribe(
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
    if (kSetting.settings != null && kSetting.settings!.email.length > 0) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$")
          .hasMatch(kSetting.settings!.email)) {
        callback(1);
      } else {
        await ProxyService.api
            .createGoogleSheetDoc(email: kSetting.settings!.email);

        BusinessSync business = ProxyService.api.getBusiness();
        business.email = kSetting.settings!.email;
        await ProxyService.api.updateBusiness(
          id: business.id,
          business: business.toJson(),
        );
        ProxyService.api.update(
          data: business.toJson(),
          endPoint: 'businesses/' + business.id.toString(),
        );
      }
    } else {
      callback(2);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [kSetting, languageService];

  void enableAttendance(Function callback) {
    kSetting.toggleAttendanceSetting();
    if (kSetting.settings != null && kSetting.settings!.email.length > 0) {
      if (!RegExp(r"^[\w.+\-]+@gmail\.com$")
          .hasMatch(kSetting.settings!.email)) {
        callback(1);
      } else {
        /// the
        BusinessSync business = ProxyService.api.getBusiness();
        ProxyService.api.enableAttendance(
            businessId: business.id, email: kSetting.settings!.email);
      }
    } else {
      callback(2);
    }
  }

  /// if the callback return with 1 that is a failure
  void activateFlipperPro(String text, Function success) async {
    _isProceeding = true;
    notifyListeners();
    try {
      int userId = int.parse(ProxyService.box.read(key: 'userId'));

      Voucher? voucher = await ProxyService.billing
          .useVoucher(voucher: int.parse(text), userId: userId);
      if (voucher != null) {
        ProxyService.billing.addPoints(points: voucher.value, userId: userId);
        List<Feature> features = [];
        for (Feature feature in voucher.features) {
          features.add(feature);
        }
        ProxyService.billing.updateSubscription(
          descriptor: voucher.descriptor,
          userId: userId,
          features: features,
          interval: voucher.interval,
          amount: voucher.value.toDouble(),
        );
        _isProceeding = false;
        notifyListeners();
        success(0);
      } else {
        _isProceeding = false;
        notifyListeners();
        success(1);
      }
    } catch (e) {
      log.d(e);
      _isProceeding = false;
      notifyListeners();
      success(1);
    }
  }
}
