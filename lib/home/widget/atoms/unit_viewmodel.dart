
import 'package:flipper/model/unit.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';

class UnitViewModel extends BaseModel{
  final Logger log = Logging.getLogger('category observer:)');
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
    //demo of listening on users table on every entry.
    _databaseService
        .observer(
            equator: AppTables.unit +
                StoreProvider.of<AppState>(context).state.branch.id,
            property: 'table')
        .stream
        .listen((ResultSet event) {
      // _unit = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Unit> list = <Unit>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(Unit.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}