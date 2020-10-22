
import 'package:flipper/model/variation.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';

class SupplierViewmodel extends BaseModel {
  final Logger log = Logging.getLogger('category observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Variation> _variation;
  List<Variation> get data => _variation;

  void getVariants({BuildContext context, @required String productId}) {
    setBusy(true);

    log.i('loading variation of ProductId:' + productId);
    _databaseService
        .observer(
            equator: AppTables.variation +
                StoreProvider.of<AppState>(context).state.branch.id,
            property: 'table',
            and: true,
            andProperty: 'productId',
            andEquator: productId)
        .stream
        .listen((ResultSet event) {
      // _variation = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Variation> list = <Variation>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(Variation.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}
