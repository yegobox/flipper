import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/unit.dart';

import 'package:flipper_models/unit_mock.dart';

/// there is a case we need to force some data to be added for a given user
/// this is the class to help with that.

class ForceDataEntryService {
  final log = getLogger('ForceDataEntryService');
  void caller() {
    if (ProxyService.remoteConfig.forceDateEntry()) {
      addData();
    }
  }

  Future<void> addData() async {
    // int? businessId = ProxyService.box.read(key: 'businessId');
    int? branchId = ProxyService.box.read(key: 'branchId');

    final String? userId = ProxyService.box.read(key: 'userId');
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

    final PColor color = new PColor(
      id: DateTime.now().millisecondsSinceEpoch,
      colors: colors,
      table: AppTables.color,
      channels: [userId!],
      active: false,
      fbranchId: branchId!,
      name: 'sample',
    );

    int branchid = ProxyService.box.read(key: 'branchId');
    List<PColor> kColors = await ProxyService.api.colors(branchId: branchid);
    if (kColors.isEmpty) {
      await ProxyService.api
          .create<PColor>(data: color.toJson(), endPoint: 'color');
    }
    List<Unit> kUnits = await ProxyService.api.units(branchId: branchid);

    //now create default units for this branch
    final units = new Unit(
      name: 'sample',
      value: 'kg',
      active: false,
      id: DateTime.now().millisecondsSinceEpoch,
      table: AppTables.unit,
      units: mockUnits,
      fbranchId: branchId,
      channels: [userId],
    );
    if (kUnits.isEmpty) {
      await ProxyService.api.addUnits(data: units.toJson());
    }
  }
}
