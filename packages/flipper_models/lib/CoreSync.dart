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
import 'package:flipper_models/mixins/TaxController.dart';
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
import 'package:uuid/uuid.dart';

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

  // Future<void> _supa({required String tableName, required int id}) async {
  //   await ProxyService.supa.init();
  //   try {
  //     // Attempt to call the RPC function
  //     final rpcResult =
  //         await ProxyService.supa.client?.rpc('insert_key', params: {
  //       'current_secret_key': AppSecrets.insertKey,
  //     });

  //     // If RPC call is successful, proceed with the insert operation
  //     if (rpcResult != null) {
  //       final response =
  //           await ProxyService.supa.client?.from(dataMapperTable).upsert({
  //         'table_name': tableName,
  //         'object_id': id,
  //         'device_identifier':
  //             await ProxyService.strategy.getPlatformDeviceId(),

  //         /// Tobe done incorporate it into payment wall the device expected to download the object.
  //         'sync_devices': 0,

  //         /// this exclude the device that is writing the object setting it to 1
  //         'device_downloaded_object': 1
  //       }).select();
  //       talker.warning(response);
  //     }
  //   } catch (e) {
  //     talker.error('Error occurred: $e');
  //     // Handle the error appropriately (e.g., show an error message to the user)
  //   }
  // }

  bool compareChanges(Map<String, dynamic> item, Map<String, dynamic> map) {
    for (final key in item.keys) {
      if (map[key]?.toString() != item[key]?.toString()) {
        return true;
      }
    }
    return false;
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
      policy: OfflineFirstGetPolicy.localOnly,
      query: brick.Query(
        where: [
          brick.Where('isDefault').isExactly(true),
        ],
      ),
    ))
        .first;
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    return (await repository.get<Business>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: brick.Query(
        where: [
          if (userId != null) brick.Where('userId').isExactly(userId),
          brick.Where('isDefault').isExactly(true),
        ],
      ),
    ))
        .firstOrNull;
  }

  @override
  Future<models.Category?> activeCategory({required int branchId}) async {
    return (await repository.get<Category>(
            query: brick.Query(where: [
              brick.Where('focused').isExactly(true),
              brick.Where('active').isExactly(true),
              brick.Where('branchId').isExactly(branchId),
            ], limit: 1),
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist))
        .firstOrNull;
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, String? transactionId}) async {
    Customer customerin = await repository.upsert(customer);
    if (transactionId != null) {
      ITransaction? transaction =
          (await transactions(id: transactionId)).firstOrNull;
      transaction!.customerId = customerin.id;
      await repository.upsert<ITransaction>(transaction);
      return (await customers(
              id: transaction.customerId, branchId: transaction.branchId!))
          .firstOrNull;
    }
    return null;
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError("addFavorite is not implemented yet");
  }

  @override
  Future<void> addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) async {
    repository.upsert<TransactionItem>(item);

    final allItems = await repository.get<TransactionItem>(
        query: brick.Query(
            where: [brick.Where('transactionId').isExactly(transaction.id)]));

    allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    for (var i = 0; i < allItems.length; i++) {
      allItems[i].itemSeq = i + 1; // itemSeq should start from 1
      await repository.upsert<TransactionItem>(allItems[i]);
    }
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      for (Map map in units) {
        final unit = IUnit(
            active: map['active'],
            branchId: branchId,
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
      Variant? variant = await getVariantById(id: variation.id);

      if (variant != null) {
        Stock? stock = await getStockById(id: variant.stockId!);

        if (stock == null) {
          stock = Stock(
              id: variant.stockId!,
              lastTouched: DateTime.now(),
              branchId: branchId,
              currentStock: stock?.rsdQty ?? 0,
              rsdQty: stock?.rsdQty ?? 0,
              value: (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
                  .toDouble(),
              productId: variation.productId,
              active: false);

          await repository.upsert<Stock>(stock);
        }

        stock.currentStock = stock.currentStock! +
            (variation.stock?.rsdQty ?? variation.qty ?? 0);
        stock.rsdQty = stock.currentStock! + (stock.rsdQty!);
        stock.lastTouched = DateTime.now().toLocal();
        stock.value = (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
            .toDouble();

        variant.stock?.rsdQty = variation.stock?.rsdQty ?? variation.qty ?? 0;
        variant.retailPrice = variation.retailPrice;
        variant.supplyPrice = variation.supplyPrice;
        variant.taxPercentage = variation.taxPercentage!.toDouble();
        variant.lastTouched = DateTime.now().toLocal();
        variant.stock = stock;
        variant.stockId = stock.id;
        await repository.upsert<Variant>(variant);
      } else {
        final newStock = Stock(
            lastTouched: DateTime.now(),
            branchId: branchId,
            rsdQty: variation.stock?.rsdQty ?? 0,
            initialStock: variation.stock?.initialStock ?? 0,
            currentStock: variation.stock?.currentStock ?? 0,
            value:
                (variation.stock?.currentStock ?? 0 * (variation.retailPrice!))
                    .toDouble(),
            active: true,
            productId: variation.productId);

        /// for relationship we save stock first then variant
        await repository.upsert<Stock>(newStock);
        Variant variant = await repository.upsert<Variant>(variation);
        variant.stock = newStock;

        variant.stockId = newStock.id;
        await repository.upsert<Variant>(variant);
      }
    } catch (e, s) {
      talker.warning('Error in updateStock: $e $s');
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<void> amplifyLogout() async {
    try {
      amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  Future<void> assignCustomerToTransaction(
      {required String customerId, String? transactionId}) async {
    try {
      final transaction = (await transactions(id: transactionId!)).firstOrNull;
      if (transaction != null) {
        transaction.customerId = customerId;
        repository.upsert<ITransaction>(transaction);
      } else {
        throw Exception('Transaction with ID $transactionId not found');
      }

      final customer =
          (await customers(branchId: transaction.branchId!, id: customerId))
              .firstOrNull;

      if (customer != null) {
        customer.updatedAt = DateTime.now();
        repository.upsert<Customer>(customer);
      } else {
        throw Exception('Customer with ID $customerId not found');
      }
    } catch (e) {
      print('Failed to assign customer to transaction: $e');
      rethrow;
    }
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
  Future<bool> bindProduct(
      {required String productId, required String tenantId}) {
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
  Future<Drawers?> closeDrawer(
      {required Drawers drawer, required double eod}) async {
    drawer.open = false;
    drawer.cashierId = ProxyService.box.getUserId()!;
    // drawer.closingBalance = double.parse(_controller.text);
    drawer.closingBalance = eod;
    drawer.closingDateTime = DateTime.now().toIso8601String();
    return await repository.upsert(drawer);
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return await repository.get<PColor>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  FutureOr<List<Composite>> composites(
      {String? productId, String? variantId}) async {
    return await repository.get<Composite>(
        query: brick.Query(
      where: [
        if (productId != null) brick.Where('productId').isExactly(productId),
        if (variantId != null) brick.Where('variantId').isExactly(variantId),
      ],
    ));
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
  Future<void> createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) async {
    Branch? branchSaved = (await repository.get<Branch>(
            query: brick.Query(where: [
      brick.Where('id').isExactly(branch.id),
    ])))
        .firstOrNull;
    if (branchSaved == null) {
      await repository.upsert<Branch>(branch);
    }
  }

  Future<models.Variant> _createRegularVariant(int branchId, int? tinNumber,
      {required double qty,
      required double supplierPrice,
      required double retailPrice,
      required int itemSeq,
      String? bhFId,
      required bool ebmSynced,
      Product? product,
      required String productId,
      required String name,
      required String sku}) async {
    final String variantId = const Uuid().v4();
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
          // variant: newVariant,
          branchId: branchId,
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
      required int invoiceNumber}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Receipt receipt = Receipt(
        branchId: branchId,
        resultCd: signature.resultCd,
        resultMsg: signature.resultMsg,
        rcptNo: signature.data?.rcptNo ?? 0,
        intrlData: signature.data?.intrlData ?? "",
        rcptSign: signature.data?.rcptSign ?? "",
        qrCode: qrCode,
        receiptType: receiptType,
        invoiceNumber: invoiceNumber,
        vsdcRcptPbctDate: signature.data?.vsdcRcptPbctDate ?? "",
        sdcId: signature.data?.sdcId ?? "",
        totRcptNo: signature.data?.totRcptNo ?? 0,
        mrcNo: signature.data?.mrcNo ?? "",
        transactionId: transaction.id,
        invcNo: counter.invcNo,
        whenCreated: whenCreated,
        resultDt: signature.resultDt ?? "");
    Receipt? existingReceipt = (await repository.get<Receipt>(
            query: brick.Query(where: [
      brick.Where('transactionId').isExactly(transaction.id),
    ])))
        .firstOrNull;

    if (existingReceipt != null) {
      existingReceipt
        ..resultCd = receipt.resultCd
        ..resultMsg = receipt.resultMsg
        ..rcptNo = receipt.rcptNo
        ..intrlData = receipt.intrlData
        ..rcptSign = receipt.rcptSign
        ..qrCode = receipt.qrCode
        ..receiptType = receipt.receiptType
        ..invoiceNumber = receipt.invoiceNumber
        ..vsdcRcptPbctDate = receipt.vsdcRcptPbctDate
        ..sdcId = receipt.sdcId
        ..totRcptNo = receipt.totRcptNo
        ..mrcNo = receipt.mrcNo
        ..invcNo = receipt.invcNo
        ..whenCreated = receipt.whenCreated
        ..resultDt = receipt.resultDt;
      return await repository.upsert(existingReceipt,
          query: brick.Query(
            action: QueryAction.update,
          ));
    } else {
      return await repository.upsert(receipt,
          query: brick.Query(
            action: QueryAction.insert,
          ));
    }
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
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) async {
    switch (endPoint) {
      case 'product':
        final product = await getProduct(
            id: id,
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!);
        if (product != null) {
          await repository.delete<Product>(product);
        }
        break;
      case 'variant':
        final variant = await getVariantById(id: id);
        final stock = await getStockById(id: variant!.stockId!);
        if (stock != null) {
          try {
            await repository.delete<Variant>(
              variant,
            );
            await repository.delete<Stock>(
              stock,
            );
          } catch (e) {}
        }
        break;

      case 'transactionItem':
        final transactionItem = await transactionItems(
            id: id, branchId: ProxyService.box.getBranchId()!);

        await repository.delete<TransactionItem>(transactionItem.first);

        break;
      // case 'discount':
      //   final discount = await getDiscount(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (discount != null) {
      //     await repository.delete<Discount>(discount);
      //   }
      //   break;
      // case 'category':
      //   final category = await getCategory(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (category != null) {
      //     await repository.delete<Category>(category);
      //   }
      //   break;
      // case 'unit':
      //   final unit = await getUnit(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (unit != null) {
      //     await repository.delete<IUnit>(unit);
      //   }
      //   break;
      // case 'setting':
      //   final setting = await getSetting(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (setting != null) {
      //     await repository.delete<Setting>(setting);
      //   }
      //   break;
      // case 'token':
      //   final token = await getToken(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (token != null) {
      //     await repository.delete<Token>(token);
      //   }
      //   break;
      // case 'device':
      //   final device = await getDevice(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (device != null) {
      //     await repository.delete<Device>(device);
      //   }
      //   break;
      // case 'favorite':
      //   final favorite = await getFavoriteByIndex(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (favorite != null) {
      //     await repository.delete<Favorite>(favorite);
      //   }
      //   break;
      // case 'composite':
      //   final composite = await getComposite(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (composite != null) {
      //     await repository.delete<Composite>(composite);
      //   }
      //   break;
      // case 'setting':
      //   final setting = await getSetting(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (setting != null) {
      //     await repository.delete<Setting>(setting);
      //   }
      //   break;
      // case 'team':
      //   final team = await getTeam(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (team != null) {
      //     await repository.delete<Team>(team);
      //   }
      //   break;
      // case 'plan':
      //   final plan = await getPlan(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (plan != null) {
      //     await repository.delete<Plan>(plan);
      //   }
      //   break;
      // case 'planAddon':
      //   final planAddon = await getPlanAddon(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (planAddon != null) {
      //     await repository.delete<PlanAddon>(planAddon);
      //   }
      //   break;
      // case 'planAddon':
      //   final planAddon = await getPlanAddon(id: id, branchId: ProxyService.box.getBranchId()!);
      //   if (planAddon != null) {
      //     await repository.delete<PlanAddon>(planAddon);
      //   }
      //   break;
    }
    return true;
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
  Future<int> deleteFavoriteByIndex({required String favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError(
        "deleteFavoriteByIndex method is not implemented yet");
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, String? transactionId}) {
    // TODO: implement deleteItemFromCart
  }

  @override
  Future<int> deleteTransactionByIndex({required String transactionIndex}) {
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
      {String? assetName, String? subPath = "branch"}) async {
    try {
      talker.info("About to call downloadAssetSave");
      int branchId = ProxyService.box.getBranchId()!;

      if (assetName != null) {
        return downloadAsset(
            branchId: branchId, assetName: assetName, subPath: subPath!);
      }

      List<Assets> assets = await repository.get(
          query: brick.Query(
              where: [brick.Where('branchId').isExactly(branchId)]));

      StreamController<double> progressController = StreamController<double>();

      for (Assets asset in assets) {
        if (asset.assetName != null) {
          // Get the download stream
          Stream<double> downloadStream = await downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!);

          // Listen to the download stream and add its events to the main controller
          downloadStream.listen((progress) {
            print('Download progress for ${asset.assetName}: $progress');
            progressController.add(progress);
          }, onError: (error) {
            // Handle errors in the download stream
            talker.error(
                'Error in download stream for ${asset.assetName}: $error');
            progressController.addError(error);
          });
        } else {
          talker.warning('Asset name is null for asset: ${asset.id}');
        }
      }

      // Close the stream controller when all downloads are finished
      Future.wait(assets.map((asset) => asset.assetName != null
          ? downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!)
          : Future.value(Stream.empty()))).then((_) {
        progressController.close();
      }).catchError((error) {
        talker.error('Error in downloading assets: $error');
        progressController.close();
      });

      return progressController.stream;
    } catch (e, s) {
      talker.error('Error in downloading assets: $e');
      talker.error('Error in downloading assets: $s');
      rethrow;
    }
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
  Future<Product?> findProductByTenantId({required String tenantId}) async {
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
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(productId)]);
    // Return the stream directly instead of storing in variable
    return repository.subscribe<Variant>(query: query);
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, String? productId}) async {
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
        query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);
    return result.firstOrNull;
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(businessId)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);
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
  Future<PColor?> getColor({required String id}) async {
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
        query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);

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
        String variantId = const Uuid().v4();
        final stockId = const Uuid().v4();
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
            taxPercentage: 18.0,
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

  @override
  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id}) async {
    if (id != null) {
      return repository.get<Customer>(
          query: brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
      ]));
    }

    if (key != null) {
      final searchFields = ['custNm', 'email', 'telNo'];
      final queries = searchFields.map((field) => brick.Query(where: [
            brick.Where(field, value: key, compare: brick.Compare.contains),
            brick.Where('branchId',
                value: branchId, compare: brick.Compare.exact),
          ]));

      final results =
          await Future.wait(queries.map((query) => repository.get<Customer>(
                policy: OfflineFirstGetPolicy.alwaysHydrate,
                query: query,
              )));

      return results.expand((customers) => customers).toList();
    }

    // If only branchId is provided, return all customers for that branch
    return repository.get<Customer>(
        query: brick.Query(where: [
      brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
    ]));
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
  Future<Favorite?> getFavoriteById({required String favId}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(favId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
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
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
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
          query: query, policy: OfflineFirstGetPolicy.alwaysHydrate);
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId}) async {
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
              id: int.tryParse(localPin.firstOrNull?.id ?? "0"),
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
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required int branchId}) async {
    if (key != null) {
      return await repository.get<Product>(
          query: brick.Query(where: [brick.Where('name').isExactly(key)]));
    }
    if (prodIndex != null) {
      return await repository.get<Product>(
          query: brick.Query(where: [brick.Where('id').isExactly(prodIndex)]));
    }
    return await repository.get<Product>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) async {
    return (await repository.get<Receipt>(
            query: brick.Query(where: [
      brick.Where('transactionId').isExactly(transactionId)
    ])))
        .firstOrNull;
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
      String? variantId,
      bool nonZeroValue = false,
      String? id}) async {
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
  FutureOr<Stock?> getStockById({required String id}) async {
    final query = brick.Query(where: [
      brick.Where('id', value: id, compare: brick.Compare.exact),
    ]);
    return (await repository.get<Stock>(query: query)).firstOrNull;
  }

  @override
  Stream<double> getStockStream(
      {String? productId, String? variantId, required int branchId}) {
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
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) async {
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<ITransaction> transactionsList = await transactions();

    List<ITransaction> filteredTransactions = [];
    for (final transaction in transactionsList) {
      temporaryDate = DateTime.parse(transaction.createdAt!);
      if (temporaryDate.isAfter(oldDate)) {
        filteredTransactions.add(transaction);
      }
    }

    double sum_cash_in = 0;
    double sum_cash_out = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sum_cash_out = transaction.subTotal! + sum_cash_out;
      } else {
        sum_cash_in = transaction.subTotal! + sum_cash_in;
      }
    }

    return (income: sum_cash_in, expense: sum_cash_out);
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
    final anyAccess = await repository.get<Access>(
        query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));

    /// cases where no access was set to a user he is admin by default.
    if (anyAccess.firstOrNull == null) return true;

    final accesses = await repository.get<Access>(
        query: brick.Query(where: [
      brick.Where('userId').isExactly(userId),
      brick.Where('featureName').isExactly(appFeature),
      brick.Where('accessLevel').isExactly('admin'),
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
            id: e.serverId,
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
              encryptionKey: e.encryptionKey ?? "",
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
      final transaction = ITransaction(
          lastTouched: DateTime.now(),
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0.0,
          cashReceived: 0.0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
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
      final transaction = ITransaction(
          lastTouched: DateTime.now(),
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0.0,
          cashReceived: 0.0,
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
  Stream<List<Product>> productStreams({String? prodIndex}) {
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
    // required String payStackUserId,
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
        // payStackUserId: payStackUserId,
        paymentMethod: paymentMethod,
        addons: updatedAddons,
        nextBillingDate: nextBillingDate,
      );

      return updatedPlan;
    } catch (e, s) {
      talker.error('Failed to save/update payment plan: $e, stack trace: $s');
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
    // required String payStackUserId,
    required String paymentMethod,
    required List<models.PlanAddon> addons,
    required DateTime nextBillingDate,
    required int numberOfPayments,
  }) async {
    final plan = models.Plan(
      businessId: businessId,
      selectedPlan: selectedPlan,
      additionalDevices: additionalDevices,
      isYearlyPlan: isYearlyPlan,
      rule: isYearlyPlan ? 'yearly' : 'monthly',
      totalPrice: totalPrice.toInt(),
      createdAt: DateTime.now(),
      numberOfPayments: numberOfPayments,
      nextBillingDate: nextBillingDate,
      // payStackCustomerId: payStackUserId,
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
                final variantId = separator[3];
                Variant? variant = (await variants(
                        variantId: variantId,
                        branchId: ProxyService.box.getBranchId()!))
                    .firstOrNull;
                if (variant != null) {
                  variant.ebmSynced = true;
                  repository.upsert<Variant>(variant);
                }
                ProxyService.notification
                    .sendLocalNotification(body: "Item Saving " + separator[1]);
              }
              if (separator[2] == "stock") {
                final stockId = separator[3];
                Stock? stock = await getStockById(id: stockId);
                if (stock != null) {
                  stock.ebmSynced = true;
                  repository.upsert<Stock>(stock);
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Stock Saving " + separator[1]);
              }
              if (separator[2] == "customer") {
                final customerId = separator[3];
                Customer? customer = (await customers(
                        id: customerId,
                        branchId: ProxyService.box.getBranchId()!))
                    .firstOrNull;
                if (customer != null) {
                  customer.ebmSynced = true;
                  repository.upsert<Customer>(customer);
                }
                ProxyService.notification.sendLocalNotification(
                    body: "Customer Saving " + separator[1]);
              }
              if (separator[2] == "transaction") {
                final transactionId = separator[3];
                ITransaction? transaction =
                    (await transactions(id: transactionId)).firstOrNull;
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
  Future<void> syncUserWithAwsIncognito({required String identifier}) async {
    try {
      final result = await amplify.Amplify.Auth.fetchAuthSession();
      if (!result.isSignedIn) {
        final signInResult = await amplify.Amplify.Auth.signIn(
          username: identifier,
          password: identifier,
        );
        if (signInResult.isSignedIn) {
          talker.warning('User logged in successfully');
        } else {
          talker.warning('Login not complete. Additional steps required.');
        }
      }

//       /// TODO: once I enable for a user to auth using his creds maybe I will enable this
//       /// but we have one user we keep using for auth uploads
//       // final Map<cognito.AuthUserAttributeKey, String> userAttributes = {
//       //   if (identifier.contains('@'))
//       //     cognito.AuthUserAttributeKey.email: identifier,
//       //   if (!identifier.contains('@')) ...{
//       //     cognito.AuthUserAttributeKey.phoneNumber: identifier,
//       //     // Provide a default email to satisfy the schema requirement
//       //     cognito.AuthUserAttributeKey.email: 'yegobox@gmail.com',
//       //   }
//       // };

//       // final signUpResult = await amplify.Amplify.Auth.signUp(
//       //   username: identifier,
//       //   password:
//       //       identifier, // Using the identifier as the password for simplicity
//       //   options: cognito.SignUpOptions(
//       //     userAttributes: userAttributes,
//       //   ),
//       // );

//       // if (signUpResult.isSignUpComplete) {
//       //   talker.warning('User signed up successfully!');
//       // } else {
//       //   talker.warning('Sign up not complete. Additional steps required.');
//       // }
//     } on cognito.AuthException catch (e) {
//       talker.error('Unexpected error: $e');
//       // rethrow;
    } catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    }
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
      if (excludeUserId != null) brick.Where('userId').isExactly(excludeUserId),
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
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(
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
            final perm = LPermission(name: permission.name);
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
  Future<double> totalStock({String? productId, String? variantId}) async {
    double totalStock = 0.0;
    if (productId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: brick.Query(
              where: [brick.Where('productId').isExactly(productId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    } else if (variantId != null) {
      List<Stock> stocksIn = await repository.get<Stock>(
          query: brick.Query(
              where: [brick.Where('variantId').isExactly(variantId)]));
      totalStock =
          stocksIn.fold(0.0, (sum, stock) => sum + (stock.currentStock!));
    }
    return totalStock;
  }

  @override
  FutureOr<List<ITransaction>> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      String? id,
      FilterType? filterType,
      bool isExpense = false,
      bool includePending = false}) async {
    final List<brick.Where> conditions = [
      brick.Where('status').isExactly(status ?? COMPLETE),
      brick.Where('subTotal').isGreaterThan(0),
      if (id != null) brick.Where('id').isExactly(id),
      // if (filterType != null) brick.Where('filterType').isExactly(filterType),
      if (branchId != null) brick.Where('branchId').isExactly(branchId),
      if (isCashOut) brick.Where('isExpense').isExactly(true),
      if (startDate != null && endDate != null)
        brick.Where('lastTouched').isBetween(startDate, endDate),
    ];

    final queryString = brick.Query(where: conditions);
    final repository = brick.Repository();

    return await repository.get<ITransaction>(query: queryString);
  }

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final List<brick.Where> conditions = [
      brick.Where('status').isExactly(status ?? COMPLETE),
      brick.Where('subTotal').isGreaterThan(0),
      if (id != null) brick.Where('id').isExactly(id),
      // if (filterType != null) brick.Where('filterType').isExactly(filterType),
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
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) async {
    try {
      int branchId = ProxyService.box.getBranchId()!;
      final filePath = 'public/invoices-${branchId}/$fileName.pdf';

      final result = await amplify.Amplify.Storage
          .uploadFile(
            localFile: amplify.AWSFile.fromStream(
              Stream.value(pdfData),
              size: pdfData.length,
            ),
            path: amplify.StoragePath.fromString(filePath),
            onProgress: (progress) {
              talker
                  .warning('Fraction completed: ${progress.fractionCompleted}');
            },
          )
          .result;
      return result.uploadedItem.path;
    } catch (e) {
      talker.error("Error uploading file to S3: $e");
      rethrow;
    }
  }

  @override
  Future<int> userNameAvailable(
      {required String name,
      required HttpClientInterface flipperHttpClient}) async {
    final response =
        await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  Future<ITransaction> collectPayment({
    required double cashReceived,
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
    required bool isIncome,
  }) async {
    try {
      // Fetch transaction items
      List<TransactionItem> items = await transactionItems(
        branchId: branchId,
        transactionId: transaction.id,
      );

      // Update transaction details
      final double subTotal =
          items.fold(0, (num a, b) => a + (b.price * b.qty));
      final double subTotalFinalized = !isIncome ? cashReceived : subTotal;

      _updateTransactionDetails(
        transaction: transaction,
        isIncome: isIncome,
        cashReceived: cashReceived,
        subTotalFinalized: subTotalFinalized,
        paymentType: paymentType,
        isProformaMode: isProformaMode,
        isTrainingMode: isTrainingMode,
        transactionType: transactionType,
        categoryId: categoryId,
      );

      // Save transaction
      repository.upsert(transaction);

      // Update stock and transaction items
      await _updateStockAndItems(items: items, branchId: branchId);

      // Handle receipt if required
      if (directlyHandleReceipt) {
        TaxController(object: transaction)
            .handleReceipt(filterType: FilterType.NS);
      }

      return transaction;
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  void _updateTransactionDetails({
    required ITransaction transaction,
    required bool isIncome,
    required double cashReceived,
    required double subTotalFinalized,
    required String paymentType,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String transactionType,
    String? categoryId,
  }) {
    final now = DateTime.now().toUtc().toLocal();

    transaction
      ..status = COMPLETE
      ..isIncome = isIncome
      ..isExpense = !isIncome
      ..customerChangeDue = (cashReceived - subTotalFinalized)
      ..paymentType = paymentType
      ..cashReceived = cashReceived
      ..subTotal = subTotalFinalized
      ..receiptType = _determineReceiptType(isProformaMode, isTrainingMode)
      ..updatedAt = now.toIso8601String()
      ..createdAt = now.toIso8601String()
      ..transactionType = transactionType
      ..categoryId = categoryId ?? "0"
      ..lastTouched = now;
  }

  String _determineReceiptType(bool isProformaMode, bool isTrainingMode) {
    if (isProformaMode) return TransactionReceptType.PS;
    if (isTrainingMode) return TransactionReceptType.TS;
    return TransactionReceptType.NS;
  }

  Future<void> _updateStockAndItems({
    required List<TransactionItem> items,
    required int branchId,
  }) async {
    for (TransactionItem item in items) {
      if (!item.active!) {
        repository.delete(item);
        continue;
      }

      await _updateStockForItem(item: item, branchId: branchId);

      item
        ..doneWithTransaction = true
        ..updatedAt = DateTime.now().toUtc().toLocal().toIso8601String();
      repository.upsert(item);
    }
  }

  Future<void> _updateStockForItem({
    required TransactionItem item,
    required int branchId,
  }) async {
    final stock =
        await getStock(variantId: item.variantId!, branchId: branchId);
    if (stock == null) return;

    final finalStock = (stock.currentStock! - item.qty);
    final variant = await getVariantById(id: item.variantId!);
    final stockValue = finalStock * (variant?.retailPrice ?? 0);
    final bhfId = await ProxyService.box.bhfId();

    stock
      ..rsdQty = finalStock
      ..currentStock = finalStock
      ..value = stockValue
      ..ebmSynced = false
      ..bhfId = stock.bhfId ?? bhfId
      ..tin = stock.tin ?? ProxyService.box.tin();

    repository.upsert(stock);
  }

  @override
  Future<Configurations> saveTax(
      {required String configId, required double taxPercentage}) {
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
      {required String productId,
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
      String? id,
      required DateTime createdAt,
      required deletedAt}) async {
    final category = await repository.get<Category>(
        query: brick.Query(where: [
      brick.Where('name').isExactly(name),
    ]));
    if (category.firstOrNull == null) {
      await repository.upsert<Category>(Category(
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
  FutureOr<void> updateAsset({required String assetId, String? assetName}) {
    // TODO: implement updateAsset
    throw UnimplementedError("updateAsset method is not implemented yet");
  }

  @override
  FutureOr<void> updateCategory(
      {required String categoryId,
      String? name,
      bool? active,
      bool? focused,
      int? branchId}) async {
    final category = (await repository.get<Category>(
            query: brick.Query(where: [
      brick.Where('id', value: categoryId, compare: Compare.exact),
    ])))
        .firstOrNull;
    if (category != null) {
      category.name = name ?? category.name;
      category.active = active ?? category.active;
      category.focused = focused ?? category.focused;
      category.branchId = branchId ?? category.branchId;
      await repository.upsert<Category>(category);
    }
  }

  @override
  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active}) {
    // TODO: implement updateColor
    throw UnimplementedError("  updateColor method is not implemented yet");
  }

  @override
  FutureOr<void> updateDrawer(
      {required String drawerId,
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
      {required String notificationId, bool? completed}) {
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
      {String? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      String? imageUrl,
      required int branchId,
      required int businessId,
      String? expiryDate}) async {
    final product = await getProduct(
        id: productId, branchId: branchId, businessId: businessId);
    if (product != null) {
      product.name = name ?? product.name;
      product.isComposite = isComposite ?? product.isComposite;
      product.unit = unit ?? product.unit;
      product.expiryDate = expiryDate ?? product.expiryDate;
      product.imageUrl = imageUrl ?? product.imageUrl;
      product.color = color ?? product.color;
      await repository.upsert(product);
    }
  }

  @override
  FutureOr<void> updateReport(
      {required String reportId, bool? downloaded}) async {
    // TODO: implement updateReport
    throw UnimplementedError("updateReport method is not implemented yet");
  }

  @override
  Future<void> updateTenant(
      {required String tenantId,
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
      String? customerId,
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
      bool? isTrainingMode}) async {
    if (receiptType != null) {
      transaction.ebmSynced = true;
      transaction.isRefunded = receiptType == "R";

      if (isProformaMode != null && isTrainingMode != null) {
        String receiptType = TransactionReceptType.NS;
        if (isProformaMode) {
          receiptType = TransactionReceptType.PS;
        }
        if (isTrainingMode) {
          receiptType = TransactionReceptType.TS;
        }
        transaction.receiptType = receiptType;
        transaction.subTotal = subTotal ?? transaction.subTotal;
        transaction.note = note ?? transaction.note;
        transaction.status = status ?? transaction.status;
        transaction.ticketName = ticketName ?? transaction.ticketName;
        transaction.updatedAt = updatedAt ?? transaction.updatedAt;
        transaction.customerId = customerId ?? transaction.customerId;
        transaction.isRefunded = isRefunded ?? transaction.isRefunded;
        transaction.ebmSynced = ebmSynced ?? transaction.ebmSynced;
        transaction.invoiceNumber = invoiceNumber ?? transaction.invoiceNumber;
        transaction.receiptNumber = receiptNumber ?? transaction.receiptNumber;
        transaction.totalReceiptNumber =
            totalReceiptNumber ?? transaction.totalReceiptNumber;
        transaction.sarTyCd = sarTyCd ?? transaction.sarTyCd;
        transaction.reference = reference ?? transaction.reference;
        transaction.customerTin = customerTin ?? transaction.customerTin;
        transaction.customerBhfId = customerBhfId ?? transaction.customerBhfId;
        transaction.cashReceived = cashReceived ?? transaction.cashReceived;
        transaction.customerName = customerName ?? transaction.customerName;
        transaction.lastTouched = lastTouched ?? transaction.lastTouched;
        await repository.upsert<ITransaction>(transaction,
            query: brick.Query(
              action: QueryAction.update,
            ));
      }
    }
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      required String transactionItemId,
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
      double? dcAmt}) async {
    TransactionItem? item = (await repository.get<TransactionItem>(
            query: brick.Query(where: [
      brick.Where('id', value: transactionItemId, compare: brick.Compare.exact),
    ])))
        .firstOrNull;
    if (item != null) {
      item.qty = incrementQty == true ? item.qty + 1 : qty ?? item.qty;
      item.discount = discount ?? item.discount;
      item.active = active ?? item.active;
      item.price = price ?? item.price;
      item.prc = prc ?? item.prc;
      item.taxAmt = taxAmt ?? item.taxAmt;
      item.isRefunded = isRefunded ?? item.isRefunded;
      item.ebmSynced = ebmSynced ?? item.ebmSynced;
      item.quantityApproved = quantityApproved ?? item.quantityApproved;
      item.quantityRequested = quantityRequested ?? item.quantityRequested;
      item.splyAmt = splyAmt ?? item.splyAmt;
      item.quantityShipped = quantityShipped ?? item.quantityShipped;
      item.taxblAmt = taxblAmt ?? item.taxblAmt;
      item.totAmt = totAmt ?? item.totAmt;
      item.doneWithTransaction =
          doneWithTransaction ?? item.doneWithTransaction;
      repository.upsert(item, query: brick.Query(action: QueryAction.update));
    }
  }

  @override
  FutureOr<void> updateUnit(
      {required String unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError("updateUnit method is not implemented yet");
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) async {
    variant.stock = stock;
    return await repository.upsert<Variant>(variant);
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
  Future<List<Variant>> variants(
      {required int branchId,
      String? productId,
      int? page,
      String? variantId,
      String? name,
      int? itemsPerPage}) async {
    // if (variants.isEmpty) {
    //   variants = await repository.get<Variant>(
    //       query: brick.Query(where: [
    //     brick.Where('branchIds').contains(branchId),
    //     brick.Where('retailPrice').isGreaterThan(0),
    //     brick.Where('name').isNot(TEMP_PRODUCT),
    //   ]));
    // }
    List<Variant> variants = await repository.get<Variant>(
        query: brick.Query(where: [
      if (variantId != null)
        brick.Where('id').isExactly(variantId)
      else ...[
        brick.Where('branchId').isExactly(branchId),
        brick.Where('retailPrice').isGreaterThan(0),
        brick.Where('name').isNot(TEMP_PRODUCT),
        brick.Where('productName').isNot(CUSTOM_PRODUCT),
        if (productId != null) brick.Where('productId').isExactly(productId),
        if (name != null) brick.Where('name').isExactly(name),
      ]
    ]));
    ;

    if (page != null && itemsPerPage != null) {
      final offset = page * itemsPerPage;
      return variants.skip(offset).take(itemsPerPage).toList();
    }

    return variants;
  }

  @override
  Future<models.TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, String? transactionId}) async {
    return (await repository.get<TransactionItem>(
            query: brick.Query(where: [
      brick.Where('variantId', value: variantId, compare: brick.Compare.exact),
      if (transactionId != null)
        brick.Where('transactionId',
            value: transactionId, compare: brick.Compare.exact),
    ])))
        .firstOrNull;
  }

  @override
  Future<Variant?> getVariantById({required String id}) async {
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
      String? transactionId,
      double amount = 0.0,
      String? paymentMethod,
      required bool singlePaymentOnly}) async {
    /// check if there is TransactionPaymentRecord with amount 0 delete it as we might not need it
    /// by default we add payment method with 0.0 amount if this method was not updated with real money they we need to delete it to avoid confusion.

    final transactionPaymentRecordWithAmount0 =
        (await repository.get<TransactionPaymentRecord>(
                query: brick.Query(where: [
      brick.Where('transactionId').isExactly(transactionId),
      brick.Where('amount').isExactly(0.0),
    ])))
            .firstOrNull;
    if (transactionPaymentRecordWithAmount0 != null) {
      await repository.delete<TransactionPaymentRecord>(
          transactionPaymentRecordWithAmount0,
          query: brick.Query(
            action: QueryAction.delete,
          ));
    }

    /// if is single payment delete any other payments, this is to handle case where a user switched from one payment method to another
    /// but he ended up one payment method choosen, in this case we delete other and save the one he is at.
    /// if multiple payment is choosen this is not applied.
    if (singlePaymentOnly) {
      final transactionPaymentRecords =
          (await repository.get<TransactionPaymentRecord>(
              query: brick.Query(where: [
        brick.Where('transactionId').isExactly(transactionId),
      ])));

      for (TransactionPaymentRecord record in transactionPaymentRecords) {
        await repository.delete<TransactionPaymentRecord>(record,
            query: brick.Query(
              action: QueryAction.delete,
            ));
      }
    }

    final transactionPaymentRecord =
        (await repository.get<TransactionPaymentRecord>(
                query: brick.Query(where: [
      brick.Where('transactionId').isExactly(transactionId),
      brick.Where('paymentMethod').isExactly(paymentMethod),
    ])))
            .firstOrNull;

    if (transactionPaymentRecord != null) {
      transactionPaymentRecord.paymentMethod = paymentMethod;
      transactionPaymentRecord.amount = amount;
      await repository.upsert<TransactionPaymentRecord>(
          transactionPaymentRecord,
          query: brick.Query(
            action: QueryAction.insert,
          ));
    } else if (transactionId != 0) {
      final transactionPaymentRecord = TransactionPaymentRecord(
        createdAt: DateTime.now(),
        amount: amount,
        transactionId: transactionId,
        paymentMethod: paymentMethod,
      );

      await repository.upsert<TransactionPaymentRecord>(
          transactionPaymentRecord,
          query: brick.Query(
            action: QueryAction.insert,
          ));
    }
    if (paymentRecord != null) {
      await repository.upsert<TransactionPaymentRecord>(paymentRecord);
    }
  }

  @override
  FutureOr<void> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
      required double currentStock,
      required double value}) async {
    final stock = Stock(
      lastTouched: DateTime.now(),
      branchId: branchId,
      // variant: variant!,
      currentStock: currentStock,
      rsdQty: rsdQty,
      value: value,
      productId: variant!.productId,
    );
    await repository.upsert<Stock>(stock);
  }

  @override
  FutureOr<void> updateStock(
      {required String stockId,
      double? qty,
      double? rsdQty,
      double? initialStock,
      bool? ebmSynced,
      double? currentStock,
      double? value,
      DateTime? lastTouched}) async {
    Stock? stock = await getStockById(id: stockId);
    if (stock != null) {
      stock.currentStock = currentStock ?? qty ?? stock.currentStock;
      stock.rsdQty = rsdQty ?? stock.rsdQty;
      stock.initialStock = initialStock ?? qty ?? stock.initialStock;
      stock.ebmSynced = ebmSynced ?? stock.ebmSynced;
      stock.value = value ?? stock.value;
      stock.lastTouched = lastTouched ?? stock.lastTouched;
      repository.upsert(stock);
    }
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
      query: brick.Query(
        where: [
          brick.Where('userId').isExactly(userId),
          if (featureName != null)
            brick.Where('featureName').isExactly(featureName),
        ],
        orderBy: [brick.OrderBy('id', ascending: true)],
      ),
    );
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
  Stream<List<TransactionItem>> transactionItemsStreams(
      {String? transactionId,
      required int branchId,
      DateTime? startDate,
      DateTime? endDate,
      bool? doneWithTransaction,
      bool? active}) {
    return repository.subscribe<TransactionItem>(
        query: brick.Query(where: [
      if (transactionId != null)
        brick.Where('transactionId').isExactly(transactionId),
      brick.Where('branchId').isExactly(branchId),
      if (startDate != null && endDate != null)
        brick.Where('lastTouched').isBetween(startDate, endDate),
      if (doneWithTransaction != null)
        brick.Where('doneWithTransaction').isExactly(doneWithTransaction),
      if (active != null) brick.Where('active').isExactly(active),
    ]));
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    required int branchId,
    String? id,
    bool? active,
  }) async {
    return repository.get(
        query: brick.Query(where: [
      if (transactionId != null)
        brick.Where('transactionId').isExactly(transactionId),
      brick.Where('branchId').isExactly(branchId),
      if (id != null) brick.Where('id').isExactly(id),
      if (doneWithTransaction != null)
        brick.Where('doneWithTransaction').isExactly(doneWithTransaction),
      if (active != null) brick.Where('active').isExactly(active),
    ]));
  }

  @override
  FutureOr<List<LPermission>> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError("permissions method is not implemented yet");
  }

  @override
  void updateAccess(
      {required String accessId,
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
      String? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<String, String>? rates,
      double? supplyPrice,
      Map<String, String>? dates,
      String? selectedProductType,
      String? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      bool? ebmSynced}) async {
    if (variantId != null) {
      Variant? variant = await getVariantById(id: variantId);
      if (variant != null) {
        variant.productName = productName ?? variant.productName;
        variant.productId = productId ?? variant.productId;
        variant.taxTyCd = taxTyCd ?? variant.taxTyCd;
        variant.unit = unit ?? variant.unit;
        repository.upsert(variant);
      }
      return;
    }

    // loop through all variants and update all with retailPrice and supplyPrice

    for (var i = 0; i < updatables.length; i++) {
      Product? product = await getProduct(
          id: updatables[i].productId!,
          branchId: updatables[i].branchId!,
          businessId: ProxyService.box.getBusinessId()!);
      updatables[i].productName = product?.name ?? updatables[i].productName;
      if (updatables[i].stock == null) {
        await addStockToVariant(variant: updatables[i]);
      }

      product?.name = updatables[i].name;
      double rate = rates?[updatables[i].id] == null
          ? 0
          : double.parse(rates![updatables[i].id]!);
      if (color != null) {
        updatables[i].color = color;
      }

      updatables[i].itemNm = updatables[i].name;
      updatables[i].ebmSynced = false;
      updatables[i].retailPrice =
          newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
      updatables[i].itemTyCd = selectedProductType;
      updatables[i].dcRt = rate;
      updatables[i].expirationDate = dates?[updatables[i].id] == null
          ? null
          : DateTime.tryParse(dates![updatables[i].id]!);

      if (retailPrice != 0 && retailPrice != null) {
        updatables[i].retailPrice = retailPrice;
      }
      if (supplyPrice != 0 && supplyPrice != null) {
        updatables[i].supplyPrice = supplyPrice;
      }

      updatables[i].stock?.rsdQty = (updatables[i].stock?.rsdQty ?? 0);
      updatables[i].stock?.currentStock = (updatables[i].stock?.rsdQty ?? 0);
      updatables[i].lastTouched = DateTime.now().toLocal();
      // realm!.add<Variant>(updatables[i]);
      await repository.upsert(updatables[i]);
    }
  }

  @override
  Future<Tenant?> saveTenant(
      {required Business business,
      required Branch branch,
      String? phoneNumber,
      String? name,
      String? id,
      String? email,
      int? businessId,
      bool? sessionActive,
      int? branchId,
      String? imageUrl,
      int? pin,
      bool? isDefault,
      required HttpClientInterface flipperHttpClient,
      required String userType}) async {
    throw UnimplementedError();
    // final data = jsonEncode({
    //   "phoneNumber": phoneNumber,
    //   "name": name,
    //   "businessId": business.serverId,
    //   "permissions": [
    //     {"name": userType.toLowerCase()}
    //   ],
    //   "businesses": [business.toJson()],
    //   "branches": [branch.toJson()]
    // });

    // final http.Response response = await flipperHttpClient
    //     .post(Uri.parse("$apihub/v2/api/tenant"), body: data);

    // if (response.statusCode == 200) {
    //   try {
    //     ITenant jTenant = ITenant.fromRawJson(response.body);
    //     await _createPin(
    //       flipperHttpClient: flipperHttpClient,
    //       phoneNumber: phoneNumber,
    //       pin: jTenant.userId,
    //       branchId: business.serverId!,
    //       businessId: branch.serverId!,
    //       defaultApp: 1,
    //     );
    //     ITenant iTenant = ITenant(
    //       businesses: jTenant.businesses,
    //       branches: jTenant.branches,
    //       isDefault: jTenant.isDefault,

    //       permissions: jTenant.permissions,
    //       name: jTenant.name,
    //       businessId: jTenant.businessId,
    //       email: jTenant.email,
    //       userId: jTenant.userId,
    //       nfcEnabled: jTenant.nfcEnabled,
    //       phoneNumber: jTenant.phoneNumber,
    //     );
    //     final branchToAdd = <Branch>[];
    //     final permissionToAdd = <LPermission>[];
    //     final businessToAdd = <Business>[];

    //     for (var business in jTenant.businesses) {
    //       Business? existingBusiness = realm!
    //           .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
    //       if (existingBusiness == null) {
    //         businessToAdd.add(Business(

    //           serverId: business.serverId!,
    //           userId: business.userId,
    //           name: business.name,
    //           currency: business.currency,
    //           categoryId: business.categoryId,
    //           latitude: business.latitude,
    //           longitude: business.longitude,
    //           timeZone: business.timeZone,
    //           country: business.country,
    //           businessUrl: business.businessUrl,
    //           hexColor: business.hexColor,
    //           imageUrl: business.imageUrl,
    //           type: business.type,
    //           active: business.active,
    //           chatUid: business.chatUid,
    //           metadata: business.metadata,
    //           role: business.role,
    //           lastSeen: business.lastSeen,
    //           firstName: business.firstName,
    //           lastName: business.lastName,
    //           createdAt: business.createdAt,
    //           deviceToken: business.deviceToken,
    //           backUpEnabled: business.backUpEnabled,
    //           subscriptionPlan: business.subscriptionPlan,
    //           nextBillingDate: business.nextBillingDate,
    //           previousBillingDate: business.previousBillingDate,
    //           isLastSubscriptionPaymentSucceeded:
    //               business.isLastSubscriptionPaymentSucceeded,
    //           backupFileId: business.backupFileId,
    //           email: business.email,
    //           lastDbBackup: business.lastDbBackup,
    //           fullName: business.fullName,
    //           tinNumber: business.tinNumber,
    //           bhfId: business.bhfId,
    //           dvcSrlNo: business.dvcSrlNo,
    //           adrs: business.adrs,
    //           taxEnabled: business.taxEnabled,
    //           taxServerUrl: business.taxServerUrl,
    //           isDefault: business.isDefault,
    //           businessTypeId: business.businessTypeId,
    //           lastTouched: business.lastTouched,
    //           deletedAt: business.deletedAt,
    //           encryptionKey: business.encryptionKey,
    //         ));
    //       }
    //     }

    //     for (var branch in jTenant.branches) {
    //       final existingBranch =
    //           realm!.query<Branch>(r'serverId==$0', [branch.id]).firstOrNull;
    //       if (existingBranch == null) {
    //         Branch br = Branch(

    //           serverId: branch.id,
    //           name: branch.name,
    //           businessId: branch.businessId,
    //           active: branch.active,
    //           lastTouched: branch.lastTouched,
    //           latitude: branch.latitude,
    //           longitude: branch.longitude,
    //         );
    //         branchToAdd.add(br);
    //       }
    //     }

    //     for (var permission in jTenant.permissions) {
    //       LPermission? existingPermission = realm!
    //           .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
    //       if (existingPermission == null) {
    //         permissionToAdd.add(LPermission(

    //           name: permission.name,
    //           id: permission.id,
    //           userId: permission.userId,
    //         ));
    //       }
    //     }

    //     Tenant? tenantToAdd;
    //     Tenant? tenant =
    //         realm!.query<Tenant>(r'userId==$0', [iTenant.userId]).firstOrNull;
    //     if (tenant == null) {
    //       tenantToAdd = Tenant(

    //         name: jTenant.name,
    //         phoneNumber: jTenant.phoneNumber,
    //         email: jTenant.email,
    //         nfcEnabled: jTenant.nfcEnabled,
    //         businessId: jTenant.businessId,
    //         userId: jTenant.userId,

    //         isDefault: jTenant.isDefault,
    //         pin: jTenant.pin,
    //       );
    //       realm!.write(() {
    //         realm!.add<Tenant>(tenantToAdd!);
    //       });
    //     }

    //     realm!.write(() {
    //       realm!.addAll<Business>(businessToAdd);
    //       realm!.addAll<Branch>(branchToAdd);
    //       realm!.write(() {
    //         realm!.addAll<LPermission>(permissionToAdd);
    //       });
    //     });

    //     return tenantToAdd;
    //   } catch (e) {
    //     talker.error(e);
    //     rethrow;
    //   }
    // } else {
    //   throw InternalServerError(term: "internal server error");
    // }
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
      {String? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) async {
    return (await repository.get<Product>(
            query: brick.Query(where: [
      // brick.Or('id').isExactly(id),
      if (id != null) brick.Where('id').isExactly(id),
      if (name != null) brick.Where('name').isExactly(name),
      if (barCode != null) brick.Where('barCode').isExactly(barCode),
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
      where: [brick.Where('code').isNot(null)],
      orderBy: [brick.OrderBy('code', ascending: false)],
    );
    final items = await repository.get<ItemCode>(
        query: Query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Extract the last sequence number and increment it
    int lastSequence = 0;
    if (items.isNotEmpty) {
      final lastItemCode = items.first.code;
      final sequencePart = lastItemCode.substring(lastItemCode.length - 7);
      lastSequence = int.parse(sequencePart);
    }
    final newSequence = (lastSequence + 1).toString().padLeft(7, '0');
    // Construct the new item code
    final newItemCode =
        '$countryCode$productType$packagingUnit$quantityUnit$newSequence';

    // Save the new item code in the database
    final newItem = ItemCode(code: newItemCode, createdAt: DateTime.now());
    await repository.upsert(newItem);

    return newItemCode;
  }

  @override
  FutureOr<SKU> getSku({required int branchId, required int businessId}) async {
    final query = brick.Query(
      where: [
        brick.Where('branchId').isExactly(branchId),
        brick.Where('businessId').isExactly(businessId),
      ],
      orderBy: [brick.OrderBy('sku', ascending: true)],
    );

    final skus = await repository.get<SKU>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Get highest sequence number
    int lastSequence = skus.isEmpty ? 0 : skus.first.sku ?? 0;
    final newSequence = lastSequence + 1;

    final newSku = SKU(
      sku: newSequence,
      branchId: branchId,
      businessId: businessId,
    );
    await repository.upsert(newSku);

    return newSku;
  }

  @override
  Stream<SKU?> sku({required int branchId, required int businessId}) {
    final query = brick.Query(
      where: [
        brick.Where('branchId').isExactly(branchId),
        brick.Where('businessId').isExactly(businessId),
      ],
      orderBy: [brick.OrderBy('sku', ascending: true)],
    );

    return repository
        .subscribe<SKU>(
          query: query,
          policy: OfflineFirstGetPolicy.alwaysHydrate,
        )
        .map((skus) => skus.isNotEmpty ? skus.first : null);
  }

  @override
  Future<void> createVariant(
      {required String barCode,
      required String sku,
      required String productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name}) async {
    await _createRegularVariant(branchId, tinNumber,
        qty: qty,
        supplierPrice: supplierPrice,
        retailPrice: retailPrice,
        itemSeq: itemSeq,
        name: name,
        sku: sku,
        ebmSynced: false,
        productId: productId);
  }

  @override
  Future<void> updateStockRequest(
      {required String stockRequestId,
      DateTime? updatedAt,
      String? status}) async {
    final stockRequest = (await repository.get<StockRequest>(
      query: brick.Query(where: [
        brick.Where('id').isExactly(stockRequestId),
      ]),
    ))
        .firstOrNull;
    if (stockRequest != null) {
      stockRequest.updatedAt = updatedAt ?? stockRequest.updatedAt;
      stockRequest.status = status ?? stockRequest.status;
      repository.upsert<StockRequest>(stockRequest);
    }
  }

  @override
  Future<void> createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) async {
    final newStock = Stock(
      lastTouched: DateTime.now(),
      branchId: subBranchId,
      currentStock: item.quantityRequested!.toDouble(),
      rsdQty: item.quantityRequested!.toDouble(),
      value: (item.quantityRequested! * variant.retailPrice!).toDouble(),
      productId: variant.productId,
      active: false,
    );
    await repository.upsert<Stock>(newStock);
  }
}
