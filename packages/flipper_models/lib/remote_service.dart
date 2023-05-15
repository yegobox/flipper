import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:io';

abstract class RemoteInterface {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel?> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<RecordModel?> update(
      {required Map<String, dynamic> data,
      required String collectionName,
      required String recordId});
  void listenToChanges();
}

class RemoteService implements RemoteInterface {
  late PocketBase pb;
  Future<RemoteInterface> getInstance() async {
    late String url;
    try {
      if (kDebugMode) {
        url = 'https://uat-db.yegobox.com';
      } else if (!kDebugMode) {
        url = 'https://db.yegobox.com';
      }
      pb = PocketBase(url);
      await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
    } on SocketException catch (e) {
      log(e.toString());
    } on ClientException catch (e) {
      log(e.toString());
    } catch (e) {}
    return this;
  }

  @override
  Future<List<RecordModel>> getCollection({required String collectionName}) {
    return pb.collection(collectionName).getFullList();
  }

  @override
  Future<RecordModel?> create({
    required Map<String, dynamic> collection,
    required String collectionName,
  }) async {
    try {
      return await pb.collection(collectionName).create(body: collection);
    } on SocketException catch (e) {
      log(e.toString());
      return null;
    } on ClientException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecordModel?> update({
    required Map<String, dynamic> data,
    required String collectionName,
    required String recordId,
  }) async {
    try {
      return await pb.collection(collectionName).update(recordId, body: data);
    } on SocketException catch (e) {
      log(e.toString());
      return null;
    } on ClientException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void listenToChanges() {
    try {
      gettingDataFirstTime();
      gettingRealTimeData();
    } on SocketException catch (e) {
      log(e.toString());
    } on ClientException catch (e) {
      log(e.toString());
    } catch (e) {
      // Handle any other errors
      print('Unexpected error: $e');
    }
  }

  Future<void> gettingDataFirstTime() async {
    try {
      int branchId = ProxyService.box.getBranchId() ?? 0;
      int businessId = ProxyService.box.getBusinessId() ?? 0;
      if (branchId == 0 || businessId == 0) {
        return;
      }
      List<RecordModel> socialItems = await pb
          .collection('socials')
          .getList(page: 1, perPage: 2, filter: 'businessId = ${businessId}')
          .then((event) => event.items);
      await Future.forEach(socialItems, (RecordModel item) async {
        Social remoteStock = Social.fromJson(item.toJson());
        await handleSocial(
            item, businessId, remoteStock.lastTouched, 'socials');
      });

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
    } on ClientException {
    } on SocketException {
    } on Exception {}
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
        localVariant.lastTouched != null &&
        remoteVariant.lastTouched!
            .isFutureDateCompareTo(localVariant.lastTouched!)) {
      await ProxyService.isarApi.update(data: remoteVariant);
      lastTouched = remoteVariant.lastTouched;
    }
    return lastTouched;
  }

  Future<String?> handleSocial(RecordModel item, int businessId,
      String? lastTouched, String model) async {
    Social remoteSocial = Social.fromJson(item.toJson());
    Social? localSocial =
        await ProxyService.isarApi.getSocialById(id: remoteSocial.localId!);
    if (localSocial == null && remoteSocial.businessId == businessId) {
      remoteSocial.id = remoteSocial.localId;
      await ProxyService.isarApi.create(data: remoteSocial);
      lastTouched = remoteSocial.lastTouched;
    } else if (localSocial != null &&
        remoteSocial.lastTouched!
            .isFutureDateCompareTo(localSocial.lastTouched!)) {
      remoteSocial.id = remoteSocial.localId;
      await ProxyService.isarApi.update(data: remoteSocial);
      lastTouched = remoteSocial.lastTouched;
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
        localStock.lastTouched != null &&
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
    } else if (localProduct != null &&
        localProduct.lastTouched != null &&
        remoteProduct.lastTouched!
            .isFutureDateCompareTo(localProduct.lastTouched!)) {
      await ProxyService.isarApi.update(data: remoteProduct);
      lastTouched = remoteProduct.lastTouched;
    }
  }

  void gettingRealTimeData() {
    int branchId = ProxyService.box.getBranchId() ?? 0;
    int businessId = ProxyService.box.getBusinessId() ?? 0;
    if (branchId == 0 || businessId == 0) {
      return;
    }
    pb.collection('socials').subscribe("*", (socialEvent) async {
      if (socialEvent.action == "create") {
        Social socialFromRecord = Social.fromRecord(socialEvent.record!);
        Social? localSocial = await ProxyService.isarApi
            .getSocialById(id: socialFromRecord.localId!);
        if (localSocial == null && socialFromRecord.businessId == businessId) {
          socialFromRecord.id = socialFromRecord.localId;
          await ProxyService.isarApi.create(data: socialFromRecord);
        }
      } else if (socialEvent.action == "update") {
        Social socialFromRecord = Social.fromRecord(socialEvent.record!);
        Social? localSocial = await ProxyService.isarApi
            .getSocialById(id: socialFromRecord.localId!);
        if (localSocial == null && socialFromRecord.businessId == businessId) {
          socialFromRecord.id = socialFromRecord.localId;
          await ProxyService.isarApi.create(data: socialFromRecord);
        }
        Social a = Social.fromRecord(socialEvent.record!);
        Social? b = await ProxyService.isarApi.getSocialById(id: a.localId!);
        String lastTouched = a.lastTouched!;
        if (b != null &&
            a.businessId == businessId &&
            lastTouched.isFutureDateCompareTo(b.lastTouched!)) {
          await ProxyService.isarApi.update(data: a);
        }
      }
    });

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
