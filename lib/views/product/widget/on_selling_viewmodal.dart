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
    print(productId);
    setBusy(true);

    final docs = Query(_databaseService.db,
        'SELECT variants.name,variants.id,variants.sku,variants.unit,stocks.retailPrice FROM variants JOIN stocks ON variants.productId=stocks.productId WHERE variants.table=\$VALUE AND variants.productId=\$PID');

    docs.parameters = {'VALUE': AppTables.variation, 'PID': productId};
    docs.addChangeListener((List results) {
      for (Map map in results) {
        if (map.length == 5) {
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
    // get item from order variable
    // get the stock and save new stock
    final q = Query(_databaseService.db,
        'SELECT id,value,branchId,variantId,isActive,canTrackingStock,productId,lowStock,currentStock,supplyPrice,retailPrice,showLowStockAlert,channels,table WHERE table=\$T AND variantId=\$VID');

    q.parameters = {'T': AppTables.stock, 'VID': _variantStock[0].id};
    q.addChangeListener((List results) {
      for (Map map in results) {
        //get the sock and update it
        final Document stockDocument =
            _databaseService.getById(id: Stock.fromMap(map).id);
        final double value = stockDocument.properties['value'].asDouble;

        stockDocument.properties['currentStock'].asDouble;
        // FIXME: use currentStock to check quantity of item remain in stock instead of value
        // update other code when adding stock on variant to reflect the changes
        stockDocument.properties['value'] = value - _quantity;
        _databaseService.update(document: stockDocument);
        //create a new order and perist it to the database....
        final id = Uuid().v1();
        _databaseService.insert(id: id, data: {
          'curreny': 'RWF',
          'orderNumber': Uuid().v1().substring(0, 4),
          'reference': Uuid().v1().substring(0, 4),
          'branchId': sharedStateService.branch.id,
          'orderItems': [],
          'isDraft': true,
          'active': true,
          'orderType': 'sales',
          'cashReceived': 0.0,
          'customerChangeDue': 0.0,
          'table': AppTables.order,
          'variantId': _variantStock[0].id,
          'price': _variantStock[0].retailPrice,
          'taxAmount':
              0.0, //FIXME: fix to the right amount of tax given to setting
          'stockId': Stock.fromMap(map).id,
          'channels': [sharedStateService.user.id.toString()],
          'subTotal': _amountTotal
        });
      }
    });
  }
}
