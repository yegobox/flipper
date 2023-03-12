import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class RemoteInterface<T> {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<T> update(
      {required Map<String, dynamic> updateCollection,
      required String collectionName});
  void listenToChanges();
}

class RemoteService<T> implements RemoteInterface {
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
