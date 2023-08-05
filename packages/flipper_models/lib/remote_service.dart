import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
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
  late String url;

  Future<RemoteInterface> getInstance() async {
    try {
      url =
          kDebugMode ? 'https://uat-db.yegobox.com' : 'https://db.yegobox.com';
      pb = PocketBase(url);
      await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
      return this;
    } catch (e) {
      return retryConnect();
    }
  }

  Future<RemoteInterface> retryConnect() async {
    await Future.delayed(Duration(seconds: 5));
    try {
      await pb.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
      return this;
    } catch (e) {
      throw Exception("Failed to initialize RemoteInterface.");
    }
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

      final collections = [
        'stocks',
        'variants',
        'products',
        'devices',
        'socials',
        'transactionItems',
        'transactions',
        'rra',
      ];

      for (final collectionName in collections) {
        final records = await pb
            .collection(collectionName)
            .getList(page: 1, perPage: 500, filter: 'branchId = $branchId')
            .then((event) => event.items);

        await Future.forEach(records, (RecordModel item) async {
          Map<String, dynamic> originalJson = item.toJson();

          // Create a copy of the original JSON
          Map<String, dynamic> updatedJson = Map.from(originalJson);

          // Update the 'action' property in the copied JSON
          /// we change action from remote fetched data to remote
          /// so that we don't push these data back when property has not changed
          updatedJson['action'] = AppActions.remote;
          switch (collectionName) {
            case 'stocks':
              await handleItem(
                  model: Stock.fromJson(updatedJson), branchId: branchId);
              break;
            case 'variants':
              await handleItem(
                  model: Variant.fromJson(updatedJson), branchId: branchId);
              break;
            case 'products':
              await handleItem(
                  model: Product.fromJson(updatedJson), branchId: branchId);
              break;
            case 'devices':
              await handleItem(
                  model: Device.fromJson(updatedJson), branchId: branchId);
              break;
            case 'socials':
              await handleItem(
                  model: Social.fromJson(updatedJson), branchId: branchId);
              break;
            case 'rra':
              await handleItem(
                  model: EBM.fromJson(updatedJson), branchId: branchId);
              break;
            case 'transactions':
              await handleItem(
                  model: Transaction.fromJson(updatedJson), branchId: branchId);
              break;
            case 'transactionItems':
              await handleItem(
                  model: TransactionItem.fromJson(updatedJson),
                  branchId: branchId);
              break;
            default:
              break;
          }
        });
      }
    } on ClientException {
    } on SocketException {
    } on Exception {}
  }

  Future<void> gettingRealTimeData() {
    int branchId = ProxyService.box.getBranchId() ?? 0;
    int businessId = ProxyService.box.getBusinessId() ?? 0;
    if (branchId != 0 || businessId != 0) {
      pb.collection('socials').subscribe("*", (socialEvent) async {
        if (socialEvent.action == "create" ||
            socialEvent.action == "update" ||
            socialEvent.action == "delete") {
          await handleRemoteData(
              socialEvent.record!, branchId, businessId, 'socials');
        }
      });

      pb.collection('stocks').subscribe("*", (stockEvent) async {
        if (stockEvent.action == "create" ||
            stockEvent.action == "update" ||
            stockEvent.action == "delete") {
          await handleRemoteData(
              stockEvent.record!, branchId, businessId, 'stocks');
        }
      });

      pb.collection('variants').subscribe("*", (variantEvent) async {
        if (variantEvent.action == "create" ||
            variantEvent.action == "update" ||
            variantEvent.action == "delete") {
          await handleRemoteData(
              variantEvent.record!, branchId, businessId, 'variants');
        }
      });

      pb.collection('products').subscribe("*", (productEvent) async {
        if (productEvent.action == "create" ||
            productEvent.action == "update" ||
            productEvent.action == "delete") {
          await handleRemoteData(
              productEvent.record!, branchId, businessId, 'products');
        }
      });

      pb.collection('devices').subscribe("*", (deviceEvent) async {
        if (deviceEvent.action == "create" ||
            deviceEvent.action == "update" ||
            deviceEvent.action == "delete") {
          await handleRemoteData(
              deviceEvent.record!, branchId, businessId, 'devices');
        }
      });
      pb.collection('rra').subscribe("*", (deviceEvent) async {
        if (deviceEvent.action == "create" ||
            deviceEvent.action == "update" ||
            deviceEvent.action == "delete") {
          await handleRemoteData(
              deviceEvent.record!, branchId, businessId, 'rra');
        }
      });
    }

    // Add the return statement at the end of the method
    return Future.value();
  }

  Future<void> handleRemoteData(
    RecordModel item,
    int branchId,
    int businessId,
    String collectionName,
  ) async {
    Map<String, dynamic> originalJson = item.toJson();

    // Create a copy of the original JSON
    Map<String, dynamic> jsonData = Map.from(originalJson);

    // Update the 'action' property in the copied JSON
    /// we change action from remote fetched data to remote
    /// so that we don't push these data back when property has not changed
    jsonData['action'] = AppActions.remote;
    switch (collectionName) {
      case 'stocks':
        await handleItem(model: Stock.fromJson(jsonData), branchId: branchId);
        break;
      case 'variants':
        await handleItem(model: Variant.fromJson(jsonData), branchId: branchId);
        break;
      case 'products':
        await handleItem(model: Product.fromJson(jsonData), branchId: branchId);
        break;
      case 'devices':
        await handleItem(model: Device.fromJson(jsonData), branchId: branchId);
        break;
      case 'rra':
        await handleItem(model: EBM.fromJson(jsonData), branchId: branchId);
        break;
      case 'socials':
        await handleItem(model: Social.fromJson(jsonData), branchId: branchId);
      case 'transactions':
        await handleItem(
            model: Transaction.fromJson(jsonData), branchId: branchId);
        break;
      case 'transactionItems':
        await handleItem(
            model: TransactionItem.fromJson(jsonData), branchId: branchId);
        break;
      default:
        break;
    }
  }

  Future<void> handleItem<T>({required T model, required int branchId}) async {
    if (model is Stock) {
      Stock remoteStock = Stock.fromJson(model.toJson());

      Stock? localStock =
          await ProxyService.isar.getStockById(id: remoteStock.localId!);

      if (localStock == null && remoteStock.branchId == branchId) {
        remoteStock.id = remoteStock.localId!;
        await ProxyService.isar.create(data: remoteStock);
      } else if (localStock != null &&
          localStock.lastTouched != null &&
          remoteStock.lastTouched!
              .isFutureDateCompareTo(localStock.lastTouched!)) {
        remoteStock.id = localStock.localId;
        remoteStock.action = AppActions.updated;
        await ProxyService.isar.update(data: remoteStock);
      }
    }
    if (model is Variant) {
      Variant remoteVariant = Variant.fromJson(model.toJson());
      Variant? localVariant =
          await ProxyService.isar.getVariantById(id: remoteVariant.localId!);

      if (localVariant == null && remoteVariant.branchId == branchId) {
        remoteVariant.id = remoteVariant.localId!;
        await ProxyService.isar.create(data: remoteVariant);
      } else if (localVariant != null &&
          localVariant.lastTouched != null &&
          remoteVariant.lastTouched!
              .isFutureDateCompareTo(localVariant.lastTouched!)) {
        remoteVariant.id = localVariant.localId;
        remoteVariant.action = AppActions.updated;
        await ProxyService.isar.update(data: remoteVariant);
      }
    }
    if (model is Product) {
      Product remoteProduct = Product.fromJson(model.toJson());
      Product? localProduct =
          await ProxyService.isar.getProduct(id: remoteProduct.localId!);

      if (localProduct == null && remoteProduct.branchId == branchId) {
        remoteProduct.id = remoteProduct.localId!;
        await ProxyService.isar.create(data: remoteProduct);
      } else if (localProduct != null &&
          localProduct.lastTouched != null &&
          remoteProduct.lastTouched!
              .isFutureDateCompareTo(localProduct.lastTouched!)) {
        remoteProduct.id = localProduct.localId;
        remoteProduct.action = AppActions.updated;
        await ProxyService.isar.update(data: remoteProduct);
      }
    }
    if (model is Device) {
      Device remoteDevice = Device.fromJson(model.toJson());
      Device? localDevice =
          await ProxyService.isar.getDeviceById(id: remoteDevice.localId!);

      if (localDevice == null && remoteDevice.branchId == branchId) {
        remoteDevice.id = remoteDevice.localId!;
        await ProxyService.isar.create(data: remoteDevice);
      } else if (localDevice != null &&
          localDevice.lastTouched != null &&
          remoteDevice.lastTouched!
              .isFutureDateCompareTo(localDevice.lastTouched!)) {
        localDevice.id = localDevice.localId;
        localDevice.action = AppActions.updated;
        await ProxyService.isar.update(data: localDevice);
      }
    }
    if (model is Social) {
      Social remoteSocial = Social.fromJson(model.toJson());
      Social? localSocial =
          await ProxyService.isar.getSocialById(id: remoteSocial.localId!);

      if (localSocial == null &&
          remoteSocial.businessId == ProxyService.box.getBusinessId()) {
        remoteSocial.id = remoteSocial.localId;
        await ProxyService.isar.create(data: remoteSocial);
      } else if (localSocial != null &&
          remoteSocial.lastTouched!
              .isFutureDateCompareTo(localSocial.lastTouched!)) {
        remoteSocial.id = remoteSocial.localId;
        await ProxyService.isar.update(data: remoteSocial);
      }
    }
    if (model is EBM) {
      EBM ebm = EBM.fromJson(model.toJson());
      EBM? localEbm =
          await ProxyService.isar.getEbmByBranchId(branchId: ebm.branchId);

      if (localEbm == null &&
          ebm.businessId == ProxyService.box.getBusinessId()) {
        ebm.id = syncIdInt();
        ebm.lastTouched = DateTime.now().toIso8601String();
        await ProxyService.isar.create(data: ebm);
        // update business
        Business? business = await ProxyService.isar.getBusiness();
        business!.bhfId = ebm.bhfId;
        business.taxServerUrl = ebm.taxServerUrl;
        business.tinNumber = ebm.tinNumber;
        business.dvcSrlNo = ebm.dvcSrlNo;
        ProxyService.isar.update(data: business);
      } else if (localEbm != null &&
          ebm.lastTouched != null &&
          ebm.lastTouched!.isFutureDateCompareTo(localEbm.lastTouched!)) {
        ebm.id = ebm.localId;
        await ProxyService.isar.update(data: ebm);
      }
    }
    if (model is Transaction) {
      Transaction remoteTransaction = Transaction.fromJson(model.toJson());
      Transaction? localTransaction = await ProxyService.isar
          .getTransactionById(id: remoteTransaction.localId!);

      if (localTransaction == null &&
          remoteTransaction.branchId == ProxyService.box.getBranchId()) {
        remoteTransaction.id = remoteTransaction.localId;
        await ProxyService.isar.create(data: remoteTransaction);
      } else if (localTransaction != null &&
          remoteTransaction.lastTouched!
              .isFutureDateCompareTo(localTransaction.lastTouched!)) {
        remoteTransaction.id = remoteTransaction.localId;
        await ProxyService.isar.update(data: remoteTransaction);
      }
    }
    if (model is TransactionItem) {
      TransactionItem? remoteTransactionItem =
          TransactionItem.fromJson(model.toJson());
      TransactionItem? localTransaction = await ProxyService.isar
          .getTransactionItemById(id: remoteTransactionItem.localId!);

      if (localTransaction == null) {
        remoteTransactionItem.id = remoteTransactionItem.localId;
        await ProxyService.isar.create(data: remoteTransactionItem);
      } else if (remoteTransactionItem.lastTouched!
          .isFutureDateCompareTo(localTransaction.lastTouched!)) {
        remoteTransactionItem.id = remoteTransactionItem.localId;
        await ProxyService.isar.update(data: remoteTransactionItem);
      }
    }
  }
}
