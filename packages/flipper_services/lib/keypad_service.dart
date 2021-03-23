library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:uuid/uuid.dart';

enum ITEM { ITEMNAME, ITEMPRICE }

class KeyPadService with ReactiveServiceMixin {
  final _state = locator<SharedStateService>();
  final RxValue<Order> order = RxValue<Order>(initial: null);
  Order get currentSales => order.value;

  final Logger log = Logging.getLogger('O2:)');
  final RxValue<double> _totalAmount = RxValue<double>();
  double get totalAmount => _totalAmount.value;

  final List<Map> currentSale = [];
  List<Map> get currentSalesItem => currentSale;

  final RxValue<double> cash = RxValue<double>(initial: 0.0);
  double get cashReceived => cash.value;

  final DatabaseService _db = ProxyService.database;

  /// create new order,this method assume a cashier is still in progress of taking order
  /// then the amount passed assume that we are dealing with custom item
  /// if the takeNewOrder is not passed it will keep updating the current active and draft order
  void sellCustomAmount(
      {double customAmount = 0.0, bool takeNewOrder = false}) {
    // TODO: this was useful when a user did not have a custom item
    // _db.createCustomItem(
    //     branchId: _state.branch.id,
    //     userId: _state.user.id,
    //     businessId: _state.business.id);
    final Document variation = _db.getCustomProductVariant();

    final String stockId = _db.getStockIdGivenProductId(
        variantId: Variation.fromMap(variation.jsonProperties).id);

    pendingOrder(
        customAmount: customAmount,
        stockId: stockId,
        variation: Variation.fromMap(variation.jsonProperties));
    order.listen((order) {
      if (order != null && order.active && order.draft && !takeNewOrder) {
        final Document orderDocument = _db.getById(id: order.id);
        orderDocument.properties['cashReceived'] = customAmount;
        _db.update(document: orderDocument);
        _totalAmount.value = customAmount;
        notifyListeners();
        return;
      }
    });
  }

  Order createOrder(
      {double customAmount,
      Variation variation,
      String stockId,
      String orderType = 'custom'}) {
    final id4 = Uuid().v1();
    final Document ordr = _db.insert(id: id4, data: {
      'reference': id4.substring(0, 4),
      'orderNUmber': id4.substring(0, 5),
      'status': 'pending',
      'variantId': variation.id,
      'variantName': variation.name,
      'orderType': orderType,
      'active':
          true, //used to check if order is parked becomes parked when false.
      'draft': true,
      'channels': [_state.user.id.toString()],
      'subTotal': customAmount,
      'table': AppTables.order,
      'cashReceived': customAmount,
      'customerChangeDue': 0.0,
      'id': id4,
      'stockId': stockId,
      'branchId': _state.branch.id,
      'createdAt': DateTime.now().toIso8601String(),
    });
    order.value = Order.fromMap(ordr.jsonProperties);
    return order.value;
  }

  /// the pending order will return the existing order if draft and active are still true otherwise
  /// wise it will create a new active & draft order.
  /// Also it is very important to treat order as an item added to the
  void pendingOrder(
      {double customAmount, String stockId, Variation variation}) {
    final q = Query(_db.db,
        'SELECT  id , branchId ,variantId,stockId,variantName, reference, draft ,active , orderType , orderNUmber , subTotal , double , taxAmount , cashReceived , saleTotal  , orderNote  , status  , variationId  , productName , channels , customerChangeDue WHERE table=\$T AND draft=\$DRAFT AND  orderType=\$OT');
    q.parameters = {'T': AppTables.order, 'DRAFT': true, 'OT': 'custom'};

    q.addChangeListener((List results) {
      if (results.isEmpty) {
        createOrder(
            stockId: stockId,
            variation: variation,
            customAmount: customAmount,
            orderType: 'custom');
        notifyListeners();
      } else {
        order.value = Order.fromMap(results[0]);
        notifyListeners();
      }
    });
  }

  void updateStock({String stockId, double quantity}) {
    final Document stock = ProxyService.database.getById(id: stockId);
    stock.properties['currentStock'] =
        stock.properties['currentStock'].asDouble - quantity;
    ProxyService.database.update(document: stock);
  }

  void cleanKeypad() {
    ProxyService.sharedState.clear.listen((e) {
      if (ProxyService.database.db != null) {
        final q = Query(ProxyService.database.db,
            'SELECT  id  WHERE table=\$T AND status=\$S');
        q.parameters = {'T': AppTables.order, 'S': 'pending'};
        final results = q.execute();
        if (results.isNotEmpty) {
          for (Map id in results) {
            ProxyService.database.delete(id: id['id']);
          }
        }
        notifyListeners();
      }
    });
  }
}
