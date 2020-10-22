
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:logger/logger.dart';

// comment
class StockViewModel extends BaseModel {
  final Logger log = Logging.getLogger('stock observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Stock> stocks;
  List<Stock> get data => stocks;


  void loadStockById({BuildContext context,String productId}) {
    setBusy(true);

    log.d('loading stock with productId:'+productId);
    //demo of listening on users table on every entry.
    _databaseService
        .observer(equator: AppTables.product, property: 'table')
        .stream
        .listen((ResultSet event) {
      // stocks = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();
      final List<Product> list = <Product>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          list.add(value);
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}
