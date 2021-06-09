import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

SettingViewModel _getModel() => SettingViewModel();
void main() {
  test('setting view mode ...', () async {
    getAndRegisterSettingsService();
    final model = _getModel();
    bool result = await model.updateSettings(email: 'richie@gmail.com');
    expect(result, true);
  });
}
