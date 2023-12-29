import 'dart:developer';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:pocketbase/pocketbase.dart';
import 'dart:io';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class RemoteInterface {
  Future<List<RecordModel>> getCollection({required String collectionName});
  Future<RecordModel?> create(
      {required Map<String, dynamic> collection,
      required String collectionName});
  Future<void> hardDelete({required String id, required String collectionName});
  Future<RecordModel?> update(
      {required Map<String, dynamic> data,
      required String collectionName,
      required String recordId});
  Future<void> listenToChanges();
  Future<String?> getToken(
    String pocketbaseUrl,
    String pocketbasePassword,
    String pocketbaseEmail,
  );
}

mixin HandleItemMixin {
  Future<void> handleItem<T>({required T model, required int branchId}) async {
    if (model is Stock) {
      Stock remoteStock = Stock.fromJson(model.toJson());

      Stock? localStock =
          await ProxyService.isar.getStockById(id: remoteStock.id);

      if (localStock == null && remoteStock.branchId == branchId) {
        await ProxyService.isar.create(data: remoteStock);
      } else if (localStock != null &&
          localStock.lastTouched != null &&
          remoteStock.lastTouched
              .isFutureDateCompareTo(localStock.lastTouched)) {
        remoteStock.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteStock);
      }
    }
    if (model is Variant) {
      Variant remoteVariant = Variant.fromJson(model.toJson());
      Variant? localVariant =
          await ProxyService.isar.getVariantById(id: remoteVariant.id);

      if (localVariant == null && remoteVariant.branchId == branchId) {
        await ProxyService.isar.create(data: remoteVariant);
      } else if (localVariant != null &&
          localVariant.lastTouched != null &&
          remoteVariant.lastTouched
              .isFutureDateCompareTo(localVariant.lastTouched)) {
        remoteVariant.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteVariant);
      }
    }
    if (model is Product) {
      Product remoteProduct = Product.fromJson(model.toJson());
      Product? localProduct =
          await ProxyService.isar.getProduct(id: remoteProduct.id);

      if (localProduct == null && remoteProduct.branchId == branchId) {
        await ProxyService.isar.create(data: remoteProduct);
      } else if (localProduct != null &&
          localProduct.lastTouched != null &&
          remoteProduct.lastTouched
              .isFutureDateCompareTo(localProduct.lastTouched)) {
        remoteProduct.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteProduct);
      }
    }
    if (model is Device) {
      Device remoteDevice = Device.fromJson(model.toJson());
      Device? localDevice =
          await ProxyService.isar.getDeviceById(id: remoteDevice.id);

      if (localDevice == null && remoteDevice.branchId == branchId) {
        await ProxyService.isar.create(data: remoteDevice);
      } else if (localDevice != null &&
          localDevice.lastTouched != null &&
          remoteDevice.lastTouched
              .isFutureDateCompareTo(localDevice.lastTouched)) {
        localDevice.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: localDevice);
      }
    }
    if (model is Social) {
      Social remoteSocial = Social.fromJson(model.toJson());
      Social? localSocial =
          await ProxyService.isar.getSocialById(id: remoteSocial.id);

      if (localSocial == null &&
          remoteSocial.branchId == ProxyService.box.getBranchId()) {
        await ProxyService.isar.create(data: remoteSocial);
      } else if (localSocial != null &&
          remoteSocial.lastTouched
              .isFutureDateCompareTo(localSocial.lastTouched)) {
        remoteSocial.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteSocial);
      }
    }
    if (model is EBM) {
      EBM ebm = EBM.fromJson(model.toJson());
      EBM? localEbm =
          await ProxyService.isar.getEbmByBranchId(branchId: ebm.branchId);

      if (localEbm == null &&
          ebm.businessId == ProxyService.box.getBusinessId()) {
        ebm.lastTouched = DateTime.now();

        if (ebm.taxServerUrl != null) {
          ebm.taxServerUrl = ebm.taxServerUrl!.trim();
        }
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
          ebm.lastTouched.isFutureDateCompareTo(localEbm.lastTouched)) {
        ebm.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: ebm);
      }
    }
    if (model is ITransaction) {
      ITransaction remoteTransaction = ITransaction.fromJson(model.toJson());
      ITransaction? localTransaction =
          await ProxyService.isar.getTransactionById(id: remoteTransaction.id);

      if (localTransaction == null &&
          remoteTransaction.branchId == ProxyService.box.getBranchId()) {
        await ProxyService.isar.create(data: remoteTransaction);
      } else if (localTransaction != null &&
          remoteTransaction.lastTouched
              .isFutureDateCompareTo(localTransaction.lastTouched)) {
        remoteTransaction.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteTransaction);
      }
    }
    if (model is TransactionItem) {
      TransactionItem? remoteTransactionItem =
          TransactionItem.fromJson(model.toJson());
      TransactionItem? localTransaction = await ProxyService.isar
          .getTransactionItemById(id: remoteTransactionItem.id);

      if (localTransaction == null) {
        await ProxyService.isar.create(data: remoteTransactionItem);
      } else if (remoteTransactionItem.lastTouched
          .isFutureDateCompareTo(localTransaction.lastTouched)) {
        remoteTransactionItem.action = AppActions.updatedLocally;
        await ProxyService.isar.update(data: remoteTransactionItem);
      }
    }
  }
}

