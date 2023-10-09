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
    Drawers? drawer = Drawers()
      ..cashierId = ProxyService.box.getBusinessId()!
      ..closingBalance = 0
      ..tradeName = ProxyService.app.business.name
      ..nsSaleCount = 0
      ..trSaleCount = 0
      ..psSaleCount = 0
      ..incompleteSale = 0
      ..totalCsSaleIncome = 0
      ..totalNsSaleIncome = 0
      ..csSaleCount = 0
      ..nrSaleCount = 0
      ..openingDateTime = DateTime.now().toIso8601String()
      ..open = true;
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
  void handleKeyBoardEvents({required RawKeyDownEvent event}) {
    // Check for F9, F10, and F12 keys
    if (event.data is RawKeyEventDataWindows) {
      final windowsData = event.data as RawKeyEventDataWindows;
      if (windowsData.keyCode == 120) {
        // F9 key (key code 120)
        print("F9 is pressed");
      } else if (windowsData.keyCode == 121) {
        // F10 key (key code 121)
        print("F10 is pressed");
      } else if (windowsData.keyCode == 123) {
        // F12 key (key code 123)
        print("F12 is pressed");
      } else if (windowsData.keyCode == 27) {
        // ESC key (key code 27)
        print("F12 is pressed");
        _dialogService.showCustomDialog(
          variant: DialogType.logOut,
          title: 'Log out',
        );
      }
    }
  }
}
