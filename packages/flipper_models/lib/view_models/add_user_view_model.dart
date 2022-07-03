import 'package:flipper_models/isar/tenant.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_routing/routes.locator.dart';

class AddUserViewModel extends ReactiveViewModel {
  final settingService = locator<SettingsService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [settingService];
}
