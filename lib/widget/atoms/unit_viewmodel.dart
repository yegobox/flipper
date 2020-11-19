import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/utils/constant.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';

class UnitViewModel extends BaseModel {
  final Logger log = Logging.getLogger('unit:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Unit> _unit;
  List<Unit> get data => _unit;

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void getProducts({BuildContext context}) {
    setBusy(true);

    log.i('loading category of branchId:' +
        StoreProvider.of<AppState>(context).state.branch.id);

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.unit};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          _unit.add(Unit.fromMap(value));
        });
        setBusy(false);
        notifyListeners();
      }
    });
  }
}
