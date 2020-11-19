import 'dart:async';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:redux/redux.dart';

// ignore: avoid_classes_with_only_static_members
class DataManager {
  @deprecated
  static Future<void> updateVariation({
    Variation variation,
    Store<AppState> store,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    final DatabaseService _databaseService = ProxyService.database;
    if (variation != null) {
      final Document stock = _databaseService.getById(id: variation.id);

      final Document variant = _databaseService.getById(id: variation.id);

      variant.properties['name'] = variantName;

      _databaseService.update(document: variant);

      stock.properties['retailPrice'] = retailPrice;
      stock.properties['supplyPrice'] = supplyPrice;

      _databaseService.update(document: stock);
    }
  }

  // ignore: always_declare_return_types
  static updateOrder(Store<AppState> store, Order order) {
    // FIXME:
    // store.state.database.orderDao.updateOrder(order);
  }

  static Future<void> deleteProduct(
      {Store<AppState> store, String productId}) async {
    // FIXME:
    // final List<StockTableData> stocks = await store.state.database.stockDao
    //     .getStockByProductId(
    //         branchId: store.state.branch.id, productId: productId);
    // final ProductTableData product = await store.state.database.productDao
    //     .getProductById(productId: productId);

    // for (int i = 0; i < stocks.length; i++) {
    //   final VariationTableData variant = await store.state.database.variationDao
    //       .getVariationById(variantId: stocks[i].variantId);

    //   await store.state.database.variationDao.deleteVariation(variant);

    //   await store.state.database.stockDao.deleteStock(stocks[i]);
    // }

    // await store.state.database.productDao.deleteItem(product);

    // AppDatabase.instance.syncLocalToRemote(store: store);
  }

  // ignore: always_declare_return_types
  static createTemporalOrder(
      Store<AppState> store) async {
    // final Order order =
        // await generalRepository.createDraftOrderOrReturnExistingOne(store);

    //broadcast order to be used later when creating a sale
    // if (order != null) {
    //   store.dispatch(
    //     OrderCreated(
    //       order: order,
    //     ),
    //   );
    // }
  }
}
