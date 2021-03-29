library flipper_models;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flipper/utils/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';

class OnProductSellingViewModal extends ReactiveViewModel {
  // NOTE: leason learned, never put anything that invoke ui for ex TextEditingController in viewmodel as it will make it hard to test the logic of viewmodel
  final DatabaseService _databaseService = ProxyService.database;
  final _keypad = locator<KeyPadService>();
  final List<VariantStock> _variations = [];
  final List<VariantStock> _variantStock = [];
  List<VariantStock> get orders => _variantStock;
  List<VariantStock> get variations => _variations;
  final sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('OnSelling Product:)');

  final DatabaseService _db = ProxyService.database;

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

  /// as we only want the focused variant to remain in what we perist on click of add button
  /// we clear the [_variantStock]
  void updateAmountTotalDefault(
      {@required double value, @required VariantStock variant}) {
    _variantStock.clear();
    _variantStock.add(variant);
    _checked = value;
    _amountTotal = paramsDefault + _checked;
    notifyListeners();
  }

  void slide({@required double value}) {
    _slider = value;
    notifyListeners();
  }

  /// on increment of the Quantity of any stock item then create a new entry for order (order details)
  /// if the increment return to 0 then delete entry as there is no need of having the same entry in order records
  /// the order should keep  the qty of ordered item, the stock id of ordered item
  /// on finalizing the order should decrement the sock value to given ordered qty.
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

  /// save order, this create a new order with orderType ${regular} does not use pending
  /// this is to avoid confusion with the existing order which can be
  /// a custom item in progress so it can be caunted as second order and differ from previouses orders
  void saveOrder({String variationId, double amount}) {
    final String stockId = _db.getStockIdGivenVariantId(variantId: variationId);

    final Document doc = _db.getById(id: variationId);

    _keypad.createOrder(
      customAmount: amount,
      useProductName: true,
      variation: Variation.fromMap(doc.jsonProperties),
      stockId: stockId,
      orderType: 'regular',
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_keypad];
}
