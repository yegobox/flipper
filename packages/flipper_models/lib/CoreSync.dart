import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:isolate';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flipper_models/DatabaseSyncInterface.dart';
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
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/mixins/business_mixin.dart';

import 'package:flipper_models/sync/mixins/category_mixin.dart';

import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/mixins/variant_mixin.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
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
import 'package:brick_offline_first/brick_offline_first.dart';
import 'dart:typed_data';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:path/path.dart' as path;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/constants.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

import 'package:uuid/uuid.dart';

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CoreSync extends AiStrategyImpl
    with
        Booting,
        CoreMiscellaneous,
        TransactionMixin,
        BranchMixin,
        PurchaseMixin,
        BusinessMixin,
        TransactionItemMixin,
        VariantMixin,
        CategoryMixin

    implements DatabaseSyncInterface {
  final String apihub = AppSecrets.apihubProd;

  bool offlineLogin = false;

  final Repository repository = Repository();

  CoreSync();
  bool isInIsolate() {
    return Isolate.current.debugName != null;
  }

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
              uid: pinLocal.uid ?? "");
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

  // @override
  // AsyncCollection? accessCollection;

  // @override
  // AsyncCollection? branchCollection;

  // @override
  // AsyncCollection? businessCollection;

  // // @override
  // // DatabaseProvider? capella;

  // @override
  // AsyncCollection? permissionCollection;

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

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
  Future<Customer?> addCustomer(
      {required Customer customer, String? transactionId}) async {
    return await repository.upsert(customer);
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      for (Map map in units) {
        final existingUnit = (await repository.get<IUnit>(
                query: brick.Query(where: [
          brick.Where('name').isExactly(map['name']),
          brick.Where('branchId').isExactly(branchId),
        ])))
            .firstOrNull;

        if (existingUnit == null) {
          final unit = IUnit(
              active: map['active'],
              branchId: branchId,
              name: map['name'],
              lastTouched: DateTime.now(),
              value: map['value']);

          // Add the unit to db
          await repository.upsert<IUnit>(unit);
        }
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
      Variant? variant = await getVariant(id: variation.id);

      if (variant != null) {
        Stock? stock = await getStockById(id: variant.stockId!);

        stock.currentStock = stock.currentStock! +
            (variation.stock?.rsdQty ?? variation.qty ?? 0);
        stock.rsdQty = stock.currentStock! + (stock.rsdQty!);
        stock.lastTouched = DateTime.now().toLocal();
        stock.value = (variation.stock?.rsdQty ?? 0 * (variation.retailPrice!))
            .toDouble();

        variant.stock?.rsdQty = variation.stock?.rsdQty ?? variation.qty ?? 0;
        variant.stock?.initialStock =
            variation.stock?.rsdQty ?? variation.qty ?? 0;
        variant.retailPrice = variation.retailPrice;
        variant.supplyPrice = variation.supplyPrice;
        variant.taxPercentage = variation.taxPercentage!.toDouble();
        variant.lastTouched = DateTime.now().toLocal();
        variant.stock = stock;
        variant.stockId = stock.id;
        await repository.upsert<Variant>(variant);
      } else {
        /// for relationship we save stock first then variant
        await repository.upsert<Stock>(variation.stock!);
        Variant variant = await repository.upsert<Variant>(variation);

        variant.stockId = variation.stock!.id;
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
      final transaction =
          (await transactions(id: transactionId!, status: PENDING)).firstOrNull;
      if (transaction != null) {
        transaction.customerId = customerId;
        repository.upsert<ITransaction>(transaction);
      } else {
        throw Exception('Try to add item to a transaction.');
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
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) async {
    return await _getBranches(businessId, includeSelf!);
  }

  Future<List<Branch>> _getBranches(int businessId, bool active) async {
    try {
      final branches = await repository.get<Branch>(
          query: brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
        brick.Or('active').isExactly(active),
      ]));
      return branches;
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
  void clearData({required ClearData data, required int identifier}) async {
    try {
      if (data == ClearData.Branch) {
        // Retrieve the list of Branches to delete based on the query
        // final query = brick.Query();
        final List<Branch> branches = await repository.get<Branch>(
            query: brick.Query(
                where: [brick.Where('serverId').isExactly(identifier)]));

        for (final branch in branches) {
          await repository.delete<Branch>(branch,
              policy: OfflineFirstDeletePolicy.optimisticLocal);
        }
      }

      if (data == ClearData.Business) {
        // Retrieve the list of Businesses to delete
        final List<Business> businesses = await repository.get<Business>(
            query: brick.Query(
                where: [brick.Where('serverId').isExactly(identifier)]));

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
    drawer.closingDateTime = DateTime.now();
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
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: brick.Query(
          where: [
            if (productId != null)
              brick.Where('productId').isExactly(productId),
            if (variantId != null)
              brick.Where('variantId').isExactly(variantId),
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
      bool createItemCode = false,
      required bool ebmSynced,
      Product? product,
      required String productId,
      required String name,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? qtyUnitCd,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      double? invcFcurExcrt,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? spplrItemCd,
      String? imptItemsttsCd,
      String? spplrItemClsCd,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      required int sku,
      models.Configurations? taxType,
      String? bcd,
      String? saleListId,
      String? pchsSttsCd,
      double? totAmt,
      double? taxAmt,
      double? taxblAmt,
      String? itemCd}) async {
    final String variantId = const Uuid().v4();
    final number = randomNumber().toString().substring(0, 5);

    return Variant(
      spplrNm: spplrNm ?? "",
      agntNm: agntNm ?? "",
      totAmt: totAmt,
      netWt: netWt ?? 0,
      totWt: totWt ?? 0,
      pchsSttsCd: pchsSttsCd,
      taxblAmt: taxblAmt,
      taxAmt: taxAmt,
      invcFcurAmt: invcFcurAmt ?? 0,
      invcFcurCd: invcFcurCd ?? "",
      exptNatCd: exptNatCd ?? "",
      dclNo: dclNo ?? "",
      taskCd: taskCd ?? "",
      dclDe: dclDe ?? "",

      hsCd: hsCd ?? "",
      imptItemSttsCd: imptItemsttsCd ?? "",
      lastTouched: DateTime.now(),
      name: product?.name ?? name,
      sku: sku.toString(),
      dcRt: 0.0,
      productId: product?.id ?? productId,
      color: product?.color,
      unit: 'Per Item',
      productName: product?.name ?? name,
      branchId: branchId,
      supplyPrice: supplierPrice,
      retailPrice: retailPrice,
      id: variantId,
      bhfId: bhFId ?? '00',
      itemStdNm: product?.name ?? name,
      addInfo: "A",
      pkg: pkg ?? 1,

      splyAmt: supplierPrice,
      itemClsCd: itemClasses?[product?.barCode] ?? "5020230602",
      itemCd: createItemCode
          ? await itemCode(
              countryCode: orgnNatCd ?? "RW",
              productType: "2",
              packagingUnit: "CT",
              quantityUnit: "BJ",
              branchId: branchId,
            )
          : itemCd!,
      modrNm: name,
      modrId: number,
      pkgUnitCd: pkgUnitCd ?? "BJ",
      regrId: randomNumber().toString().substring(0, 5),
      itemTyCd: itemTypes?.containsKey(product?.barCode) == true
          ? itemTypes![product!.barCode]!
          : "2", // this is a finished product
      /// available type for itemTyCd are 1 for raw material and 3 for service
      /// is insurance applicable default is not applicable
      isrcAplcbYn: "N",
      useYn: "N",
      itemSeq: itemSeq,
      itemNm: product?.name ?? name,
      taxPercentage: taxType?.taxPercentage ?? 18.0,
      tin: tinNumber,
      bcd: bcd ??
          (product?.name ?? name)
              .substring(0, min((product?.name ?? name).length, 20)),

      /// country of origin for this item we default until we support something different
      /// and this will happen when we do import.
      orgnNatCd: orgnNatCd ?? "RW",

      /// registration name
      regrNm: product?.name ?? name,

      /// taxation type code
      taxTyCd: taxTypes?[product?.barCode] ?? "B",
      // default unit price
      dftPrc: retailPrice,
      prc: retailPrice,

      // NOTE: I believe bellow item are required when saving purchase
      ///but I wonder how to get them when saving an item.
      spplrItemCd: spplrItemCd ?? "",
      spplrItemClsCd: itemClasses?[product?.barCode] ?? spplrItemClsCd,
      spplrItemNm: product?.name ?? name,

      /// Packaging Unit
      // qtyUnitCd ??
      qtyUnitCd: "U", // see 4.6 in doc
      ebmSynced: ebmSynced,
    );
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

  Future<void> deleteTransactionItemAndResequence({required String id}) async {
    try {
      // 1. Fetch the TransactionItem to be deleted.
      final transactionItemToDelete = await repository.get<TransactionItem>(
        query: brick.Query(
          where: [brick.Where('id').isExactly(id)],
          limit: 1, // Assuming 'id' is unique, limit to 1 result for efficiency
        ),
      );

      if (transactionItemToDelete.isEmpty) {
        print('Transaction item with ID $id not found.');
        return; // Or throw an exception, depending on desired behavior
      }

      final itemToDelete = transactionItemToDelete.first;
      final transactionId = itemToDelete.transactionId;

      // 2. Delete the TransactionItem.
      await repository.delete<TransactionItem>(
        itemToDelete, // Pass the actual TransactionItem object
        query: brick.Query(
          action: brick.QueryAction.delete,
          where: [brick.Where('id').isExactly(id)],
        ),
      );

      // 3. Fetch all remaining TransactionItems for the same transaction.
      final remainingItems = await repository.get<TransactionItem>(
        query: brick.Query(
          where: [brick.Where('transactionId').isExactly(transactionId)],
        ),
      );

      // 4. Sort the remaining items by createdAt.
      remainingItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      // 5. Update the itemSeq for each remaining item.
      for (var i = 0; i < remainingItems.length; i++) {
        remainingItems[i].itemSeq = i + 1;
        await repository.upsert<TransactionItem>(remainingItems[i]);
      }
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
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
        try {
          final variant = await getVariant(id: id);
          final stock = await getStockById(id: variant!.stockId ?? "");

          await repository.delete<Variant>(
            variant,
            query: brick.Query(
                action: QueryAction.delete,
                where: [brick.Where('id').isExactly(id)]),
          );
          await repository.delete<Stock>(
            stock,
            query: brick.Query(
                action: QueryAction.delete,
                where: [brick.Where('id').isExactly(id)]),
          );
        } catch (e, s) {
          final variant = await getVariant(id: id);
          await repository.delete<Variant>(
            variant!,
            query: brick.Query(
                action: QueryAction.delete,
                where: [brick.Where('id').isExactly(id)]),
          );
          talker.warning(s);
          rethrow;
        }

        break;

      case 'transactionItem':
        await deleteTransactionItemAndResequence(id: id);
        break;
      case 'customer':
        final customer =
            (await customers(id: id, branchId: ProxyService.box.getBranchId()!))
                .firstOrNull;
        if (customer != null) {
          await repository.delete<Customer>(
            customer,
            query: brick.Query(
                action: QueryAction.delete,
                where: [brick.Where('id').isExactly(id)]),
          );
        }
        break;
      case 'stockRequest':
        final request = (await requests(
          requestId: id,
        ))
            .firstOrNull;
        if (request != null) {
          // get dependent first
          final financing = await repository.get<Financing>(
            query: brick.Query(
                where: [brick.Where('id').isExactly(request.financingId)]),
          );
          try {
            await repository.delete<Financing>(
              financing.first,
              query: brick.Query(
                  action: QueryAction.delete,
                  where: [brick.Where('id').isExactly(financing.first.id)]),
            );
          } catch (e) {
            talker.warning(e);
          }
          await repository.delete<InventoryRequest>(
            request,
            query: brick.Query(
                action: QueryAction.delete,
                where: [brick.Where('id').isExactly(id)]),
          );
        }
        break;
    }
    return true;
  }

  @override
  Future<void> deleteBranch(
      {required int branchId,
      required HttpClientInterface flipperHttpClient}) async {
    try {
      await flipperHttpClient
          .delete(Uri.parse(apihub + '/v2/api/branch/${branchId}'));

      Branch? branch = (await repository.get<Branch>(
              query: brick.Query(
                  where: [brick.Where('serverId').isExactly(branchId)])))
          .firstOrNull;
      if (branch != null) {
        await repository.delete<Branch>(branch);
      }
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) async {
    Favorite? favorite = (await repository.get<Favorite>(
            query: brick.Query(where: [
      brick.Where('favIndex').isExactly(favIndex),
    ])))
        .firstOrNull;

    repository.delete(favorite!);
    return Future.value(200);
  }

  @override
  Future<void> deleteItemFromCart(
      {required TransactionItem transactionItemId,
      String? transactionId}) async {
    TransactionItem item = (await transactionItems(
            id: transactionItemId.id,
            transactionId: transactionId,
            branchId: ProxyService.box.getBranchId()!))
        .first;
    await repository.delete(item);
  }

  @override
  Future<int> deleteTransactionByIndex(
      {required String transactionIndex}) async {
    final transaction = await transactions(id: transactionIndex);
    repository.delete(transaction.first);
    return Future.value(200);
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
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final result = await repository.get<models.Ebm>(
        query: query,
        policy: fetchRemote == true
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
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
          serverId: iBusiness.id,
          name: iBusiness.name,
          userId: int.parse(iBusiness.userId),
          createdAt: DateTime.now());

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
  Future<List<Counter>> getCounters(
      {required int branchId, bool fetchRemote = false}) async {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<models.Counter>(
        query: query,
        policy: fetchRemote == true
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly);

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
          createItemCode: true,
          branchId: branchId,
          businessId: businessId,
          product: models.Product(
              lastTouched: DateTime.now(),
              name: CUSTOM_PRODUCT,
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now(),
              branchId: branchId));
    }

    /// for whatever reason if a product exist and there is no related variant please add it before we proceed.
    final variantQuery =
        brick.Query(where: [brick.Where('productId').isExactly(product!.id)]);
    final variantResult = await repository.get<models.Variant>(
        query: variantQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Variant? variant = variantResult.firstOrNull;

    return variant;
  }

  @override
  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id}) async {
    if (id != null) {
      return repository.get<Customer>(
          policy: OfflineFirstGetPolicy.localOnly,
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
                policy: OfflineFirstGetPolicy.localOnly,
                query: query,
              )));

      return results.expand((customers) => customers).toList();
    }

    // If only branchId is provided, return all customers for that branch
    return repository.get<Customer>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: brick.Query(where: [
          brick.Where('branchId',
              value: branchId, compare: brick.Compare.exact),
        ]));
  }

  @override
  Stream<List<Customer>> customersStream({
    required int branchId,
    String? key,
    String? id,
  }) async* {
    if (id != null) {
      // Yield results for a specific customer by ID
      yield* repository.subscribe<Customer>(
        query: brick.Query(
          where: [
            brick.Where('id', value: id, compare: brick.Compare.exact),
          ],
        ),
      );
      return;
    }

    if (key != null) {
      // Fetch customers matching the search key asynchronously
      final searchFields = ['custNm', 'email', 'telNo'];
      final queries = searchFields.map((field) => brick.Query(
            where: [
              brick.Where(field, value: key, compare: brick.Compare.contains),
              brick.Where('branchId',
                  value: branchId, compare: brick.Compare.exact),
            ],
          ));

      final results = await Future.wait(
        queries.map((query) => repository.get<Customer>(
              policy: OfflineFirstGetPolicy.localOnly,
              query: query,
            )),
      );

      // Yield combined results from all queries
      yield results.expand((customers) => customers).toList();
      return;
    }

    // Yield all customers for a specific branch if no other filters are applied
    yield* repository.subscribe<Customer>(
      query: brick.Query(
        where: [
          brick.Where('branchId',
              value: branchId, compare: brick.Compare.exact),
        ],
      ),
    );
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
  Future<String> getFirebaseToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "NONE";
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() async {
    final query = brick.Query(
      orderBy: [const OrderBy('createdAt', ascending: false)],
    );
    final List<FlipperSaleCompaign> fetchedCampaigns =
        await repository.get<FlipperSaleCompaign>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedCampaigns.firstOrNull;
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
              ownerName: localPin.firstOrNull!.ownerName ?? "N/A",
              tokenUid: localPin.firstOrNull!.tokenUid ?? "N/A");
        } else {
          clearData(data: ClearData.Branch, identifier: branchE!.serverId!);
          clearData(data: ClearData.Business, identifier: business!.serverId);
        }
      }
      final response = await flipperHttpClient.get(uri);

      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NeedSignUpException(term: "User does not exist needs signup.");
      } else {
        throw PinError(term: "Not found");
      }
    } catch (e) {
      rethrow;
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
      temporaryDate = transaction.createdAt!;
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

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
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
  Future<bool> hasActiveSubscription({
    required int businessId,
    required HttpClientInterface flipperHttpClient,
  }) async {
    if (isTestEnvironment()) return true;
    final models.Plan? plan = await getPaymentPlan(businessId: businessId);

    if (plan == null) {
      throw NoPaymentPlanFound(
          "No payment plan found for businessId: $businessId");
    }

    final isPaymentCompletedLocally = plan.paymentCompletedByUser ?? false;

    // Avoid unnecessary sync if payment is already marked as complete
    if (!isPaymentCompletedLocally) {
      final isPaymentComplete = await ProxyService.realmHttp.isPaymentComplete(
        flipperHttpClient: flipperHttpClient,
        businessId: businessId,
      );

      // Update the plan's state or handle syncing logic here if necessary
      if (!isPaymentComplete) {
        throw FailedPaymentException(PAYMENT_REACTIVATION_REQUIRED);
      }
    }

    return true;
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

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
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

    final bool shouldEnableOfflineLogin = businessesE.isNotEmpty &&
        branchesE.isNotEmpty &&
        !foundation.kDebugMode &&
        !(await ProxyService.status.isInternetAvailable());

    if (shouldEnableOfflineLogin) {
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
              userId: e.userId.toString(),
              timeZone: e.timeZone,
              country: e.country,
              businessUrl: e.businessUrl,
              hexColor: e.hexColor,
              imageUrl: e.imageUrl,
              type: e.type,
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
              isDefault: e.isDefault,
              businessTypeId: e.businessTypeId,
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

      /// Fetch transactions
      /// keey it local localOnly this is to avoid the status to change from remote and
      final List<ITransaction> transactions =
          await repository.get<ITransaction>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );

      // Return the first transaction (if any)
      return transactions.isNotEmpty ? transactions.last : null;
    } catch (e, s) {
      // Log errors (optional, replace talker with your preferred logger)
      talker.error('Error in _pendingTransaction: $e');
      talker.error('Stack trace: $s');
      return null;
    }
  }

  bool _isProcessingTransaction = false;
  final Lock _transactionLock = Lock();

  @override
  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async {
    return await _transactionLock.synchronized(() async {
      if (_isProcessingTransaction) return null; // Ensure return

      _isProcessingTransaction = true;
      try {
        final existTransaction = await _pendingTransaction(
          branchId: branchId,
          isExpense: isExpense,
          transactionType: transactionType,
          includeSubTotalCheck: includeSubTotalCheck,
        );

        if (existTransaction != null) return existTransaction;

        final now = DateTime.now();
        final randomRef = randomNumber().toString();

        final transaction = ITransaction(
          lastTouched: now,
          reference: randomRef,
          transactionNumber: randomRef,
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0.0,
          cashReceived: 0.0,
          updatedAt: now,
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: now,
        );

        await repository.upsert<ITransaction>(transaction);
        return transaction;
      } catch (e) {
        print('Error processing transaction: $e');
        rethrow;
      } finally {
        _isProcessingTransaction = false;
      }
    });
  }

  final Map<int, bool> _isProcessingTransactionMap = {};

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async* {
    _isProcessingTransactionMap[branchId] ??= false;

    // Check for an existing transaction
    ITransaction? transaction = await _pendingTransaction(
      branchId: branchId,
      isExpense: isExpense,
      transactionType: transactionType,
      includeSubTotalCheck: includeSubTotalCheck,
    );

    // If no transaction exists, create and insert a new one
    if (transaction == null && !_isProcessingTransactionMap[branchId]!) {
      _isProcessingTransactionMap[branchId] =
          true; // Lock processing for this branch

      transaction = ITransaction(
        lastTouched: DateTime.now(),
        reference: randomNumber().toString(),
        transactionNumber: randomNumber().toString(),
        status: PENDING,
        isExpense: isExpense,
        isIncome: !isExpense,
        transactionType: transactionType,
        subTotal: 0.0,
        cashReceived: 0.0,
        updatedAt: DateTime.now(),
        customerChangeDue: 0.0,
        paymentType: ProxyService.box.paymentType() ?? "Cash",
        branchId: branchId,
        createdAt: DateTime.now(),
      );

      await repository.upsert<ITransaction>(transaction);

      _isProcessingTransactionMap[branchId] =
          false; // Unlock processing for this branch
    }
    if (transaction != null) {
      yield transaction;
    }
    // Listen for changes in the transaction data
    while (true) {
      final updatedTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck,
      );

      if (updatedTransaction != null) {
        yield updatedTransaction;
      }

      // Add a delay to avoid busy-waiting
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction}) {
    transaction.customerId = null;
    repository.upsert(transaction);
  }

  @override
  Future<bool> removeS3File({required String fileName}) async {
    await syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");
    int branchId = ProxyService.box.getBranchId()!;
    try {
      final result = await amplify.Amplify.Storage
          .remove(
            path: amplify.StoragePath.fromString(
                'public/branch-$branchId/$fileName'),
          )
          .result;
      talker.warning('Removed file: ${result.removedItem.path}');
      return true; // Return true if the file is successfully removed
    } on amplify.StorageException catch (e) {
      talker.warning(e.message);
      return false; // Return false if an exception occurs during the removal process
    }
  }

  @override
  Stream<List<Report>> reports({required int branchId}) {
    return repository.subscribe(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  FutureOr<List<models.InventoryRequest>> requests(
      {int? branchId, String? requestId}) async {
    if (branchId != null) {
      return await repository.get<InventoryRequest>(
          query: brick.Query(where: [
        brick.Where('mainBranchId').isExactly(branchId),
        brick.Where('status').isExactly(RequestStatus.pending),
        brick.Or('status').isExactly(RequestStatus.partiallyApproved)
      ]));
    }
    if (requestId != null) {
      return await repository.get<InventoryRequest>(
          query: brick.Query(where: [
        brick.Where('id').isExactly(requestId),
      ]));
    }
    throw Exception("Invalid parameter");
  }

  @override
  Stream<List<InventoryRequest>> requestsStream(
      {required int branchId, String? filter}) {
    if (filter != null && filter == RequestStatus.approved) {
      final query = repository.subscribe<InventoryRequest>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: brick.Query(where: [
            brick.Where('mainBranchId').isExactly(branchId),
            brick.Where('status').isExactly(RequestStatus.approved),
          ]));

      return query
          .map((changes) => changes.toList())
          .debounceTime(Duration(milliseconds: 100));
    } else {
      final query = repository.subscribe<InventoryRequest>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: brick.Query(where: [
            brick.Where('mainBranchId').isExactly(branchId),
            brick.Where('status').isExactly(RequestStatus.pending),
            brick.Or('status').isExactly(RequestStatus.partiallyApproved),
          ]));

      return query
          .map((changes) => changes.toList())
          .debounceTime(Duration(milliseconds: 100));
    }
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
    try {
      final num = ProxyService.box.numberOfPayments() ?? numberOfPayments;
      // compute next billing date
      final nextBillingDate = isYearlyPlan
          ? DateTime.now().add(Duration(days: 365 * num))
          : DateTime.now().add(Duration(days: 30 * num));
      // Fetch existing plan and addons
      final existingPlanAddons = await _fetchExistingAddons(businessId);

      // Process new addons if provided
      final updatedAddons = await _processNewAddons(
        businessId: businessId,
        existingAddons: existingPlanAddons,
        newAddonNames: addons,
        isYearlyPlan: isYearlyPlan,
      );

      // Create or update the plan
      final updatedPlan = await _upsertPlan(
        businessId: businessId,
        selectedPlan: selectedPlan,
        numberOfPayments: numberOfPayments,
        additionalDevices: additionalDevices,
        isYearlyPlan: isYearlyPlan,
        totalPrice: totalPrice,
        // payStackUserId: payStackUserId,
        paymentMethod: paymentMethod,
        plan: plan,
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
    required int businessId,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required String paymentMethod,
    required List<models.PlanAddon> addons,
    required DateTime nextBillingDate,
    required int numberOfPayments,
    models.Plan? plan,
  }) async {
    final fPlan = plan ??
        models.Plan(
          businessId: businessId,
          selectedPlan: selectedPlan,
          additionalDevices: additionalDevices,
          isYearlyPlan: isYearlyPlan,
          rule: isYearlyPlan ? 'yearly' : 'monthly',
          totalPrice: totalPrice.toInt(),
          createdAt: DateTime.now(),
          numberOfPayments: numberOfPayments,
          nextBillingDate: nextBillingDate,
          paymentMethod: paymentMethod,
          addons: addons,
        );
    fPlan.paymentMethod = paymentMethod;
    fPlan.paymentCompletedByUser = false;
    fPlan.nextBillingDate = nextBillingDate;
    fPlan.numberOfPayments = numberOfPayments;
    fPlan.isYearlyPlan = isYearlyPlan;
    fPlan.isYearlyPlan = isYearlyPlan;
    fPlan.rule = isYearlyPlan ? 'yearly' : 'monthly';
    fPlan.totalPrice = totalPrice.toInt();
    await repository.upsert(
      fPlan,
      query: brick.Query(
        where: [brick.Where('businessId').isExactly(businessId)],
      ),
    );
    return fPlan;
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

// Helper method to save a variant
  Future<void> saveVariant(
      Variant item, Business business, int branchId) async {
    await createProduct(
      bhFId: (await ProxyService.box.bhfId()) ?? "00",
      tinNumber: business.tinNumber!,
      businessId: ProxyService.box.getBusinessId()!,
      branchId: branchId,
      totWt: item.totWt,
      netWt: item.netWt,
      itemCd: item.itemCd,
      spplrNm: item.spplrNm,
      agntNm: item.agntNm,
      invcFcurAmt: item.invcFcurAmt,
      invcFcurCd: item.invcFcurCd,
      invcFcurExcrt: item.invcFcurExcrt,
      exptNatCd: item.exptNatCd,
      pkg: item.pkg!,
      qty: item.qty ?? 1,
      qtyUnitCd: item.qtyUnitCd,
      pkgUnitCd: "BJ",
      createItemCode: item.itemCd?.isEmpty == true,
      dclNo: item.dclNo,
      taskCd: item.taskCd,
      dclDe: item.dclDe,
      orgnNatCd: item.orgnNatCd,
      hsCd: item.hsCd,
      imptItemsttsCd: item.imptItemSttsCd,
      product: Product(
        color: randomizeColor(),
        name: item.itemNm!,
        lastTouched: DateTime.now(),
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId()!,
        createdAt: DateTime.now(),
        spplrNm: item.spplrNm,
      ),
      supplyPrice: item.supplyPrice ?? 0,
      retailPrice: item.retailPrice ?? 0,
      itemSeq: item.itemSeq!,
      ebmSynced: true,
      spplrItemCd: item.hsCd,
      spplrItemClsCd: item.hsCd,
    );
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
    final responseBody = jsonDecode(response.body);
    talker.warning("sendLoginRequest:UserId:${responseBody['id']}");
    talker.warning("sendLoginRequest:token:${responseBody['token']}");
    ProxyService.box.writeInt(key: 'userId', value: responseBody['id']);
    ProxyService.box.writeString(key: 'userPhone', value: phoneNumber);
    await ProxyService.box
        .writeString(key: 'bearerToken', value: responseBody['token']);
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
        'tinNumber': business?.tinNumber,
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
  Future<List<ext.ITenant>> signup(
      {required Map business,
      required HttpClientInterface flipperHttpClient}) async {
    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/business"), body: jsonEncode(business));
    if (response.statusCode == 200) {
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      final userId = ProxyService.box.getUserId();
      IPin? pin = await ProxyService.strategy.getPin(
          pinString: userId.toString(), flipperHttpClient: ProxyService.http);

      ///save or update the pin, we might get the pin from remote then we need to update the local or create new one
      Pin? savedPin = await savePin(
          pin: Pin(
              userId: int.parse(pin!.userId),
              id: pin.userId,
              branchId: pin.branchId,
              businessId: pin.businessId,
              ownerName: pin.ownerName,
              tokenUid: pin.tokenUid,
              phoneNumber: pin.phoneNumber));
      await login(
          pin: savedPin!,
          userPhone: business['phoneNumber'],
          skipDefaultAppSetup: true,
          flipperHttpClient: flipperHttpClient);

      configureLocal(useInMemory: false, box: ProxyService.box);
      try {
        /// when signup, save the businessId on fly, this can be overriden later.
        ProxyService.box.writeInt(
            key: 'businessId',
            value: ITenant.fromJsonList(response.body).first.id!);
      } catch (e) {}
      return ITenant.fromJsonList(response.body);
    } else {
      talker.error(response.body.toString());
      throw InternalServerError(term: response.body.toString());
    }
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
              return;
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
                ProxyService.notification
                    .sendLocalNotification(body: "Item Saving " + separator[1]);
              }
              if (separator[2] == "stock") {
                final stockId = separator[3];
                Stock? stock = await getStockById(id: stockId);

                stock.ebmSynced = true;
                repository.upsert<Stock>(stock);

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
            nfcEnabled: jTenant.nfcEnabled ?? false,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(
              serverId: business.id,
              userId: int.parse(business.userId),
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
              active: false,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
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
  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool isExpense = false,
    bool includePending = false,
  }) async {
    final List<brick.Where> conditions = [
      brick.Where('status')
          .isExactly(status ?? COMPLETE), // Ensure default value
      if (!isExpense)
        brick.Where('subTotal').isGreaterThan(0), // Optional condition
      if (id != null) brick.Where('id').isExactly(id),
      if (branchId != null) brick.Where('branchId').isExactly(branchId),
      if (isCashOut) brick.Where('isCashOut').isExactly(true),
      if (isExpense) brick.Where('isExpense').isExactly(true),
      if (includePending) brick.Where('status').isExactly(PENDING),
      if (filterType != null)
        brick.Where('type').isExactly(filterType.toString()),
      if (transactionType != null)
        brick.Where('transactionType').isExactly(transactionType),
    ];

    if (startDate != null && endDate != null) {
      final endRange =
          startDate == endDate ? endDate.add(Duration(days: 1)) : endDate;
      conditions.add(
        brick.Where('lastTouched').isBetween(
          startDate.toIso8601String(),
          endRange.toUtc().toIso8601String(),
        ),
      );
    }

    final queryString = brick.Query(where: conditions);

    return await repository.get<ITransaction>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: queryString,
    );
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
      if (branchId != null) brick.Where('branchId').isExactly(branchId),
      if (isCashOut) brick.Where('isExpense').isExactly(true),
    ];
    // talker.warning(conditions.toString());
    if (startDate != null && endDate != null) {
      if (startDate == endDate) {
        // Ensure we include the entire day
        DateTime endOfDay = startDate.add(Duration(days: 1));

        conditions.add(
          brick.Where('lastTouched').isBetween(
            startDate.toUtc().toIso8601String(),
            endOfDay.toUtc().toIso8601String(),
          ),
        );
      } else {
        conditions.add(
          brick.Where('lastTouched').isBetween(
            startDate.toUtc().toIso8601String(),
            endDate.toUtc().toIso8601String(),
          ),
        );
      }
    }
    final queryString = brick.Query(where: conditions);
    // Directly return the stream from the repository
    return repository
        .subscribe<ITransaction>(
            query: queryString, policy: OfflineFirstGetPolicy.alwaysHydrate)
        .map((data) {
      print('Transaction stream data: ${data.length} records');
      return data;
    });
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
      policy: OfflineFirstGetPolicy.alwaysHydrate,
    );
  }

  @override
  void updateCounters(
      {required List<Counter> counters, RwApiResponse? receiptSignature}) {
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
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName,
      {required String transactionId}) async {
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
      // update thi transacton
      ITransaction? transaction =
          await _getTransaction(transactionId: transactionId);
      if (transaction != null) {
        transaction.receiptFileName = fileName + ".pdf";
        await repository.upsert(transaction);
      }
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
    ITransaction? transaction,
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
    if (transaction != null) {
      try {
        // Fetch transaction items
        List<TransactionItem> items = await transactionItems(
          branchId: branchId,
          transactionId: transaction.id,
        );
        double subTotalFinalized = cashReceived;
        if (isIncome) {
          // Update transaction details
          final double subTotal =
              items.fold(0, (num a, b) => a + (b.price * b.qty));
          subTotalFinalized = !isIncome ? cashReceived : subTotal;
          // Update stock and transaction items
          /// I intentionally removed await on _updateStockAndItems to speed up clearing cart.
          _updateStockAndItems(items: items, branchId: branchId);
        }
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
        transaction.status = COMPLETE;
        // TODO: if transactin has customerId use the customer.phone number instead.
        transaction.currentSaleCustomerPhoneNumber =
            "250" + (ProxyService.box.currentSaleCustomerPhoneNumber() ?? "");
        await repository.upsert(transaction);

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
    throw Exception("transaction is null");
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

    // Update transaction properties using the = operator
    transaction.status = COMPLETE;
    transaction.isIncome = isIncome;
    transaction.isExpense = !isIncome;
    transaction.customerChangeDue = (cashReceived - subTotalFinalized);
    transaction.paymentType = paymentType;
    transaction.cashReceived = cashReceived;
    transaction.subTotal = subTotalFinalized;
    transaction.receiptType =
        _determineReceiptType(isProformaMode, isTrainingMode);
    transaction.updatedAt = now;
    transaction.createdAt = now;
    transaction.transactionType = transactionType;
    transaction.lastTouched = now;

    // Optionally update categoryId if provided
    if (categoryId != null) {
      transaction.categoryId = categoryId;
    }
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
    try {
      final adjustmentTransaction = await _createAdjustmentTransaction();
      final business = await ProxyService.strategy.getBusiness();
      final serverUrl = await ProxyService.box.getServerUrl();

      if (business == null) {
        talker.warning('Business or Server URL is null, aborting update.');
        return; // Early exit if crucial data is missing
      }

      if (adjustmentTransaction == null) {
        talker.warning("Failed to create adjustment transaction. Aborting.");
        return;
      }
      if (serverUrl != null) {
        await _processTransactionItems(
          items: items,
          branchId: branchId,
          adjustmentTransaction: adjustmentTransaction,
          business: business,
          serverUrl: serverUrl,
        );

        // Assuming completeTransaction is defined in the same scope.
        await completeTransaction(pendingTransaction: adjustmentTransaction);
      }
    } catch (e, s) {
      talker.error(s);
      talker.warning(e);
    }
  }

  Future<ITransaction?> _createAdjustmentTransaction() async {
    try {
      return await ProxyService.strategy.manageTransaction(
        transactionType: TransactionType.adjustment,
        isExpense: true,
        branchId: ProxyService.box.getBranchId()!,
      );
    } catch (e, s) {
      talker.error(s);
      talker.warning(e);
      return null; // Handle transaction creation failure gracefully
    }
  }

  Future<void> _processTransactionItems({
    required List<TransactionItem> items,
    required int branchId,
    required ITransaction adjustmentTransaction,
    required Business business,
    required String serverUrl,
  }) async {
    for (TransactionItem item in items) {
      await _processSingleTransactionItem(
        item: item,
        branchId: branchId,
        adjustmentTransaction: adjustmentTransaction,
        business: business,
        serverUrl: serverUrl,
      );
    }
  }

  Future<void> _processSingleTransactionItem({
    required TransactionItem item,
    required int branchId,
    required ITransaction adjustmentTransaction,
    required Business business,
    required String serverUrl,
  }) async {
    if (!item.active!) {
      repository.delete(item);
      return;
    }
    String stockInOutType = ProxyService.box.stockInOutType();
    await _updateStockForItem(item: item, branchId: branchId);

    final variant = await ProxyService.strategy.getVariant(id: item.variantId);
    // Setting the quantity here, after the stock patch is crucial for accuracy.

    variant?.qty = item.qty;
    if (variant != null) {
      await _updateVariantAndPatchStock(
        variant: variant,
        item: item,
        serverUrl: serverUrl,
      );

      // Assuming assignTransaction and randomNumber are defined in the same scope.
      await assignTransaction(
        variant: variant,
        pendingTransaction: adjustmentTransaction,
        business: business,
        randomNumber: randomNumber(),

        /// this item we are passing is the item from existing transaction
        /// and since we are now using another type of transaction adjustment transaction
        /// then we pass the same item so we can use same qty.
        item: item,

        /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
        /// transaction i.e not original transaction
        useTransactionItemForQty: true,

        /// 11 is for sale
        sarTyCd: stockInOutType,
      );
    }

    item
      ..doneWithTransaction = true
      ..updatedAt = DateTime.now().toUtc().toLocal();
    repository.upsert<TransactionItem>(item);
  }

  Future<void> _updateVariantAndPatchStock({
    required Variant variant,
    required TransactionItem item,
    required String serverUrl,
  }) async {
    ProxyService.box.writeBool(key: 'lockPatching', value: true);
    variant.ebmSynced = false;
    await ProxyService.strategy.updateVariant(updatables: [variant]);

    VariantPatch.patchVariant(
      URI: serverUrl,
      identifier: variant.id,
      sendPort: (message) {
        ProxyService.notification.sendLocalNotification(body: message);
      },
    );
  }

  Future<void> _updateStockForItem({
    required TransactionItem item,
    required int branchId,
  }) async {
    try {
      final variant = await getVariant(id: item.variantId!);

      if (variant != null && variant.stock != null) {
        final currentStock = variant.stock?.currentStock ?? 0;
        final finalStock = currentStock - item.qty;
        final stockValue = finalStock * (variant.retailPrice ?? 0);

        // Update all stock-related fields
        variant.stock!.rsdQty = finalStock;
        variant.stock!.currentStock = finalStock;

        variant.stock!.value = stockValue;
        variant.stock!.ebmSynced = false;

        // Update stock in repository
        await repository.upsert<Stock>(variant.stock!);

        // Update transaction item flags
        item.active = true;
        item.doneWithTransaction = true;
        item.remainingStock = finalStock;
        item.updatedAt = DateTime.now().toUtc().toLocal();
        item.lastTouched = DateTime.now().toUtc().toLocal();
        repository.upsert<TransactionItem>(item);
      }
    } catch (e, s) {
      talker.error(s);
      talker.warning(e);
    }
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
    //     realm!.deleteAll<StockRequests>();
    //   });
    // }
    if (tableName == transactionItemsTable) {
      // await repository.sqliteProvider.;
    }
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

  /// Updates a transaction with the provided details.
  ///
  /// The [transaction] parameter is required and represents the transaction to update.
  /// The [isUnclassfied] parameter is used to mark the transaction as unclassified,
  /// meaning it is neither income nor expense. This helps avoid incorrect computations
  /// on the dashboard.
  @override
  FutureOr<void> updateTransaction({
    required ITransaction? transaction,
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
    DateTime? updatedAt,
    int? invoiceNumber,
    DateTime? lastTouched,
    int? supplierId,
    int? receiptNumber,
    int? totalReceiptNumber,
    bool? isProformaMode,

    /// because transaction is involved in account reporting
    /// and in other ways to facilitate that everything in flipper has attached transaction
    /// we want to make it unclassified i.e neither it is income or expense
    /// this help us having wrong computation on dashboard of what is income or expenses.
    bool isUnclassfied = false,
    bool? isTrainingMode,
  }) async {
    if (transaction == null) {
      print("Error: Transaction is null in updateTransaction.");
      return; // Exit if transaction is null.
    }

    // Determine receipt type based on mode (or use the provided value if available)
    if (isProformaMode != null || isTrainingMode != null) {
      String newReceiptType = TransactionReceptType.NS;
      if (isProformaMode == true) {
        newReceiptType = TransactionReceptType.PS;
      }
      if (isTrainingMode == true) {
        newReceiptType = TransactionReceptType.TS;
      }
      receiptType = newReceiptType; // Use the determined value for receiptType
    }

    // update to avoid the same issue, make sure that every parameter is update correctly.
    transaction.receiptType = receiptType ?? transaction.receiptType;
    transaction.subTotal = subTotal ?? transaction.subTotal;
    transaction.note = note ?? transaction.note;
    transaction.supplierId = supplierId ?? transaction.supplierId;
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
    transaction.isExpense = isUnclassfied ? null : transaction.isExpense;
    transaction.isIncome = isUnclassfied ? null : transaction.isIncome;

    await repository.upsert<ITransaction>(
        policy: OfflineFirstUpsertPolicy.optimisticLocal, transaction);
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
      item.quantityApproved =
          (item.quantityApproved ?? 0) + (quantityApproved ?? 0);
      item.quantityRequested = incrementQty == true
          ? (item.qty + 1).toInt()
          : qty?.toInt() ?? item.qty.toInt();
      item.splyAmt = splyAmt ?? item.splyAmt;
      item.quantityShipped = quantityShipped ?? item.quantityShipped;
      item.taxblAmt = taxblAmt ?? item.taxblAmt;
      item.totAmt = totAmt ?? item.totAmt;
      item.doneWithTransaction =
          doneWithTransaction ?? item.doneWithTransaction;
      repository.upsert(policy: OfflineFirstUpsertPolicy.optimisticLocal, item);
    }
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) async {
    variant.stock = stock;
    return await repository.upsert<Variant>(variant);
  }

  @override
  Future<DatabaseSyncInterface> configureCapella(
      {required bool useInMemory, required storage.LocalStorage box}) async {
    return this as DatabaseSyncInterface;
  }

  @override
  FutureOr<T?> create<T>({required T data}) async {
    try {
      if (data is Counter) {
        await repository.upsert<Counter>(data);
        return data as T;
      }

      if (data is PColor) {
        PColor color = data;
        for (String colorName in data.colors!) {
          await repository.upsert<PColor>(PColor(
              name: colorName, active: color.active, branchId: color.branchId));
        }
        return data as T;
      }

      if (data is Device) {
        await repository.upsert<Device>(data);
        return data as T;
      }

      if (data is Category) {
        await repository.upsert<Category>(data);
        return data as T;
      }

      if (data is Product) {
        await repository.upsert<Product>(data);
        return data as T;
      }

      if (data is Variant) {
        return (await repository.upsert<Variant>(data)) as T;
      }

      if (data is Favorite) {
        await repository.upsert<Favorite>(data);
        return data as T;
      }

      if (data is Stock) {
        await repository.upsert<Stock>(data);
        return data as T;
      }

      if (data is Token) {
        await repository.upsert<Token>(data);
        return data as T;
      }

      if (data is Setting) {
        await repository.upsert<Setting>(data);
        return data as T;
      }

      if (data is Ebm) {
        await repository.upsert<Ebm>(data);
        return data as T;
      }

      if (data is ITransaction) {
        await repository.upsert<ITransaction>(data);
        return data as T;
      }

      if (data is TransactionItem) {
        await repository.upsert<TransactionItem>(data);
        return data as T;
      }

      if (data is VariantBranch) {
        await repository.upsert<VariantBranch>(data);
        return data as T;
      }

      return null; // Still return null if none of the above conditions match
    } catch (e) {
      // Handle the error appropriately, e.g., log it
      print('Error in create: $e');
      return null; // Or rethrow the exception if appropriate
    }
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) async {
    return await repository.get<Configurations>(
        policy: OfflineFirstGetPolicy.localOnly,
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<models.TransactionItem?> getTransactionItem(
      {required String variantId, String? transactionId}) async {
    return (await repository.get<TransactionItem>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: brick.Query(where: [
              brick.Where('variantId',
                  value: variantId, compare: brick.Compare.exact),
              if (transactionId != null)
                brick.Where('transactionId',
                    value: transactionId, compare: brick.Compare.exact),
            ])))
        .firstOrNull;
  }

  Future<ITransaction?> _getTransaction({String? transactionId}) async {
    return (await repository.get<ITransaction>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: brick.Query(where: [
              if (transactionId != null)
                brick.Where('id',
                    value: transactionId, compare: brick.Compare.exact),
            ])))
        .firstOrNull;
  }

  @override
  Future<Variant?> getVariant(
      {String? id,
      String? modrId,
      String? name,
      String? itemCd,
      String? bcd,
      String? productId,
      String? taskCd,
      String? itemClsCd,
      String? itemNm,
      String? stockId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    final query = brick.Query(where: [
      if (productId != null)
        brick.Where('productId',
            value: productId, compare: brick.Compare.exact),
      if (id != null) brick.Where('id').isExactly(id),
      if (modrId != null) ...[
        brick.Where('modrId', value: modrId, compare: brick.Compare.exact),
        brick.Where('branchId').isExactly(branchId),
      ] else if (name != null) ...[
        brick.Where('name', value: name, compare: brick.Compare.exact),
        brick.Where('branchId').isExactly(branchId),
      ] else if (bcd != null) ...[
        brick.Where('bcd', value: bcd, compare: brick.Compare.exact),
        brick.Where('branchId').isExactly(branchId),
      ] else if (itemCd != null && itemClsCd != null && itemNm != null) ...[
        brick.Where('itemCd').isExactly(itemCd),
        brick.Where('itemClsCd').isExactly(itemClsCd),
        brick.Where('itemNm').isExactly(itemNm),
        brick.Where('branchId').isExactly(branchId),
      ] else if (taskCd != null) ...[
        brick.Where('taskCd').isExactly(taskCd),
        brick.Where('branchId').isExactly(branchId),
      ] else if (stockId != null) ...[
        brick.Where('stockId').isExactly(stockId),
      ]
    ]);
    return (await repository.get<Variant>(query: query)).firstOrNull;
  }

  @override
  DatabaseSyncInterface instance() {
    return this;
  }

  @override
  Future<bool> isTaxEnabled({required int businessId}) async {
    final business = (await getBusiness(businessId: businessId));
    return business?.tinNumber != null;
  }

  @override
  Future<void> saveEbm({
    required int branchId,
    required String severUrl,
    required String bhFId,
  }) async {
    final business =
        await getBusiness(businessId: ProxyService.box.getBusinessId()!);

    if (business == null) {
      throw Exception("Business not found");
    }

    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('bhfId').isExactly(bhFId),
    ]);

    final ebm = await repository.get<models.Ebm>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    final existingEbm = ebm.firstOrNull;

    final updatedEbm = existingEbm ??
        models.Ebm(
          bhfId: bhFId,
          tinNumber: business.tinNumber!,
          dvcSrlNo: business.dvcSrlNo ?? "vsdcyegoboxltd",
          userId: ProxyService.box.getUserId()!,
          taxServerUrl: severUrl,
          businessId: business.serverId,
          branchId: branchId,
        );

    if (existingEbm != null) {
      updatedEbm.taxServerUrl = severUrl;
    }

    await repository.upsert(updatedEbm);
  }

  @override
  FutureOr<void> savePaymentType({
    TransactionPaymentRecord? paymentRecord,
    String? transactionId,
    double amount = 0.0,
    String? paymentMethod,
    required bool singlePaymentOnly,
  }) async {
    // Input validation
    if (transactionId == null) {
      throw ArgumentError('transactionId cannot be null');
    }

    if (paymentMethod == null && paymentRecord == null) {
      throw ArgumentError(
          'Either paymentMethod or paymentRecord must be provided');
    }

    // 1. Delete records with amount 0
    final transactionPaymentRecordWithAmount0 = await repository
        .get<TransactionPaymentRecord>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: brick.Query(where: [
            brick.Where('transactionId').isExactly(transactionId),
            brick.Where('amount').isExactly(0.0),
          ]),
        )
        .then((records) => records.firstOrNull);

    if (transactionPaymentRecordWithAmount0 != null) {
      await repository.delete<TransactionPaymentRecord>(
        transactionPaymentRecordWithAmount0,
        query: brick.Query(action: QueryAction.delete),
      );
    }

    // 2. Handle single payment mode
    if (singlePaymentOnly) {
      final existingRecords = await repository.get<TransactionPaymentRecord>(
        query: brick.Query(where: [
          brick.Where('transactionId').isExactly(transactionId),
        ]),
      );

      await Future.wait(
        existingRecords
            .map((record) => repository.delete<TransactionPaymentRecord>(
                  record,
                  query: brick.Query(action: QueryAction.delete),
                )),
      );
    }

    // 3. Handle payment record update or creation
    if (paymentRecord != null) {
      await repository.upsert<TransactionPaymentRecord>(paymentRecord);
      return;
    }

    // 4. Handle payment method update or creation
    final existingPaymentRecord = await repository
        .get<TransactionPaymentRecord>(
          query: brick.Query(where: [
            brick.Where('transactionId').isExactly(transactionId),
            brick.Where('paymentMethod').isExactly(paymentMethod),
          ]),
        )
        .then((records) => records.firstOrNull);

    if (existingPaymentRecord != null) {
      existingPaymentRecord
        ..paymentMethod = paymentMethod
        ..amount = amount;

      await repository.upsert<TransactionPaymentRecord>(
        existingPaymentRecord,
        query: brick.Query(
            action: QueryAction.update), // Changed from insert to update
      );
    } else {
      final newPaymentRecord = TransactionPaymentRecord(
        createdAt: DateTime.now(),
        amount: amount,
        transactionId: transactionId,
        paymentMethod: paymentMethod,
      );

      await repository.upsert<TransactionPaymentRecord>(
        newPaymentRecord,
        query: brick.Query(action: QueryAction.insert),
      );
    }
  }

  @override
  FutureOr<Stock> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
      required double currentStock,
      required double value}) async {
    final stock = Stock(
      id: const Uuid().v4(),
      lastTouched: DateTime.now(),
      branchId: branchId,
      currentStock: currentStock,
      rsdQty: rsdQty,
      value: value,
    );
    return await repository.upsert<Stock>(stock);
  }

  @override
  FutureOr<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    bool appending = false,
    DateTime? lastTouched,
  }) async {
    Stock? stock = await getStockById(id: stockId);
    Variant? variant = await getVariant(stockId: stock.id);

    // If appending, add to existing values; otherwise, replace.
    if (currentStock != null) {
      stock.currentStock =
          appending ? (stock.currentStock ?? 0) + currentStock : currentStock;
    }
    if (rsdQty != null) {
      stock.rsdQty = appending ? (stock.rsdQty ?? 0) + rsdQty : rsdQty;
    }
    if (initialStock != null) {
      stock.initialStock =
          appending ? (stock.initialStock ?? 0) + initialStock : initialStock;
    }
    if (value != null) {
      stock.value = appending ? (variant!.retailPrice! * currentStock!) : value;
    }

    // These fields should always be replaced, not appended
    if (ebmSynced != null) {
      stock.ebmSynced = ebmSynced;
    }
    if (lastTouched != null) {
      stock.lastTouched = lastTouched;
    }

    await repository.upsert(stock);
  }

  @override
  Future<void> addBusiness(
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
      required String encryptionKey}) async {
    Business? exist =
        await ProxyService.strategy.getBusiness(businessId: serverId);

    if (exist != null) {
      exist.tinNumber = tinNumber;

      repository.upsert<Business>(exist);

      Business? dd =
          await ProxyService.strategy.getBusiness(businessId: serverId);

      talker.warning("tin number:${dd?.tinNumber ?? ""}");
    } else {
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
        tinNumber: tinNumber,
        metadata: metadata,
        role: role,
        userId: userId,
        lastSeen: lastSeen,
        firstName: firstName,
        lastName: lastName,
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
      policy: OfflineFirstGetPolicy.alwaysHydrate,
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
    if (flipperHttpClient == null) {
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
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/branch/${userOwnerPhoneNumber}'),
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "businessId": businessId,
        "location": location
      }),
    );
    if (response.statusCode == 201) {
      IBranch remoteBranch = IBranch.fromJson(json.decode(response.body));
      return await repository.upsert<Branch>(Branch(
        serverId: remoteBranch.id,
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
    throw Exception('Failed to create branch');
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    int? branchId,
    DateTime? startDate,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
  }) {
    // Create a list of conditions for better readability and debugging
    final List<brick.Where> conditions = [
      // Always include branchId since it's required
      if (branchId != null) brick.Where('branchId').isExactly(branchId),

      // Optional conditions
      if (transactionId != null)
        brick.Where('transactionId').isExactly(transactionId),
      if (requestId != null)
        brick.Where('inventoryRequestId').isExactly(requestId),

      // Date range handling
      if (startDate != null && endDate != null)
        if (startDate == endDate)
          brick.Where('createdAt').isBetween(
            startDate.toIso8601String(),
            startDate.add(const Duration(days: 1)).toIso8601String(),
          )
        else
          brick.Where('createdAt').isBetween(
            startDate.toIso8601String(),
            endDate.toIso8601String(),
          ),

      if (doneWithTransaction != null)
        brick.Where('doneWithTransaction').isExactly(doneWithTransaction),
      if (active != null) brick.Where('active').isExactly(active),
    ];

    // Add logging to help debug the query
    // print('TransactionItems query conditions: $conditions');

    final queryString = brick.Query(where: conditions);

    // Return the stream directly from repository with mapping
    return repository.subscribe<TransactionItem>(
      query: queryString,
      policy: fetchRemote == true
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
    );
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    int? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
  }) async {
    final items = await repository.get<TransactionItem>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : OfflineFirstGetPolicy.localOnly,
        query: brick.Query(where: [
          if (transactionId != null)
            brick.Where('transactionId').isExactly(transactionId),
          if (branchId != null) brick.Where('branchId').isExactly(branchId),
          if (id != null) brick.Where('id').isExactly(id),
          if (doneWithTransaction != null)
            brick.Where('doneWithTransaction').isExactly(doneWithTransaction),
          if (active != null) brick.Where('active').isExactly(active),
          if (variantId != null) brick.Where('variantId').isExactly(active),
          if (requestId != null)
            brick.Where('inventoryRequestId').isExactly(requestId),
        ]));
    return items;
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
      Business businessUpdate = business.first;
      businessUpdate.isDefault = isDefault;
      businessUpdate.active = active;
      businessUpdate.backupFileId = backupFileId;

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
      Branch branchUpdate = branch.first;
      branchUpdate.active = active;
      branchUpdate.isDefault = isDefault;

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
      DateTime? expirationDate,
      bool? ebmSynced}) async {
    if (variantId != null) {
      Variant? variant = await getVariant(id: variantId);
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
      final name = (productName ?? updatables[i].productName)!;
      updatables[i].productName = name;
      if (updatables[i].stock == null) {
        await addStockToVariant(variant: updatables[i]);
      }

      updatables[i].name = name;
      updatables[i].itemStdNm = name;
      updatables[i].spplrItemNm = name;
      double rate = rates?[updatables[i].id] == null
          ? 0
          : double.parse(rates![updatables[i].id]!);
      if (color != null) {
        updatables[i].color = color;
      }
      updatables[i].bhfId = updatables[i].bhfId ?? "00";
      updatables[i].itemNm = name;
      updatables[i].expirationDate = expirationDate;

      updatables[i].ebmSynced = false;
      updatables[i].retailPrice =
          newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
      if (selectedProductType != null) {
        updatables[i].itemTyCd = selectedProductType;
      }

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

      updatables[i].lastTouched = DateTime.now().toLocal();

      await repository.upsert<Variant>(updatables[i]);
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
  Future<DatabaseSyncInterface> configureLocal(
      {required bool useInMemory, required storage.LocalStorage box}) async {
    try {
      // await loadSupabase();
      return this;
    } catch (e) {
      return this;
    }
  }

  @override
  Future<models.Product?> getProduct(
      {String? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) async {
    return (await repository.get<Product>(
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
            query: brick.Query(where: [
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
      required int branchId,
      required String quantityUnit}) async {
    final repository = Repository();
    final Query = brick.Query(
      where: [
        brick.Where('code').isNot(null),
        brick.Where('branchId').isExactly(branchId),
      ],
      orderBy: [brick.OrderBy('createdAt', ascending: false)],
    );
    final items = await repository.get<ItemCode>(
        query: Query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    // Extract the last sequence number and increment it
    int lastSequence = 0;
    if (items.isNotEmpty) {
      final lastItemCode = items.first.code;
      final sequencePart = lastItemCode.substring(lastItemCode.length - 7);
      try {
        lastSequence = int.parse(sequencePart);
      } catch (e) {
        lastSequence = 0;
      }
    }
    final newSequence = (lastSequence + 1).toString().padLeft(7, '0');
    // Construct the new item code
    final newItemCode =
        '$countryCode$productType$packagingUnit$quantityUnit$newSequence';

    // Save the new item code in the database
    final newItem = ItemCode(
        code: newItemCode, createdAt: DateTime.now(), branchId: branchId);
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
    int lastSequence = skus.isEmpty ? 0 : skus.last.sku ?? 0;
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
          policy: OfflineFirstGetPolicy.localOnly,
        )
        .map((skus) => skus.isNotEmpty ? skus.first : null);
  }

  @override
  Future<Variant> createVariant(
      {required String barCode,
      required int sku,
      required String productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name,
      models.Configurations? taxType}) async {
    return await _createRegularVariant(
      branchId,
      tinNumber,
      qty: qty,
      supplierPrice: supplierPrice,
      retailPrice: retailPrice,
      itemSeq: itemSeq,
      name: name,
      sku: sku,
      taxType: taxType,
      ebmSynced: false,
      productId: productId,
      taxTypes: taxTypes,
      itemClasses: itemClasses,
      itemTypes: itemTypes,
    );
  }

  @override
  Future<void> updateStockRequest(
      {required String stockRequestId,
      DateTime? updatedAt,
      String? status}) async {
    final stockRequest = (await repository.get<InventoryRequest>(
      query: brick.Query(where: [
        brick.Where('id').isExactly(stockRequestId),
      ]),
    ))
        .firstOrNull;
    if (stockRequest != null) {
      stockRequest.updatedAt = updatedAt ?? stockRequest.updatedAt;
      stockRequest.status = status ?? stockRequest.status;
      repository.upsert<InventoryRequest>(stockRequest);
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
      active: false,
    );
    await repository.upsert<Stock>(newStock);
  }

  @override
  FutureOr<void> addTransaction({required models.ITransaction transaction}) {
    repository.upsert(transaction);
  }

  @override
  Future<int> addFavorite({required models.Favorite data}) async {
    try {
      Favorite? fav = (await repository.get<Favorite>(
              query: brick.Query(
                  where: [brick.Where('favIndex').isExactly(data.favIndex)])))
          .firstOrNull;

      if (fav == null) {
        await repository.upsert(data);

        return 200;
      } else {
        fav.productId = data.productId;
        repository.upsert(fav);
        return 200;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  @override
  Future<bool> bindProduct(
      {required String productId, required String tenantId}) async {
    try {
      final product = await getProduct(
          id: productId,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!);

      if (product == null) {
        return false;
      }

      product.nfcEnabled = true;
      product.bindedToTenantId = tenantId;

      repository.upsert(product);

      return true;
    } catch (error) {
      // Handle error during binding process
      return false;
    }
  }

  @override
  Future<String> createStockRequest(List<models.TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required ITransaction transaction,
      required FinanceProvider financeOption,
      required int mainBranchId}) async {
    try {
      final financing = Financing(
        requested: true,
        financeProviderId: financeOption.id,
        provider: financeOption,
        status: RequestStatus.pending,
        amount: transaction.subTotal!,
        approvalDate: DateTime.now(),
      );
      await repository.upsert(financing);
      Branch branch = await activeBranch();
      String orderId = const Uuid().v4();
      final stockRequest = InventoryRequest(
        id: orderId,
        itemCounts: items.length,
        deliveryDate: deliveryDate,
        deliveryNote: deliveryNote,
        mainBranchId: mainBranchId,
        branch: branch,

        // transactionItems: items,
        branchId: branch.id,
        subBranchId: ProxyService.box.getBranchId(),
        status: RequestStatus.pending,
        updatedAt: DateTime.now().toUtc().toLocal(),
        createdAt: DateTime.now().toUtc().toLocal(),
        financing: financing,
        financingId: financing.id,
      );
      InventoryRequest request = await repository.upsert(stockRequest);
      for (TransactionItem item in items) {
        item.inventoryRequest = request;
        await repository.upsert(item);
      }
      return orderId;
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  conversations({int? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  Future<List<models.Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<models.Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

//TODO: check if we are setting modrId same as barcode in other places
  @override
  Future<void> processItem({
    required Variant item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  }) async {
    try {
      if (item.bcdU != null && item.bcdU!.isNotEmpty) {
        print('Searching for variant with modrId: ${item.barCode}');

        Variant? variant = await getVariant(bcd: item.barCode);
        print('Found variant: ${variant?.bcd}, ${variant?.name}');
        if (variant != null) {
          variant.bcd = item.bcdU!.endsWith('.0')
              ? item.bcdU!.substring(0, item.bcdU!.length - 2)
              : item.bcdU;
          variant.name = item.name;
          Stock? stock = await getStockById(id: variant.stock!.id);
          stock.currentStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.rsdQty = double.parse(quantitis[item.barCode] ?? "0");
          stock.initialStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.value = stock.currentStock! * variant.retailPrice!;
          //upsert
          await await repository.upsert(stock);
          await repository.upsert(variant);

          print('Updated variant bcd: ${variant.bcd}, name: ${variant.name}');
        } else {
          print('no variant found with modrId:${item.barCode}');
          throw Exception('no variant found with modrId:${item.barCode}');
        }
      } else {
        final branchId = await ProxyService.box.getBranchId()!;
        final businessId = await ProxyService.box.getBusinessId()!;
        // TO DO: fix this when sql is fixed.
        final bhfId = await ProxyService.box.bhfId();

        Business? business = await getBusiness(businessId: businessId);

        talker.warning("ItemClass${itemClasses[item.barCode] ?? "5020230602"}");
        // is this exist using name
        Variant? variant = await getVariant(name: item.name);
        if (variant != null && item.bcdU != null) {
          variant.bcd = item.bcdU;
          variant.name = item.name;
          variant.color = randomizeColor();
          variant.lastTouched = DateTime.now();
          //get stock
          Stock? stock = await getStockById(id: variant.stock!.id);
          stock.currentStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.rsdQty = double.parse(quantitis[item.barCode] ?? "0");
          stock.initialStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.value = stock.currentStock! * variant.retailPrice!;
          //upsert
          await repository.upsert(stock);
          await repository.upsert(variant);
          //
        } else {
          await createProduct(
            bhFId: bhfId ?? "00",
            tinNumber: business?.tinNumber ?? 111111,
            businessId: ProxyService.box.getBusinessId()!,
            branchId: ProxyService.box.getBranchId()!,
            totWt: item.totWt,
            createItemCode: true,
            netWt: item.netWt,
            spplrNm: item.spplrNm,
            agntNm: item.agntNm,
            invcFcurAmt: item.invcFcurAmt,
            invcFcurCd: item.invcFcurCd,
            invcFcurExcrt: item.invcFcurExcrt,
            exptNatCd: item.exptNatCd,
            pkg: item.pkg ?? 1,
            qty: double.parse(quantitis[item.barCode] ?? "1"),
            qtyUnitCd: item.qtyUnitCd,
            pkgUnitCd: "BJ",
            dclNo: item.dclNo,
            taskCd: item.taskCd,
            dclDe: item.dclDe,
            orgnNatCd: item.orgnNatCd,
            hsCd: item.hsCd,
            imptItemsttsCd: item.imptItemSttsCd,
            taxTypes: taxTypes,
            itemClasses: itemClasses,
            itemTypes: itemTypes,
            // barCode: item.barCode,
            product: Product(
              color: randomizeColor(),
              name: item.itemNm ?? item.name,
              lastTouched: DateTime.now(),
              branchId: branchId,
              businessId: businessId,
              createdAt: DateTime.now(),
              spplrNm: item.spplrNm,
              barCode: item.barCode,
            ),
            supplyPrice: item.supplyPrice ?? 0,
            retailPrice: item.retailPrice ?? 0,
            itemSeq: item.itemSeq ?? 1,
            ebmSynced: false,
            spplrItemCd: item.hsCd,
            spplrItemClsCd: item.hsCd,
          );
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  String randomizeColor() {
    return '#${(Random().nextInt(0x1000000) | 0x800000).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<void> initCollections() {
    // TODO: implement initCollections
    throw UnimplementedError();
  }

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  Future<ext.SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  Future<models.ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) {
    // TODO: implement manageCashInOutTransaction
    throw UnimplementedError();
  }

  @override
  void notify({required models.AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  models.Drawers? openDrawer({required models.Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required models.Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  FutureOr<List<models.LPermission>> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  Stream<List<models.Product>> productStreams({String? prodIndex}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Future<List<models.Product>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<models.Product>> productsFuture({required int branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  void reDownloadAsset() {
    // TODO: implement reDownloadAsset
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  models.Report report({required int id}) {
    // TODO: implement report
    throw UnimplementedError();
  }

  @override
  void saveComposite({required models.Composite composite}) {
    // TODO: implement saveComposite
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<models.Configurations> saveTax(
      {required String configId, required double taxPercentage}) {
    // TODO: implement saveTax
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport(
      {required List<models.TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Future<void> startReplicator() async {}

  @override
  Future<({String customerCode, String url, int userId})> subscribe(
      {required int businessId,
      required models.Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAcess(
      {required int userId,
      String? featureName,
      String? status,
      String? accessLevel,
      String? userType}) {
    // TODO: implement updateAcess
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAsset({required String assetId, String? assetName}) {
    // TODO: implement updateAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active}) {
    // TODO: implement updateColor
    throw UnimplementedError();
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
      DateTime? openingDateTime,
      double? closingBalance,
      bool? open}) {
    // TODO: implement updateDrawer
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateNotification(
      {required String notificationId, bool? completed}) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }

  @override
  Future<void> updatePin(
      {required int userId, String? phoneNumber, String? tokenUid}) async {
    List<Pin> pin = await repository.get<Pin>(
        query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));
    if (pin.isNotEmpty) {
      Pin myPin = pin.first;
      myPin.phoneNumber = phoneNumber;
      myPin.tokenUid = tokenUid;
      repository.upsert(myPin);
    }
  }

  @override
  FutureOr<void> updateReport({required String reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateUnit(
      {required String unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }

  Future<Stock> getStockById({required String id}) async {
    return (await repository.get<Stock>(
            query: brick.Query(where: [brick.Where('id').isExactly(id)])))
        .first;
  }

  @override
  Future<bool> isBranchEnableForPayment(
      {required String currentBranchId}) async {
    final payment_status = await repository.get<BranchPaymentIntegration>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(where: [
          brick.Where('branchId').isExactly(currentBranchId),
          brick.Where('isEnabled').isExactly(true),
        ]));
    return payment_status.isNotEmpty;
  }

  @override
  Future<void> setBranchPaymentStatus(
      {required String currentBranchId, required bool status}) async {
    final payment_status = (await repository.get<BranchPaymentIntegration>(
            policy: OfflineFirstGetPolicy.alwaysHydrate,
            query: brick.Query(where: [
              brick.Where('branchId').isExactly(currentBranchId),
            ])))
        .firstOrNull;
    if (payment_status != null) {
      payment_status.isEnabled = status;
      await repository.upsert<BranchPaymentIntegration>(payment_status);
    }
  }

  @override
  Future<void> deletePaymentById(String id) {
    // TODO: implement deletePaymentById
    throw UnimplementedError();
  }

  @override
  Future<List<models.CustomerPayments>> getAllPayments() {
    // TODO: implement getAllPayments
    throw UnimplementedError();
  }

  @override
  Future<models.CustomerPayments?> getPaymentById(String id) {
    // TODO: implement getPaymentById
    throw UnimplementedError();
  }

  @override
  Future<models.CustomerPayments> upsertPayment(
      models.CustomerPayments payment) async {
    return await repository.upsert<CustomerPayments>(payment);
  }

  @override
  Future<List<Country>> countries() async {
    return await repository.get<Country>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      String? modrId,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? qtyUnitCd,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      double? invcFcurExcrt,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? imptItemsttsCd,
      String? spplrItemClsCd,
      String? spplrItemCd,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      required bool createItemCode,
      bool ebmSynced = false,
      String? saleListId,
      Purchase? purchase,
      String? pchsSttsCd,
      double? totAmt,
      double? taxAmt,
      double? taxblAmt,
      String? itemCd}) async {
    try {
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
      final createdProduct = await repository.upsert<Product>(product);

      if (!skipRegularVariant) {
        Variant newVariant = await _createRegularVariant(
          branchId,
          tinNumber,
          orgnNatCd: orgnNatCd,
          exptNatCd: exptNatCd,
          pchsSttsCd: pchsSttsCd,
          pkg: pkg,
          taxblAmt: taxblAmt,
          taxAmt: taxAmt,
          totAmt: totAmt,
          itemCd: itemCd,
          createItemCode: createItemCode,
          taxTypes: taxTypes,
          saleListId: saleListId,
          itemClasses: itemClasses,
          itemTypes: itemTypes,
          pkgUnitCd: pkgUnitCd,
          qtyUnitCd: qtyUnitCd,
          totWt: totWt,
          netWt: netWt,
          spplrNm: spplrNm,
          agntNm: agntNm,
          invcFcurAmt: invcFcurAmt,
          invcFcurExcrt: invcFcurExcrt,
          invcFcurCd: invcFcurCd,
          qty: qty,
          dclNo: dclNo,
          taskCd: taskCd,
          dclDe: dclDe,
          hsCd: hsCd,
          imptItemsttsCd: imptItemsttsCd,
          product: createdProduct,
          bhFId: bhFId,
          supplierPrice: supplyPrice,
          retailPrice: retailPrice,
          name: createdProduct.name,
          sku: sku.sku!,
          productId: product.id,
          itemSeq: itemSeq,
          bcd: product.barCode,
          ebmSynced: ebmSynced,
          spplrItemCd: spplrItemCd,
          spplrItemClsCd: spplrItemClsCd,
        );
        talker.info('New variant created: ${newVariant.toJson()}');
        final Stock stock = Stock(
            lastTouched: DateTime.now(),
            rsdQty: qty,
            initialStock: qty,
            value: (qty * newVariant.retailPrice!).toDouble(),
            branchId: branchId,
            currentStock: qty);
        final createdStock = await repository.upsert<Stock>(stock);
        newVariant.stock = createdStock;
        newVariant.stockId = createdStock.id;

        /// if this was associated with purchase, look for the variant created then associate it with the purchase
        /// purchase can have a list of variants associated with it.
        if (purchase != null) {
          Purchase purch = await repository.upsert<Purchase>(purchase);
          newVariant.purchaseId = purch.id;
          newVariant.spplrNm = purch.spplrNm;
          await repository.upsert<Variant>(newVariant);
        } else {
          await repository.upsert<Variant>(newVariant);
        }
      }

      return createdProduct;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> fetchCost(int branchId) async {
    double totalCost = 0.0;

    // Fetch all variants for the given branch
    final variants = await repository.get<Variant>(
      query: brick.Query(where: [
        brick.Where('branchId').isExactly(branchId),
      ]),
    );

    // Calculate cost for each variant
    for (final variant in variants) {
      if (variant.supplyPrice != null && variant.qty != null) {
        totalCost += variant.supplyPrice! * variant.qty!;
      }
    }

    return totalCost;
  }

  @override
  Future<double> fetchProfit(int branchId) async {
    double totalProfit = 0.0;

    // Fetch all variants for the given branch
    final variants = await repository.get<Variant>(
      query: brick.Query(where: [
        brick.Where('branchId').isExactly(branchId),
      ]),
    );

    // Calculate profit for each variant
    for (final variant in variants) {
      if (variant.retailPrice != null &&
          variant.supplyPrice != null &&
          variant.qty != null) {
        final revenue = variant.retailPrice! * variant.qty!;
        final cost = variant.supplyPrice! * variant.qty!;
        totalProfit += (revenue - cost);
      }
    }

    // Fetch all transaction items for the given branch
    final transactionItems = await repository.get<TransactionItem>(
      query: brick.Query(where: [
        brick.Where('branchId').isExactly(branchId),
      ]),
    );

    // Calculate profit for each transaction item
    for (final item in transactionItems) {
      // Fetch the associated variant to get the supply price
      final variant = (await repository.get<Variant>(
        query: brick.Query(where: [
          brick.Where('id').isExactly(item.variantId!),
        ]),
      ))
          .first;

      if (variant.supplyPrice != null) {
        final revenue = item.price * item.qty;
        final cost = variant.supplyPrice! * item.qty;
        totalProfit += (revenue - cost);
      }
    }

    return totalProfit;
  }

  @override
  Stream<double> wholeStockValue({required int branchId}) {
    return repository
        .subscribe<Stock>(
            query: brick.Query(
                where: [brick.Where('branchId').isExactly(branchId)]))
        .map(
            (changes) => changes.fold(0.0, (sum, stock) => sum + stock.value!));
  }

  @override
  Stream<double> totalSales({required int branchId}) async* {
    // Fetch all stock records for the given branch
    final stocks = await repository.get<Stock>(
      query: brick.Query(where: [
        brick.Where('branchId').isExactly(branchId), // Filter by branchId
      ]),
    );

    // Initialize total revenue to 0.0
    double totalRevenue = 0.0;

    // Iterate through each stock record
    for (final stock in stocks) {
      // Check if initialStock and currentStock are not null
      if (stock.initialStock != null && stock.currentStock != null) {
        // Calculate the quantity of stock sold for this stock item
        final soldQuantity = stock.initialStock! - stock.currentStock!;

        // Fetch all variants associated with this stock item
        final variants = await repository.get<Variant>(
          query: brick.Query(where: [
            brick.Where('stockId').isExactly(stock.id), // Filter by stockId
          ]),
        );

        // Iterate through each variant to calculate revenue
        for (final variant in variants) {
          // Check if retailPrice (selling price) is not null
          if (variant.retailPrice != null) {
            // Calculate revenue for this variant: soldQuantity * retailPrice
            totalRevenue += soldQuantity * variant.retailPrice!;
          }
        }
      }
    }

    // Yield the total sales revenue as a stream value
    yield totalRevenue;
  }

  @override
  Future<List<BusinessAnalytic>> analytics({required int branchId}) async {
    try {
      final data = await repository.get<BusinessAnalytic>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: brick.Query(
              where: [brick.Where('branchId').isExactly(branchId)]));
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<models.Stock>> stocks({required int branchId}) async {
    return await repository.get<Stock>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<void> deleteFailedQueue() async {
    await repository.deleteUnprocessedRequests();
  }

  @override
  Future<int> queueLength() async {
    return await repository.availableQueue();
  }

  @override
  Future<List<models.FinanceProvider>> financeProviders() async {
    return await repository.get<FinanceProvider>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
    );
  }

  @override
  Future<models.VariantBranch?> variantBranch(
      {required String variantId, required String destinationBranchId}) async {
    return (await repository.get<VariantBranch>(
      query: brick.Query(where: [
        brick.Where('destinationBranchId').isExactly(destinationBranchId),
        brick.Where('variantId').isExactly(variantId),
      ]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    ))
        .firstOrNull;
  }

  @override
  Future<BusinessInfo> initializeEbm({
    required String tin,
    required String bhfId,
    required String dvcSrlNo,
  }) async {
    final URI = await ProxyService.box.getServerUrl();

    if (foundation.kDebugMode) {
      // Mock response in debug mode
      print("Running in debug mode - using mock data");
      // Simulate a delay to mimic a network request
      await Future.delayed(Duration(seconds: 1));

      // Create a BusinessInfo object directly from the mock data

      return BusinessInfoResponse.fromJson(ebmInitializationMockData).data.info;
    } else {
      // Call the API in release mode
      final initialisable = await ProxyService.tax
          .initApi(tinNumber: tin, bhfId: bhfId, dvcSrlNo: dvcSrlNo, URI: URI!);
      return initialisable;
    }
  }

  @override
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    return repository.get<Message>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [
          Where('conversationId').isExactly(conversationId),
          if (startDate != null)
            Where('timestamp').isGreaterThanOrEqualTo(startDate),
          if (endDate != null) Where('timestamp').isLessThanOrEqualTo(endDate),
        ],
        limit: limit,
        offset: offset,
        orderBy: [OrderBy('timestamp', ascending: false)],
      ),
    );
  }

  @override
  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  }) async {
    final message = Message(
      text: text,
      phoneNumber: phoneNumber,
      branchId: branchId,
      delivered: true,
      role: role,
      conversationId: conversationId,
      timestamp: DateTime.now(),
      aiResponse: aiResponse,
      aiContext: aiContext,
    );
    await repository.upsert<Message>(message);
    return message;
  }

  Stream<List<Message>> conversationStream({required String conversationId}) {
    return repository.subscribe<Message>(
      query: Query(
        where: [Where('conversationId').isExactly(conversationId)],
        orderBy: [OrderBy('timestamp', ascending: false)],
      ),
    );
  }
}
