import 'package:flipper_models/mocks.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flipper_models/isar_models.dart';

/// there is a case we need to force some data to be added for a given user
/// this is the class to help with that.

class ForceDataEntryService {
  final log = getLogger('ForceDataEntryService');
  void caller() {
    addData();
  }

  Future<void> addData() async {
    int? branchId = ProxyService.box.read(key: 'branchId');

    if (branchId == null) {
      return;
    }

    final String? userId = ProxyService.box.getUserId();
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

    final PColor color = PColor()
      ..id = DateTime.now().millisecondsSinceEpoch
      ..colors = colors
      ..table = AppTables.color
      ..channels = [userId!]
      ..active = false
      ..branchId = branchId
      ..name = '#d63031';

    int branchid = ProxyService.box.read(key: 'branchId');
    List<PColor> kColors =
        await ProxyService.isarApi.colors(branchId: branchid);
    if (kColors.isEmpty) {
      await ProxyService.isarApi.create<PColor>(data: color, endPoint: 'color');
    }
    List<Unit> kUnits = await ProxyService.isarApi.units(branchId: branchid);

    //now create default units for this branch
    final units = Unit()
      ..name = 'Per Kilogram (kg)'
      ..value = 'kg'
      ..active = false
      ..id = DateTime.now().millisecondsSinceEpoch
      ..units = mockUnits
      ..branchId = branchId;
    if (kUnits.isEmpty) {
      await ProxyService.isarApi.addUnits(data: units);
    }
  }
}
