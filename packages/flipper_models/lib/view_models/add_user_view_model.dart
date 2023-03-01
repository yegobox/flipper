import 'package:flipper_models/isar/tenant.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class AddTenantViewModel extends ReactiveViewModel {
  List<ITenant> _tenants = [];
  List<ITenant> get tenants => _tenants;

  Future<void> loadTenants() async {
    List<ITenant> users = await ProxyService.isarApi
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    _tenants = [...users];
    rebuildUi();
  }
}
