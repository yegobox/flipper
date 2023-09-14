import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class FlipperBaseModel extends BaseViewModel {
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
}
