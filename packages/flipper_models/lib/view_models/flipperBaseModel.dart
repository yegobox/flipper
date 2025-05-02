import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/proxy.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/services.dart';

class FlipperBaseModel extends ReactiveViewModel {
  void openDrawer() {
    Drawers drawer = Drawers(
      openingBalance: 0.0,
      closingBalance: 0.0,
      cashierId: ProxyService.box.getUserId()!,
      tradeName: ProxyService.app.business.name,
      openingDateTime: DateTime.now().toUtc(),
      open: true,
      businessId: ProxyService.box.getBusinessId(),
      branchId: ProxyService.box.getBranchId(),
    );

    final _routerService = locator<RouterService>();
    _routerService.navigateTo(DrawerScreenRoute(open: "open", drawer: drawer));
  }

  List<Tenant> _tenants = [];
  List<Tenant> get tenants => _tenants;

  void deleteTenantById(int tenantId) {
    _tenants.removeWhere((tenant) => tenant.id == tenantId);
    notifyListeners();
  }

  void deleteTenant(Tenant tenant) {
    _tenants.remove(tenant);
    notifyListeners();
  }

  Future<void> loadTenants() async {
    List<Tenant> users = await ProxyService.strategy
        .tenants(businessId: ProxyService.box.getBusinessId()!);

    Set<String> uniqueUserIds = {};
    List<Tenant> uniqueUsers = [];

    for (var user in users) {
      if (!uniqueUserIds.contains(user.id)) {
        uniqueUserIds.add(user.id);
        uniqueUsers.add(user);
      } else {
        await ProxyService.strategy.delete(id: user.id, endPoint: 'tenant');
      }
    }

    _tenants = [...uniqueUsers];
    notifyListeners();
  }

  /// keyboard events handler

  void handleKeyBoardEvents({required KeyEvent event}) {
    final DialogService _dialogService = locator<DialogService>();

    if (event.logicalKey == LogicalKeyboardKey.f9) {
      print("F9 is pressed");
      // Add your F9 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.f10) {
      print("F10 is pressed");
      // Add your F10 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.f12) {
      print("F12 is pressed");
      // Add your F12 key handling logic here
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      print("Escape key is pressed");
      _dialogService.showCustomDialog(
        variant: DialogType.logOut,
        title: 'Log out',
      );
    }
  }
}
