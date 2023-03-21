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
    int branchId = ProxyService.box.getBranchId()!;

    // Define a helper function to generate the filter string
    String generateFilterString(String? filterValue) {
      return filterValue != null && filterValue.isNotEmpty
          ? 'lastTouched >= "$filterValue"'
          : 'lastTouched >= ""';
    }

    // Get the latest change for each model and sync the remote data with the local database
    await Future.forEach(['stocks', 'variants', 'products'],
        (String model) async {
      IChange? filter = await ProxyService.isarApi
          .latestChange(branchId: branchId, model: model);

      String filterValue = filter?.lastReportQuery ?? '';
      String filterString = generateFilterString(filterValue);

      List<RecordModel> items = await pb
          .collection(model)
          .getList(page: 1, perPage: 100, filter: filterString)
          .then((event) => event.items);

      String? lastQuery;
      await Future.forEach(items, (RecordModel item) async {
        switch (model) {
          case 'stocks':
            Stock remoteStock = Stock.fromJson(item.toJson());
            Stock? localStock = await ProxyService.isarApi
                .getStockById(id: remoteStock.localId!);
            if (localStock == null && remoteStock.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteStock);
              lastQuery = remoteStock.lastTouched;
              await savePointer(branchId, lastQuery, model, filter);
            }
            break;
          case 'variants':
            Variant remoteVariant = Variant.fromJson(item.toJson());
            Variant? localVariant = await ProxyService.isarApi
                .getVariantById(id: remoteVariant.localId!);
            if (localVariant == null && remoteVariant.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteVariant);
              lastQuery = remoteVariant.lastTouched;
              await savePointer(branchId, lastQuery, model, filter);
            }
            break;
          case 'products':
            Product remoteProduct = Product.fromJson(item.toJson());
            Product? localProduct = await ProxyService.isarApi
                .getProduct(id: remoteProduct.localId!);
            if (localProduct == null && remoteProduct.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteProduct);
              lastQuery = remoteProduct.lastTouched;
              await savePointer(branchId, lastQuery, model, filter);
            }
            break;
        }
      });
    });
  }

  Future<void> savePointer(
      int branchId, String? lastQuery, String model, IChange? filter) async {
    IChange change = IChange(
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId()!,
        lastReportQuery: lastQuery,
        model: model);
    if (filter == null) {
      await ProxyService.isarApi.create(data: change);
    } else {
      change.id = filter.id;
      await ProxyService.isarApi.update(data: change);
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
      }
    });
  }
}
