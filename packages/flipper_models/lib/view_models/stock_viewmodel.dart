import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'Queries.dart';
import 'base_model.dart';

class StockViewModel extends BaseModel {
  final Logger log = Logging.getLogger('stocks observer:)');
  final DatabaseService _databaseService = ProxyService.database;
  final List<Stock> _stocks = <Stock>[];
  List<Stock> get stock => _stocks;
  double stockValue;

  void setStockValue({double value}) async {
    stockValue = value;
    notifyListeners();
  }

  /// update stock related to the given variantId
  void updateStock({String variantId}) {
    //the Id we get we are sure it stands for variant no need to run complicated query!
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND variantId=\$VID');
    q.parameters = {'VALUE': AppTables.stock, 'VID': variantId};

    q.addChangeListener((results) {
      for (Map map in results.allResults) {
        map.forEach((key, value) {
          final Document variantDocument =
              _databaseService.getById(id: Stock.fromMap(value).id);

          variantDocument.properties['currentStock'] = stockValue;
          if (stockValue > 0) {
            variantDocument.properties['canTrackingStock'] = true;
            variantDocument.properties['showLowStockAlert'] = true;
          }

          _databaseService.update(document: variantDocument);
        });
      }
    });
  }

  Future<ResultSet> getVariantsBy({String productId}) async {
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$PRODUCTID');

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};
    return q.execute();
  }

  String _variantId;
  String get variantId {
    return _variantId;
  }

  /// load stock of the given productId and update [stocks array]
  /// This is the most heavy Query since we need to query each product and get related stock
  void loadStockByProductId({BuildContext context, String productId}) async {
    final q = Query(_databaseService.db, Queries.Q_1);

    q.parameters = {'VALUE': AppTables.variation, 'PRODUCTID': productId};
    final variants = q.execute();

    for (Map map in variants.allResults) {
      _variantId = Variation.fromMap(map).id;
    }

    final qq = Query(_databaseService.db, Queries.Q_2);

    qq.parameters = {'VALUE': AppTables.stock, 'VARIANTID': variantId};

    qq.addChangeListener((results) {
      for (Map map in results.allResults) {
        if (!_stocks.contains(Stock.fromMap(map))) {
          _stocks.add(Stock.fromMap(map));
        }
      }
      notifyListeners();
    });
  }
}
