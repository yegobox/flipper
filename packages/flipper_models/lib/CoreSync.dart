import 'dart:convert';
import 'dart:math';
import 'dart:isolate';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/mixins/asset_mixin.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/mixins/business_mixin.dart';

import 'package:flipper_models/sync/mixins/category_mixin.dart';
import 'package:flipper_models/sync/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/mixins/delete_mixin.dart';
import 'package:flipper_models/sync/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/mixins/product_mixin.dart';

import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_mixin.dart';
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
import 'package:supabase_models/brick/repository/storage.dart' as storage;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'dart:typed_data';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/constants.dart';
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
        TransactionMixinOld,
        BranchMixin,
        PurchaseMixin,
        AuthMixin,
        FlipperHttpClient,
        TransactionMixin,
        BusinessMixin,
        TransactionItemMixin,
        TenantMixin,
        ProductMixin,
        AssetMixin,
        DeleteMixin,
        VariantMixin,
        CustomerMixin,
        EbmMixin,
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
              lastTouched: DateTime.now().toUtc(),
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
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
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
      lastTouched: DateTime.now().toUtc(),
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
      required String timeReceivedFromserver,
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
        timeReceivedFromserver: timeReceivedFromserver.toCompactDateTime(),
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
            branchId: (await ProxyService.strategy.activeBranch()).id))
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
      {required int branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    final repository = brick.Repository();
    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('receiptType').isExactly(receiptType),
    ]);
    final counter = await repository.get<models.Counter>(
        query: query,
        policy: fetchRemote == true
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly);
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
              lastTouched: DateTime.now().toUtc(),
              name: CUSTOM_PRODUCT,
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toUtc(),
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
              id: localPin.firstOrNull?.id,
              pin: localPin.firstOrNull?.pin ?? int.parse(pinString),
              userId: localPin.firstOrNull!.userId!.toString(),
              phoneNumber: localPin.firstOrNull!.phoneNumber!,
              branchId: localPin.firstOrNull!.branchId!,
              businessId: localPin.firstOrNull!.businessId!,
              ownerName: localPin.firstOrNull!.ownerName ?? "N/A",
              tokenUid: localPin.firstOrNull!.tokenUid ?? "N/A");
        } else {
          clearData(data: ClearData.Branch, identifier: branchE?.serverId ?? 0);
          clearData(
              data: ClearData.Business, identifier: business?.serverId ?? 0);
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
  Future<models.Plan?> getPaymentPlan({
    required int businessId,
    bool fetchRemote = false,
  }) async {
    try {
      final repository = brick.Repository();

      final query = brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
      ]);
      final result = await repository.get<models.Plan>(
          query: query,
          policy: fetchRemote
              ? OfflineFirstGetPolicy.alwaysHydrate
              : OfflineFirstGetPolicy.localOnly);
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
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
        createdAt: DateTime.now().toUtc(),
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
          createdAt: DateTime.now().toUtc(),
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
        lastTouched: DateTime.now().toUtc(),
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId()!,
        createdAt: DateTime.now().toUtc(),
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
  Future<void> sendMessageToIsolate() async {
    if (ProxyService.box.stopTaxService() ?? false) return;

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
        // 'dbPath': path.join(
        //     (await DatabasePath.getDatabaseDirectory()), Repository.dbFileName),
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
            value: ITenant.fromJsonList(response.body).first.businessId!);
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
    } catch (e) {
      talker.error('Unexpected error: $e');
      // rethrow;
    }
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
        createdAt: DateTime.now().toUtc(),
        lastTouched: DateTime.now().toUtc(),
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
      // in erference https://github.com/GetDutchie/brick/issues/580#issuecomment-2845610769
      // Repository().sqliteProvider.upsert<Counter>(upCounter);
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
    String? customerName,
    String? customerTin,
  }) async {
    if (transaction != null) {
      try {
        // Fetch transaction items
        List<TransactionItem> items = await transactionItems(
          branchId: (await ProxyService.strategy.activeBranch()).id,
          transactionId: transaction.id,
        );
        double subTotalFinalized = cashReceived;
        if (isIncome) {
          // Update transaction details
          final double subTotal =
              items.fold(0, (num a, b) => a + (b.price * (b.qty).toDouble()));
          subTotalFinalized = !isIncome ? cashReceived : subTotal;
          // Update stock and transaction items

          /// please do not remove await on the following method because feature like sync to ebm rely heavily on it.
          /// by ensuring that transaction's item have both doneWithTransaction and active that are true at time of completing a transaction
          await _updateStockAndItems(items: items, branchId: branchId);
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
          customerName: customerName,
          customerTin: customerTin,
        );

        // Save transaction
        transaction.status = COMPLETE;
        // refresh transaction's date
        transaction.updatedAt = DateTime.now().toUtc();
        transaction.lastTouched = DateTime.now().toUtc();
        transaction.createdAt = DateTime.now().toUtc();
        // TODO: if transactin has customerId use the customer.phone number instead.
        transaction.currentSaleCustomerPhoneNumber =
            "250" + (ProxyService.box.currentSaleCustomerPhoneNumber() ?? "");
        await repository.upsert(transaction);

        // Handle receipt if required
        if (directlyHandleReceipt) {
          if (!isProformaMode && !isTrainingMode) {
            TaxController(object: transaction)
                .handleReceipt(filterType: FilterType.NS);
          } else if (isProformaMode) {
            TaxController(object: transaction)
                .handleReceipt(filterType: FilterType.PS);
          } else if (isTrainingMode) {
            TaxController(object: transaction)
                .handleReceipt(filterType: FilterType.TS);
          }
        }
        return transaction;
      } catch (e, s) {
        talker.error(s);
        rethrow;
      }
    }
    throw Exception("transaction is null");
  }

  /// customerName and customerTin are optional
  /// but for transactions that need to sync with ebm they need them otherwise they will be skipped.
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
    String? customerName,
    String? customerTin,
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
    transaction.customerName = customerName;
    transaction.customerTin = customerTin;

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
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final serverUrl = await ProxyService.box.getServerUrl();

      if (business == null) {
        throw Exception("Business not found");
      }

      if (adjustmentTransaction == null) {
        throw Exception("Failed to create adjustment transaction");
      }
      await _processTransactionItems(
        items: items,
        branchId: branchId,
        adjustmentTransaction: adjustmentTransaction,
        business: business,
        serverUrl: serverUrl,
      );

      // Assuming completeTransaction is defined in the same scope.
      await completeTransaction(pendingTransaction: adjustmentTransaction);
    } catch (e, s) {
      talker.error(s);
      talker.warning(e);
      rethrow;
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
    String? serverUrl,
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
    String? serverUrl,
  }) async {
    if (!item.active!) {
      repository.delete(item);
      return;
    }
    String stockInOutType = ProxyService.box.stockInOutType();
    await _updateStockForItem(item: item, branchId: branchId);

    final variant = await ProxyService.strategy.getVariant(id: item.variantId);
    // Setting the quantity here, after the stock patch is crucial for accuracy.

    variant?.qty = item.qty.toDouble();
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
        doneWithTransaction: true,
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
    String? serverUrl,
  }) async {
    ProxyService.box.writeBool(key: 'lockPatching', value: true);
    variant.ebmSynced = false;
    await ProxyService.strategy.updateVariant(updatables: [variant]);
    if (serverUrl != null) {
      VariantPatch.patchVariant(
        URI: serverUrl,
        identifier: variant.id,
        sendPort: (message) {
          ProxyService.notification.sendLocalNotification(body: message);
        },
      );
    }
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
        await repository.upsert<TransactionItem>(item);
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
      {required String tableName}) async {}

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
        createdAt: DateTime.now().toUtc(),
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
      lastTouched: DateTime.now().toUtc(),
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
        serverId: remoteBranch.serverId,
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
  void updateAccess(
      {required String accessId,
      required int userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required int branchId,
      required int businessId,
      required String userType}) {
    Access access = Access(
      id: accessId,
      userId: userId,
      featureName: featureName,
      accessLevel: accessLevel,
      status: status,
      branchId: branchId,
      businessId: businessId,
      userType: userType,
    );
    repository.upsert(access);
  }

  @override
  FutureOr<List<Access>> access(
      {required int userId,
      String? featureName,
      required bool fetchRemote}) async {
    return await repository.get<Access>(
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
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
      lastTouched: DateTime.now().toUtc(),
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
        approvalDate: DateTime.now().toUtc(),
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
          // Get category information if available
          String? categoryId = item.categoryId;
          String? category = item.category;

          // Create a new variant with the product
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
            product: Product(
              color: randomizeColor(),
              name: item.itemNm ?? item.name,
              lastTouched: DateTime.now().toUtc(),
              branchId: branchId,
              businessId: businessId,
              createdAt: DateTime.now().toUtc(),
              spplrNm: item.spplrNm,
              barCode: item.barCode,
              categoryId: categoryId, // Set categoryId on the product
            ),
            supplyPrice: item.supplyPrice ?? 0,
            retailPrice: item.retailPrice ?? 0,
            itemSeq: item.itemSeq ?? 1,
            ebmSynced: false,
            spplrItemCd: item.hsCd,
            spplrItemClsCd: item.hsCd,
          );

          // After creating the product, find the variant by name and update its category information
          if (categoryId != null && categoryId.isNotEmpty) {
            Variant? variant = await getVariant(name: item.name);
            if (variant != null) {
              variant.categoryId = categoryId;
              variant.category = category;
              await repository.upsert(variant);
            }
          }
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
      {required String currentBranchId, bool fetchRemote = false}) async {
    final payment_status = await repository.get<BranchPaymentIntegration>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
        query: brick.Query(where: [
          brick.Where('branchId').isExactly(currentBranchId),
        ]));
    return payment_status.firstOrNull?.isEnabled ?? false;
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
          where: [brick.Where('branchId').isExactly(branchId)],
          orderBy: [OrderBy('date', ascending: false)],
        ),
      );
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
      timestamp: DateTime.now().toUtc(),
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

  @override
  Future<List<Access>> allAccess({required int userId}) async {
    return (await repository.get<Access>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [Where('userId').isExactly(userId)],
      ),
    ));
  }
}
