import 'dart:async';
import 'dart:io';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/core_db.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/upload_response.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import 'logger.dart';

// ignore: avoid_classes_with_only_static_members
class DataManager {
  //updatable variables
  static double retailPrice = 0.0;
  static double supplyPrice = 0.0;
  static String description;
  static String sku;
  static String name;
    

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

      final Document stock = await _databaseService.getById(id:variation.id);

      final Document variant = await _databaseService.getById(id:variation.id);
     
      variant.toMutable()
      .setString('name',variantName);
      _databaseService.update(document: variant);

      stock.toMutable()
      .setDouble('retailPrice',retailPrice)
      .setDouble('supplyPrice',supplyPrice);
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
      GeneralRepository generalRepository, Store<AppState> store) async {
    final Order order =
        await generalRepository.createDraftOrderOrReturnExistingOne(store);

    //broadcast order to be used later when creating a sale
    if (order != null) {
      store.dispatch(
        OrderCreated(
          order: order,
        ),
      );
    }
  }

  static void dispatchCurrentTmpItem(
      Store<AppState> store, Product product, String productName,String userId) async {
    final DatabaseService _databaseService = ProxyService.database;
    // ignore: always_specify_types
    final List<Map<String, dynamic>> v = await _databaseService.filter(
      equator: productName,
      property: 'name',
      and: true,
      andEquator: product.id,
      andProperty: 'productId',
    );
    Variation variant;
    if (v.isEmpty) {
      final String id = Uuid().v1();
      _databaseService.insert(id: id, data: {
        'name': 'Regular',
        'id': id,
        'channels':[userId],
        'productId': product.id,
        'table': AppTables.variation
      });

      final List<Map<String, dynamic>> vv = await _databaseService.filter(
        equator: 'Regular',
        property: 'name',
        and: true,
        andEquator: product.id,
        andProperty: 'productId',
      );
      variant = Variation.fromMap(vv[0][CoreDB.instance.dbName]);
    } else {
      
      variant = Variation.fromMap(v[0][CoreDB.instance.dbName]);
    }
    store.dispatch(
      VariationAction(variation: variant),
    );
    return dispatchProduct(store, product);
  }

  static dynamic dispatchProduct(Store<AppState> store, Product product) {
    return store.dispatch(
      TempProduct(
        product: product,
      ),
    );
  }

  static Future<void> insertProduct(
      Store<AppState> store, Product data) async {}
}
