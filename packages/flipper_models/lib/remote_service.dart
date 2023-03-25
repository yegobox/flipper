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
  Future<void> savePointer(
      int branchId, String? lastQuery, String model, IChange? filter);
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
    gettingDataAsync();
    gettingRealTimeData();
  }

  Future<void> gettingDataAsync() async {
    int branchId = ProxyService.box.getBranchId()!;

    // Define a helper function to generate the filter string
    String generateFilterString(String? filterValue) {
      return filterValue != null && filterValue.isNotEmpty
          ? 'lastTouched > "$filterValue"'
          : 'lastTouched > ""';
    }

    // Get the latest change for each model and sync the remote data with the local database
    await Future.forEach(['stocks', 'variants', 'products'],
        (String model) async {
      IChange? filter = await ProxyService.isarApi.latestChange(
          branchId: branchId, model: model, isRemoteDataSource: true);

      String filterValue = filter?.lastTouched ?? '';
      String filterString = generateFilterString(filterValue);
      // ignore: todo
      // TODO: once we have 10 users using the product, implement pagination here
      List<RecordModel> items = await pb
          .collection(model)
          .getList(page: 1, perPage: 100, filter: filterString)
          .then((event) => event.items);

      String? lastTouched;
      await Future.forEach(items, (RecordModel item) async {
        switch (model) {
          case 'stocks':
            Stock remoteStock = Stock.fromJson(item.toJson());
            Stock? localStock = await ProxyService.isarApi
                .getStockById(id: remoteStock.localId!);
            if (localStock == null && remoteStock.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteStock);
              lastTouched = remoteStock.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
            } else if (localStock != null &&
                remoteStock.lastTouched!
                    .isGreaterThanOrEqualTo(localStock.lastTouched!)) {
              await ProxyService.isarApi.update(data: remoteStock);
              lastTouched = remoteStock.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
            }
            break;
          case 'variants':
            Variant remoteVariant = Variant.fromJson(item.toJson());
            Variant? localVariant = await ProxyService.isarApi
                .getVariantById(id: remoteVariant.localId!);
            if (localVariant == null && remoteVariant.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteVariant);
              lastTouched = remoteVariant.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
            } else if (localVariant != null &&
                remoteVariant.lastTouched!
                    .isGreaterThanOrEqualTo(localVariant.lastTouched!)) {
              await ProxyService.isarApi.update(data: remoteVariant);
              lastTouched = remoteVariant.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
            }
            break;
          case 'products':
            Product remoteProduct = Product.fromJson(item.toJson());
            Product? localProduct = await ProxyService.isarApi
                .getProduct(id: remoteProduct.localId!);
            if (localProduct == null && remoteProduct.branchId == branchId) {
              await ProxyService.isarApi.create(data: remoteProduct);
              lastTouched = remoteProduct.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
              //
            } else if (localProduct != null &&
                remoteProduct.lastTouched!
                    .isGreaterThanOrEqualTo(localProduct.lastTouched!)) {
              await ProxyService.isarApi.update(data: remoteProduct);
              lastTouched = remoteProduct.lastTouched;
              await savePointer(branchId, lastTouched, model, filter);
            }
            break;
        }
      });
    });
  }

  // ignore: todo
  ///TODO: right now I am not saving id of the model in pointer, is this necessary
  ///in making sure that I do not miss understood the change??
  @override
  Future<void> savePointer(
      int branchId, String? lastTouched, String model, IChange? filter) async {
    IChange change = IChange(
        branchId: branchId,
        remoteChange: true,
        businessId: ProxyService.box.getBusinessId()!,
        lastTouched: lastTouched,
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
      } else if (stockEvent.action == "update") {
        Stock stockFromRecord = Stock.fromRecord(stockEvent.record!);
        Stock? localStock = await ProxyService.isarApi
            .getStockById(id: stockFromRecord.localId!);
        if (localStock != null && stockFromRecord.branchId == branchId) {
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
        if (localVariant != null && variant.branchId == branchId) {
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
        if (localProduct != null && productFromRecord.branchId == branchId) {
          log("updated product from remote");
          await ProxyService.isarApi.update(data: productFromRecord);
        }
      }
    });
  }
}
