import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/setting.dart';

class SettingsService {
  Future<bool> updateEmail({required String email}) async {
    //todo: when no setting for this user create one with given detail
    //if the setting exist then update the given detail.

    String userId = ProxyService.box.read(key: 'userId');
    Setting? setting =
        await ProxyService.api.getSetting(userId: int.parse(userId));
    if (setting != null) {
      //updat with given setting
      Map map = {'email': email};
      ProxyService.api.update(data: map, endPoint: 'setting');
      return true;
    } else {
      Setting setting =
          new Setting(email: email, userId: int.parse(userId), hasPin: 'null');
      await ProxyService.api.createSetting(userId: 300, setting: setting);
      return true;
    }
  }
}
