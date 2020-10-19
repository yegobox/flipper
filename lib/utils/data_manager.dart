import 'dart:async';
import 'dart:io';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/helper/constant.dart';
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

  static Future<void> startUploading(
      {String storagePath,
      String fileName,
      Store<AppState> store,
      String productId}) async {
    final FlutterUploader uploader = FlutterUploader();

    await uploader.enqueue(
        url: 'https://test.flipper.rw/api/upload',
        // ignore: always_specify_types
        files: [
          FileItem(
              filename: fileName, savedDir: storagePath, fieldname: 'image')
        ], // required: list of files that you want to upload
        method: UploadMethod.POST,
        // ignore: always_specify_types
        headers: {'Authorization': 'Bearer  ' + store.state.user.token},
        // ignore: always_specify_types
        data: {'product_id': productId},
        showNotification:
            true, // send local notification (android only) for upload status
        tag: 'Backup products images...'); // unique tag for upload task

    uploader.progress.listen((UploadTaskProgress progress) {
      //... code to handle progress
      print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      final UploadResponse uploadResponse =
          uploadResponseFromJson(result.response);
      // final ProductTableData product = await store.state.database.productDao
      //     .getItemById(productId: uploadResponse.productId);
      final DatabaseService _databaseService = ProxyService.database;
      final Map<String, dynamic> productDoc =
          await _databaseService.getById(id: uploadResponse.productId);

      final Product product = Product.fromMap(productDoc);

      // TODO(richard): update url here
      // await store.state.database.productDao.updateProduct(
      //     pro.copyWith(picture: uploadResponse.url, isImageLocal: false));

      // List<ProductImageTableData> p = await store.state.database.productImageDao
      //     .getByid(productId: productId);
      // for (var i = 0; i < p.length; i++) {
      //   store.state.database.productImageDao.deleteImageProduct(p[i]);
      // }
      return dispatchProduct(store, product);
      // ignore: always_specify_types
    }, onError: (ex, stacktrace) {
      print('error' + stacktrace.toString());
    });
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<void> updateVariation({
    VariationTableData variation,
    Store<AppState> store,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    if (variation != null) {
      final StockTableData stock = await store.state.database.stockDao
          .getStockByVariantId(
              branchId: store.state.branch.id, variantId: variation.id);
      final VariationTableData variant = await store.state.database.variationDao
          .getVariationById(variantId: variation.id);
      await store.state.database.variationDao
          .updateVariation(variant.copyWith(name: variantName));

      await store.state.database.stockDao.updateStock(
        stock.copyWith(
          retailPrice: retailPrice,
          supplyPrice: supplyPrice,
        ),
      );
    }
  }

  // ignore: always_declare_return_types
  static updateOrder(Store<AppState> store, OrderTableData order) {
    store.state.database.orderDao.updateOrder(order);
  }

  static Future<void> deleteProduct(
      {Store<AppState> store, String productId}) async {
    final List<StockTableData> stocks = await store.state.database.stockDao
        .getStockByProductId(
            branchId: store.state.branch.id, productId: productId);
    final ProductTableData product = await store.state.database.productDao
        .getProductById(productId: productId);

    for (int i = 0; i < stocks.length; i++) {
      final VariationTableData variant = await store.state.database.variationDao
          .getVariationById(variantId: stocks[i].variantId);

      await store.state.database.variationDao.deleteVariation(variant);

      await store.state.database.stockDao.deleteStock(stocks[i]);
    }

    await store.state.database.productDao.deleteItem(product);

    AppDatabase.instance.syncLocalToRemote(store: store);
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

  //create a product and it's default variant which is regular
  //if a product does not exist then create it otherwise
  //create variant,
  //add the variant to stock with default value 0
  static Future<String> createTempProduct(
      {Store<AppState> store, String productName,String userId}) async {
    if (store.state.branch != null && userId !=null) {
      final Logger log = Logging.getLogger('Data manager   Model ....');

      
      final DatabaseService _databaseService = ProxyService.database;
      // ignore: always_specify_types
      final category = await _databaseService.filter(
        equator: AppTables.category + store.state.branch.id,
        property: 'tableName',
        and: true, //define that this query is and type.
        andEquator: 'custom',
        andProperty: 'name',
      );
      

      final List<Map<String, dynamic>> product = await _databaseService.filter(
        equator: productName,
        property: 'name',
        and: true,
        andProperty: 'tableName',
        andEquator: AppTables.product + store.state.branch.id,
      );

      final List<Map<String, dynamic>> gettax = await _databaseService.filter(
        equator: AppTables.tax + store.state.currentActiveBusiness.id,
        property: 'tableName',
        and: true, //define that this query is and type.
        andEquator: 'Vat',
        andProperty: 'name',
      );
      log.d('categoryId:'+Category.fromMap(category[0]['main']).id);
      log.d('taxId:'+Tax.fromMap(gettax[0]['main']).id);
      
      log.d(product);
      log.d('branchId'+store.state.branch.id);
      log.d('productName:'+productName);
      log.d('businessId:'+store.state.currentActiveBusiness.id);

      if (product.isEmpty) {
        // ignore: always_specify_types
        final Document productDoc = await _databaseService.insert(data: {
          'name': productName,
          'categoryId': Category.fromMap(category[0]['main']).id,
          'color': '#955be9',
          'id': Uuid().v1(),
          'active': true,
          'hasPicture': false,
          'channels':<String>[userId],
          'tableName': AppTables.product + store.state.branch.id,
          'isCurrentUpdate': false,
          'isDraft': true,
          'taxId': Tax.fromMap(gettax[0]['main']).id,
          'businessId': store.state.currentActiveBusiness.id,
          'description': productName,
          'createdAt': DateTime.now().toIso8601String(),
        });

        final Document variant = await _databaseService.insert(data: {
          'isActive': false,
          'name': productName,
          'unit': 'kg',
          'channels':<String>[userId],
          'tableName': AppTables.variation + store.state.branch.id,
          'productId': productDoc.id,
          'sku': Uuid().v1().substring(0, 4),
          'id': Uuid().v1(),
          'createdAt': DateTime.now().toIso8601String(),
        });

        await _databaseService.insert(data: {
          'variantId': variant.id,
          'supplyPrice': 0,
          'canTrackingStock': false,
          'showLowStockAlert': false,
          'retailPrice': 0,
          'channels': [userId],
          'isActive': true,
          // TODO(richard): decide which tableName
          // 'tableName':AppTables.variation + store.state.branch.id,
          'lowStock': 0,
          'currentStock': 0,
          'id': Uuid().v1(),
          'productId': productDoc.id,
          'branchId': store.state.branch.id,
          'createdAt': DateTime.now().toIso8601String(),
        });

        await _databaseService.insert(data: {
          'branchId': store.state.branch.id,
          'productId': productDoc.id,
          'tableName': AppTables.branchProduct + store.state.branch.id,
          'id': Uuid().v1()
        });
        final Product pro = Product.fromMap(productDoc.toMap());
        dispatchCurrentTmpItem(store, pro, productName,userId);
        
        return  productDoc.id;
      } else {
        final Product pro = Product.fromMap(product[0]['main']);
        dispatchCurrentTmpItem(store, pro, productName,userId);
        return pro.id;
      }
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
        'tableName': AppTables.variation + store.state.branch.id
      });

      final List<Map<String, dynamic>> vv = await _databaseService.filter(
        equator: 'Regular',
        property: 'name',
        and: true,
        andEquator: product.id,
        andProperty: 'productId',
      );
      variant = Variation.fromMap(vv[0][AppDatabase.instance.dbName]);
    } else {
      
      variant = Variation.fromMap(v[0][AppDatabase.instance.dbName]);
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
