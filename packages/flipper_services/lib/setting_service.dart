import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';

class SettingsService {
  Future<bool> updateSettings({required Map map, required endPoint}) async {
    //todo: when no setting for this user create one with given detail
    //if the setting exist then update the given detail.
    String userId = ProxyService.box.read(key: 'userId');
    Setting? setting =
        await ProxyService.api.getSetting(userId: int.parse(userId));
    if (setting != null) {
      //updat with given setting
      int id = setting.id;
      ProxyService.api.update(data: map, endPoint: 'settings/$id');
      return true;
    } else {
      Map kMap = map;
      map.forEach((key, value) {
        kMap[key] = value;
      });
      Setting setting = new Setting(
          email: kMap['email'],
          userId: int.parse(userId),
          hasPin: kMap['hasPin'],
          openReceiptFileOSaleComplete: kMap['openReceiptFileOSaleComplete'],
          autoPrint: kMap['autoPrint']);
      await ProxyService.api.createSetting(userId: 300, setting: setting);
      return true;
    }
  }
}
