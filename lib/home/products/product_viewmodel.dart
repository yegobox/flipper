
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/util/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:logger/logger.dart';


class ProductViewModel extends BaseModel {
  final Logger log = Logging.getLogger('product observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  List<Product> _products;
  List<Product> get data => _products;


  void getProducts({BuildContext context}) {
    setBusy(true);
    

    //demo of listening on users table on every entry.
    _databaseService
        .observer(equator: AppTables.product + StoreProvider.of<AppState>(context).state.branch.id, property: 'tableName')
        .stream
        .listen((ResultSet event) {
      // _products = event.allResults();
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
