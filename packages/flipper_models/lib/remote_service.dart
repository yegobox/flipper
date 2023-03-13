import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class RemoteInterface {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<void> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName});
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
      // You can add custom handling here if you want to do something with the error
      rethrow;
    }
  }

  @override
  Future<void> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName}) {
    return pb
        .collection(collectionName)
        .update(updateCollection["id"], body: updateCollection)
        .then((record) {
      print(record.id);
      print(record.getStringValue('id'));
    });
  }

  @override
  void listenToChanges() {
    gettingDataAsync();
    gettingRealTimeData();
  }

  // https://pocketbase.io/docs/api-collections
  Future<void> gettingDataAsync() async {
    // final response = await pb.collections.getFirstListItem(query: query, headers: {'Authorization': 'Bearer $YOUR_ACCESS_TOKEN'});
    await pb.collection("stocks").getFullList(
        sort: '-created', query: {"perPage": 1}).then((stockEvent) async {
      Stock stockFromRecord = Stock.fromJson(stockEvent.first.toJson());
      Stock? localStock =
          await ProxyService.isarApi.getStockById(id: stockFromRecord.localId!);
      if (localStock == null) {
        await ProxyService.isarApi.create(data: stockFromRecord);
      }
    });
    await pb.collection("variants").getFullList(
        sort: '-created', query: {"perPage": 1}).then((variantEvent) async {
      Variant variant = Variant.fromJson(variantEvent.first.toJson());

      Variant? localVariant =
          await ProxyService.isarApi.getVariantById(id: variant.localId!);
      if (localVariant == null) {
        await ProxyService.isarApi.create(data: variant);
      }
    });
    await pb.collection("products").getFullList(
        sort: '-created', query: {"perPage": 1}).then((productEvent) async {
      Product productFromRecord = Product.fromJson(productEvent.first.toJson());
      Product? localProduct =
          await ProxyService.isarApi.getProduct(id: productFromRecord.localId!);
      if (localProduct == null) {
        log("created product from remote");
        await ProxyService.isarApi.create(data: productFromRecord);
      }
    });
  }

  void gettingRealTimeData() {
    pb.collection('stocks').subscribe("*", (stockEvent) async {
      if (stockEvent.action == "create") {
        Stock stockFromRecord = Stock.fromRecord(stockEvent.record!);
        Stock? localStock = await ProxyService.isarApi
            .getStockById(id: stockFromRecord.localId!);
        if (localStock == null) {
          await ProxyService.isarApi.create(data: stockFromRecord);
        }
      }
    });
    pb.collection('variants').subscribe("*", (variantEvent) async {
      Variant variant = Variant.fromRecord(variantEvent.record!);

      Variant? localVariant =
          await ProxyService.isarApi.getVariantById(id: variant.localId!);
      if (localVariant == null) {
        await ProxyService.isarApi.create(data: variant);
      }
    });
    pb.collection('products').subscribe("*", (productEvent) async {
      if (productEvent.action == "create") {
        Product productFromRecord = Product.fromRecord(productEvent.record!);
        Product? localProduct = await ProxyService.isarApi
            .getProduct(id: productFromRecord.localId!);
        if (localProduct == null) {
          log("created product from remote");
          await ProxyService.isarApi.create(data: productFromRecord);
        }
      }
    });
  }
}
