import 'dart:async';
import 'dart:io';

import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/util/upload_response.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class DataManager extends CouchBase {
  //updatable variables
  static double retailPrice = 0.0;
  static double supplyPrice = 0.0;
  static String description;
  static String sku;
  static String name;

  static Future startUploading(
      {String storagePath,
      String fileName,
      Store<AppState> store,
      String productId}) async {
    final uploader = FlutterUploader();

    await uploader.enqueue(
        url: 'https://test.flipper.rw/api/upload',
        files: [
          FileItem(
              filename: fileName, savedDir: storagePath, fieldname: 'image')
        ], // required: list of files that you want to upload
        method: UploadMethod.POST,
        headers: {'Authorization': 'Bearer  ' + store.state.user.token},
        data: {'product_id': productId},
        showNotification:
            true, // send local notification (android only) for upload status
        tag: 'Backup products images...'); // unique tag for upload task

    uploader.progress.listen((progress) {
      //... code to handle progress
      print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((result) async {
      final uploadResponse = uploadResponseFromJson(result.response);
      ProductTableData product = await store.state.database.productDao
          .getItemById(productId: uploadResponse.productId);

      await store.state.database.productDao.updateProduct(
          product.copyWith(picture: uploadResponse.url, isImageLocal: false));

      List<ProductImageTableData> p = await store.state.database.productImageDao
          .getByid(productId: productId);
      for (var i = 0; i < p.length; i++) {
        store.state.database.productImageDao.deleteImageProduct(p[i]);
      }
      return dispatchProduct(store, product);
    }, onError: (ex, stacktrace) {
      print('error' + stacktrace.toString());
    });
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future updateVariation({
    VariationTableData variation,
    Store<AppState> store,
    double retailPrice,
    double supplyPrice,
    String variantName,
  }) async {
    if (variation != null) {
      final stock = await store.state.database.stockDao.getStockByVariantId(
          branchId: store.state.branch.id, variantId: variation.id);
      final variant = await store.state.database.variationDao
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

  static updateOrder(Store<AppState> store, OrderTableData order) {
    store.state.database.orderDao.updateOrder(order);
  }

  static Future deleteProduct({Store<AppState> store, String productId}) async {
    List<StockTableData> stocks = await store.state.database.stockDao
        .getStockByProductId(
            branchId: store.state.branch.id, productId: productId);
    ProductTableData product = await store.state.database.productDao
        .getProductById(productId: productId);

    for (var i = 0; i < stocks.length; i++) {
      VariationTableData variant = await store.state.database.variationDao
          .getVariationById(variantId: stocks[i].variantId);

      await store.state.database.variationDao.deleteVariation(variant);

      await store.state.database.stockDao.deleteStock(stocks[i]);
    }

    await store.state.database.productDao.deleteItem(product);
    //TODO: uncomment this.
    // store.state.couch.syncLocalToRemote(store: store);
  }

  static createTemporalOrder(
      GeneralRepository generalRepository, Store<AppState> store) async {
    OrderTableData order =
        await generalRepository.createDraftOrderOrReturnExistingOne(store);

    //broadcast order to be used later when creating a sale
    if (order != null) {
      store.dispatch(
        OrderCreated(
          order: Order(
            (o) => o
              ..status = order.status
              ..id = order.id
              ..userId = store.state.userId
              ..branchId = order.branchId
              ..orderNote = order.orderNote
              ..orderNUmber = order.orderNUmber
              ..supplierId = order.supplierId
              ..subTotal = order.subTotal
              ..discountAmount = order.discountAmount
              ..supplierInvoiceNumber = order.supplierInvoiceNumber
              ..deliverDate = order.deliverDate
              ..discountRate = order.discountRate
              ..taxRate = order.taxRate
              ..taxAmount = order.taxAmount
              ..cashReceived = order.cashReceived
              ..saleTotal = order.saleTotal
              ..userId = order.userId
              ..customerSaving = order.customerSaving
              ..paymentId = order.paymentId
              ..orderNote = order.orderNote
              ..status = order.status
              ..customerChangeDue = order.customerChangeDue,
          ),
        ),
      );
    }
  }

  //create a product and it's default variant which is regular
  //if a product does not exist then create it otherwise
  //create variant,
  //add the variant to stock with default value 0
  static Future createTempProduct(
      Store<AppState> store, String productName) async {
    if (store.state.branch == null) return null;
    CategoryTableData category =
        await store.state.database.categoryDao.getCategoryByNameBranchId(
      'custom',
      store.state.branch.id,
    );

    ProductTableData product =
        await store.state.database.productDao.getItemByName(
      name: productName,
      businessId: store.state.currentActiveBusiness.id,
    );

    TaxTableData tax = await store.state.database.taxDao.getByName(
        businessId: store.state.currentActiveBusiness.id, name: 'Vat');

    if (product == null) {
      final productId = await store.state.database.productDao.insert(
        //ignore: missing_required_param
        ProductTableData(
          name: productName,
          categoryId: category?.id,
          color: '#955be9',
          active: true,
          hasPicture: false,
          isCurrentUpdate: false,
          isDraft: true,
          picture: '',
          supplierId: '',
          taxId: tax?.id,
          businessId: store.state.currentActiveBusiness.id,
          id: Uuid().v1(),
          description: productName,
          createdAt: DateTime.now(),
        ),
      );
      product = await store.state.database.productDao
          .getProductByIdLocal(productId: productId);

      final variantId = await store.state.database.variationDao.insert(
        //ignore: missing_required_param
        VariationTableData(
          isActive: false,
          name: productName,
          unit: 'kg',
          productId: product.id,
          sku: Uuid().v1().substring(0, 4),
          id: Uuid().v1(),
          createdAt: DateTime.now(),
        ),
      );

      VariationTableData variant = await store.state.database.variationDao
          .getVariationByIdLocal(variantId: variantId);

      store.state.database.stockDao.insert(
        //ignore: missing_required_param
        StockTableData(
          variantId: variant.id,
          supplyPrice: 0,
          canTrackingStock: false,
          showLowStockAlert: false,
          retailPrice: 0,
          isActive: true,
          lowStock: 0,
          currentStock: 0,
          id: Uuid().v1(),
          productId: product.id,
          branchId: store.state.branch.id,
          createdAt: DateTime.now(),
        ),
      );

      //update branchProduct.
      store.state.database.branchProductDao.insert(
        //ignore: missing_required_param
        BranchProductTableData(
            branchId: store.state.branch.id,
            productId: product.id,
            id: Uuid().v1()),
      );

      dispatchCurrentTmpItem(store, product, productName);
    } else {
      dispatchCurrentTmpItem(store, product, productName);
    }
  }

  static void dispatchCurrentTmpItem(Store<AppState> store,
      ProductTableData product, String productName) async {
    VariationTableData variant;
    variant = await store.state.database.variationDao
        .getVariationByName(name: productName, productId: product.id);

    if (variant == null) {
      //this is when a user started editing default variant to regular variant
      //and we do not need to get error as there is no tmp variant available, the product
      //is not done creating.
      variant = await store.state.database.variationDao
          .getVariationByName(name: 'Regular', productId: product.id);
    }
    //dispatch this variant.
    store.dispatch(
      VariationAction(
        variation: Variation(
          (v) => v
            ..productId = variant.productId
            ..sku = variant.sku
            ..name = variant.name
            ..id = variant.id,
        ),
      ),
    );

    return dispatchProduct(store, product);
  }

  static dispatchProduct(Store<AppState> store, ProductTableData product) {
    return store.dispatch(
      TempProduct(
        product: Product(
          (i) => i
            ..isCurrentUpdate = product.isCurrentUpdate
            ..isDraft = product.isDraft
            ..taxId = product.taxId
            ..description = product.description
            ..isImageLocal = product.isImageLocal
            ..picture = product.picture
            ..hasPicture = product.hasPicture
            ..active = product.active
            ..color = product.color
            ..businessId = product.businessId
            ..supplierId = product.supplierId
            ..categoryId = product.categoryId
            ..productId = product.id
            ..name = product.name
            ..color = product.color,
        ),
      ),
    );
  }

  static Future insertProduct(
      Store<AppState> store, ProductTableData data) async {}
}
