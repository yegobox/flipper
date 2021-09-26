import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ReactiveServiceMixin {
  final log = getLogger('SettingsService');
  //  bool sendDailReport = false;
  final _enablePrinter = ReactiveValue<bool>(false);

  bool get enablePrinter => _enablePrinter.value;

  final _sendDailReport = ReactiveValue<bool>(false);

  bool get sendDailReport => _sendDailReport.value;
  Future<bool> updateSettings({required Map map}) async {
    //todo: when no setting for this user create one with given detail
    //if the setting exist then update the given detail.
    String userId = ProxyService.box.read(key: 'userId');
    Setting? setting =
        await ProxyService.api.getSetting(userId: int.parse(userId));
    if (setting != null) {
      Map<String, dynamic> settings_map = setting.toJson();
      //replace a key in settings_map if the key match with the key from map
      settings_map.forEach((key, value) {
        if (map.containsKey(key)) {
          settings_map[key] = map[key];
        }
      });
      // log.i(settings_map);
      int id = setting.id;
      ProxyService.api.update(data: settings_map, endPoint: 'settings/$id');
      return true;
    } else {
      Map kMap = map;
      map.forEach((key, value) {
        kMap[key] = value;
      });
      Setting setting = new Setting(
          email: kMap['email'] ?? '',
          userId: int.parse(userId),
          hasPin: kMap['hasPin'] ?? '',
          openReceiptFileOSaleComplete:
              kMap['openReceiptFileOSaleComplete'] ?? false,
          autoPrint: kMap['autoPrint'] ?? false);
      await ProxyService.api.createSetting(userId: 300, setting: setting);
      return true;
    }
  }

  Map<String, dynamic> settings() {
    String userId = ProxyService.box.read(key: 'userId');
    Setting? setting = ProxyService.api.getSetting(userId: int.parse(userId));
    if (setting != null) {
      Map<String, dynamic> settings_map = setting.toJson();
      return settings_map;
    } else {
      return new Map<String, String>();
    }
  }

  Future<void> enableDailyReport({required bool bool}) async {
    await updateSettings(map: {'sendDailyReport': bool});
  }

  bool enabledReport() {
    return settings()['email'] != null && settings()['sendDailyReport'];
  }

  bool enabledPrint() {
    return settings()['autoPrint'] != null && settings()['autoPrint'];
  }

  void enablePrint({required bool bool}) async {
    await updateSettings(map: {'autoPrint': bool});
  }

  Future<void> createGoogleSheetDoc() async {
    await updateSettings(map: {'googleSheetDocCreated': true});
  }

  void toggleSettings() {
    _enablePrinter.value =
        settings()['autoPrint'] != null && settings()['autoPrint'];
    _sendDailReport.value = settings()['email'] != null &&
        settings()['sendDailyReport'] != null &&
        settings()['sendDailyReport'];
    log.i(sendDailReport);
  }

  SettingsService() {
    listenToReactiveValues([_sendDailReport, _enablePrinter]);
  }
}
