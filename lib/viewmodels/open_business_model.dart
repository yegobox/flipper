import 'package:flipper/core_db.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/ui/open_close_drawerview.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
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

    await _databaseService.insert(data: {
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
    final Document document =
        await CoreDB.instance.database.document(userId);

    final Map<String, dynamic> buildMap = {
      'table': AppTables.switchi,
      'name': name,
      'isClosed': isClosed,
      'isSocial': isSocial,
      'businessId': businessId,
      // ignore: always_specify_types
      'channels': [userId]
    };
    if (document == null) {
      try {
        final MutableDocument newDoc =
            MutableDocument(id: userId, data: buildMap);
        await CoreDB.instance.database.saveDocument(newDoc);
        // ignore: empty_catches
      } on PlatformException {}
    } else {
      final MutableDocument mutableDoc =
          document.toMutable().setBoolean('isClosed', isClosed);
      CoreDB.instance.database.saveDocument(mutableDoc);
    }
  }
}
