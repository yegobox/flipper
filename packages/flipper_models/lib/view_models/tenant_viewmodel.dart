import 'package:flipper_models/isar_models.dart';

import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class TenantViewModel extends ReactiveViewModel {
  List<ITenant> _tenants = [];
  List<ITenant> get tenants => _tenants;

  Future<void> loadTenants() async {
    List<ITenant> users = await ProxyService.isar
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    _tenants = [...users];
    rebuildUi();
  }
}