class RemoteService with HandleItemMixin implements RemoteInterface {
  PocketBase? pb;
  late String url;
  int _retryCount = 0;

  Future<RemoteInterface?> getInstance() async {
    try {
      String url;
      String password;
      String email;

      if (foundation.kDebugMode) {
        url = AppSecrets.apiUrlDebug;
        password = AppSecrets.debugPassword;
        email = AppSecrets.debugEmail;
      } else {
        url = AppSecrets.apiUrlProd;
        password = AppSecrets.prodPassword;
        email = AppSecrets.prodEmail;
      }

      pb = PocketBase(url);
      await pb!.admins.authWithPassword(email, password);

      return this;
    } catch (e) {
      if (_retryCount < 2) {
        _retryCount++;
        return retryConnect();
      } else {
        print("Failed to initialize RemoteInterface after retries: $e");
        return null; // Return null or another default value
      }
    }
  }

  Future<RemoteInterface?> retryConnect() async {
    await Future.delayed(Duration(seconds: 5));
    try {
      await pb!.admins.authWithPassword('info@yegobox.com', '5nUeS5TjpArcSGd');
      return this;
    } catch (e) {
      //throw Exception("Failed to initialize RemoteInterface.");
      return null;
    }
  }

  @override
  Future<List<RecordModel>> getCollection({required String collectionName}) {
    return pb!.collection(collectionName).getFullList();
  }

  @override
  Future<RecordModel?> create({
    required Map<String, dynamic> collection,
    required String collectionName,
  }) async {
    if (pb == null) {
      await getInstance();
    }
    try {
      collection['action'] = AppActions.updatedLocally;
      return await pb!.collection(collectionName).create(body: collection);
    } on SocketException catch (e) {
      log(e.toString());

      /// returning null here was casing the item to be updated locally as done
      /// syncing yet it was not done on remote server
      /// so moving [collection['action'] = AppActions.updatedLocally;] avoid the issue
      return null;
    } on ClientException catch (e) {
      log("Client error could not create item ${collection['id']} and ${collection['action']}");
      updateItemLocally(collectionName, collection);

      return null;
    } catch (e) {
      return null;
    }
  }

