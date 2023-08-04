import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/mocks.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_models/isar_models.dart';

/// there is a case we need to force some data to be added for a given user
/// this is the class to help with that.

class ForceDataEntryService {
  final appService = locator<AppService>();
  void dataBootstrapper() {
    addData();
  }

  Future<void> addData() async {
    int? branchId = ProxyService.box.getBranchId();

    if (branchId == null) {
      return;
    }
    int businessId = ProxyService.box.getBusinessId()!;

    List<Product> products =
        await ProxyService.isar.products(branchId: branchId);
    if (products.isEmpty) {
      await ProxyService.isar.createProduct(
          product: Product(
              name: "Custom Amount",
              action: 'create',
              businessId: businessId,
              color: "#e74c3c",
              branchId: branchId)
            ..color = "#e74c3c"
            ..branchId = branchId
            ..businessId = businessId);
    }
    final List<String> colors = [
      '#d63031',
      '#0984e3',
      '#e84393',
      '#2d3436',
      '#6c5ce7',
      '#74b9ff',
      '#ff7675',
      '#a29bfe'
    ];

    final PColor color = PColor(
        id: syncIdInt(),
        colors: colors,
        branchId: branchId,
        action: AppActions.create,
        name: "#d63031",
        active: false);

    int branchid = ProxyService.box.getBranchId()!;
    List<PColor> kColors = await ProxyService.isar.colors(branchId: branchid);
    if (kColors.isEmpty) {
      await ProxyService.isar.create<PColor>(data: color);
    }
    List<IUnit> kUnits = await ProxyService.isar.units(branchId: branchid);

    //now create default units for this branch
    final units = IUnit()
      ..name = 'Per Kilogram (kg)'
      ..value = 'kg'
      ..active = false
      ..id = DateTime.now().millisecondsSinceEpoch
      ..units = mockUnits
      ..branchId = branchId;
    if (kUnits.isEmpty) {
      await ProxyService.isar.addUnits(data: units);
    }
  }
}
