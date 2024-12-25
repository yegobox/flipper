import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flipper_models/RealmInterface.dart';
import 'package:flipper_models/SessionManager.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as superUser;
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/Booting.dart';
import 'dart:async';
import 'package:flipper_services/abstractions/storage.dart' as storage;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:http/http.dart' as http;
import 'package:flipper_models/power_sync/schema.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'dart:typed_data';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/models/all_models.dart' as old;
import 'package:path/path.dart' as path;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/constants.dart';
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CoreSync with Booting, CoreMiscellaneous implements RealmInterface {
  final String apihub = AppSecrets.apihubProd;
  final repository = Repository();
  bool offlineLogin = false;

  bool isInIsolate() {
    return Isolate.current.debugName != null;
  }

  CoreSync({SupabaseClient? client});

  Future<void> _supa({required String tableName, required int id}) async {
    await ProxyService.supa.init();
    try {
      // Attempt to call the RPC function
      final rpcResult =
          await ProxyService.supa.client?.rpc('insert_key', params: {
        'current_secret_key': AppSecrets.insertKey,
      });

      // If RPC call is successful, proceed with the insert operation
      if (rpcResult != null) {
        final response =
            await ProxyService.supa.client?.from(dataMapperTable).upsert({
          'table_name': tableName,
          'object_id': id,
          'device_identifier':
              await ProxyService.strategy.getPlatformDeviceId(),

          /// Tobe done incorporate it into payment wall the device expected to download the object.
          'sync_devices': 0,

          /// this exclude the device that is writing the object setting it to 1
          'device_downloaded_object': 1
        }).select();
        talker.warning(response);
      }
    } catch (e) {
      talker.error('Error occurred: $e');
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  bool compareChanges(Map<String, dynamic> item, Map<String, dynamic> map) {
    for (final key in item.keys) {
      if (map[key]?.toString() != item[key]?.toString()) {
        return true;
      }
    }
    return false;
  }

  static const int BATCH_SIZE = 100;

  List<List<TransactionItem>> _splitIntoBatches(
      List<TransactionItem> items, int batchSize) {
    return [
      for (var i = 0; i < items.length; i += batchSize)
        items.sublist(
            i, i + batchSize > items.length ? items.length : i + batchSize)
    ];
  }

  @override
  Future<bool> firebaseLogin({String? token}) async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return false;
    final pinLocal = await ProxyService.strategy.getPinLocal(userId: userId);
    try {
      token ??= pinLocal?.tokenUid;

      if (token != null) {
        talker.warning(token);
        await FirebaseAuth.instance.signInWithCustomToken(token);

        return true;
      }
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      talker.error(e);
      // talker.info("Retry ${pinLocal?.uid ?? "NULL"}");
      final http.Response response = await ProxyService.strategy
          .sendLoginRequest(
              pinLocal!.phoneNumber!, ProxyService.http, AppSecrets.apihubProd,
              uid: pinLocal.uid!);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        /// path the user pin, with
        final IUser user = IUser.fromJson(json.decode(response.body));

        ProxyService.strategy.updatePin(
          userId: user.id!,
          phoneNumber: pinLocal.phoneNumber,
          tokenUid: user.uid,
        );
      }

      return false;
    }
  }

  @override
  AsyncCollection? accessCollection;

  @override
  AsyncCollection? branchCollection;

  @override
  AsyncCollection? businessCollection;

  @override
  DatabaseProvider? capella;

  @override
  AsyncCollection? permissionCollection;

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  //TODO: add a filter of a businessId when looking for a branch to avoid query unreleated branches
  @override
  Future<Branch> activeBranch() async {
    return (await repository.get<Branch>(
            query:
                brick.Query(where: [brick.Where('isDefault').isExactly(true)])))
        .first;
  }

  @override
  Future<Business?> activeBusiness({required int userId}) async {
    return (await repository.get<Business>(
            query:
                brick.Query(where: [brick.Where('userId').isExactly(userId)])))
        .firstOrNull;
  }

  @override
  Category? activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError("activeCategory is not implemented yet");
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) {
    // TODO: implement addCustomer
    throw UnimplementedError("addCustomer is not implemented yet");
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError("addFavorite is not implemented yet");
  }

  @override
  void addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError("addTransactionItem is not implemented yet");
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      for (Map map in units) {
        final unit = IUnit(
            active: map['active'],
            branchId: branchId,
            id: randomNumber(),
            name: map['name'],
            lastTouched: DateTime.now(),
            value: map['value']);

        // Add the unit to Realm
        await repository.upsert<IUnit>(unit);
      }

      return 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) async {
    try {
      for (final variation in variations) {
        await _processVariant(branchId, variation);
      }
      return 200;
    } catch (e) {
      print('Failed to add variants: $e');
      rethrow;
    }
  }

  Future<void> _processVariant(int branchId, Variant variation) async {
    try {
      int stockId = randomNumber();
      // Variant? variant = realm!.query<Variant>(
      //     r'id == $0 && branchId == $1 && deletedAt == nil',
      //     [variation.id, branchId]).firstOrNull;
      Variant? variant = await getVariantById(id: variation.id);

      if (variant != null) {
        // Stock? stock = realm!.query<Stock>(
        //     r'id == $0 && branchId == $1 && deletedAt == nil',
        //     [stockId, branchId]).firstOrNull;
        Stock? stock = await getStockById(id: stockId);

        if (stock == null) {
          final newStock = Stock(
              id: stockId,
              lastTouched: DateTime.now(),
              branchId: branchId,
              variant: variation,
              // variantId: variation.id,
              currentStock: stock?.rsdQty ?? 0,
              rsdQty: stock?.rsdQty ?? 0,
              value: (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
                  .toDouble(),
              productId: variation.productId,
              active: false);
          // realm!.put<Stock>(newStock, tableName: 'stocks');
          repository.upsert<Stock>(newStock);
        }

        stock!.currentStock =
            stock.currentStock! + (variation.stock?.rsdQty ?? 0);
        stock.rsdQty = stock.currentStock! + (stock.rsdQty!);
        stock.lastTouched = DateTime.now().toLocal();
        stock.value = (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
            .toDouble();
        // realm!.put<Stock>(stock, tableName: 'stocks');
        await repository.upsert<Stock>(stock);
        variant.stock?.rsdQty = variation.stock?.rsdQty ?? 0;
        variant.retailPrice = variation.retailPrice;
        variant.supplyPrice = variation.supplyPrice;
        variant.lastTouched = DateTime.now().toLocal();
        // realm!.put<Variant>(variant, tableName: 'variants');
        await repository.upsert<Variant>(variant);
      } else {
        int stockId = randomNumber();

        talker.info("Saving variant when scanning..... [1]");

        await repository.upsert<Variant>(variation);

        final newStock = Stock(
            id: stockId,
            lastTouched: DateTime.now(),
            branchId: branchId,
            // variantId: variation.id,
            variant: variation,
            currentStock: variation.stock?.rsdQty ?? 0,
            value: (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
                .toDouble(),
            productId: variation.productId)
          ..active = true;

        await repository.upsert<Stock>(newStock);
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  @override
  Future<void> amplifyLogout() async {
    try {
      amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
  }

  @override
  Stream<Tenant?> authState({required int branchId}) async* {
    final userId = ProxyService.box.getUserId();

    if (userId == null) {
      // Handle the case where userId == null, perhaps throw an exception or return an error Stream
      throw Exception('User ID == nil');
    }

    final controller = StreamController<Tenant?>();

    repository
        .subscribe<Tenant>(
            query:
                brick.Query(where: [brick.Where('userId').isExactly(userId)]))
        .listen((tenants) {
      controller.add(tenants.isEmpty ? null : tenants.first);
    });

    await for (var tenant in controller.stream) {
      yield tenant;
    }
    // Close the StreamController after the stream is finishe
    controller.close();
  }

  @override
  Future<bool> bindProduct({required int productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError('addVariant method is not implemented yet');
  }

  @override
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) async {
    return await _getBranches(businessId, includeSelf!);
  }

  Future<List<Branch>> _getBranches(int businessId, bool active) async {
    try {
      return await repository.get<Branch>(
          query: brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
        brick.Or('active').isExactly(active),
        brick.Or('active').isExactly(false)
      ]));
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<ext.BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"}
    ];
    await Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Future<List<Business>> businesses({required int userId}) async {
    return await repository.get<Business>(
        query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));
  }

  @override
  Future<List<Category>> categories({required int branchId}) {
    return repository.get<Category>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Stream<List<Category>> categoryStream() async* {
    final controller = StreamController<List<Category>>.broadcast();
    final branchId = ProxyService.box.getBranchId()!;
    controller.onListen = () async {
      try {
        final categories = await repository.get<Category>(
            query: brick.Query(
                where: [brick.Where('branchId').isExactly(branchId)]));
        if (categories.isNotEmpty) {
          controller.add(categories);
        }
      } catch (e, s) {
        talker.error('Error fetching categories: $e');
        talker.error('Stack trace: $s');
      }
    };

    controller.onCancel = () {
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  void clearData({required ClearData data}) async {
    try {
      if (data == ClearData.Branch) {
        // Retrieve the list of Branches to delete based on the query
        // final query = brick.Query();
        final List<Branch> branches = await repository.get<Branch>();

        for (final branch in branches) {
          await repository.delete<Branch>(branch);
        }
      }

      if (data == ClearData.Business) {
        // Retrieve the list of Businesses to delete
        final List<Business> businesses = await repository.get<Business>();

        for (final business in businesses) {
          await repository.delete<Business>(business);
        }
      }
    } catch (e, s) {
      // Log the error with talker
      talker.error('Failed to clear data: $e');
      talker.error('Stack trace: $s');
    }
  }

  @override
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    // TODO: implement closeDrawer
    throw UnimplementedError("closeDrawer method is not implemented yet");
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError("colors method is not implemented yet");
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) {
    // TODO: implement completedTransactions
    throw UnimplementedError(
        "completedTransactions method is not implemented yet");
  }

  @override
  Composite composite({required int variantId}) {
    // TODO: implement composite
    throw UnimplementedError("composite method is not implemented yet");
  }

  @override
  List<Composite> composites({required int productId}) {
    // TODO: implement composites
    throw UnimplementedError("composites method is not implemented yet");
  }

  @override
  List<Composite> compositesByVariantId({required int variantId}) {
    // TODO: implement compositesByVariantId
    throw UnimplementedError(
        "compositesByVariantId method is not implemented yet");
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    await configureTheBox(userPhone, user);
    await saveNeccessaryData(user);
    if (!offlineLogin) {
      await _suserbaseAuth();
    }
  }

  Future<void> _suserbaseAuth() async {
    try {
      // Check if the user already exists
      final email = '${ProxyService.box.getBranchId()}@flipper.rw';
      final superUser.User? existingUser =
          superUser.Supabase.instance.client.auth.currentUser;

      if (existingUser == null) {
        // User does not exist, proceed to sign up
        await superUser.Supabase.instance.client.auth.signUp(
          email: email,
          password: email,
        );
        // Handle sign-up response if needed
      } else {
        // User exists, log them in
        await superUser.Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: email,
        );
      }
    } catch (e) {}
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  void createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) {
    // TODO: implement createNewStock
    throw UnimplementedError("createNewStock method is not implemented yet");
  }

  @override
  void createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) {
    // TODO: implement createOrUpdateBranchOnCloud
    throw UnimplementedError(
        "createOrUpdateBranchOnCloud method is not implemented yet");
  }

  Future<models.Variant> _createRegularVariant(int branchId, int? tinNumber,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      String? bhFId,
      required bool ebmSynced,
      Product? product,
      required int productId,
      required String name,
      required String sku}) async {
    final int variantId = randomNumber();
    final number = randomNumber().toString().substring(0, 5);

    return Variant(
        lastTouched: DateTime.now(),
        name: product?.name ?? name,
        sku: sku,
        productId: product?.id ?? productId,
        color: product?.color,
        unit: 'Per Item',
        productName: product?.name ?? name,
        branchId: branchId,
        supplyPrice: supplierPrice,
        retailPrice: retailPrice,
        id: variantId,
        bhfId: bhFId ?? '00',
        itemStdNm: "Regular",
        addInfo: "A",
        pkg: "1",
        splyAmt: supplierPrice,
        itemClsCd: "5020230602",
        itemCd: await itemCode(
          countryCode: 'RW',
          productType: "2",
          packagingUnit: "CT",
          quantityUnit: "BJ",
        ),
        modrNm: number,
        modrId: number,
        pkgUnitCd: "BJ",
        regrId: randomNumber().toString().substring(0, 5),
        itemTyCd: "2", // this is a finished product
        /// available type for itemTyCd are 1 for raw material and 3 for service
        /// is insurance applicable default is not applicable
        isrcAplcbYn: "N",
        useYn: "N",
        itemSeq: itemSeq,
        itemNm: product?.name ?? name,
        taxPercentage: 18.0,
        tin: tinNumber,
        bcd: product?.name ?? name,

        /// country of origin for this item we default until we support something different
        /// and this will happen when we do import.
        orgnNatCd: "RW",

        /// registration name
        regrNm: product?.name ?? name,

        /// taxation type code
        taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
        // default unit price
        dftPrc: retailPrice,
        prc: retailPrice,

        // NOTE: I believe bellow item are required when saving purchase
        ///but I wonder how to get them when saving an item.
        spplrItemCd: "",
        spplrItemClsCd: "",
        spplrItemNm: product?.name ?? name,

        /// Packaging Unit
        qtyUnitCd: "U", // see 4.6 in doc
        ebmSynced: ebmSynced);
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) async {
    final String productName = product.name;
    if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
      final Product? existingProduct = await getProduct(
          name: productName, businessId: businessId, branchId: branchId);
      if (existingProduct != null) {
        return existingProduct;
      }
    }

    SKU sku = await getSku(branchId: branchId, businessId: businessId);

    sku.consumed = true;
    await repository.upsert(sku);
    await repository.upsert(product);

    if (!skipRegularVariant) {
      Product? kProduct = await getProduct(
          id: product.id, branchId: branchId, businessId: businessId);
      Variant newVariant = await _createRegularVariant(branchId, tinNumber,
          qty: qty,
          product: product,
          bhFId: bhFId,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
          name: product.name,
          sku: sku.sku.toString(),
          productId: product.id,
          itemSeq: itemSeq,
          ebmSynced: ebmSynced);
      await repository.upsert<Variant>(newVariant);

      final Stock stock = Stock(
          lastTouched: DateTime.now(),
          id: randomNumber(),
          variant: newVariant,
          branchId: branchId,
          // variantId: newVariant.id,
          currentStock: qty,
          productId: kProduct!.id);

      await repository.upsert<Stock>(stock);
    }
    return (await repository.get<Product>(
            query: brick.Query.where('id', product.id)))
        .first;
  }

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter,
      required int invoiceNumber}) {
    // TODO: implement createReceipt
    throw UnimplementedError("createReceipt method is not implemented yet");
  }

  @override
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId}) {
    // TODO: implement createStockRequest
    throw UnimplementedError(
        "createStockRequest method is not implemented yet");
  }

  @override
  void createVariant(
      {required String barCode,
      required String sku,
      required int productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name}) {
    // TODO: implement createVariant
  }

  @override
  List<Customer> customers({required int branchId}) {
    // TODO: implement customers
    throw UnimplementedError("customers method is not implemented yet");
  }

  @override
  Future<Branch?> defaultBranch() async {
    return (await repository.get<Branch>(
            query: brick.Query(where: [
      brick.Where('isDefault').isExactly(true),
    ])))
        .firstOrNull;
  }

  @override
  Future<Business?> defaultBusiness() async {
    return (await repository.get<Business>(
            query:
                brick.Query(where: [brick.Where('isDefault').isExactly(true)])))
        .firstOrNull;
  }

  @override
  Future<bool> delete(
      {required int id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) {
    // TODO: implement delete
    throw UnimplementedError("delete method is not implemented yet");
  }

  @override
  Future<void> deleteAllProducts() {
    // TODO: implement deleteAllProducts
    throw UnimplementedError("deleteAllProducts method is not implemented yet");
  }

  @override
  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement deleteBranch
    throw UnimplementedError("deleteBranch method is not implemented yet");
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError(
        "deleteFavoriteByIndex method is not implemented yet");
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, int? transactionId}) {
    // TODO: implement deleteItemFromCart
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) {
    // TODO: implement deleteTransactionByIndex
    throw UnimplementedError(
        "deleteTransactionByIndex method is not implemented yet");
  }

  final sessionManager = SessionManager();
  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) async {
    Directory directoryPath = await getSupportDir();

    final filePath = path.join(directoryPath.path, assetName);

    final file = File(filePath);
    if (await file.exists()) {
      talker.warning('File Exist: ${file.path}');
      return Stream.value(100.0); // Return a stream indicating 100% completion
    }
    talker.warning("file to Download:$filePath");
    if (!await sessionManager.isAuthenticated()) {
      await sessionManager.signIn("yegobox@gmail.com");
      if (!await sessionManager.isAuthenticated()) {
        throw Exception('Failed to authenticate');
      }
    }
    final storagePath = amplify.StoragePath.fromString(
        'public/${subPath}-$branchId/$assetName');
    try {
      // Create a stream controller to manage the progress
      final progressController = StreamController<double>();
      // Start the download process
      final operation = amplify.Amplify.Storage.downloadFile(
        path: storagePath,
        localFile: amplify.AWSFile.fromPath(filePath),
        onProgress: (progress) {
          // Calculate the progress percentage
          final percentageCompleted =
              (progress.fractionCompleted * 100).toInt();
          // Add the progress to the stream
          progressController.sink.add(percentageCompleted.toDouble());
        },
      );
      // Listen for the download completion
      operation.result.then((_) {
        progressController.close();
        talker.warning("Downloaded file at path ${storagePath}");
      }).catchError((error) async {
        progressController.addError(error);
        progressController.close();
      });
      return progressController.stream;
    } catch (e) {
      talker.error('Error downloading file: $e');
      rethrow;
    }
  }

  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) {
    // TODO: implement downloadAssetSave
    throw UnimplementedError("downloadAssetSave method is not implemented yet");
  }

  @override
  Future<Ebm?> ebm({required int branchId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final result = await repository.get<models.Ebm>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    final query = brick.Query(
        where: [brick.Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<models.Product>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  FutureOr<Branch?> branch({required int serverId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(serverId)]);
    final result = await repository.get<models.Branch>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(productId)]);
    // Return the stream directly instead of storing in variable
    return repository.subscribe<Variant>(query: query);
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, int? productId}) async {
    final repository = Repository();
    final query = brick.Query(
        where: assetName != null
            ? [brick.Where('assetName').isExactly(assetName)]
            : productId != null
                ? [brick.Where('productId').isExactly(productId)]
                : throw Exception("no asset"));
    final result = await repository.get<models.Assets>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  FutureOr<Business?> getBusiness({int? businessId}) async {
    final repository = Repository();
    final query = brick.Query(
        where: businessId != null
            ? [brick.Where('serverId').isExactly(businessId)]
            : [brick.Where('isDefault').isExactly(true)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(businessId)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) async {
    final repository = Repository();
    final query = brick.Query(where: [brick.Where('serverId').isExactly(id)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Business? business = result.firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(
          id: iBusiness.id!,
          serverId: iBusiness.id!,
          name: iBusiness.name,
          userId: iBusiness.userId,
          createdAt: DateTime.now().toIso8601String());

      business.serverId = id;
      await repository.upsert<models.Business>(business);
      return business;
    }
    return null;
  }

  @override
  FutureOr<Configurations?> getByTaxType({required String taxtype}) async {
    final repository = Repository();
    final query = brick.Query(where: [
      brick.Where('taxType').isExactly(taxtype),
      brick.Where('branchId').isExactly(ProxyService.box.getBranchId()!),
    ]);
    final result = await repository.get<models.Configurations>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<PColor?> getColor({required int id}) async {
    final repository = Repository();
    final query = brick.Query(where: [brick.Where('id').isExactly(id)]);
    final result = await repository.get<models.PColor>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
    final repository = brick.Repository();
    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('receiptType').isExactly(receiptType),
    ]);
    final counter = await repository.get<models.Counter>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return counter.firstOrNull;
  }

  @override
  Future<List<Counter>> getCounters({required int branchId}) async {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<models.Counter>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    return counters;
  }

  @override
  Future<Variant?> getCustomVariant(
      {required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId}) async {
    final repository = Repository();
    final productQuery = brick.Query(where: [
      brick.Where('name').isExactly(CUSTOM_PRODUCT),
      brick.Where('branchId').isExactly(branchId),
    ]);
    final productResult = await repository.get<models.Product>(
        query: productQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Product? product = productResult.firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
          tinNumber: tinNumber,
          bhFId: bhFId,
          branchId: branchId,
          businessId: businessId,
          product: models.Product(
              id: randomNumber(),
              lastTouched: DateTime.now(),
              name: CUSTOM_PRODUCT,
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toIso8601String(),
              branchId: branchId));
    }

    /// for whatever reason if a product exist and there is no related variant please add it before we proceed.
    final variantQuery =
        brick.Query(where: [brick.Where('productId').isExactly(product!.id)]);
    final variantResult = await repository.get<models.Variant>(
        query: variantQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Variant? variant = variantResult.firstOrNull;

    if (variant == null) {
      /// If the variant doesn't exist, add it
      variant = await _addMissingVariant(variant, product, branchId, tinNumber);
    }

    return variant;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId, int tinNumber) async {
    final number = randomNumber().toString().substring(0, 5);
    final repository = Repository();
    try {
      if (variant == null) {
        int variantId = randomNumber();
        final stockId = randomNumber();
        variant = Variant(
            id: variantId,

            // branchIds: [ProxyService.box.getBranchId()!],
            lastTouched: DateTime.now(),
            name: product!.name,
            color: product.color,
            sku: 'sku',
            productId: product.id,
            unit: 'Per Item',
            productName: product.name,
            branchId: branchId,
            supplyPrice: 0,
            retailPrice: 0,
            itemNm: product.name,
            bhfId: (await ProxyService.box.bhfId()) ?? '00',
            // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
            itemClsCd: "5020230602",
            itemCd: randomNumber().toString().substring(0, 5),
            modrNm: number,
            modrId: number,
            pkgUnitCd: "BJ",
            regrId: randomNumber().toString().substring(0, 5),
            itemTyCd: "2", // this is a finished product
            /// available type for itemTyCd are 1 for raw material and 3 for service
            /// is insurance applicable default is not applicable
            isrcAplcbYn: "N",
            useYn: "N",
            itemSeq: 1,
            itemStdNm: product.name,
            taxPercentage: 18,
            tin: tinNumber,
            bcd: CUSTOM_PRODUCT,

            /// country of origin for this item we default until we support something different
            /// and this will happen when we do import.
            orgnNatCd: "RW",

            /// registration name
            regrNm: CUSTOM_PRODUCT,

            /// taxation type code
            taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
            // default unit price
            dftPrc: 0,

            // NOTE: I believe bellow item are required when saving purchase
            ///but I wonder how to get them when saving an item.
            spplrItemCd: randomNumber().toString().substring(0, 5),
            spplrItemClsCd: randomNumber().toString().substring(0, 5),
            spplrItemNm: CUSTOM_PRODUCT,
            qtyUnitCd: "U");

        Stock stock = Stock(
            variant: variant,
            lastTouched: DateTime.now(),
            id: stockId,
            branchId: branchId,
            // variantId: variantId,
            currentStock: 0,
            productId: product.id)
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..currentStock = 0
          ..branchId = branchId
          // ..variantId = variantId
          ..lowStock = 10 // default static
          ..canTrackingStock = true
          ..showLowStockAlert = true
          ..active = false
          ..productId = product.id
          ..rsdQty = 0;

        repository.upsert<Variant>(variant);

        repository.upsert<Stock>(stock);

        final variantQuery =
            brick.Query(where: [brick.Where('id').isExactly(variantId)]);
        final variantResult = await repository.get<models.Variant>(
            query: variantQuery,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        return variantResult.firstOrNull;
      }
    } catch (e, s) {
      // Handle error during write operation
      talker.error(e);
      talker.error(s);
      throw Exception(e);
    }
    return variant;
  }

  FutureOr<Customer?> getCustomer({String? key, int? id}) async {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }

    if (id != null) {
      // Query by ID
      final query = brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
      ]);
      final List<Customer> customers =
          await repository.get<Customer>(query: query);
      return customers.isNotEmpty ? customers.first : null;
    } else if (key != null) {
      // Queries for each field combined with OR logic
      final queries = [
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('custNm', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('email', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('telNo', value: key, compare: brick.Compare.contains),
        ]),
      ];

      for (final query in queries) {
        final List<Customer> customers = await repository.get<Customer>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        if (customers.isNotEmpty) return customers.first;
      }
    }

    return null;
  }

  @override
  FutureOr<List<Customer>> getCustomers({String? key, int? id}) async {
    final List<Customer> customers = [];
    if (id != null) {
      // Query by ID
      final query = brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
      ]);
      final List<Customer> fetchedCustomers =
          await repository.get<Customer>(query: query);
      customers.addAll(fetchedCustomers);
    } else if (key != null) {
      // Queries for each field combined with OR logic
      final queries = [
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('custNm', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('email', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('telNo', value: key, compare: brick.Compare.contains),
        ]),
      ];

      for (final query in queries) {
        final List<Customer> fetchedCustomers = await repository.get<Customer>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        customers.addAll(fetchedCustomers);
      }
    }
    return customers;
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
    final query =
        brick.Query(where: [brick.Where('businessId').isExactly(businessId)]);
    // Return the stream directly instead of storing in variable
    return repository
        .subscribe<Tenant>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist)
        .map((tenants) => tenants.firstOrNull);
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    final query = brick.Query(where: [
      brick.Where('phone', value: phone, compare: brick.Compare.exact),
      brick.Where(
        'linkingCode',
        value: linkingCode,
        compare: brick.Compare.exact,
      ),
    ]);
    final List<Device> fetchedDevices =
        await repository.get<Device>(query: query);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(id)]);
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    final query = brick.Query(
      where: [brick.Where('businessId').isExactly(businessId)],
    );
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    final query =
        brick.Query(where: [brick.Where('cashierId').isExactly(cashierId)]);
    final List<Drawers> fetchedDrawers = await repository.get<Drawers>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDrawers.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(favId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    return repository
        .subscribe<Favorite>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist)
        .map((data) => data.firstOrNull);
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(prodId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    final query = brick.Query();
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites;
  }

  @override
  Future<String> getIdToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "NONE";
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() async {
    final query = brick.Query(providerArgs: {'orderBy': 'createdAt DESC'});
    final List<FlipperSaleCompaign> fetchedCampaigns =
        await repository.get<FlipperSaleCompaign>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedCampaigns.firstOrNull;
  }

  @override
  Future<models.Plan?> getPaymentPlan({required int businessId}) async {
    try {
      final repository = brick.Repository();

      final query = brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
      ]);
      final result = await repository.get<models.Plan>(
          query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required int transactionId}) async {
    final query = brick.Query(
        where: [brick.Where('transactionId').isExactly(transactionId)]);
    final List<TransactionPaymentRecord> fetchedPaymentTypes =
        await repository.get<TransactionPaymentRecord>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedPaymentTypes;
  }

  @override
  Future<ext.IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) async {
    final Uri uri = Uri.parse("$apihub/v2/api/pin/$pinString");

    try {
      final localPin = await repository.get<Pin>(
          query:
              brick.Query(where: [brick.Where('userId').isExactly(pinString)]),
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

      if (localPin.firstOrNull != null) {
        Business? business = await getBusinessById(
            businessId: localPin.firstOrNull!.businessId!);
        Branch? branchE =
            await branch(serverId: localPin.firstOrNull!.branchId!);
        if (branchE != null || business != null) {
          return IPin(
              id: localPin.firstOrNull?.id,
              pin: localPin.firstOrNull?.pin ?? int.parse(pinString),
              userId: localPin.firstOrNull!.userId!.toString(),
              phoneNumber: localPin.firstOrNull!.phoneNumber!,
              branchId: localPin.firstOrNull!.branchId!,
              businessId: localPin.firstOrNull!.businessId!,
              ownerName: localPin.firstOrNull!.ownerName!,
              tokenUid: localPin.firstOrNull!.tokenUid!);
        } else {
          clearData(data: ClearData.Branch);
          clearData(data: ClearData.Business);
        }
      } else {
        clearData(data: ClearData.Branch);
        clearData(data: ClearData.Business);
      }
      final response = await flipperHttpClient.get(uri);

      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw PinError(term: "Not found");
      } else {
        throw PinError(term: "Not found");
      }
    } catch (e, s) {
      talker.warning(e, s);

      throw UnknownError(term: e.toString());
    }
  }

  @override
  FutureOr<Pin?> getPinLocal({required int userId}) async {
    return (await repository.get<Pin>(
            query:
                brick.Query(where: [brick.Where('userId').isExactly(userId)])))
        .firstOrNull;
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.serialNumber;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.macOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.systemGUID;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.windows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    }
    return null;
  }

  @override
  Future<List<Product>> getProductList(
      {int? prodIndex, required int branchId}) {
    // TODO: implement getProductList
    throw UnimplementedError("getProductList method is not implemented yet");
  }

  @override
  List<Product> getProducts({String? key}) {
    // TODO: implement getProducts
    throw UnimplementedError("getProducts method is not implemented yet");
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
    // TODO: implement getReceipt
    throw UnimplementedError("getReceipt method is not implemented yet");
  }

  @override
  Future<({double grossProfit, double netProfit})> getReportData() {
    // TODO: implement getReportData
    throw UnimplementedError("getReportData method is not implemented yet");
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError("getSetting method is not implemented yet");
  }

  @override
  Future<Stock?> getStock(
      {required int branchId,
      required int? variantId,
      bool nonZeroValue = false,
      int? id}) async {
    if (variantId == null) {
      final stock = await repository.get<Stock>(
          query: brick.Query(where: [
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
      ]));
      return stock.firstOrNull;
    } else if (id != null) {
      final stock = await repository.get<Stock>(
          query: brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
      ]));
      return stock.firstOrNull;
    } else {
      final stock = await repository.get<Stock>(
          query: brick.Query(where: [
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
        brick.Where('variantId',
            value: variantId, compare: brick.Compare.exact),
      ]));
      return stock.firstOrNull;
    }
  }

  @override
  FutureOr<Stock?> getStockById({required int id}) async {
    final query = brick.Query(where: [
      brick.Where('id', value: id, compare: brick.Compare.exact),
    ]);
    return (await repository.get<Stock>(query: query)).firstOrNull;
  }

  @override
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId}) {
    // TODO: implement getStockStream
    throw UnimplementedError("getStockStream method is not implemented yet");
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    // TODO: implement getStockValue
    throw UnimplementedError("getStockValue method is not implemented yet");
  }

  @override
  FutureOr<Tenant?> getTenant({int? userId, int? pin}) async {
    if (userId != null) {
      return (await repository.get<Tenant>(
              query: brick.Query(
                  where: [brick.Where('userId').isExactly(userId)])))
          .firstOrNull;
    } else if (pin != null) {
      return (await repository.get<Tenant>(
              query: brick.Query(where: [brick.Where('pin').isExactly(pin)])))
          .firstOrNull;
    }
    throw Exception("UserId or Pin is required");
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError(
        "getTransactionItemById method is not implemented yet");
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) {
    // TODO: implement getTransactionItemsByTransactionId
    throw UnimplementedError(
        "getTransactionItemsByTransactionId method is not implemented yet");
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
    throw UnimplementedError(
        "getTransactionsAmountsSum method is not implemented yet");
  }

  @override
  Variant? getVariantByProductId({required int productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError(
        "getVariantByProductId method is not implemented yet");
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    // TODO: implement getVariantByProductIdStream
    throw UnimplementedError(
        "getVariantByProductIdStream method is not implemented yet");
  }

  @override
  List<Variant> getVariants({String? key}) {
    // TODO: implement getVariants
    throw UnimplementedError("getVariants is not implemented yet");
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    models.Plan? plan = await getPaymentPlan(businessId: businessId);

    if (plan == null) {
      throw NoPaymentPlanFound(
          "No payment plan found for businessId: $businessId");
    }

    // If paymentCompletedByUser is false, sync again and check
    if (!(plan.paymentCompletedByUser ?? false)) {
      final isPaymentComplete = await ProxyService.realmHttp.isPaymentComplete(
          flipperHttpClient: flipperHttpClient, businessId: businessId);

      if (!isPaymentComplete) {
        throw FailedPaymentException(PAYMENT_REACTIVATION_REQUIRED);
      }
    }

    return true;
  }

  @override
  Future<void> initCollections() {
    // TODO: implement initCollections
    throw UnimplementedError("initCollections method is not implemented yet");
  }

  @override
  FutureOr<bool> isAdmin(
      {required int userId, required String appFeature}) async {
    //  try {
    //     final Access? permission = realm?.query<Access>(
    //         r'userId == $0 && featureName == $1',
    //         [userId, appFeature]).firstOrNull;
    //     talker.warning(permission?.accessLevel?.toLowerCase());
    //     return permission?.accessLevel?.toLowerCase() == "admin";
    //   } catch (e) {
    //     rethrow;
    //   }
    // check if we have any access where UserId first
    final anyAccess = await repository.get<Access>(
        query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));

    /// cases where no access was set to a user he is admin by default.
    if (anyAccess.firstOrNull == null) return true;

    final accesses = await repository.get<Access>(
        query: brick.Query(where: [
      brick.Where('userId').isExactly(userId),
      brick.Or('featureName').isExactly(appFeature),
      brick.Or('accessLevel').isExactly('admin'),
    ]));

    return accesses.firstOrNull != null;
  }

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError("isDrawerOpen method is not implemented yet");
  }

  @override
  bool isRealmClosed() {
    // TODO: implement isRealmClosed
    throw UnimplementedError("isRealmClosed method is not implemented yet");
  }

  @override
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId}) {
    // TODO: implement isTokenValid
    throw UnimplementedError("isTokenValid method is not implemented yet");
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError(
        "lifeTimeCustomersForbranch method is not implemented yet");
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError("loadConversations is not implemented yet");
  }

  String _formatPhoneNumber(String userPhone) {
    if (!isEmail(userPhone) && !userPhone.startsWith('+')) {
      return '+$userPhone';
    }
    return userPhone;
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient}) async {
    final flipperWatch? w =
        foundation.kDebugMode ? flipperWatch("callLoginApi") : null;
    w?.start();
    final String phoneNumber = _formatPhoneNumber(userPhone);
    final IUser user =
        await _authenticateUser(phoneNumber, pin, flipperHttpClient);
    await configureSystem(userPhone, user, offlineLogin: offlineLogin);
    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    if (stopAfterConfigure) return user;
    if (!skipDefaultAppSetup) {
      await setDefaultApp(user);
    }
    ProxyService.box.writeBool(key: 'pinLogin', value: false);
    w?.log("user logged in");
    try {
      _hasActiveSubscription();
    } catch (e) {
      rethrow;
    }
    return user;
  }

  Future<void> _hasActiveSubscription() async {
    await hasActiveSubscription(
        businessId: ProxyService.box.getBusinessId()!,
        flipperHttpClient: ProxyService.http);
  }

  Future<IUser> _authenticateUser(String phoneNumber, Pin pin,
      HttpClientInterface flipperHttpClient) async {
    List<Business> businessesE = await businesses(userId: pin.userId!);
    List<Branch> branchesE = await branches(businessId: pin.businessId!);

    if (businessesE.isNotEmpty && branchesE.isNotEmpty) {
      offlineLogin = true;

      return _createOfflineUser(phoneNumber, pin, businessesE, branchesE);
    }

    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      /// path the user pin, with
      final IUser user = IUser.fromJson(json.decode(response.body));
      await _patchPin(user.id!, flipperHttpClient, apihub,
          ownerName: user.tenants.first.name);
      ProxyService.box.writeInt(key: 'userId', value: user.id!);
      await ProxyService.strategy.firebaseLogin(token: user.uid);
      return user;
    } else {
      await _handleLoginError(response);
      throw Exception("Error during login");
    }
  }

  Future<http.Response> _patchPin(
      int pin, HttpClientInterface flipperHttpClient, String apihub,
      {required String ownerName}) async {
    return await flipperHttpClient.patch(
      Uri.parse(apihub + '/v2/api/pin/${pin}'),
      body: jsonEncode(<String, String?>{
        'ownerName': ownerName,
        'tokenUid': firebase.FirebaseAuth.instance.currentUser?.uid
      }),
    );
  }

  Future<void> _handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  IUser _createOfflineUser(String phoneNumber, Pin pin,
      List<Business> businesses, List<Branch> branches) {
    return IUser(
      token: pin.tokenUid!,
      uid: pin.tokenUid,
      channels: [],
      phoneNumber: pin.phoneNumber!,
      id: pin.userId!,
      tenants: [
        ITenant(
            id: randomNumber(),
            name: pin.ownerName == null ? "DEFAULT" : pin.ownerName!,
            phoneNumber: phoneNumber,
            permissions: [],
            branches: _convertBranches(branches),
            businesses: _convertBusinesses(businesses),
            businessId: 0,
            nfcEnabled: false,
            userId: pin.userId!,
            isDefault: false)
      ],
    );
  }

  List<IBranch> _convertBranches(List<Branch> branches) {
    return branches
        .map((e) => IBranch(
            id: e.id,
            name: e.name,
            businessId: e.businessId,
            longitude: e.longitude,
            latitude: e.latitude,
            location: e.location,
            active: e.active,
            isDefault: e.isDefault ?? false))
        .toList();
  }

  List<IBusiness> _convertBusinesses(List<Business> businesses) {
    return businesses
        .map((e) => IBusiness(
              id: e.serverId,
              encryptionKey: e.encryptionKey!,
              name: e.name,
              currency: e.currency,
              categoryId: e.categoryId,
              latitude: e.latitude,
              longitude: e.longitude,
              userId: e.userId,
              timeZone: e.timeZone,
              country: e.country,
              businessUrl: e.businessUrl,
              hexColor: e.hexColor,
              imageUrl: e.imageUrl,
              type: e.type,
              active: e.active,
              metadata: e.metadata,
              lastSeen: e.lastSeen,
              firstName: e.firstName,
              lastName: e.lastName,
              deviceToken: e.deviceToken,
              chatUid: e.chatUid,
              backUpEnabled: e.backUpEnabled,
              subscriptionPlan: e.subscriptionPlan,
              nextBillingDate: e.nextBillingDate,
              previousBillingDate: e.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  e.isLastSubscriptionPaymentSucceeded,
              backupFileId: e.backupFileId,
              email: e.email,
              lastDbBackup: e.lastDbBackup,
              fullName: e.fullName,
              role: e.role,
              tinNumber: e.tinNumber,
              bhfId: e.bhfId,
              dvcSrlNo: e.dvcSrlNo,
              adrs: e.adrs,
              taxEnabled: e.taxEnabled,
              taxServerUrl: e.taxServerUrl,
              isDefault: e.isDefault,
              businessTypeId: e.businessTypeId,
              deletedAt: e.deletedAt,
            ))
        .toList();
  }

  Future<ITransaction?> _pendingTransaction({
    required int branchId,
    required String transactionType,
    required bool isExpense,
    bool includeSubTotalCheck = true,
  }) async {
    try {
      // Build the query
      final query = brick.Query(where: [
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
        brick.Where('isExpense',
            value: isExpense, compare: brick.Compare.exact),
        brick.Where('status', value: PENDING, compare: brick.Compare.exact),
        brick.Where('transactionType',
            value: transactionType, compare: brick.Compare.exact),
        if (includeSubTotalCheck)
          brick.Where('subTotal', value: 0, compare: brick.Compare.greaterThan),
      ]);

      // Fetch transactions
      final List<ITransaction> transactions =
          await repository.get<ITransaction>(query: query);

      // Check for transactions with items
      for (final transaction in transactions) {
        final List<TransactionItem> items = await transactionItems(
          branchId: branchId,
          transactionId: transaction.id,
          doneWithTransaction: false,
          active: true,
        );

        if (items.isNotEmpty) {
          return transaction;
        }
      }

      // If no transaction with items found, return the first transaction (if any)
      return transactions.isNotEmpty ? transactions.first : null;
    } catch (e, s) {
      // Log errors (optional, replace talker with your preferred logger)
      talker.error('Error in _pendingTransaction: $e');
      talker.error('Stack trace: $s');
      return null;
    }
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) async {
    throw UnimplementedError(
        "manageCashInOutTransaction is not implemented yet");
  }

  @override
  FutureOr<ITransaction> manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) async {
    ITransaction? existTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck!);
    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(
          lastTouched: DateTime.now(),
          id: id,
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      repository.upsert<ITransaction>(transaction);

      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) async* {
    final ITransaction? existTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck!);

    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(
          lastTouched: DateTime.now(),
          id: id,
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      repository.upsert<ITransaction>(transaction);

      yield transaction;
    } else {
      yield existTransaction;
    }
  }

  @override
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) {
    // TODO: implement markModelForEbmUpdate
    throw UnimplementedError(
        "markModelForEbmUpdate method is not implemented yet");
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError("openDrawer method is not implemented yet");
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError(
        "patchSocialSetting method is not implemented yet");
  }

  @override
  Stream<Plan?> paymentPlanStream({required int businessId}) {
    // TODO: implement paymentPlanStream
    throw UnimplementedError("paymentPlanStream method is not implemented yet");
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    // final products = productsRef
    //     .whereId(isEqualTo: prodIndex)
    //     .whereBranchId(isEqualTo: ProxyService.box.getBranchId()!);
    // return products
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => doc.data).toList());
    throw UnimplementedError("productStreams method is not implemented yet");
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    // final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    // return products.docs.map((doc) => doc.data).toList();
    throw UnimplementedError("products method is not implemented yet");
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    // final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    // return products.docs.map((doc) => doc.data).toList();
    throw UnimplementedError("productsFuture method is not implemented yet");
  }

  @override
  void reDownloadAsset() {
    // TODO: implement reDownloadAsset
    throw UnimplementedError("reDownloadAsset method is not implemented yet");
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError("refreshSession method is not implemented yet");
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError("refund method is not implemented yet");
  }

  @override
  void removeCustomerFromTransaction({required ITransaction transaction}) {
    // TODO: implement removeCustomerFromTransaction
  }

  @override
  Future<bool> removeS3File({required String fileName}) {
    // TODO: implement removeS3File
    throw UnimplementedError("removeS3File method is not implemented yet");
  }

  @override
  Report report({required int id}) {
    // TODO: implement report
    throw UnimplementedError("report method is not implemented yet");
  }

  @override
  Stream<List<Report>> reports({required int branchId}) {
    // TODO: implement reports
    throw UnimplementedError("reports method is not implemented yet");
  }

  @override
  List<StockRequest> requests({required int branchId}) {
    // TODO: implement requests
    throw UnimplementedError("requests is not implemented yet");
  }

  @override
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter}) {
    if (filter == RequestStatus.approved) {
      final query = repository.subscribe<StockRequest>(
          query: brick.Query(where: [
        brick.Where('mainBranchId').isExactly(branchId),
        brick.Where('status').isExactly(RequestStatus.approved),
      ]));

      return query
          .map((changes) => changes.toList())
          .debounceTime(Duration(milliseconds: 100));
    } else {
      final query = repository.subscribe<StockRequest>(
          query: brick.Query(where: [
        brick.Where('mainBranchId').isExactly(branchId),
        brick.Or('status').isExactly(RequestStatus.pending),
        brick.Or('status').isExactly(RequestStatus.partiallyApproved),
      ]));

      return query
          .map((changes) => changes.toList())
          .debounceTime(Duration(milliseconds: 100));
    }
  }

  @override
  void saveComposite({required Composite composite}) {
    // updateRecord(
    //   tableName: compositesTable,
    //   idField: "${compositesTable.singularize()}_id",
    //   map: composite.toJson(),
    //   id: composite.id!,
    //   syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
    // );
    throw UnimplementedError("saveComposite method is not implemented yet");
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError("saveDiscount method is not implemented yet");
  }

  @override
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required int businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    String? customerCode,
    models.Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  }) async {
    final repository = brick.Repository();

    try {
      final num = ProxyService.box.numberOfPayments() ?? numberOfPayments;
      // compute next billing date
      final nextBillingDate = isYearlyPlan
          ? DateTime.now().add(Duration(days: 365 * num))
          : DateTime.now().add(Duration(days: 30 * num));
      // Fetch existing plan and addons
      final existingPlanAddons =
          await _fetchExistingAddons(repository, businessId);

      // Process new addons if provided
      final updatedAddons = await _processNewAddons(
        repository: repository,
        businessId: businessId,
        existingAddons: existingPlanAddons,
        newAddonNames: addons,
        isYearlyPlan: isYearlyPlan,
      );

      // Create or update the plan
      final updatedPlan = await _upsertPlan(
        repository: repository,
        businessId: businessId,
        selectedPlan: selectedPlan,
        numberOfPayments: numberOfPayments,
        additionalDevices: additionalDevices,
        isYearlyPlan: isYearlyPlan,
        totalPrice: totalPrice,
        payStackUserId: payStackUserId,
        paymentMethod: paymentMethod,
        addons: updatedAddons,
        nextBillingDate: nextBillingDate,
      );

      return updatedPlan;
    } catch (e) {
      talker.error('Failed to save/update payment plan: $e');
      rethrow;
    }
  }

  Future<List<models.PlanAddon>> _fetchExistingAddons(
    brick.Repository repository,
    int businessId,
  ) async {
    try {
      final query = brick.Query.where(
        'addons',
        brick.Where('planId').isExactly(businessId),
      );

      final planWithAddons = await repository.get<models.Plan>(
        query: query,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      return planWithAddons.expand((plan) => plan.addons).toList();
    } catch (e) {
      talker.error('Failed to fetch existing addons: $e');
      rethrow;
    }
  }

  Future<List<models.PlanAddon>> _processNewAddons({
    required brick.Repository repository,
    required int businessId,
    required List<models.PlanAddon> existingAddons,
    required List<String>? newAddonNames,
    required bool isYearlyPlan,
  }) async {
    if (newAddonNames == null) return existingAddons;

    final updatedAddons = List<models.PlanAddon>.from(existingAddons);
    final existingAddonNames = existingAddons.map((e) => e.addonName).toSet();

    for (final addonName in newAddonNames) {
      if (existingAddonNames.contains(addonName)) continue;

      final newAddon = models.PlanAddon(
        id: randomNumber(),
        addonName: addonName,
        createdAt: DateTime.now(),
        planId: businessId,
      );

      // Create temporary plan for foreign key relationship
      await _createTemporaryPlan(
        repository: repository,
        businessId: businessId,
        isYearlyPlan: isYearlyPlan,
        addons: updatedAddons,
      );

      await repository.upsert(newAddon);
      updatedAddons.add(newAddon);
    }

    return updatedAddons;
  }

  Future<void> _createTemporaryPlan({
    required brick.Repository repository,
    required int businessId,
    required bool isYearlyPlan,
    required List<models.PlanAddon> addons,
  }) async {
    await repository.upsert(
      models.Plan(
        id: businessId,
        rule: isYearlyPlan ? 'yearly' : 'monthly',
        addons: addons,
      ),
      query: brick.Query(
        where: [brick.Where('businessId').isExactly(businessId)],
      ),
    );
  }

  Future<Plan> _upsertPlan({
    required brick.Repository repository,
    required int businessId,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    required List<models.PlanAddon> addons,
    required DateTime nextBillingDate,
    required int numberOfPayments,
  }) async {
    final plan = models.Plan(
      id: businessId,
      businessId: businessId,
      selectedPlan: selectedPlan,
      additionalDevices: additionalDevices,
      isYearlyPlan: isYearlyPlan,
      rule: isYearlyPlan ? 'yearly' : 'monthly',
      totalPrice: totalPrice.toInt(),
      createdAt: DateTime.now(),
      numberOfPayments: numberOfPayments,
      nextBillingDate: nextBillingDate,
      payStackCustomerId: payStackUserId,
      paymentMethod: paymentMethod,
      addons: addons,
    );

    await repository.upsert(
      plan,
      query: brick.Query(
        where: [brick.Where('businessId').isExactly(businessId)],
      ),
    );
    return plan;
  }

  @override
  Future<Pin?> savePin({required Pin pin}) async {
    try {
      final query = brick.Query.where('userId', pin.userId, limit1: true);
      final savedPin = await repository.upsert(
        pin,
        query: query,
      );

      return savedPin;
    } catch (e, s) {
      talker.error(s.toString());
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin, required String bhfId, required String lastReqDt}) {
    // TODO: implement selectImportItems
    throw UnimplementedError("selectImportItems is not implemented yet");
  }

  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) async {
    uid = uid ?? firebase.FirebaseAuth.instance.currentUser?.uid;
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body:
          jsonEncode(<String, String?>{'phoneNumber': phoneNumber, 'uid': uid}),
    );
    return response;
  }

  @override
  Future<void> sendMessageToIsolate() async {
    if (ProxyService.box.stopTaxService()!) return;

    Business? business =
        await getBusiness(businessId: ProxyService.box.getBusinessId()!);

    try {
      sendPort!.send({
        'task': 'taxService',
        'branchId': ProxyService.box.getBranchId()!,
        "businessId": ProxyService.box.getBusinessId()!,
        "URI": await ProxyService.box.getServerUrl(),
        "bhfId": await ProxyService.box.bhfId(),
        'tinNumber': business!.tinNumber,
        'encryptionKey': ProxyService.box.encryptionKey(),
        'dbPath':
            path.join((await DatabasePath.getDatabaseDirectory()), dbFileName),
      });
    } catch (e, s) {
      talker.error(e, s);
      rethrow;
    }
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError("sendReport method is not implemented yet");
  }

  @override
  Future<List<ext.ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement signup
    throw UnimplementedError("signup method is not implemented yet");
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError("size method is not implemented yet");
  }

  @override
  Stream<double> soldStockValue({required branchId}) {
    // TODO: implement soldStockValue
    throw UnimplementedError("soldStockValue method is not implemented yet");
  }

  @override
  Future<void> spawnIsolate(isolateHandler) async {
    try {
      final isTaxEnabledFor =
          await isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
      if (isTaxEnabledFor) {
        // 1. Create the ReceivePort to receive messages from the isolate
        receivePort = ReceivePort();

        // 2. Spawn the isolate and pass the receivePort.sendPort to it
        // await Isolate.spawn(isolateHandler, receivePort!.sendPort);
        final rootIsolateToken = RootIsolateToken.instance!;

        await Isolate.spawn(
          isolateHandler,
          // [receivePort!.sendPort, rootIsolateToken, CouchbaseLite.context],
          [receivePort!.sendPort, rootIsolateToken],
          debugName: 'backgroundIsolate',
        );

        // 3. Retrieve the SendPort sent back by the isolate (used to send messages to the isolate)
        // sendPort = await receivePort!.first;

        receivePort!.listen(
          (message) async {
            if (message is SendPort) {
              // Store the sendPort for communication with isolate
              sendPort = message;
              print('SendPort received');
            }
            String identifier = message as String;
            List<String> separator = identifier.split(":");

            if (separator.first == "notification") {
              if (separator.length == 2) {
                /// this is error message
                ProxyService.notification
                    .sendLocalNotification(body: separator[1]);
              }
              if (separator.length < 3) return;
              if (separator[2] == "variant") {
                final variantId = int.tryParse(separator[3]);
                Variant? variant =
                    ProxyService.strategy.variant(variantId: variantId);
                if (variant != null) {
                  variant.ebmSynced = true;
                  repository.upsert<Variant>(variant);
                }
                ProxyService.notification
                    .sendLocalNotification(body: "Item Saving " + separator[1]);
              }
              if (separator[2] == "stock") {
                final stockId = int.tryParse(separator[3]);
                Stock? stock = await getStockById(id: stockId!);
                if (stock != null) {
                  stock.ebmSynced = true;
                  repository.upsert<Stock>(stock);
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Stock Saving " + separator[1]);
              }
              if (separator[2] == "customer") {
                final customerId = int.tryParse(separator[3]);
                Customer? customer = await getCustomer(id: customerId);
                if (customer != null) {
                  customer.ebmSynced = true;
                  repository.upsert<Customer>(customer);
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Customer Saving " + separator[1]);
              }
              if (separator[2] == "transaction") {
                final transactionId = int.tryParse(separator[3]);
                ITransaction? transaction =
                    getTransactionById(id: transactionId!);
                if (transaction != null) {
                  transaction.ebmSynced = true;
                  repository.upsert<ITransaction>(transaction);
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Transaction Saving " + separator[1]);
              }
            }
          },
        );
      }
    } catch (error, s) {
      talker.warning('Error managing isolates: $error');
      talker.warning('Error managing isolates: $s');
    }
  }

  @override
  Future<void> startReplicator() {
    // TODO: implement startReplicator
    throw UnimplementedError("startReplicator method is not implemented yet");
  }

  @override
  Stream<double> stockValue({required branchId}) {
    // TODO: implement stockValue
    throw UnimplementedError("stockValue method is not implemented yet");
  }

  @override
  List<Stock> stocks({required int branchId}) {
    // TODO: implement stocks
    throw UnimplementedError("stocks method is not implemented yet");
  }

  @override
  Future<({String customerCode, String url, int userId})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError("subscribe is not implemented yet");
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    // TODO: implement syncUserWithAwsIncognito
    throw UnimplementedError(
        "syncUserWithAwsIncognito method is not implemented yet");
  }

  @override
  FutureOr<Tenant?> tenant({int? businessId, int? userId}) async {
    if (businessId != null) {
      return (await repository.get<Tenant>(
              query: brick.Query(
                  where: [brick.Where('businessId').isExactly(businessId)])))
          .firstOrNull;
    } else {
      return (await repository.get<Tenant>(
              query: brick.Query(
                  where: [brick.Where('userId').isExactly(userId)])))
          .firstOrNull;
    }
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) {
    return repository.get<Tenant>(
        query: brick.Query(where: [
      brick.Where('businessId').isExactly(businessId),
      brick.Or('userId').isExactly(excludeUserId),
      brick.Or('pin').isExactly(false)
    ]));
  }

  @override
  Future<List<ext.ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(
              id: business.id!,
              serverId: business.id!,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = (await repository.get<Business>(
                  query: brick.Query(
                      where: [brick.Where('serverId').isExactly(business.id)])))
              .firstOrNull;
          if (exist == null) {
            await repository.upsert<Business>(biz);
          }
        }

        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(
              id: brannch.id!,
              serverId: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault);
          Branch? exist = (await repository.get<Branch>(
                  query: brick.Query(
                      where: [brick.Where('serverId').isExactly(brannch.id)])))
              .firstOrNull;
          if (exist == null) {
            await repository.upsert<Branch>(branch);
          }
        }

        final permissionToAdd = <LPermission>[];
        for (ext.IPermission permission in jTenant.permissions) {
          LPermission? exist = (await repository.get<LPermission>(
                  query: brick.Query(
                      where: [brick.Where('id').isExactly(permission.id)])))
              .firstOrNull;
          if (exist == null) {
            final perm = LPermission(id: permission.id!, name: permission.name);
            permissionToAdd.add(perm);
          }
        }

        for (LPermission permission in permissionToAdd) {
          await repository.upsert<LPermission>(permission);
        }

        Tenant? tenanti = (await repository.get<Tenant>(
                query: brick.Query(
                    where: [brick.Where('userId').isExactly(iTenant.userId)])))
            .firstOrNull;

        if (tenanti == null) {
          tenantToAdd.add(iTenant);
        }
      }

      if (tenantToAdd.isNotEmpty) {
        for (Tenant tenant in tenantToAdd) {
          await repository.upsert<Tenant>(tenant);
        }
      }

      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError("tickets method is not implemented yet");
  }

  @override
  Future<double> totalStock({int? productId, int? variantId}) {
    // TODO: implement totalStock
    throw UnimplementedError("totalStock method is not implemented yet");
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    // TODO: implement transactionItemList
    throw UnimplementedError(
        "transactionItemList method is not implemented yet");
  }

  @override
  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsFuture
    throw UnimplementedError(
        "transactionItemsFuture method is not implemented yet");
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsStreams
    throw UnimplementedError(
        "transactionItemsStreams method is not implemented yet");
  }

  @override
  List<ITransaction> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isExpense = false,
      bool includePending = false}) {
    // TODO: implement transactions
    throw UnimplementedError("transactions method is not implemented yet");
  }

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    int? id,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final List<brick.Where> conditions = [
      brick.Where('status').isExactly(status ?? COMPLETE),
      brick.Where('subTotal').isGreaterThan(0),
      if (id != null) brick.Where('id').isExactly(id),
      if (filterType != null) brick.Where('filterType').isExactly(filterType),
      if (branchId != null) brick.Where('branchId').isExactly(branchId),
      if (isCashOut) brick.Where('isExpense').isExactly(true),
      if (startDate != null && endDate != null)
        brick.Where('lastTouched').isBetween(startDate, endDate),
    ];

    final queryString = brick.Query(where: conditions);
    final repository = brick.Repository();

    // Directly return the stream from the repository
    return repository.subscribe<ITransaction>(query: queryString);
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    final existingUnits = await repository.get<IUnit>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
    if (existingUnits.isNotEmpty) {
      return existingUnits;
    }
    await addUnits(units: mockUnits);
    return await repository.get<IUnit>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<List<UnversalProduct>> universalProductNames(
      {required int branchId}) async {
    return repository.get<UnversalProduct>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError(
        "unpublishedDevices method is not implemented yet");
  }

  @override
  void upSert() {
    // TODO: implement upSert
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError("updateContact method is not implemented yet");
  }

  @override
  void updateCounters(
      {required List<Counter> counters, RwApiResponse? receiptSignature}) {
    final repository = brick.Repository();
    // build brick Counter to pass in to upsert
    for (Counter counter in counters) {
      final upCounter = models.Counter(
        createdAt: DateTime.now(),
        lastTouched: DateTime.now(),
        id: counter.id,
        branchId: counter.branchId,
        curRcptNo: receiptSignature!.data?.rcptNo ?? 0,
        totRcptNo: receiptSignature.data?.totRcptNo ?? 0,
        invcNo: counter.invcNo! + 1,
        businessId: counter.businessId,
        receiptType: counter.receiptType,
      );
      counter.invcNo = counter.invcNo! + 1;
      repository.upsert(upCounter);
    }
  }

  @override
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement updateNonRealm
    throw UnimplementedError("updateNonRealm method is not implemented yet");
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) {
    // TODO: implement uploadPdfToS3
    throw UnimplementedError("uploadPdfToS3 method is not implemented yet");
  }

  @override
  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError("userNameAvailable method is not implemented yet");
  }

  @override
  Future<ITransaction> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType,
      required double discount,
      required int branchId,
      required String bhfId,
      required bool isProformaMode,
      required bool isTrainingMode,
      required String transactionType,
      String? categoryId,
      bool directlyHandleReceipt = false,
      required bool isIncome}) {
    // TODO: implement collectPayment
    throw UnimplementedError("collectPayment method is not implemented yet");
  }

  @override
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage}) {
    // TODO: implement saveTax
    throw UnimplementedError("saveTax method is not implemented yet");
  }

  @override
  FutureOr<void> addAccess(
      {required int userId,
      required String featureName,
      required String accessLevel,
      required String userType,
      required String status,
      required int branchId,
      required int businessId,
      DateTime? createdAt}) async {
    await repository.upsert<Access>(Access(
      id: userId,
      branchId: branchId,
      businessId: businessId,
      userId: userId,
      featureName: featureName,
      accessLevel: accessLevel,
      status: status,
      userType: userType,
      createdAt: createdAt,
    ));
  }

  @override
  Future<void> addAsset(
      {required int productId,
      required assetName,
      required int branchId,
      required int businessId}) async {
    final asset = await repository.get<Assets>(
        query: brick.Query(where: [
      brick.Where('productId').isExactly(productId),
      brick.Where('assetName').isExactly(assetName),
    ]));
    if (asset.firstOrNull == null) {
      await repository.upsert<Assets>(Assets(
        id: randomNumber(),
        assetName: assetName,
        productId: productId,
        branchId: branchId,
        businessId: businessId,
      ));
    }
  }

  @override
  Future<void> addCategory(
      {required String name,
      required int branchId,
      required bool active,
      required bool focused,
      required DateTime lastTouched,
      required int id,
      required DateTime createdAt,
      required deletedAt}) async {
    final category = await repository.get<Category>(
        query: brick.Query(where: [
      brick.Where('name').isExactly(name),
    ]));
    if (category.firstOrNull == null) {
      await repository.upsert<Category>(Category(
        id: id,
        focused: focused,
        name: name,
        active: active,
        branchId: branchId,
        lastTouched: lastTouched,
        deletedAt: deletedAt,
      ));
    }
  }

  @override
  FutureOr<void> addColor({required String name, required int branchId}) {
    repository.upsert<PColor>(PColor(
      id: randomNumber(),
      name: name,
      active: false,
      branchId: branchId,
    ));
  }

  @override
  FutureOr<void> deleteAll<T extends Object>(
      {required String tableName}) async {
    // if (tableName == productsTable) {
    //   realm!.write(() {
    //     realm!.deleteAll<Product>();
    //   });
    // }
    // if (tableName == variantTable) {
    //   realm!.write(() {
    //     realm!.deleteAll<Variant>();
    //   });
    // }
    // if (tableName == stocksTable) {
    //   realm!.write(() {
    //     realm!.deleteAll<Stock>();
    //   });
    // }
    // if (tableName == transactionItemsTable) {
    //   realm!.write(() {
    //     realm!.deleteAll<TransactionItem>();
    //   });
    // }
    // if (tableName == stockRequestsTable) {
    //   realm!.write(() {
    //     realm!.deleteAll<StockRequest>();
    //   });
    // }
    if (tableName == transactionItemsTable) {
      // await repository.sqliteProvider.;
    }
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError("getContacts method is not implemented yet");
  }

  @override
  Future<Customer?> getCustomerFuture({String? key, int? id}) {
    // TODO: implement getCustomerFuture
    throw UnimplementedError("getCustomerFuture method is not implemented yet");
  }

  @override
  Future<
      ({
        List<Device> devices,
        List<Favorite> favorites,
        List<Product> products,
        List<Stock> stocks,
        List<TransactionItem> transactionItems,
        List<ITransaction> transactions,
        List<Variant> variants
      })> getUnSyncedData() {
    // TODO: implement getUnSyncedData
    throw UnimplementedError("getUnSyncedData method is not implemented yet");
  }

  @override
  Stream<double> initialStock({required branchId}) {
    // TODO: implement initialStock
    throw UnimplementedError("initialStock method is not implemented yet");
  }

  @override
  Future<ext.SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError("loginOnSocial method is not implemented yet");
  }

  @override
  Future<void> processItem(
      {required old.Item item,
      required Map<String, String> quantitis,
      required Map<String, String> taxTypes,
      required Map<String, String> itemClasses,
      required Map<String, String> itemTypes}) {
    // TODO: implement processItem
    throw UnimplementedError("processItem method is not implemented yet");
  }

  @override
  FutureOr<void> updateAcess(
      {required int userId,
      String? featureName,
      String? status,
      String? accessLevel,
      String? userType}) {
    // TODO: implement updateAcess
    throw UnimplementedError("updateAcess method is not implemented yet");
  }

  @override
  FutureOr<void> updateAsset({required int assetId, String? assetName}) {
    // TODO: implement updateAsset
    throw UnimplementedError("updateAsset method is not implemented yet");
  }

  @override
  FutureOr<void> updateCategory(
      {required int categoryId,
      String? name,
      bool? active,
      bool? focused,
      int? branchId}) {
    // TODO: implement updateCategory
    throw UnimplementedError("updateCategory method is not implemented yet");
  }

  @override
  FutureOr<void> updateColor(
      {required int colorId, String? name, bool? active}) {
    // TODO: implement updateColor
    throw UnimplementedError("  updateColor method is not implemented yet");
  }

  @override
  FutureOr<void> updateDrawer(
      {required int drawerId,
      int? cashierId,
      int? nsSaleCount,
      int? trSaleCount,
      int? psSaleCount,
      int? csSaleCount,
      int? nrSaleCount,
      int? incompleteSale,
      double? totalCsSaleIncome,
      double? totalNsSaleIncome,
      String? openingDateTime,
      double? closingBalance,
      bool? open}) {
    // TODO: implement updateDrawer
    throw UnimplementedError("updateDrawer method is not implemented yet");
  }

  @override
  FutureOr<void> updateNotification(
      {required int notificationId, bool? completed}) {
    // TODO: implement updateNotification
    throw UnimplementedError(
        "updateNotification method is not implemented yet");
  }

  @override
  FutureOr<void> updatePin(
      {required int userId, String? phoneNumber, String? tokenUid}) {
    // TODO: implement updatePin
    throw UnimplementedError("updatePin method is not implemented yet");
  }

  @override
  FutureOr<void> updateProduct(
      {int? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      String? imageUrl,
      String? expiryDate}) {
    // TODO: implement updateProduct
    throw UnimplementedError("updateProduct method is not implemented yet");
  }

  @override
  FutureOr<void> updateReport({required int reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError("updateReport method is not implemented yet");
  }

  @override
  FutureOr<void> updateStockRequest(
      {required int stockRequestId, DateTime? updatedAt, String? status}) {
    // TODO: implement updateStockRequest
    throw UnimplementedError(
        "updateStockRequest method is not implemented yet");
  }

  @override
  Future<void> updateTenant(
      {required int tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      int? userId,
      int? businessId,
      String? type,
      int? id,
      int? pin,
      bool? sessionActive,
      int? branchId}) async {
    final tenant = (await repository.get<Tenant>(
            query: brick.Query(where: [
      brick.Where('id').isExactly(tenantId),
    ])))
        .firstOrNull;

    repository.upsert<Tenant>(Tenant(
      id: tenantId,
      name: name ?? tenant?.name,
      userId: userId ?? tenant?.userId,
      phoneNumber: phoneNumber ?? tenant?.phoneNumber,
      email: email ?? tenant?.email,
      businessId: businessId ?? tenant?.businessId,
      type: type ?? tenant?.type ?? "Agent",
      pin: pin ?? tenant?.pin,
      sessionActive: sessionActive ?? tenant?.sessionActive,
    ));
  }

  @override
  FutureOr<void> updateTransaction(
      {required ITransaction transaction,
      String? receiptType,
      double? subTotal,
      String? note,
      String? status,
      int? customerId,
      bool? ebmSynced,
      String? sarTyCd,
      String? reference,
      String? customerTin,
      String? customerBhfId,
      double? cashReceived,
      bool? isRefunded,
      String? customerName,
      String? ticketName,
      String? updatedAt,
      int? invoiceNumber,
      DateTime? lastTouched,
      int? receiptNumber,
      int? totalReceiptNumber,
      bool? isProformaMode,
      bool? isTrainingMode}) {
    // TODO: implement updateTransaction
    throw UnimplementedError("updateTransaction method is not implemented yet");
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      required int transactionItemId,
      double? discount,
      bool? active,
      double? taxAmt,
      int? quantityApproved,
      int? quantityRequested,
      bool? ebmSynced,
      bool? isRefunded,
      bool? incrementQty,
      double? price,
      double? prc,
      double? splyAmt,
      bool? doneWithTransaction,
      int? quantityShipped,
      double? taxblAmt,
      double? totAmt,
      double? dcRt,
      double? dcAmt}) {
    // TODO: implement updateTransactionItem
    throw UnimplementedError(
        "updateTransactionItem method is not implemented yet");
  }

  @override
  FutureOr<void> updateUnit(
      {required int unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError("updateUnit method is not implemented yet");
  }

  @override
  FutureOr<Stock?> addStockToVariant({required Variant variant, Stock? stock}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError("addStockToVariant method is not implemented yet");
  }

  @override
  Future<RealmInterface> configureCapella(
      {required bool useInMemory, required storage.LocalStorage box}) {
    // TODO: implement configureCapella
    throw UnimplementedError("configureCapella method is not implemented yet");
  }

  @override
  T? create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError("create method is not implemented yet");
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) {
    // TODO: implement taxes
    throw UnimplementedError("taxes method is not implemented yet");
  }

  @override
  Variant? variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError("variant method is not implemented yet");
  }

  @override
  List<Variant> variants(
      {required int branchId, int? productId, int? page, int? itemsPerPage}) {
    // TODO: implement variants
    throw UnimplementedError("variants method is not implemented yet");
  }

  @override
  ITransaction? getTransactionById({required int id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError("getTransactionById is not implemented yet");
  }

  @override
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError(
        "getTransactionItemByVariantId method is not implemented yet");
  }

  @override
  Future<Variant?> getVariantById({required int id}) async {
    final query = brick.Query(where: [
      brick.Where('id', value: id, compare: brick.Compare.exact),
    ]);
    return (await repository.get<Variant>(query: query)).firstOrNull;
  }

  @override
  RealmInterface instance() {
    // TODO: implement instance
    throw UnimplementedError("instance is not implemented yet");
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError("isSubscribed method is not implemented yet");
  }

  @override
  Future<bool> isTaxEnabled({required int businessId}) async {
    final business = (await getBusiness(businessId: businessId));
    return business?.tinNumber != null;
  }

  @override
  Future<void> saveEbm(
      {required int branchId,
      required String severUrl,
      required String bhFId}) {
    // TODO: implement saveEbm
    throw UnimplementedError("  saveEbm method is not implemented yet");
  }

  @override
  FutureOr<void> savePaymentType(
      {TransactionPaymentRecord? paymentRecord,
      int? transactionId,
      double amount = 0.0,
      String? paymentMethod,
      required bool singlePaymentOnly}) {
    // TODO: implement savePaymentType
    throw UnimplementedError("savePaymentType method is not implemented yet");
  }

  @override
  FutureOr<void> saveStock(
      {Variant? variant,
      required double rsdQty,
      required int productId,
      required int variantId,
      required int branchId,
      required double currentStock,
      required double value}) async {
    final stock = Stock(
      id: randomNumber(),
      lastTouched: DateTime.now(),
      branchId: branchId,
      // variantId: variantId,
      variant: variant!,
      currentStock: currentStock,
      rsdQty: rsdQty,
      value: value,
      productId: variant.productId,
    );
    await repository.upsert<Stock>(stock);
  }

  @override
  FutureOr<void> updateStock(
      {required int stockId,
      double? qty,
      double? rsdQty,
      double? initialStock,
      bool? ebmSynced,
      double? currentStock,
      double? value,
      DateTime? lastTouched}) async {
    // TODO: implement updateStock
    throw UnimplementedError("updateStock method is not implemented yet");
  }

  @override
  FutureOr<void> addBusiness(
      {required int id,
      required int userId,
      required int serverId,
      String? name,
      String? currency,
      String? categoryId,
      String? latitude,
      String? longitude,
      String? timeZone,
      String? country,
      String? businessUrl,
      String? hexColor,
      String? imageUrl,
      String? type,
      bool? active,
      String? chatUid,
      String? metadata,
      String? role,
      int? lastSeen,
      String? firstName,
      String? lastName,
      String? createdAt,
      String? deviceToken,
      bool? backUpEnabled,
      String? subscriptionPlan,
      String? nextBillingDate,
      String? previousBillingDate,
      bool? isLastSubscriptionPaymentSucceeded,
      String? backupFileId,
      String? email,
      String? lastDbBackup,
      String? fullName,
      int? tinNumber,
      required String bhfId,
      String? dvcSrlNo,
      String? adrs,
      bool? taxEnabled,
      String? taxServerUrl,
      bool? isDefault,
      int? businessTypeId,
      DateTime? lastTouched,
      DateTime? deletedAt,
      required String encryptionKey}) {
    repository.upsert<Business>(Business(
      id: id,
      serverId: serverId,
      name: name,
      currency: currency,
      categoryId: categoryId,
      latitude: latitude,
      longitude: longitude,
      timeZone: timeZone,
      country: country,
      businessUrl: businessUrl,
      hexColor: hexColor,
      imageUrl: imageUrl,
      type: type,
      active: active,
      chatUid: chatUid,
      metadata: metadata,
      role: role,
      userId: userId,
      lastSeen: lastSeen,
      firstName: firstName,
      lastName: lastName,
      createdAt: createdAt,
      deviceToken: deviceToken,
      backUpEnabled: backUpEnabled,
      subscriptionPlan: subscriptionPlan,
      nextBillingDate: nextBillingDate,
      previousBillingDate: previousBillingDate,
      isLastSubscriptionPaymentSucceeded: isLastSubscriptionPaymentSucceeded,
      backupFileId: backupFileId,
      email: email,
      lastDbBackup: lastDbBackup,
      fullName: fullName,
      tinNumber: tinNumber,
      bhfId: bhfId,
      dvcSrlNo: dvcSrlNo,
      adrs: adrs,
      taxEnabled: taxEnabled,
      taxServerUrl: taxServerUrl,
      isDefault: isDefault,
      businessTypeId: businessTypeId,
      lastTouched: lastTouched,
      deletedAt: deletedAt,
      encryptionKey: encryptionKey,
    ));
  }

  @override
  FutureOr<LPermission?> permission({required int userId}) async {
    return (await repository.get<LPermission>(
            query:
                brick.Query(where: [brick.Where('userId').isExactly(userId)]),
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist))
        .firstOrNull;
  }

  @override
  void whoAmI() {
    print("I am coresync");
  }

  @override
  FutureOr<List<Access>> access(
      {required int userId, String? featureName}) async {
    return await repository.get<Access>(
        query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));
  }

  @override
  FutureOr<Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      String? userOwnerPhoneNumber,
      HttpClientInterface? flipperHttpClient,
      int? serverId,
      String? description,
      String? longitude,
      String? latitude,
      required bool isDefault,
      required bool active,
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? id}) async {
    return await repository.upsert<Branch>(Branch(
      id: id!,
      serverId: serverId,
      location: location,
      description: description,
      name: name,
      businessId: businessId,
      longitude: longitude,
      latitude: latitude,
      isDefault: isDefault,
      active: active,
    ));
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems(
      {int? transactionId,
      bool? doneWithTransaction,
      required int branchId,
      bool? active}) async {
    if (transactionId == null) {
      final items = await repository.get<TransactionItem>(
          query: brick.Query(where: [
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
      ]));
      return items;
    } else if (doneWithTransaction == null || active == null) {
      final items = await repository.get<TransactionItem>(
          query: brick.Query(where: [
        brick.Where('transactionId',
            value: transactionId, compare: brick.Compare.exact),
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
      ]));
      return items;
    } else {
      final items = await repository.get<TransactionItem>(
          query: brick.Query(where: [
        brick.Where('transactionId',
            value: transactionId, compare: brick.Compare.exact),
        brick.Where('doneWithTransaction',
            value: doneWithTransaction, compare: brick.Compare.exact),
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
        brick.Where('active', value: active, compare: brick.Compare.exact),
      ]));
      return items;
    }
  }

  @override
  Stock? stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError("stockByVariantId method is not implemented yet");
  }

  @override
  FutureOr<List<LPermission>> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError("permissions method is not implemented yet");
  }

  @override
  void updateAccess(
      {required int accessId,
      required int userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required String userType}) {
    // TODO: implement updateAccess
  }

  @override
  Future<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId}) async {
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(businessId)]);
    final business = await repository.get<Business>(query: query);
    if (business.firstOrNull != null) {
      final businessUpdate = business.first.copyWith(
        serverId: business.first.serverId,
        name: name,
        active: active,
        isDefault: isDefault,
        backupFileId: backupFileId,
      );
      repository.upsert<Business>(businessUpdate);
    }
  }

  @override
  FutureOr<void> updateBranch(
      {required int branchId,
      String? name,
      bool? active,
      bool? isDefault}) async {
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(branchId)]);
    final branch = await repository.get<Branch>(query: query);
    if (branch.firstOrNull != null) {
      final branchUpdate = branch.first.copyWith(
        serverId: branch.first.serverId,
        name: name,
        active: active,
        isDefault: isDefault,
      );
      repository.upsert<Branch>(branchUpdate);
    }
  }

  @override
  FutureOr<void> updateVariant(
      {required List<Variant> updatables,
      String? color,
      String? taxTyCd,
      int? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<int, String>? rates,
      double? supplyPrice,
      Map<int, String>? dates,
      String? selectedProductType,
      int? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      bool? ebmSynced}) {
    // TODO: implement updateVariant
    throw UnimplementedError("updateVariant method is not implemented yet");
  }

  @override
  Future<Tenant?> saveTenant(
      {required Business business,
      required Branch branch,
      String? phoneNumber,
      String? name,
      int? id,
      String? email,
      int? businessId,
      bool? sessionActive,
      int? branchId,
      String? imageUrl,
      int? pin,
      bool? isDefault,
      required HttpClientInterface flipperHttpClient,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError("saveTenant method is not implemented yet");
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError("getDiscounts method is not implemented yet");
  }

  @override
  void notify({required AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  conversations({int? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError("conversations method is not implemented yet");
  }

  @override
  getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError(
        "getTop5RecentConversations is not implemented yet");
  }

  @override
  Future<RealmInterface> configureLocal(
      {required bool useInMemory, required storage.LocalStorage box}) async {
    return this as RealmInterface;
  }

  @override
  Future<models.Product?> getProduct(
      {int? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) async {
    return (await repository.get<Product>(
            query: brick.Query(where: [
      brick.Or('id').isExactly(id),
      brick.Or('barCode').isExactly(barCode),
      brick.Or('name').isExactly(name),
      brick.Where('branchId').isExactly(branchId),
      brick.Where('businessId').isExactly(businessId),
    ])))
        .firstOrNull;
  }

  @override
  FutureOr<String> itemCode(
      {required String countryCode,
      required String productType,
      required packagingUnit,
      required String quantityUnit}) async {
    final repository = Repository();
    final Query = brick.Query(
      where: [brick.Where('itemCode').isNot(null)],
      orderBy: [brick.OrderBy('itemCode', ascending: false)],
    );
    final items = await repository.get<models.ItemCode>(
        query: Query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Extract the last sequence number and increment it
    int lastSequence = 0;
    if (items.isNotEmpty) {
      final lastItemCode = items.first.itemCode;
      final sequencePart = lastItemCode.substring(lastItemCode.length - 7);
      lastSequence = int.parse(sequencePart);
    }
    final newSequence = (lastSequence + 1).toString().padLeft(7, '0');
    // Construct the new item code
    final newItemCode =
        '$countryCode$productType$packagingUnit$quantityUnit$newSequence';

    // Save the new item code in the database
    final newItem = ItemCode(
        itemCode: newItemCode, id: randomNumber(), createdAt: DateTime.now());
    await repository.upsert(newItem);

    return newItemCode;
  }

  @override
  Stream<SKU?> sku({required int branchId, required int businessId}) {
    // TODO: implement sku
    throw UnimplementedError("sku method is not implemented yet");
  }

  @override
  FutureOr<SKU> getSku({required int branchId, required int businessId}) async {
    final query = brick.Query(
      where: [
        brick.Where('branchId').isExactly(branchId),
        brick.Where('businessId').isExactly(businessId),
      ],
    );
    final skus = await repository.get<SKU>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Extract the last sequence number and increment it
    int lastSequence = 0;
    if (skus.isNotEmpty) {
      final lastSku = skus.first;
      lastSequence = lastSku.sku!;
    }
    final newSequence = lastSequence + 1;

    // Create and save the new SKU
    final newSku = SKU(
      sku: newSequence,
      branchId: branchId,
      businessId: businessId,
      id: randomNumber(),
    );
    await repository.upsert(newSku);

    return newSku;
  }
}
