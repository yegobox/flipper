


import 'package:flipper/model/product.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:couchbase_lite/couchbase_lite.dart';

class ProductViewModel extends BaseModel {
  final Logger log = Logging.getLogger('product observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  final List<Product> _products = <Product>[];
  List<Product> get data => _products;


  void getProducts({BuildContext context}) {
    setBusy(true);
    
    log.i('loading products');
    //demo of listening on users table on every entry.
    _databaseService
        .observer(equator: AppTables.product,property:'table')
        .stream
        .listen((ResultSet event) {
      // _products = event.allResults();
      final List<Map<String, dynamic>> model = event.map((Result result) {
        return result.toMap();
      }).toList();

      // final List<Product> list = <Product>[];
      // remove unnecessarry nesting "main"appended on each map value
      for (Map<String, dynamic> map in model) {
        // ignore: always_specify_types
        // ignore: always_specify_types
        map.forEach((String key, value) {
          log.i(value);
          _products.add(Product.fromMap(value));
        });
      }
      notifyListeners();

      setBusy(false);
    });
  }
}
