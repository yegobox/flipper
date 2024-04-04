import 'package:flipper_models/isar/random.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flutter/services.dart';

class FlipperBaseModel extends ReactiveViewModel {
  final DialogService _dialogService = locator<DialogService>();

  final _routerService = locator<RouterService>();
  void openDrawer() {
    Drawers drawer = Drawers(
      id: randomString(),
      openingBalance: 0.0,
      closingBalance: 0.0,
      cashierId: ProxyService.box.getBusinessId()!,
      tradeName: ProxyService.app.business!.name,
      openingDateTime: DateTime.now().toIso8601String(),
      open: true,
    );

    _routerService.navigateTo(DrawerScreenRoute(open: "open", drawer: drawer));
  }

  List<ITenant> _tenants = [];
  List<ITenant> get tenants => _tenants;

  Future<void> loadTenants() async {
    List<ITenant> users = await ProxyService.isar
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    _tenants = [...users];
    rebuildUi();
  }

  /// keyboard events handler

  void handleKeyBoardEvents({required KeyEvent event}) {
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
