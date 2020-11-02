import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/stock.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

// comment
class StockViewModel extends BaseModel {
  final Logger log = Logging.getLogger('stocks observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  final List<Stock> _stocks = <Stock>[];
  List<Stock> get stock => _stocks;

  Future<List<Map<String, dynamic>>> geetVariantsBy({String productId}) async {
    final List<Map<String, dynamic>> variants = await _databaseService.filter(
      equator: AppTables.variation,
      property: 'table',
      and: true, //define that this query is and type.
      andEquator: productId,
      andProperty: 'productId',
    );
    return variants;
  }

  void loadStockById({BuildContext context, String productId}) async {

    setBusy(true);

    log.d('loading stock with productId: ' + productId);

    final List<dynamic> variants = await geetVariantsBy(productId: productId);

    if (variants.length == 1) { 
     
      _databaseService
          .observer(
              equator: AppTables.stock,
              property: 'table',
              and: true,
              andEquator: Variation.fromMap(variants[0]['main']).id, 
              andProperty: 'variantId')
          .stream
          .listen((ResultSet event) {
        
        final List<Map<String, dynamic>> model = event.map((Result result) {
          return result.toMap();
        }).toList();

        // remove unnecessarry nesting "main"appended on each map value
        for (Map<String, dynamic> map in model) {
          map.forEach((String key, value) {
            _stocks.add(Stock.fromMap(value));
          });
        }

        notifyListeners();

        setBusy(false);
      });
    }
  }
}
