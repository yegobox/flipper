import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flipper/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:flipper_models/order.dart';

class OnProductSellingViewModal extends BaseModel {
  // NOTE: leason learned, never put anything that invoke ui for ex TextEditingController in viewmodel as it will make it hard to test the logic of viewmodel
  final DatabaseService _databaseService = ProxyService.database;
  final List<VariantStock> _variations = [];
  final List<VariantStock> _variantStock = [];
  List<VariantStock> get orders => _variantStock;
  List<VariantStock> get variations => _variations;
  final sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('OnSelling Product:)');

  double _quantity = 1;
  double get quantity {
    return _quantity;
  }

  double _amountTotal;
  double get amountTotal {
    return _amountTotal;
  }

  // ignore: prefer_final_fields
  double _paramsDefault = 0.0;
  double get paramsDefault {
    return _paramsDefault;
  }

  double _checked = 0;
  double get checked {
    return _checked;
  }

  // ignore: prefer_final_fields
  double _slider = 0;
  double get slider {
    return _slider;
  }

  void increaseQty() {
    _quantity++;
    _amountTotal = _paramsDefault + (_checked * _quantity);

    notifyListeners();
  }

  void decreaseQty() {
    if (_quantity != 1) _quantity--;
    _amountTotal = _paramsDefault + (_checked * _quantity);
    notifyListeners();
  }

  void updateAmountTotalDefault(
      {@required double value, @required VariantStock variant}) {
    _variantStock
        .clear(); //as we only want the focused variant to remain in what we perist on click of add button
    _variantStock.add(variant);
    _checked = value;
    _amountTotal = paramsDefault + _checked;
    notifyListeners();
  }

  void slide({@required double value}) {
    _slider = value;
    notifyListeners();
  }

  // on increment of the Quantity of any stock item then create a new entry for order (order details)
  // if the increment return to 0 then delete entry as there is no need of having the same entry in order records
  // the order should keep  the qty of ordered item, the stock id of ordered item
  // on finalizing the order should decrement the sock value to given ordered qty.
  void loadVariants({String productId}) {
    setBusy(true);

    final docs = Query(_databaseService.db,
        'SELECT variants.name,products.name as productName, variants.id,variants.sku,variants.unit,stocks.retailPrice FROM variants JOIN stocks ON variants.productId=stocks.productId JOIN products ON variants.productId=products.id WHERE variants.table=\$VALUE AND variants.productId=\$PID');

    docs.parameters = {'VALUE': AppTables.variation, 'PID': productId};
    docs.addChangeListener((List stocks) {
      for (Map map in stocks) {
        if (map.length == 6) {
          //to avoid anomalitie caused by join query.
          if (!_variations.contains(VariantStock.fromMap(map))) {
            _variations.add(VariantStock.fromMap(map));
          }
        }
        setBusy(false);
        notifyListeners();
      }
    });
  }

  void saveOrder() {
    final q = Query(_databaseService.db,
        'SELECT id,value,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table WHERE table=\$T AND variantId=\$VID');

    q.parameters = {'T': AppTables.stock, 'VID': _variantStock[0].id};
    final stocks = q.execute();

    if (stocks.isNotEmpty) {
      if (amountTotal.abs() != 0) {
        final Order order =
            ProxyService.keypad.pendingOrder(customAmount: amountTotal);

        // TODO: udate order with bellow
        // 'cashReceived': amountTotal,
        // 'cashCollected': amountTotal
        final id5 = Uuid().v1();
        _databaseService.insert(id: id5, data: {
          'orderId': order.id,
          'variantId': _variantStock[0].id,
          'variantName': _variantStock[0].name,
          'Note': 'Custom Amount',
          'updatedAt': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'stockId': Stock.fromMap(stocks[0]).id,
          'channels': [ProxyService.sharedState.user.id.toString()],
          'reason': 'SOLD',
          'table': AppTables.stockHistories,
          'quantity': _quantity,
          'id': id5,
        });
      }
      ProxyService.keypad.updateStock(
          stockId: Stock.fromMap(stocks[0]).id, quantity: _quantity);
    }
  }
}
