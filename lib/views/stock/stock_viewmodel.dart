import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:logger/logger.dart';

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

  void updateStock({String variantId}) {
    //the Id we get we are sure it stands for variant no need to run complicated query!
    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND variantId=\$VID');
    q.parameters = {'VALUE': AppTables.stock, 'VID': variantId};

    q.addChangeListener((List results) {
      for (Map map in results) {
        map.forEach((key, value) {
          final Document variantDocument =
              _databaseService.getById(id: Stock.fromMap(value).id);

          variantDocument.properties['value'] = stockValue;
          if (stockValue > 0) {
            variantDocument.properties['canTrackingStock'] = true;
            variantDocument.properties['showLowStockAlert'] = true;
          }

          _databaseService.update(document: variantDocument);
        });
      }
    });
  }

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
            if (!_stocks.contains(Stock.fromMap(value))) {
              _stocks.add(Stock.fromMap(value));
            }
          });
        }
        notifyListeners();
      });
    }
  }
}
