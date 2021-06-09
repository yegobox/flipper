import 'package:flipper/routes.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';

class SettingViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  Future<bool> updateSettings({String? email}) async {
    return await settingService.updateEmail(email: email!);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
