import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/views/open_close_drawerview.dart';
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
    final id = Uuid().v1();
    _databaseService.insert(id: id, data: {
      'float': float,
      'id': id,
      'table': AppTables.drawerHistory,
      'businessState': businessState == BusinessState.OPEN ? 'Open' : 'Close',
      'note': note,
      'businessId': ProxyService.sharedState.business.id,
      'userId': vm.user.id.toString(),
      'channels': [vm.user.id.toString()],
      'uid': Uuid().v1()
    });
    await openCloseBusiness(
      businessId: ProxyService.sharedState.business.id,
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
    final Document document = _databaseService.getById(id: userId + '2');
    document.properties['isClosed'] = isClosed;
    _databaseService.update(document: document);
  }
}
