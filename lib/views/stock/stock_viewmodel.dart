import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
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
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};
    return q.execute();
  }

  String _variantId;
  String get variantId {
    return _variantId;
  }

  void loadStockById({BuildContext context, String productId}) async {
    setBusy(true);

    log.d('loading stock with productId: ' + productId);

    // final List<dynamic> variants = await _databaseService(productId: productId);
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};

    final variants = q.execute();
    if (variants.isNotEmpty) {
      for (Map map in variants) {
        map.forEach((key, value) {
          _variantId = Variation.fromMap(value).id;
        });
        notifyListeners();
      }

      final q = Query(_databaseService.db,
          'SELECT * WHERE table=\$VALUE AND variantId=\$VARIANTID');

      q.parameters = {'VALUE': AppTables.stock, 'VARIANTID': variantId};

      q.addChangeListener((List results) {
        for (Map map in results) {
          map.forEach((key, value) {
            _stocks.add(Stock.fromMap(value));
          });
          notifyListeners();
        }
      });
    }
  }
}
