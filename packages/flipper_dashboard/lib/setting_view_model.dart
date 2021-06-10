import 'package:flipper/routes.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/setting_service.dart';

class SettingViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  bool _updateStarted = false;
  bool get updateStart => _updateStarted;
  Future<bool> updateSettings({String? email}) async {
    _updateStarted = true;
    return await settingService.updateEmail(email: email!);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
