library flipper_services;

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:uuid/uuid.dart';

class KeyPadService with ReactiveServiceMixin {
  final RxValue<double> customAmount = RxValue<double>();
  final _sharedStateService = locator<SharedStateService>();
  double get getSum => customAmount.value;
  final DatabaseService _databaseService = ProxyService.database;
  void setCustomAmount({double customAmount}) {
    //on + button on keypad should create custom item and sell it with the given amount
    if (customAmount.abs() != 0) {
      final id1 = Uuid().v1();
      final Document productDoc = _databaseService.insert(id: id1, data: {
        'name': 'Custom Amount',
        'categoryId': '',
        'color': '#955be9',
        'id': id1,
        'active': true,
        'hasPicture': false,
        'channels': [_sharedStateService.user.id.toString()],
        'table': AppTables.product,
        'isCurrentUpdate': false,
        'isDraft': true,
        'taxId': '',
        'businessId': _sharedStateService.business.id,
        'branchId': _sharedStateService.branch.id,
        'description': 'Custom Amount',
        'createdAt': DateTime.now().toIso8601String(),
      });
      // create it's regular
      final variantId = Uuid().v1();
      final Document variation = _databaseService.insert(id: variantId, data: {
        'isActive': false,
        'name': 'Regular',
        'unit': 'kg',
        'channels': [_sharedStateService.user.id.toString()],
        'table': AppTables.variation,
        'productId': productDoc.ID,
        'sku': Uuid().v1().substring(0, 4),
        'id': variantId,
        'userId': _sharedStateService.user.id.toString(),
        'productName': 'Custom Amount',
        'createdAt': DateTime.now().toIso8601String(),
      });
      // create it's stock
      final id3 = Uuid().v1();

      final Document stockDoc = _databaseService.insert(id: id3, data: {
        'variantId': variantId,
        'supplyPrice': customAmount,
        'value': 0.0,
        'canTrackingStock': false,
        'showLowStockAlert': false,
        'retailPrice': customAmount,
        'channels': [_sharedStateService.user.id.toString()],
        'isActive': true,
        'table': AppTables.stock,
        'lowStock': 0.0,
        'currentStock': 0.0,
        'id': id3,
        'productId': productDoc.ID,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });
      // create order for this custom amount.
      //get pending order
      final Order order = pendingOrder(customAmount: customAmount);
      // we now have order to use. create stock history for this custom Amount
      final id5 = Uuid().v1();
      _databaseService.insert(id: id5, data: {
        'orderId': order.id,
        'variantId': variation.ID,
        'variantName': Variation.fromMap(variation.jsonProperties).name,
        'Note': 'Custom Amount',
        'updatedAt': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'stockId': stockDoc.ID,
        'channels': [_sharedStateService.user.id.toString()],
        'reason': 'SOLD',
        'table': AppTables.stockHistories,
        'quantity': 0.0,
        'cashReceived': customAmount,
        'cashCollected': customAmount,
        'id': id5,
        'customerChangeDue': 0.0
      });
    }
    // TODO: update stock Qty
  }

  Order pendingOrder({double customAmount}) {
    final q = Query(_databaseService.db,
        'SELECT  id , branchId , reference, draft ,active , orderType , orderNUmber , subTotal , double , taxAmount , cashReceived , saleTotal  , orderNote  , status  , variationId  , productName , channels , customerChangeDue WHERE table=\$T AND draft=\$DRAFT');
    q.parameters = {'T': AppTables.order, 'DRAFT': true};
    final od = q.execute();
    Order order;
    if (od.isEmpty) {
      final id4 = Uuid().v1();
      final id5 = Uuid().v1();
      final Document ordr = _databaseService.insert(id: id4, data: {
        'reference': id4.substring(0, 4),
        'orderNUmber': id5.substring(0, 5),
        'status': 'pending',
        'orderType': 'mobile',
        'active': true,
        'draft': true,
        'channels': [_sharedStateService.user.id.toString()],
        'subTotal': customAmount,
        'table': AppTables.order,
        'cashReceived': customAmount,
        'customerChangeDue': 0.0,
        'id': id4,
        'branchId': _sharedStateService.branch.id,
        'createdAt': DateTime.now().toIso8601String(),
      });
      order = Order.fromMap(ordr.jsonProperties);
      return order;
    } else {
      order = Order.fromMap(od[0]);
      return order;
    }
  }
}
