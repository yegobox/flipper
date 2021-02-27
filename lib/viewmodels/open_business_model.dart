import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/views/open_close_drawerview.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flipper_services/proxy.dart';

import 'base_model.dart';

class OpenBusinessModel extends BaseModel {
  final DatabaseService _databaseService = ProxyService.database;
  final FlipperNavigationService _flipperNavigationService = ProxyService.nav;
  final state = locator<SharedStateService>();

  final Logger log = Logging.getLogger('Open:');

  Future<void> openBusiness({
    double float,
    String note,
    BusinessState businessState,
    BuildContext context,
    @required historyId,
  }) async {
    await closingDrawerState(
        businessId: ProxyService.sharedState.business.id,
        userId: state.user.id.toString(),
        isSocial: false,
        name: state.user.name,
        businessState: businessState,
        historyId: historyId);
    _flipperNavigationService.navigateTo(Routing.switchView);
  }

  Future<void> closingDrawerState({
    //aka switcher.
    String userId,
    String name,
    double float,
    bool isSocial = false,
    String businessId,
    BusinessState businessState,
    @required historyId,
  }) async {
    if (businessState == BusinessState.OPEN) {
      print(historyId);
      final Document document = _databaseService.getById(id: historyId);
      document.properties['openingHour'] = true;
      document.properties['openingFloat'] = float;
      print(document.jsonProperties);
      _databaseService.update(document: document);
    } else {
      final Document document = _databaseService.getById(id: historyId);
      document.properties['openingHour'] = false;
      document.properties['closingFloat'] = float;
      _databaseService.update(document: document);
    }
  }
}
