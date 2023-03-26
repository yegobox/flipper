import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class RemoteInterface {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<RecordModel> update(
      {required Map<String, dynamic> data,
      required String collectionName,
      required String recordId});
  void listenToChanges();
}

class RemoteService implements RemoteInterface {
  late PocketBase pb;
  Future<RemoteInterface> getInstance() async {
    try {
      pb = PocketBase('https://db.yegobox.com');
      await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
    } catch (e) {}
    return this;
  }

  @override
  Future<List<RecordModel>> getCollection({required String collectionName}) {
    return pb.collection(collectionName).getFullList();
  }

  @override
  Future<RecordModel> create({
    required Map<String, dynamic> collection,
    required String collectionName,
  }) async {
    try {
      return await pb.collection(collectionName).create(body: collection);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecordModel> update({
    required Map<String, dynamic> data,
    required String collectionName,
    required String recordId,
  }) async {
    try {
      return await pb.collection(collectionName).update(recordId, body: data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void listenToChanges() {
    gettingDataFirstTime();
    gettingRealTimeData();
  }

  Future<void> gettingDataFirstTime() async {
    int branchId = ProxyService.box.getBranchId()!;

    List<RecordModel> stockItems = await pb
        .collection('stocks')
        .getList(page: 1, perPage: 100, filter: 'branchId = ${branchId}')
        .then((event) => event.items);
    await Future.forEach(stockItems, (RecordModel item) async {
      Stock remoteStock = Stock.fromJson(item.toJson());
      await handleStock(item, branchId, remoteStock.lastTouched, 'stocks');
    });
    List<RecordModel> variantItems = await pb
        .collection('variants')
        .getList(page: 1, perPage: 100, filter: 'branchId = ${branchId}')
        .then((event) => event.items);
    await Future.forEach(variantItems, (RecordModel item) async {
      Variant remoteVariant = Variant.fromJson(item.toJson());
      await handleVariant(
          item, branchId, remoteVariant.lastTouched, 'variants');
    });
    List<RecordModel> productItems = await pb
        .collection('products')
        .getList(page: 1, perPage: 100, filter: 'branchId = ${branchId}')
        .then((event) => event.items);
    await Future.forEach(productItems, (RecordModel item) async {
      Product remoteProduct = Product.fromJson(item.toJson());
      await handleProduct(
          item, branchId, remoteProduct.lastTouched, 'products');
    });
  }

  Future<String?> handleVariant(
      RecordModel item, int branchId, String? lastTouched, String model) async {
    Variant remoteVariant = Variant.fromJson(item.toJson());
    Variant? localVariant =
        await ProxyService.isarApi.getVariantById(id: remoteVariant.localId!);
    if (localVariant == null && remoteVariant.branchId == branchId) {
      await ProxyService.isarApi.create(data: remoteVariant);
      lastTouched = remoteVariant.lastTouched;
    } else if (localVariant != null &&
        remoteVariant.lastTouched!
            .isFutureDateCompareTo(localVariant.lastTouched!)) {
      await ProxyService.isarApi.update(data: remoteVariant);
      lastTouched = remoteVariant.lastTouched;
    }
    return lastTouched;
  }

  Future<String?> handleStock(
      RecordModel item, int branchId, String? lastTouched, String model) async {
    Stock remoteStock = Stock.fromJson(item.toJson());
    Stock? localStock =
        await ProxyService.isarApi.getStockById(id: remoteStock.localId!);
    if (localStock == null && remoteStock.branchId == branchId) {
      await ProxyService.isarApi.create(data: remoteStock);
      lastTouched = remoteStock.lastTouched;
    } else if (localStock != null &&
        remoteStock.lastTouched!
            .isFutureDateCompareTo(localStock.lastTouched!)) {
      await ProxyService.isarApi.update(data: remoteStock);
      lastTouched = remoteStock.lastTouched;
    }
    return lastTouched;
  }

  Future<void> handleProduct(
      RecordModel item, int branchId, String? lastTouched, String model) async {
    Product remoteProduct = Product.fromJson(item.toJson());
    Product? localProduct =
        await ProxyService.isarApi.getProduct(id: remoteProduct.localId!);
    if (localProduct == null && remoteProduct.branchId == branchId) {
      await ProxyService.isarApi.create(data: remoteProduct);
      lastTouched = remoteProduct.lastTouched;
      //
    } else if (localProduct != null &&
        remoteProduct.lastTouched!
            .isFutureDateCompareTo(localProduct.lastTouched!)) {
      await ProxyService.isarApi.update(data: remoteProduct);
      lastTouched = remoteProduct.lastTouched;
    }
  }

  void gettingRealTimeData() {
    int branchId = ProxyService.box.getBranchId()!;
    pb.collection('stocks').subscribe("*", (stockEvent) async {
      if (stockEvent.action == "create") {
        Stock stockFromRecord = Stock.fromRecord(stockEvent.record!);
        Stock? localStock = await ProxyService.isarApi
            .getStockById(id: stockFromRecord.localId!);
        if (localStock == null && stockFromRecord.branchId == branchId) {
          await ProxyService.isarApi.create(data: stockFromRecord);
        }
      } else if (stockEvent.action == "update") {
        Stock stockFromRecord = Stock.fromRecord(stockEvent.record!);
        Stock? localStock = await ProxyService.isarApi
            .getStockById(id: stockFromRecord.localId!);
        String lastTouched = stockFromRecord.lastTouched!;
        if (localStock != null &&
            stockFromRecord.branchId == branchId &&
            lastTouched.isFutureDateCompareTo(localStock.lastTouched!)) {
          await ProxyService.isarApi.update(data: stockFromRecord);
        }
      }
    });
    pb.collection('variants').subscribe("*", (variantEvent) async {
      if (variantEvent.action == "create") {
        Variant variant = Variant.fromRecord(variantEvent.record!);

        Variant? localVariant =
            await ProxyService.isarApi.getVariantById(id: variant.localId!);
        if (localVariant == null && variant.branchId == branchId) {
          await ProxyService.isarApi.create(data: variant);
        }
      } else if (variantEvent.action == "update") {
        Variant variant = Variant.fromRecord(variantEvent.record!);

        Variant? localVariant =
            await ProxyService.isarApi.getVariantById(id: variant.localId!);
        String lastTouched = variant.lastTouched!;
        if (localVariant != null &&
            variant.branchId == branchId &&
            lastTouched.isFutureDateCompareTo(localVariant.lastTouched!)) {
          await ProxyService.isarApi.update(data: variant);
        }
      }
    });
    pb.collection('products').subscribe("*", (productEvent) async {
      if (productEvent.action == "create") {
        Product productFromRecord = Product.fromRecord(productEvent.record!);
        Product? localProduct = await ProxyService.isarApi
            .getProduct(id: productFromRecord.localId!);
        if (localProduct == null && productFromRecord.branchId == branchId) {
          log("created product from remote");
          await ProxyService.isarApi.create(data: productFromRecord);
        }
      } else if (productEvent.action == "update") {
        Product productFromRecord = Product.fromRecord(productEvent.record!);
        Product? localProduct = await ProxyService.isarApi
            .getProduct(id: productFromRecord.localId!);
        String lastTouched = productFromRecord.lastTouched!;
        if (localProduct != null &&
            productFromRecord.branchId == branchId &&
            lastTouched.isFutureDateCompareTo(localProduct.lastTouched!)) {
          log("updated product from remote");
          await ProxyService.isarApi.update(data: productFromRecord);
        }
      }
    });
  }
}
