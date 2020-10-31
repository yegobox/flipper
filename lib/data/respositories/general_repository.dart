import 'package:flipper/core_db.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/services/proxy.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class GeneralRepository {

  Future<bool> insertOrUpdateCart(
      Store<AppState> store, Map data, int quantity) async {
    // get the oder for this variationId
    final List<Map<String, dynamic>> existingCart =
        await ProxyService.database.filter(
      property: 'variantId',
      equator: data['variationId'],
    );

    if (existingCart.isEmpty) {
      ProxyService.database.insert(data: {
        'quantity': quantity,
        'subTotal': data['subTotal'],
        'id': data['id'],
        'channels': [store.state.user.id.toString()],
        'table': AppTables.order,
        'taxAmount': data['taxAmount'],
        'taxRate': data['taxRate'], //get the current active tax rate
        'unit': data['unit'], //get unit of this item sold should hav it.
        'note': data['note'], //keep it lik this.
        'discountAmount': data['discountAmount'],
        'discountRate': data['discountRate'],
        'updatedAt': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } else {
      // keep order fresh
      final Order order = Order.fromMap(existingCart[0]['main']);
      final Document orderDoc =
          await ProxyService.database.getById(id: order.id);
      orderDoc
          .toMutable()
          .setString('createdAt', DateTime.now().toIso8601String())
          .setString('updatedAt', DateTime.now().toIso8601String());
      return true;
    }
  }

 

  Future<Order> createDraftOrderOrReturnExistingOne(
      Store<AppState> store) async {
    final DatabaseService _databaseService = ProxyService.database;
    final List<Map<String, dynamic>> or = await _databaseService.filter(
      equator: 'draft',
      property: 'name',
      and: true,
      andProperty: 'table',
      andEquator: AppTables.order,
    );
    if (or.isEmpty) {
      final String id = Uuid().v1();
      _databaseService.insert(id: id, data: {
        'name': 'draft',
        'id': id,
        'branchId': store.state.branch.id,
        'table': AppTables.order,
        'channels': [store.state.user.id.toString()]
      });

      final List<Map<String, dynamic>> or = await _databaseService.filter(
        equator: 'draft',
        property: 'name',
        and: true,
        andProperty: 'table',
        andEquator: AppTables.order,
      );

      final Order order = Order.fromMap(or[0][CoreDB.instance.dbName]);
      dispatchOrder(store, order);
      return order;
    } else {
      final Order order = Order.fromMap(or[0][CoreDB.instance.dbName]);
      dispatchOrder(store, order);
      return order;
    }
  }

  Future<bool> updateCategory(Store<AppState> store, String categoryId,
      String categoryName, String branchId,
      {bool focused}) async {
    final DatabaseService _databaseService = ProxyService.database;
    final Document cat = await _databaseService.getById(id: categoryId);
    if (cat != null) {
      cat
          .toMutable()
          .setString('name', categoryName)
          .setString('branchId', branchId)
          .setString('updatedAt', DateTime.now().toIso8601String())
          .setBoolean('focused', focused);
      return await _databaseService.update(document: cat);
    }
    return false;
  }



  Future<int> insertCategory(Store<AppState> store, Category category) async {
    // FIXME(richard): I am not sure if this is still in use.
    // CategoryTableData existingCategory =
    //     await store.state.database.categoryDao.getCategoryName(category.name);
    // if (existingCategory == null) {
    //   return store.state.database.categoryDao.insert(category);
    // }
    // store.state.database.categoryDao
    //     .updateCategory(category.copyWith(updatedAt: DateTime.now()));
    // existingCategory =
    //     await store.state.database.categoryDao.getCategoryName(category.name);
    // return existingCategory.idLocal;
  }

  Future<void> insertVariant(Store<AppState> store, Variation data) async {
    final DatabaseService _databaseService = ProxyService.database;
    _databaseService.insert(id: Uuid().v1(), data: data.toMap());
  }
}

Future<void> insertHistory(Store<AppState> store, int variantId, int count) {
  final DatabaseService _databaseService = ProxyService.database;
  // TODO(richard): inset a history here.
  // return store.state.database.stockHistoryDao
  //     // ignore: missing_required_param
  //     .insert(StockHistoryTableData(quantity: count, variantId: variantId));
}

Future<bool> updateOrder(Store<AppState> store, Order order) async {
  // return await store.state.database.orderDao.updateOrder(order);
}

Future<Order> getOrder(Store<AppState> store, String orderId) async {
  // FIXME(richard): I am not sure if this is still in use.
  // return await store.state.database.orderDao.getOrderById(orderId);
}

Future<Variation> getVariationById(
    Store<AppState> store, String variantId) async {
  // return await store.state.database.variationDao.getVariationById(variantId);
  // FIXME(richard): I am not sure if this is still in use.
}

Future<void> insertNewDraftOrder(Store<AppState> store) async {
  if (store.state.branch != null) {
    // FIXME(richard): I am not sure if this is still in use.
    // return await store.state.database.orderDao.insert(
    //   //ignore: missing_required_param
    //   OrderTableData(
    //     status: 'draft',
    //     branchId: store.state.branch.id,
    //     id: Uuid().v1(),
    //     currency: 'RWF',
    //     deviceId: Uuid().v1(),
    //     orderDate: DateTime.now(),
    //     isDraft: true,
    //     orderType: 'sales',
    //     reference: Uuid().v1(),
    //     cashReceived: 0,
    //     customerChangeDue: 0,
    //     customerSaving: 0,
    //     deliverDate: DateTime.now(),
    //     discountAmount: 0,
    //     discountRate: 0,
    //     orderNote: 'none',
    //     variantName: 'custom',
    //     count: 1,
    //     orderNUmber: 0,
    //     paymentId: 0,
    //     saleTotal: 0,
    //     subTotal: 0,
    //     supplierId: 0,
    //     supplierInvoiceNumber: 0,
    //     taxAmount: 0,
    //     taxRate: 0,
    //     // userId: store.state.user.id,
    //   ),
    // );
  }
}

void dispatchOrder(Store<AppState> store, Order order) {
  return store.dispatch(OrderCreated(
    order: order,
  ));
}
