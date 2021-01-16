import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/views/open_close_drawerview.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flipper_services/proxy.dart';

import 'package:uuid/uuid.dart';
import 'base_model.dart';

class OpenBusinessModel extends BaseModel {
  final DatabaseService _databaseService = ProxyService.database;
  final FlipperNavigationService _flipperNavigationService = ProxyService.nav;

  final Logger log = Logging.getLogger('Open Business model....');

  Future<void> openBusiness({
    double float,
    String note,
    BusinessState businessState,
    BuildContext context,
    CommonViewModel vm,
  }) async {
    setBusy(true);

    _databaseService.insert(data: {
      'float': float,
      'table': AppTables.drawerHistory,
      'businessState': businessState == BusinessState.OPEN ? 'Open' : 'Close',
      'note': note,
      'businessId': vm.currentBusiness.id,
      'userId': vm.user.id.toString(),
      // ignore: always_specify_types
      'channels': [vm.user.id.toString()],
      'uid': Uuid().v1()
    });
    await openCloseBusiness(
      businessId: vm.currentBusiness.id,
      userId: vm.user.id.toString(),
      isSocial: false,
      name: vm.user.name,
      isClosed: false,
    );

    _flipperNavigationService.navigateTo(Routing.dashboard);

    setBusy(false);
  }

  Future<void> openCloseBusiness({
    String userId,
    String name,
    bool isSocial = false,
    String businessId,
    bool isClosed = true,
  }) async {
    // FIXME: fix this query to look for where there is open drawer for this user
    final Document document = _databaseService.getById(id: userId);

    final Map<String, dynamic> buildMap = {
      'table': AppTables.switchi,
      'name': name,
      'isClosed': isClosed,
      'isSocial': isSocial,
      'businessId': businessId,
      'channels': [userId]
    };
    if (document == null) {
      try {
        _databaseService.insert(data: buildMap);
        // ignore: empty_catches
      } on PlatformException {}
    } else {
      document.properties['isClosed'] = isClosed;
      _databaseService.update(document: document);
    }
  }
}