  void updateItemLocally(
      String collectionName, Map<String, dynamic> collection) {
    if (collectionName == "products") {
      collection['action'] = AppActions.updatedLocally;
      final json = Product.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "stocks") {
      collection['action'] = AppActions.updatedLocally;
      final json = Stock.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "variants") {
      collection['action'] = AppActions.updatedLocally;
      final json = Variant.fromJson(collection);
      ProxyService.isar.update(data: json);
    }

    if (collectionName == "transactions") {
      collection['action'] = AppActions.updatedLocally;
      final json = ITransaction.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "socials") {
      collection['action'] = AppActions.updatedLocally;
      final json = Social.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "favorites") {
      collection['action'] = AppActions.updatedLocally;
      final json = Favorite.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "devices") {
      collection['action'] = AppActions.updatedLocally;
      final json = Device.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
    if (collectionName == "transactionItems") {
      collection['action'] = AppActions.updatedLocally;
      final json = TransactionItem.fromJson(collection);
      ProxyService.isar.update(data: json);
    }
  }

  @override
  Future<RecordModel?> update({
    required Map<String, dynamic> data,
    required String collectionName,
    required String recordId,
  }) async {
    if (pb == null) {
      await getInstance();
    }
    try {
      // Record is empty
      data['action'] = AppActions.updatedLocally;
      return await pb!.collection(collectionName).update(recordId, body: data);
    } on SocketException catch (e) {
      log(e.toString());
      return null;
    } on ClientException catch (e) {
      if (e.statusCode == 404) {
        ///there is cases where a model is marked as need update locally yet it is not on
        ///remote, in this case create it first
        return await pb!.collection(collectionName).create(body: data);
      }
      log(e.statusCode.toString(), name: 'failed to update');
      ProxyService.sentry.debug(event: e.toString());
      return null;
    } catch (e) {
      ProxyService.sentry.debug(event: e.toString());
      return null;
    }
  }

  @override
  Future<void> listenToChanges() async {
    if (pb == null) {
      await getInstance();
    }
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
    if (pb == null) {
      await getInstance();
    }
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
        'transactionItems',
        'transactions',
        'devices',
        'socials',
        'rra',
      ];
      for (final collectionName in collections) {
        try {
          int page = 1;
          int perPage = 100;
          int totalPages = 1; // Initialize totalPages to 1

          do {
            final records = await pb!.collection(collectionName).getList(
                  page: page,
                  perPage: perPage,
                  filter: 'branchId = $branchId',
                );
            totalPages = records.totalPages;
            await Future.forEach(records.items, (RecordModel item) async {
              Map<String, dynamic> originalJson = item.toJson();

              // Create a copy of the original JSON
              Map<String, dynamic> updatedJson = Map.from(originalJson);

              // Update the 'action' property in the copied JSON
              /// we change action from remote fetched data to remote
              /// so that we don't push these data back when property has not changed
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
                  // log(updatedJson.toString(), name: 'rra data');
                  await handleItem(
                      model: EBM.fromJson(updatedJson), branchId: branchId);
                  break;
                case 'transactions':
                  await handleItem(
                      model: ITransaction.fromJson(updatedJson),
                      branchId: branchId);
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
            page++; // Move to the next page for the next iteration
          } while (page <= totalPages);
        } catch (e, s) {
          log(s.toString());
          log(e.toString(), name: 'on Pull ${collectionName}');
          Sentry.captureException(e);
        }
      }
    } on ClientException {
    } on SocketException {
    } on Exception {}
  }

  Future<void> gettingRealTimeData() {
    int branchId = ProxyService.box.getBranchId() ?? 0;
    int businessId = ProxyService.box.getBusinessId() ?? 0;
    if (branchId != 0 || businessId != 0) {
      pb!.collection('socials').subscribe("*", (socialEvent) async {
        if (socialEvent.action == "create" ||
            socialEvent.action == "update" ||
            socialEvent.action == "delete") {
          await handleRemoteData(
              socialEvent.record!, branchId, businessId, 'socials');
        }
      }, filter: "branchId == ${branchId}");

      pb!.collection('stocks').subscribe("*", (stockEvent) async {
        if (stockEvent.action == "create" ||
            stockEvent.action == "update" ||
            stockEvent.action == "delete") {
          await handleRemoteData(
              stockEvent.record!, branchId, businessId, 'stocks');
        }
      }, filter: "branchId == ${branchId}");

      pb!.collection('variants').subscribe("*", (variantEvent) async {
        if (variantEvent.action == "create" ||
            variantEvent.action == "update" ||
            variantEvent.action == "delete") {
          await handleRemoteData(
              variantEvent.record!, branchId, businessId, 'variants');
        }
      }, filter: "branchId == ${branchId}");

      pb!.collection('products').subscribe("*", (productEvent) async {
        if (productEvent.action == "create" ||
            productEvent.action == "update" ||
            productEvent.action == "delete") {
          await handleRemoteData(
              productEvent.record!, branchId, businessId, 'products');
        }
      }, filter: "branchId == ${branchId}");

      pb!.collection('devices').subscribe("*", (deviceEvent) async {
        if (deviceEvent.action == "create" ||
            deviceEvent.action == "update" ||
            deviceEvent.action == "delete") {
          await handleRemoteData(
              deviceEvent.record!, branchId, businessId, 'devices');
        }
      }, filter: "branchId == ${branchId}");
      pb!.collection('rra').subscribe("*", (deviceEvent) async {
        if (deviceEvent.action == "create" ||
            deviceEvent.action == "update" ||
            deviceEvent.action == "delete") {
          await handleRemoteData(
              deviceEvent.record!, branchId, businessId, 'rra');
        }
      }, filter: "branchId == ${branchId}");
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
    jsonData['action'] = AppActions.updatedLocally;
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
            model: ITransaction.fromJson(jsonData), branchId: branchId);
        break;
      case 'transactionItems':
        await handleItem(
            model: TransactionItem.fromJson(jsonData), branchId: branchId);
        break;
      default:
        break;
    }
  }

  @override
  Future<void> hardDelete(
      {required String id, required String collectionName}) async {
    try {
      await pb!.collection(collectionName).delete(id);
    } catch (e) {
      ProxyService.sentry.debug(event: e.toString());
    }
  }

  @override
  Future<String?> getToken(String pocketbaseUrl, String pocketbasePassword,
      String pocketbaseEmail) async {
    try {
      final response = await http.post(
        Uri.parse('$pocketbaseUrl/api/admins/auth-with-password'),
        body: {
          'identity': pocketbaseEmail,
          'password': pocketbasePassword,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data['token'] ?? '';
        return token;
      } else {
        // Handle error response here if needed
        return null;
      }
    } catch (e) {
      // Handle network or other exceptions here
      return null;
    }
  }
}
