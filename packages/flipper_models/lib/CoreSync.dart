import 'dart:convert';
import 'dart:math';
import 'dart:isolate';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/sync/mixins/asset_mixin.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/mixins/business_mixin.dart';

import 'package:flipper_models/sync/mixins/category_mixin.dart';
import 'package:flipper_models/sync/mixins/counter_mixin.dart';
import 'package:flipper_models/sync/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/mixins/delegation_mixin.dart';
import 'package:flipper_models/sync/mixins/delete_mixin.dart';
import 'package:flipper_models/sync/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/mixins/log_mixin.dart';
import 'package:flipper_models/sync/mixins/shift_mixin.dart';
import 'package:flipper_models/sync/mixins/product_mixin.dart';

import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/mixins/stock_mixin.dart';
import 'package:flipper_models/sync/mixins/stock_recount_mixin.dart';
import 'package:flipper_models/sync/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_mixin.dart';
import 'package:flipper_models/sync/mixins/variant_mixin.dart';
import 'package:flipper_models/sync/mixins/discount_mixin.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/Booting.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'dart:async';
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
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        LogMixin,
        EbmMixin,
        StockRecountMixin,
        ShiftMixin,
        StockMixin,
        CategoryMixin,
        CounterMixin,
        DelegationMixin,
        DiscountMixin
    implements DatabaseSyncInterface {
  final String apihub = AppSecrets.apihubProd;

  bool offlineLogin = false;

  Repository repository = Repository();

  DittoService get dittoService => DittoService.instance;

  CoreSync();
  bool isInIsolate() {
    return Isolate.current.debugName != null;
  }

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
    String? userId = ProxyService.box.getUserId();
    if (userId == null) return false;
    final pinLocal = await ProxyService.strategy
        .getPinLocal(userId: userId, alwaysHydrate: true);
    try {
      token ??= pinLocal?.tokenUid;

      if (token != null) {
        talker.warning(token);
        await FirebaseAuth.instance.signInWithCustomToken(token);

        return true;
      }
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
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
  Future<void> amplifyLogout() async {
    try {
      await amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  Future<void> assignCustomerToTransaction(
      {required Customer customer, required ITransaction transaction}) async {
    try {
      transaction.customerId = customer.id;
      transaction.customerName = customer.custNm;
      transaction.customerTin = customer.custTin;
      transaction.customerPhone = customer.telNo;
      transaction.currentSaleCustomerPhoneNumber = customer.telNo;
      repository.upsert<ITransaction>(transaction);
    } catch (e) {
      print('Failed to assign customer to transaction: $e');
      rethrow;
    }
  }

  @override
  Stream<Tenant?> authState({required String branchId}) async* {
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
  Future<List<PColor>> colors({required String branchId}) async {
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
    // Add system configuration logic here

    await ProxyService.box.writeString(key: 'userId', value: user.id);
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);

    // Ensure the PIN record has the correct UID to prevent duplicates
    if (user.uid != null) {
      // Check if a PIN with this userId already exists
      final existingPin = await ProxyService.strategy.getPinLocal(
          userId: user.id,
          alwaysHydrate: false // Use local-only to avoid network calls
          );

      if (existingPin != null) {
        // Update the existing PIN with the correct UID
        if (existingPin.uid != user.uid) {
          talker.debug(
              "Updating existing PIN with correct UID during configureSystem");
          await ProxyService.strategy.updatePin(
              userId: user.id, tokenUid: user.uid, phoneNumber: userPhone);
        }
      }
    }

    if (!offlineLogin) {
      // Perform online-specific configuration
      await firebaseLogin();
    }
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

  Future<models.Variant> _createRegularVariant(String branchId, int? tinNumber,
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
      itemCd: (createItemCode || itemCd == null)
          ? await itemCode(
              countryCode: orgnNatCd ?? "RW",
              productType: "2",
              packagingUnit: "CT",
              quantityUnit: "BJ",
              branchId: branchId,
            )
          : itemCd,
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
  Future<Receipt?> createReceipt({
    required RwApiResponse signature,
    required DateTime whenCreated,
    required ITransaction transaction,
    required String qrCode,
    required String receiptType,
    required int highestInvcNo,
    required int invoiceNumber,
    required String timeReceivedFromserver,
  }) async {
    String branchId = ProxyService.box.getBranchId()!;

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
        invcNo: highestInvcNo,
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
          action: QueryAction.delete,
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
      double newSubTotal = 0.0;
      for (var i = 0; i < remainingItems.length; i++) {
        remainingItems[i].itemSeq = i + 1;
        await repository.upsert<TransactionItem>(remainingItems[i]);
        newSubTotal += (remainingItems[i].price * remainingItems[i].qty);
      }

      // 6. Update the transaction's subTotal.
      await updateTransaction(
        transactionId: transactionId,
        subTotal: newSubTotal,
        updatedAt: DateTime.now().toUtc(),
        lastTouched: DateTime.now().toUtc(),
      );
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<void> deleteBranch(
      {required String branchId,
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
            branchId: (await ProxyService.strategy.activeBranch(
              branchId: ProxyService.box.getBranchId()!,
            ))
                .id))
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
  Future<Variant?> getCustomVariant(
      {required String businessId,
      required String branchId,
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
          skipRRaCall: false,
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
  Future<Variant?> getUtilityVariant({
    required String name,
    required String branchId,
  }) async {
    final businessId = ProxyService.box.getBusinessId()!;
    final bhFId = await ProxyService.box.bhfId() ?? "00";
    final tinNumber = await effectiveTin(branchId: branchId) ?? 0;

    final repository = Repository();
    final productQuery = brick.Query(where: [
      brick.Where('name').isExactly("Utility"),
      brick.Where('branchId').isExactly(branchId),
    ]);
    final productResult = await repository.get<models.Product>(
        query: productQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    models.Product? product = productResult.firstOrNull;

    if (product == null) {
      product = await createProduct(
          tinNumber: tinNumber,
          bhFId: bhFId,
          skipRRaCall: false,
          createItemCode: true,
          branchId: branchId,
          businessId: businessId,
          product: models.Product(
              lastTouched: DateTime.now().toUtc(),
              name: "Utility",
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toUtc(),
              branchId: branchId));
    }

    final variantQuery = brick.Query(where: [
      brick.Where('productId').isExactly(product!.id),
      brick.Where('name').isExactly(name),
    ]);
    final variantResult = await repository.get<models.Variant>(
        query: variantQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    models.Variant? variant = variantResult.firstOrNull;

    if (variant == null) {
      final sku = await getSku(branchId: branchId, businessId: businessId);
      sku.consumed = true;
      await repository.upsert(sku);

      variant = models.Variant(
        id: const Uuid().v4(),
        name: name,
        productId: product.id,
        branchId: branchId,
        sku: sku.sku.toString(),
        retailPrice: 0.0,
        supplyPrice: 0.0,
        lastTouched: DateTime.now().toUtc(),
        taxTyCd: "B",
        taxPercentage: 18.0,
        itemNm: name,
        itemStdNm: name,
        bhfId: bhFId,
        regrNm: name,
        modrNm: name,
        bcd: name,
      );

      final stock = models.Stock(
        id: const Uuid().v4(),
        lastTouched: DateTime.now().toUtc(),
        rsdQty: 0,
        initialStock: 0,
        currentStock: 0,
        branchId: branchId,
      );
      final createdStock = await repository.upsert<models.Stock>(stock);
      variant.stock = createdStock;
      variant.stockId = createdStock.id;
      variant = await repository.upsert<models.Variant>(variant);
    }

    return variant;
  }

  @override
  Stream<List<Customer>> customersStream({
    required String branchId,
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
  Stream<Tenant?> getDefaultTenant({required String businessId}) {
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
    try {
      final query = brick.Query(where: [
        brick.Where('phone', value: phone, compare: brick.Compare.exact),
        brick.Where(
          'linkingCode',
          value: linkingCode,
          compare: brick.Compare.exact,
        ),
      ]);
      final List<Device> fetchedDevices = await repository.get<Device>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist, query: query);
      return fetchedDevices.firstOrNull;
    } catch (e) {
      // Log the error but don't throw it up the stack
      talker.error('Error in getDevice: $e');

      // Try a fallback query with just linkingCode if available
      if (linkingCode.isNotEmpty) {
        try {
          final fallbackQuery = brick.Query(where: [
            brick.Where(
              'linkingCode',
              value: linkingCode,
              compare: brick.Compare.exact,
            ),
          ]);
          final List<Device> devices =
              await repository.get<Device>(query: fallbackQuery);
          return devices.firstOrNull;
        } catch (fallbackError) {
          talker.error('Fallback query also failed: $fallbackError');
        }
      }

      // Return null instead of throwing an exception
      return null;
    }
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(id)]);
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required String businessId}) async {
    final query = brick.Query(
      where: [brick.Where('businessId').isExactly(businessId)],
    );
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices;
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
          clearData(data: ClearData.Branch, identifier: branchE?.id ?? "");
          clearData(data: ClearData.Business, identifier: business?.id ?? "");
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
  FutureOr<Pin?> getPinLocal(
      {String? userId,
      required bool alwaysHydrate,
      String? phoneNumber}) async {
    return (await repository.get<Pin>(
            policy: alwaysHydrate
                ? OfflineFirstGetPolicy.awaitRemote
                : OfflineFirstGetPolicy.localOnly,
            query: brick.Query(where: [
              if (userId != null) brick.Where('userId').isExactly(userId),
              if (phoneNumber != null)
                brick.Where('phoneNumber').isExactly(phoneNumber)
            ])))
        .firstOrNull;
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
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
      {String? key, int? prodIndex, required String branchId}) async {
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
  FutureOr<Tenant?> getTenant({String? userId, int? pin}) async {
    if (userId != null) {
      return (await repository.get<Tenant>(
              query:
                  brick.Query(where: [brick.Where('userId').isExactly(userId)]),
              policy: OfflineFirstGetPolicy.localOnly))
          .firstOrNull;
    } else if (pin != null) {
      return (await repository.get<Tenant>(
              query: brick.Query(where: [brick.Where('pin').isExactly(pin)]),
              policy: OfflineFirstGetPolicy.localOnly))
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
    required String businessId,
    bool? fetchOnline,
  }) async {
    try {
      final query = brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
      ]);

      // Use awaitRemote when explicitly requesting online data to ensure
      // remote fetch happens even if local data exists (important for new devices)
      final policy = (fetchOnline == true)
          ? OfflineFirstGetPolicy.awaitRemote
          : OfflineFirstGetPolicy.alwaysHydrate;

      talker.info(
          'getPaymentPlan: businessId=$businessId, fetchOnline=$fetchOnline, policy=$policy');

      final result = await repository.get<models.Plan>(
        query: query,
        policy: policy,
      );
      return result.firstOrNull;
    } catch (e) {
      talker.error('getPaymentPlan error: $e');
      rethrow;
    }
  }

  @override
  Future<void> upsertPlan(
      {required String businessId, required Plan selectedPlan}) async {
    try {
      selectedPlan.updatedAt = DateTime.now();
      await repository.upsert(selectedPlan);
    } catch (e) {
      talker.error('upsertPlan error: $e');
      rethrow;
    }
  }

  @override
  FutureOr<bool> isAdmin(
      {required String userId, required String appFeature}) async {
    final accesses = await allAccess(userId: userId);

    /// cases where no access was set to a user he is admin by default.
    if (accesses.isEmpty) return true;

    return accesses.any((access) =>
        access.featureName == appFeature &&
        access.accessLevel?.toLowerCase() == 'admin');
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
    transaction.customerTin = null;
    repository.upsert(transaction);
  }

  @override
  Future<bool> removeS3File({required String fileName}) async {
    await syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");
    String branchId = ProxyService.box.getBranchId()!;
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
  Stream<List<Report>> reports({required String branchId}) {
    return repository.subscribe(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<List<models.InventoryRequest>> requests(
      {String? branchId, String? requestId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }

    if (branchId != null) {
      final result = await ditto.store.execute(
        'SELECT * FROM stock_requests WHERE mainBranchId = :branchId AND (status = :pending OR status = :partiallyApproved)',
        arguments: {
          'branchId': branchId,
          'pending': RequestStatus.pending,
          'partiallyApproved': RequestStatus.partiallyApproved,
        },
      );

      final requests = result.items.map((item) {
        final data = Map<String, dynamic>.from(item.value);
        return _convertInventoryRequestFromDitto(data);
      }).toList();
      return await Future.wait(requests.map(_hydrateSingleRequest));
    }

    if (requestId != null) {
      final result = await ditto.store.execute(
        'SELECT * FROM stock_requests WHERE _id = :requestId',
        arguments: {'requestId': requestId},
      );

      final requests = result.items.map((item) {
        final data = Map<String, dynamic>.from(item.value);
        return _convertInventoryRequestFromDitto(data);
      }).toList();
      return await Future.wait(requests.map(_hydrateSingleRequest));
    }

    throw Exception("Invalid parameter");
  }

  @override
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.warning(
          'Ditto not initialized yet, returning empty stream for requests');
      // Return empty stream instead of error - Ditto will initialize soon
      return Stream.value([]);
    }

    final controller = StreamController<List<InventoryRequest>>.broadcast();
    dynamic observer;

    () async {
      try {
        final query =
            'SELECT * FROM stock_requests WHERE mainBranchId = :branchId AND status = :status';
        final arguments = {'branchId': branchId, 'status': filter};

        // Subscribe to ensure we have the latest data
        await ditto.sync.registerSubscription(query, arguments: arguments);

        observer = ditto.store.registerObserver(
          query,
          arguments: arguments,
          onChange: (queryResult) async {
            if (controller.isClosed) return;

            final requests = queryResult.items.map((item) {
              final data = Map<String, dynamic>.from(item.value);
              return _convertInventoryRequestFromDitto(data);
            }).toList();

            // Hydrate requests
            final hydratedRequests =
                await Future.wait(requests.map(_hydrateSingleRequest));

            controller.add(hydratedRequests);
          },
        );
      } catch (e) {
        talker.error('Error setting up requests observer: $e');
        controller.addError(e);
      }
    }();

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  InventoryRequest _convertInventoryRequestFromDitto(
      Map<String, dynamic> data) {
    // Parse transactionItems from embedded data
    List<TransactionItem>? items;
    if (data['transactionItems'] != null && data['transactionItems'] is List) {
      items = (data['transactionItems'] as List).map((itemData) {
        final itemMap = Map<String, dynamic>.from(itemData);
        return TransactionItem(
          id: itemMap['id'],
          name: itemMap['name'],
          qty: itemMap['qty'] ?? 0,
          price: itemMap['price'] ?? 0,
          discount: itemMap['discount'] ?? 0,
          prc: itemMap['prc'] ?? 0,
          ttCatCd: itemMap['ttCatCd'],
          quantityRequested:
              (itemMap['quantityRequested'] as num?)?.toInt() ?? 0,
          quantityApproved: (itemMap['quantityApproved'] as num?)?.toInt() ?? 0,
          quantityShipped: (itemMap['quantityShipped'] as num?)?.toInt() ?? 0,
          transactionId: itemMap['transactionId'],
          variantId: itemMap['variantId'],
          inventoryRequestId: itemMap['inventoryRequestId'],
        );
      }).toList();
    }

    return InventoryRequest(
      id: data['_id'] ?? data['id'],
      mainBranchId: data['mainBranchId'],
      subBranchId: data['subBranchId'],
      branchId: data['branchId'],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
      status: data['status'],
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.tryParse(data['deliveryDate'])
          : null,
      deliveryNote: data['deliveryNote'],
      orderNote: data['orderNote'],
      customerReceivedOrder: data['customerReceivedOrder'],
      driverRequestDeliveryConfirmation:
          data['driverRequestDeliveryConfirmation'],
      driverId: data['driverId'],
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
      itemCounts: data['itemCounts'],
      bhfId: data['bhfId'],
      tinNumber: data['tinNumber'],
      financingId: data['financingId'],
      transactionItems: items,
    );
  }

  Future<InventoryRequest> _hydrateSingleRequest(InventoryRequest req) async {
    Branch? hydratedBranch = req.branch;

    if (hydratedBranch == null && req.subBranchId != null) {
      final branches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(where: [
          brick.Where('serverId').isExactly(req.subBranchId),
        ]),
      );

      if (branches.isNotEmpty) {
        hydratedBranch = branches.first;
      }
    }

    Financing? financingToUse = req.financing;

    if (financingToUse == null && req.financingId != null) {
      final financingList = await repository.get<Financing>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(where: [
          brick.Where('id').isExactly(req.financingId),
        ]),
      );

      if (financingList.isNotEmpty) {
        financingToUse = financingList.first;
      }
    }

    return await req.copyWith(
      branch: hydratedBranch,
      financing: financingToUse,
    );
  }

  @override
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required String businessId,
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
    String businessId,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('plans')
          .select('*, addons(*)')
          .eq('business_id', businessId)
          .maybeSingle();

      if (response == null) {
        return [];
      }

      final addonsData = response['addons'] as List<dynamic>?;
      if (addonsData == null || addonsData.isEmpty) {
        return [];
      }

      return addonsData.map((addonJson) {
        return models.PlanAddon(
          id: addonJson['id'] as String,
          planId: addonJson['plan_id'] as String?,
          addonName: addonJson['addon_name'] as String?,
          createdAt: addonJson['created_at'] != null
              ? DateTime.parse(addonJson['created_at'] as String)
              : null,
        );
      }).toList();
    } catch (e) {
      talker.error('Failed to fetch existing addons: $e');
      rethrow;
    }
  }

  Future<List<models.PlanAddon>> _processNewAddons({
    required String businessId,
    required List<models.PlanAddon> existingAddons,
    required List<String>? newAddonNames,
    required bool isYearlyPlan,
  }) async {
    if (newAddonNames == null || newAddonNames.isEmpty) return existingAddons;

    final updatedAddons = List<models.PlanAddon>.from(existingAddons);
    final existingAddonNames = existingAddons.map((e) => e.addonName).toSet();

    final newAddonsToInsert = <Map<String, dynamic>>[];

    for (final addonName in newAddonNames) {
      if (existingAddonNames.contains(addonName)) continue;

      final newAddon = models.PlanAddon(
        addonName: addonName,
        createdAt: DateTime.now().toUtc(),
        planId: businessId,
      );

      newAddonsToInsert.add({
        'id': newAddon.id,
        'plan_id': newAddon.planId,
        'addon_name': newAddon.addonName,
        'created_at': newAddon.createdAt?.toIso8601String(),
      });

      updatedAddons.add(newAddon);
    }

    // Insert all new addons in a single batch operation
    if (newAddonsToInsert.isNotEmpty) {
      await Supabase.instance.client.from('addons').insert(newAddonsToInsert);
    }

    return updatedAddons;
  }

  Future<models.Plan> _upsertPlan({
    required String businessId,
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
    final planId = plan?.id ?? const Uuid().v4();
    final now = DateTime.now().toUtc();

    final planData = {
      'id': planId,
      'business_id': businessId,
      'selected_plan': selectedPlan,
      'additional_devices': additionalDevices,
      'is_yearly_plan': isYearlyPlan,
      'rule': isYearlyPlan ? 'yearly' : 'monthly',
      'total_price': totalPrice.toInt(),
      'payment_method': paymentMethod,
      'payment_completed_by_user': false,
      'next_billing_date': nextBillingDate.toIso8601String(),
      'number_of_payments': numberOfPayments,
      'created_at': plan?.createdAt?.toIso8601String() ?? now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await Supabase.instance.client.from('plans').upsert(planData);

    return models.Plan(
      id: planId,
      businessId: businessId,
      selectedPlan: selectedPlan,
      additionalDevices: additionalDevices,
      isYearlyPlan: isYearlyPlan,
      rule: isYearlyPlan ? 'yearly' : 'monthly',
      totalPrice: totalPrice.toInt(),
      createdAt: plan?.createdAt ?? now,
      numberOfPayments: numberOfPayments,
      nextBillingDate: nextBillingDate,
      paymentMethod: paymentMethod,
      addons: addons,
      paymentCompletedByUser: false,
      updatedAt: now,
    );
  }

  @override
  Future<Pin?> savePin({required Pin pin}) async {
    try {
      // First check if a PIN with this userId already exists
      final existingPins = await repository.get<Pin>(
        query:
            brick.Query(where: [brick.Where('userId').isExactly(pin.userId)]),
      );

      if (existingPins.isNotEmpty) {
        // Update the existing PIN instead of creating a new one
        Pin existingPin = existingPins.first;

        // Since we can't modify the ID (it's final), we'll update the existing PIN's fields
        // and then use that object instead of the new one
        existingPin.phoneNumber = pin.phoneNumber;
        existingPin.branchId = pin.branchId;
        existingPin.businessId = pin.businessId;
        existingPin.ownerName = pin.ownerName;
        existingPin.tokenUid = pin.tokenUid;
        existingPin.uid = pin.uid;

        // Use the existing PIN object with updated fields
        pin = existingPin;

        talker.debug(
            "Updating existing PIN with userId: ${pin.userId}, ID: ${pin.id}");
      } else {
        talker.debug("Creating new PIN with userId: ${pin.userId}");
      }

      // Use upsert with a query to ensure we're updating the right record
      final query = brick.Query.where('userId', pin.userId, limit1: true);
      final savedPin = await repository.upsert(
        pin,
        query: query,
      );

      return savedPin;
    } catch (e, s) {
      talker.error("Error saving PIN: $e");
      talker.error(s.toString());
      rethrow;
    }
  }

  @override
// Helper method to save a variant
  Future<void> saveVariant(Variant item, Business business, String branchId,
      {required bool skipRRaCall}) async {
    final resolvedTin = (await effectiveTin(business: business))!;
    await createProduct(
      skipRRaCall: skipRRaCall,
      bhFId: (await ProxyService.box.bhfId()) ?? "00",
      tinNumber: resolvedTin,
      businessId: ProxyService.box.getBusinessId()!,
      branchId: branchId,
      totWt: item.totWt,
      netWt: item.netWt,
      itemCd: item.itemCd,
      spplrNm: item.spplrNm,
      agntNm: item.agntNm,
      invcFcurAmt: item.invcFcurAmt?.toInt() ?? 0,
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
    if (ProxyService.box.getBusinessId() == null) return;
    if (ProxyService.box.getBranchId() == null) return;

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
  Future<Business> signup(
      {required Map business,
      required HttpClientInterface flipperHttpClient}) async {
    try {
      // Step 1: Create business via API
      talker.info('Signup: Creating business via API ${apihub}');
      talker.info('Signup: Creating business via API ${business}');
      // remove businessTypeId from business map
      business.remove('businessTypeId');
      final http.Response response = await flipperHttpClient.post(
          Uri.parse("$apihub/v2/api/business"),
          body: jsonEncode(business));

      if (response.statusCode != 200 && response.statusCode != 201) {
        talker.error('Signup: API returned error: ${response.statusCode}');
        talker.error('Response body: ${response.body}');
        throw InternalServerError(term: response.body.toString());
      }

      talker.info('Signup: Business created successfully, parsing response');
      final responseBody = response.body;
      talker.debug('Response body: $responseBody');

      // Step 2: Parse business object
      final Map<String, dynamic> jsonData;
      final Business bus;
      try {
        jsonData = jsonDecode(responseBody);
        bus = Business.fromMap(jsonData);
        talker
            .info('Signup: Business parsed successfully, ID: ${bus.serverId}');
        await repository
            .upsert<Business>(bus); // Save the business object locally
      } catch (e, s) {
        talker.error('Signup: Error parsing business data: $e', s);
        throw e;
      }

      // Step 2.5: Branches are now created by the server during tenant creation
      // and synced via tenantsFromOnline method, so no need for local creation

      // Save branch and business IDs early
      ProxyService.box.writeString(key: 'businessId', value: bus.id);
      ProxyService.box.writeString(key: 'branchId', value: bus.id);

      // Step 3: Create PIN
      // Ensure userId is not null
      if (bus.userId == null) {
        talker.error('Signup: Business userId is null');
        throw Exception('Business userId is null');
      }

      // Step 4: Save PIN locally
      Pin? savedPin;
      try {
        talker.info('Signup: Saving PIN locally');
        savedPin = await savePin(
            pin: Pin(
                userId: bus.userId,
                id: bus.userId.toString(),
                branchId: bus.id,
                businessId: bus.id,
                ownerName: business['name'] ?? '',
                phoneNumber: business['phoneNumber'] ?? ''));

        if (savedPin == null) {
          talker.error('Signup: Failed to save PIN');
          throw Exception('Failed to save PIN');
        }
        talker.info('Signup: PIN saved successfully');
      } catch (e, s) {
        talker.error('Signup: Error in saving PIN: $e', s);
        throw e;
      }

      // Step 5: Login
      try {
        talker.info('Signup: Logging in with new PIN');
        await login(
            isInSignUpProgress: true,
            pin: savedPin,
            userPhone: business['phoneNumber'],
            skipDefaultAppSetup: true,
            flipperHttpClient: flipperHttpClient,
            freshUser: true);
        talker.info('Signup: Login successful');
      } catch (e, s) {
        talker.error('Signup: Error in login: $e', s);
        throw e;
      }

      // Set flag to indicate fresh signup for login choices
      ProxyService.box.writeBool(key: 'freshSignup', value: true);

      return bus;
    } catch (e, s) {
      talker.error('Signup: Unhandled error: $e', s);
      rethrow;
    }
  }

  @override
  Future<void> spawnIsolate(isolateHandler) async {
    try {
      final isTaxEnabledFor = await isTaxEnabled(
          businessId: ProxyService.box.getBusinessId()!,
          branchId: ProxyService.box.getBranchId()!);
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
  Future<List<IUnit>> units({required String branchId}) async {
    final existingUnits = await repository.get<IUnit>(
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
    if (existingUnits.isNotEmpty) {
      return existingUnits;
    }
    await addUnits(units: mockUnits);
    return await repository.get<IUnit>(
      query: brick.Query(where: [
        brick.Where('branchId').isExactly(branchId),
      ]),
      policy: OfflineFirstGetPolicy.localOnly,
    );
  }

  @override
  Future<List<UnversalProduct>> universalProductNames(
      {required String branchId}) async {
    return repository.get<UnversalProduct>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
    );
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName,
      {required String transactionId}) async {
    try {
      String branchId = ProxyService.box.getBranchId()!;
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
        ProxyService.box
            .writeString(key: 'getReceiptFileName', value: fileName + ".pdf");
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
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/search?name=$name"));
    return response.statusCode;
  }

  @override
  Future<ITransaction> collectPayment({
    required double cashReceived,
    ITransaction? transaction,
    required String paymentType,
    required double discount,
    required String branchId,
    required String bhfId,
    required String countryCode,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String transactionType,
    String? categoryId,
    bool directlyHandleReceipt = false,
    required bool isIncome,
    String? customerName,
    String? customerTin,
    String? customerPhone,
    String? note,
  }) async {
    if (transaction != null) {
      if (note != null) {
        transaction.note = note;
      }
      try {
        final userId = ProxyService.box.getUserId();
        if (userId != null) {
          transaction.customerTin = customerTin;
          transaction.customerChangeDue = cashReceived - transaction.subTotal!;
          final currentShift = await getCurrentShift(userId: userId);
          if (currentShift != null) {
            num saleAmount = transaction.subTotal ?? 0.0;
            if (!isIncome) {
              saleAmount = -saleAmount;
            }

            final updatedCashSales = (currentShift.cashSales ?? 0) + saleAmount;
            final updatedExpectedCash =
                currentShift.openingBalance + updatedCashSales;

            final updatedShift = currentShift.copyWith(
              cashSales: updatedCashSales,
              expectedCash: updatedExpectedCash,
            );
            await repository.upsert<Shift>(updatedShift);
          }
        }
        if (countryCode != "N/A" && countryCode != "") {
          transaction.currentSaleCustomerPhoneNumber = countryCode +
              (customerPhone ??
                  ProxyService.box.currentSaleCustomerPhoneNumber())!;
        }
        transaction.customerPhone =
            customerPhone ?? ProxyService.box.currentSaleCustomerPhoneNumber();
        transaction.customerName =
            customerName ?? ProxyService.box.customerName();
        // Fetch transaction items
        talker.info("collectPayment: Explicitly fetching transaction items");
        final items = await repository.get<TransactionItem>(
          query: brick.Query(where: [
            brick.Where('transactionId').isExactly(transaction.id),
          ]),
          policy: OfflineFirstGetPolicy.localOnly,
        );
        talker.info("collectPayment: Found ${items.length} items");

        // Update numberOfItems before completing the sale
        transaction.numberOfItems = items.length;

        // sum up all discount found on item then save them on a transaction
        talker.info("collectPayment: Calculating discountAmount");
        transaction.discountAmount =
            items.fold(0, (a, b) => a! + (b.dcAmt ?? 0));

        transaction.subTotal = items.isEmpty
            ? cashReceived
            : items.fold(0.0, (a, b) => a! + (b.price * b.qty));

        if (transaction.isLoan == true) {
          transaction.originalLoanAmount ??= transaction.subTotal;
          // Cumulative cash received
          double totalPaidSoFar =
              (transaction.cashReceived ?? 0.0) + cashReceived;
          transaction.cashReceived = totalPaidSoFar;
          transaction.remainingBalance = transaction.subTotal! - totalPaidSoFar;
          transaction.lastPaymentDate = DateTime.now().toUtc();
          transaction.lastPaymentAmount = cashReceived;
        } else {
          transaction.cashReceived = cashReceived;
        }

        transaction.transactionType = transactionType;
        transaction.categoryId = categoryId;
        transaction.isIncome = isIncome;
        transaction.isExpense = !isIncome;
        transaction.paymentType = ProxyService.box.paymentType() ?? paymentType;
        transaction.customerTin = customerTin;

        if (isIncome) {
          talker.info(
              "Processing income items for transaction ${transaction.id}");
        }
        // Touch variants' lastTouched asynchronously to aid reporting without blocking the flow.
        Future.microtask(() async {
          final items = transaction.items ?? const <TransactionItem>[];
          talker.info(
              "Touching ${items.length} items for transaction ${transaction.id}");

          final variantIds =
              items.map((i) => i.variantId).whereType<String>().toSet();
          for (final id in variantIds) {
            final variant = await ProxyService.strategy.getVariant(id: id);
            if (variant != null) {
              variant.lastTouched = DateTime.now().toUtc();
              await repository.upsert<Variant>(variant);
            }
          }
        });

        talker.info("collectPayment: Upserting transaction");

        await repository.upsert<ITransaction>(transaction);
        talker.info("collectPayment: Transaction upserted successfully");
        return transaction;
      } catch (e, s) {
        talker.error(s);
        rethrow;
      }
    }
    throw Exception("transaction is null");
  }

  @override
  FutureOr<void> addAccess(
      {required String userId,
      required String featureName,
      required String accessLevel,
      required String userType,
      required String status,
      required String branchId,
      required String businessId,
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
  FutureOr<void> addColor({required String name, required String branchId}) {
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
      String? branchId}) async {
    final category = (await repository.get<Category>(
            query: brick.Query(where: [
              brick.Where('id', value: categoryId, compare: Compare.exact),
            ]),
            policy: OfflineFirstGetPolicy.localOnly))
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
        final existingDevice = await repository.get<Device>(
            query: brick.Query(
                where: [brick.Where('userId').isExactly(data.userId)]));
        if (existingDevice.isNotEmpty) {
          final device = existingDevice.first;
          device.linkingCode = data.linkingCode;
          device.deviceName = data.deviceName;
          device.deviceVersion = data.deviceVersion;
          device.pubNubPublished = data.pubNubPublished;
          device.phone = data.phone;
          device.branchId = data.branchId;
          device.businessId = data.businessId;
          device.defaultApp = data.defaultApp;
          await repository.upsert<Device>(device);
          return device as T;
        }
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
      if (data is Business) {
        await repository.upsert<Business>(data);
        return data as T;
      }
      if (data is Branch) {
        await repository.upsert<Branch>(data);
        return data as T;
      }
      if (data is Purchase) {
        await repository.upsert<Purchase>(data);
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
  Future<List<Configurations>> taxes({required String branchId}) async {
    return await repository.get<Configurations>(
        policy: OfflineFirstGetPolicy.awaitRemote,
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
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
  DatabaseSyncInterface instance() {
    return this;
  }

  @override
  Future<bool> isTaxEnabled(
      {required String businessId, required String branchId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:001');
        return false;
      }
      ditto.sync.registerSubscription(
        "SELECT * FROM ebms WHERE businessId = :businessId AND branchId = :branchId",
        arguments: {'businessId': businessId, 'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM ebms WHERE businessId = :businessId AND branchId = :branchId",
        arguments: {'businessId': businessId, 'branchId': branchId},
      );

      // Query the ebms table using Ditto
      String query =
          'SELECT * FROM ebms WHERE businessId = :businessId AND branchId = :branchId';
      final arguments = <String, dynamic>{
        'businessId': businessId,
        'branchId': branchId,
      };

      // Subscribe to ensure we have the latest data from Ditto mesh
      await ditto.sync.registerSubscription(query, arguments: arguments);

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            completer.complete(result.items.toList());
          }
        },
      );

      List<dynamic> items = [];
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for ebms data');
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      // Check if any EBM configuration exists and if VAT is enabled
      if (items.isNotEmpty) {
        final ebmData = items.first.value as Map<String, dynamic>;
        final vatEnabled = ebmData['vatEnabled'] as bool?;
        final taxServerUrl = ebmData['taxServerUrl'] as String?;

        final isMobile =
            foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS ||
                foundation.defaultTargetPlatform ==
                    foundation.TargetPlatform.android;

        if (isMobile &&
            taxServerUrl != null &&
            taxServerUrl.contains('localhost')) {
          talker.info('Tax disabled on mobile with localhost tax server');
          return false;
        }

        return vatEnabled ==
            true; // Return true if vatEnabled is true, false otherwise
      }

      // If no EBM configuration found, tax is not enabled
      return false;
    } catch (e, st) {
      talker.error('Error checking if tax is enabled from Ditto: $e\n$st');
      return false;
    }
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

    // 4. Create a new payment record for the payment attempt
    // This allows multiple partial payments of the same type (e.g., multiple Cash payments)
    // to be recorded as separate entries in the history, preventing overwriting.
    if (amount != 0) {
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
  FutureOr<LPermission?> permission({required String userId}) async {
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
  void updateAccess(
      {required String accessId,
      required String userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required String branchId,
      required String businessId,
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
  Future<List<Access>> access(
      {required String userId,
      String? featureName,
      required bool fetchRemote}) async {
    final accesses = await allAccess(userId: userId);
    if (featureName != null) {
      return accesses
          .where((element) => element.featureName == featureName)
          .toList();
    }
    return accesses;
  }

  @override
  FutureOr<SKU> getSku(
      {required String branchId, required String businessId}) async {
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
  Stream<SKU?> sku({required String branchId, required String businessId}) {
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
      required String branchId,
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
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:002');
    }

    final updateData = <String, dynamic>{};
    if (updatedAt != null) {
      updateData['updatedAt'] = updatedAt.toIso8601String();
    }
    if (status != null) {
      updateData['status'] = status;
    }

    if (updateData.isNotEmpty) {
      await ditto.store.execute(
        'UPDATE stock_requests SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :stockRequestId',
        arguments: {...updateData, 'stockRequestId': stockRequestId},
      );
    }
  }

  @override
  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    bool? ignoreForReport,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:003');
    }

    // Get the request
    final result = await ditto.store.execute(
      'SELECT * FROM stock_requests WHERE _id = :requestId LIMIT 1',
      arguments: {'requestId': requestId},
    );

    if (result.items.isEmpty) {
      talker.error('Stock request with ID $requestId not found');
      throw Exception('Stock request with ID $requestId not found');
    }

    final requestData = Map<String, dynamic>.from(result.items.first.value);
    final transactionItems = requestData['transactionItems'] as List?;

    if (transactionItems != null) {
      // Find and update the item
      final itemIndex = transactionItems
          .indexWhere((item) => item['id'] == transactionItemId);

      if (itemIndex != -1) {
        final item = Map<String, dynamic>.from(transactionItems[itemIndex]);

        if (quantityApproved != null) {
          item['quantityApproved'] =
              (item['quantityApproved'] ?? 0) + quantityApproved;
        }
        if (ignoreForReport != null) {
          item['ignoreForReport'] = ignoreForReport;
        }

        transactionItems[itemIndex] = item;

        // Update the request with modified items
        await ditto.store.execute(
          'UPDATE stock_requests SET transactionItems = :items WHERE _id = :requestId',
          arguments: {
            'items': transactionItems,
            'requestId': requestId,
          },
        );
      }
    }
  }

  @override
  Future<void> createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required String subBranchId}) async {
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
  Future<String> createStockRequest(
    List<models.TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  }) async {
    try {
      final String requestId = const Uuid().v4();
      final String? bhfId = await ProxyService.box.bhfId();
      int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);

      FinanceProvider? provider;
      if (financingId != null) {
        provider = (await repository.get<FinanceProvider>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: brick.Query(where: [
            brick.Where('id').isExactly(financingId),
          ]),
        ))
            .firstOrNull;
      }

      final financing = Financing(
        id: provider?.id,
        provider: provider,
        requested: true,
        amount: items.fold(
          0,
          (previousValue, element) => previousValue! + element.price,
        ),
        status: 'pending',
        financeProviderId: provider?.id,
        approvalDate: DateTime.now().toUtc(),
      );

      await repository.upsert(financing);

      final InventoryRequest request = InventoryRequest(
        id: requestId,
        mainBranchId: mainBranchId,
        subBranchId: subBranchId,
        financing: financing,
        createdAt: DateTime.now().toUtc(),
        status: RequestStatus.pending,
        deliveryNote: deliveryNote,
        orderNote: orderNote,
        bhfId: bhfId,
        tinNumber: tin!.toString(),
        branchId: (await ProxyService.strategy
                .activeBranch(branchId: ProxyService.box.getBranchId()!))
            .id,
        financingId: financingId,
        itemCounts: items.length,
        transactionItems: items
            .map((item) => item.copyWith(inventoryRequestId: requestId))
            .toList(),
      );

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        throw Exception('Ditto not initialized:004');
      }

      final requestDoc = {
        '_id': request.id,
        'mainBranchId': request.mainBranchId,
        'subBranchId': request.subBranchId,
        'branchId': request.branchId,
        'createdAt': request.createdAt?.toIso8601String(),
        'status': request.status,
        'deliveryDate': request.deliveryDate?.toIso8601String(),
        'deliveryNote': request.deliveryNote,
        'orderNote': request.orderNote,
        'customerReceivedOrder': request.customerReceivedOrder,
        'driverRequestDeliveryConfirmation':
            request.driverRequestDeliveryConfirmation,
        'driverId': request.driverId,
        'updatedAt': request.updatedAt?.toIso8601String(),
        'itemCounts': request.itemCounts,
        'bhfId': request.bhfId,
        'tinNumber': request.tinNumber,
        'financingId': request.financingId,
        'transactionItems': request.transactionItems
            ?.map((item) => {
                  'id': item.id,
                  'name': item.name,
                  'qty': item.qty,
                  'price': item.price,
                  'discount': item.discount,
                  'prc': item.prc,
                  'ttCatCd': item.ttCatCd,
                  'quantityRequested': item.qty,
                  'quantityApproved': 0,
                  'quantityShipped': 0,
                  'transactionId': item.transactionId,
                  'variantId': item.variantId,
                  'inventoryRequestId': item.inventoryRequestId,
                })
            .toList(),
      };

      await ditto.store.execute('''
  INSERT INTO stock_requests
  DOCUMENTS (:request)
  ON ID CONFLICT DO UPDATE
  ''', arguments: {
        'request': requestDoc,
      });

      return requestId;
    } catch (e) {
      talker.error('Error in createStockRequest: $e');
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
  Future<models.Setting?> getSetting({required String businessId}) {
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
      int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);
      if (item.bcdU != null && item.bcdU!.isNotEmpty) {
        print('Searching for variant with modrId: ${item.barCode}');

        Variant? variant = await getVariant(bcd: item.barCode);
        print('Found variant: ${variant?.bcd}, ${variant?.name}');
        if (variant != null) {
          variant.bcd = item.bcdU!.endsWith('.0')
              ? item.bcdU!.substring(0, item.bcdU!.length - 2)
              : item.bcdU;
          variant.name = item.name;

          // Update EBM fields from the maps (with proper defaults)
          variant.itemClsCd =
              itemClasses[item.barCode] ?? variant.itemClsCd ?? "5020230602";
          variant.itemTyCd = itemTypes[item.barCode] ??
              variant.itemTyCd ??
              "2"; // 2 = Finished Product
          variant.taxTyCd = taxTypes[item.barCode] ?? variant.taxTyCd ?? "B";

          // Update prices if provided
          if (item.retailPrice != null) {
            variant.retailPrice = item.retailPrice;
            variant.prc = item.retailPrice;
            variant.dftPrc = item.retailPrice;
          }
          if (item.supplyPrice != null) {
            variant.supplyPrice = item.supplyPrice;
            variant.splyAmt = item.supplyPrice;
          }

          Stock? stock = await getStockById(id: variant.stock!.id);
          stock.currentStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.rsdQty = double.parse(quantitis[item.barCode] ?? "0");
          stock.initialStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.value = stock.currentStock! * variant.retailPrice!;

          // Update stock first
          await repository.upsert(stock);

          // Use ProxyService.strategy.addVariant for consistency with DesktopProductAdd
          await ProxyService.strategy.addVariant(
            skipRRaCall: false,
            variations: [variant],
            branchId: ProxyService.box.getBranchId()!,
          );

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

        talker.warning("ItemClass${itemClasses[item.barCode] ?? "5020230602"}");
        // is this exist using name
        Variant? variant = await getVariant(name: item.name);
        if (variant != null && item.bcdU != null) {
          variant.bcd = item.bcdU;
          variant.name = item.name;
          variant.color = randomizeColor();
          variant.lastTouched = DateTime.now();

          // Update EBM fields from the maps (with proper defaults)
          variant.itemClsCd =
              itemClasses[item.barCode] ?? variant.itemClsCd ?? "5020230602";
          variant.itemTyCd = itemTypes[item.barCode] ??
              variant.itemTyCd ??
              "2"; // 2 = Finished Product
          variant.taxTyCd = taxTypes[item.barCode] ?? variant.taxTyCd ?? "B";

          // Update prices if provided
          if (item.retailPrice != null) {
            variant.retailPrice = item.retailPrice;
            variant.prc = item.retailPrice;
            variant.dftPrc = item.retailPrice;
          }
          if (item.supplyPrice != null) {
            variant.supplyPrice = item.supplyPrice;
            variant.splyAmt = item.supplyPrice;
          }

          // Get stock
          Stock? stock = await getStockById(id: variant.stock!.id);
          stock.currentStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.rsdQty = double.parse(quantitis[item.barCode] ?? "0");
          stock.initialStock = double.parse(quantitis[item.barCode] ?? "0");
          stock.value = stock.currentStock! * variant.retailPrice!;

          // Update stock first
          await repository.upsert(stock);

          // Use ProxyService.strategy.addVariant for consistency
          await ProxyService.strategy.addVariant(
            variations: [variant],
            branchId: branchId,
            skipRRaCall: false,
          );
        } else {
          // Get category information if available
          String? categoryId = item.categoryId;
          String? category = item.category;

          // Create a new variant with the product
          await createProduct(
            skipRRaCall: false,
            bhFId: bhfId ?? "00",
            tinNumber: tin!,
            businessId: ProxyService.box.getBusinessId()!,
            branchId: ProxyService.box.getBranchId()!,
            totWt: item.totWt,
            createItemCode: true,
            netWt: item.netWt,
            spplrNm: item.spplrNm,
            agntNm: item.agntNm,
            invcFcurAmt: item.invcFcurAmt?.toInt() ?? 0,
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

              // Use ProxyService.strategy.addVariant for consistency
              await ProxyService.strategy.addVariant(
                variations: [variant],
                skipRRaCall: false,
                branchId: branchId,
              );
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
  bool isSubscribed({required String feature, required String businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required String businessId,
      int? pageSize = 10,
      String? pk,
      String? sk}) {
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
  void notify({required models.AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  Future<void> patchSocialSetting({required models.Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  FutureOr<List<models.LPermission>> permissions({required String userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  Stream<List<models.Product>> productStreams({String? prodIndex}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Future<List<models.Product>> products({required String branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<models.Product>> productsFuture({required String branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession(
      {required String branchId, int? refreshRate = 5}) {
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
  Future<void> saveComposite({required models.Composite composite}) async {
    try {
      await repository.upsert<Composite>(composite);
      talker.debug(
          "Saved composite: productId=${composite.productId}, variantId=${composite.variantId}, qty=${composite.qty}");
    } catch (e, s) {
      talker.error("Error saving composite: $e");
      talker.error(s.toString());
      rethrow;
    }
  }

  @override
  Future<void> saveDiscount(
      {required String branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<models.Configurations> saveTax(
      {required String configId, required double taxPercentage}) async {
    try {
      // Get existing configuration or create new one
      final existingConfig = (await repository.get<Configurations>(
        query: brick.Query(where: [
          brick.Where('id').isExactly(configId),
        ]),
      ))
          .firstOrNull;

      Configurations config;
      if (existingConfig != null) {
        // Update existing configuration
        config = existingConfig;
        config.taxPercentage = taxPercentage;
      } else {
        // Create new configuration
        config = Configurations(
          id: configId,
          taxPercentage: taxPercentage,
        );
      }

      // Save the configuration
      await repository.upsert<Configurations>(config);
      return config;
    } catch (e, s) {
      talker.error('Error saving tax configuration: $e');
      talker.error(s.toString());
      rethrow;
    }
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
      {required String businessId,
      required models.Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAcess(
      {required String userId,
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
  FutureOr<void> updateNotification(
      {required String notificationId, bool? completed}) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }

  @override
  Future<void> updatePin(
      {required String userId, String? phoneNumber, String? tokenUid}) async {
    try {
      List<Pin> pins = await repository.get<Pin>(
          query: brick.Query(where: [brick.Where('userId').isExactly(userId)]));

      if (pins.isNotEmpty) {
        Pin myPin = pins.first;

        // Update the PIN with new information if provided
        if (phoneNumber != null) {
          myPin.phoneNumber = phoneNumber;
        }

        // Update the tokenUid if provided
        if (tokenUid != null) {
          myPin.tokenUid = tokenUid;
        }

        talker.debug(
            "Updating PIN for userId: $userId with tokenUid: ${tokenUid ?? 'unchanged'}");
        await repository.upsert(myPin);
      } else {
        talker.warning("No PIN found for userId: $userId. Cannot update.");
      }
    } catch (e, s) {
      talker.error("Error updating PIN: $e");
      talker.error(s.toString());
    }
  }

  @override
  FutureOr<void> updateReport({required String reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateUnit(
      {required String unitId, String? name, bool? active, String? branchId}) {
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
            : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: brick.Query(where: [
          brick.Where('branchId').isExactly(currentBranchId),
        ]));
    final decision = payment_status.firstOrNull?.isEnabled ?? false;
    return decision;
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
  Future<CustomerPayments?> getPayment(
      {required String paymentReference}) async {
    return (await repository.get<CustomerPayments>(
            policy: OfflineFirstGetPolicy.alwaysHydrate,
            query: brick.Query(where: [
              brick.Where('transactionId').isExactly(paymentReference),
            ])))
        .firstOrNull;
  }

  @override
  Future<void> updateCredit(Credit credit) async {
    await repository.upsert(credit);
  }

  @override
  Future<Credit?> getCredit({required String branchId}) async {
    return (await repository.get<Credit>(
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
            query: brick.Query(where: [
              brick.Where('branchId').isExactly(branchId),
            ])))
        .firstOrNull;
  }

  Stream<Credit?> credit({required String branchId}) {
    return repository
        .subscribe<Credit>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: brick.Query(where: [
            brick.Where('branchId').isExactly(branchId),
          ]),
        )
        .map((list) => list.isNotEmpty ? list.first : null);
  }

  @override
  Future<List<Country>> countries() async {
    return await repository.get<Country>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
  }

  @override
  Future<double> fetchCost(String branchId) async {
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
  Future<double> fetchProfit(String branchId) async {
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
      policy: OfflineFirstGetPolicy.localOnly,
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
  Stream<double> wholeStockValue({required String branchId}) {
    return repository
        .subscribe<Stock>(
            query: brick.Query(
                where: [brick.Where('branchId').isExactly(branchId)]))
        .map(
            (changes) => changes.fold(0.0, (sum, stock) => sum + stock.value!));
  }

  @override
  Stream<double> totalSales({required String branchId}) async* {
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
  Future<List<BusinessAnalytic>> analytics({required String branchId}) async {
    try {
      final data = await repository.get<BusinessAnalytic>(
        /// since we always want fresh data and assumption is that ai is supposed to work with internet on, then this make sense.
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(
          // limit: 100,
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
  Future<List<models.Stock>> stocks({required String branchId}) async {
    return await repository.get<Stock>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query:
            brick.Query(where: [brick.Where('branchId').isExactly(branchId)]));
  }

  @override
  Future<void> deleteFailedQueue() async {}

  @override
  Future<int> queueLength() async {
    return await repository.availableQueue();
  }

  @override
  Future<List<models.FinanceProvider>> financeProviders() async {
    return await repository.get<FinanceProvider>(
      policy: OfflineFirstGetPolicy.awaitRemote,
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

    // if (foundation.kDebugMode) {
    //   // Mock response in debug mode
    //   print("Running in debug mode - using mock data");
    //   // Simulate a delay to mimic a network request
    //   await Future.delayed(Duration(seconds: 1));

    //   // Create a BusinessInfo object directly from the mock data

    //   return BusinessInfoResponse.fromJson(ebmInitializationMockData).data.info;
    // } else {
    // Call the API in release mode
    final initialisable = await ProxyService.tax
        .initApi(tinNumber: tin, bhfId: bhfId, dvcSrlNo: dvcSrlNo, URI: URI!);
    return initialisable;
    // }
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
    required String branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    required String messageSource,
    String? aiContext,
  }) async {
    final message = Message(
      text: text,
      phoneNumber: phoneNumber,
      branchId: branchId,
      delivered: true,
      role: role,
      messageSource: messageSource,
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
  Future<List<Access>> allAccess({required String userId}) async {
    final userAccessJson = await ProxyService.ditto.getUserAccess(userId);
    return _mapUserAccessToAccessList(userAccessJson);
  }

  List<Access> _mapUserAccessToAccessList(
      Map<String, dynamic>? userAccessJson) {
    if (userAccessJson == null || !userAccessJson.containsKey('businesses')) {
      return [];
    }

    final List<Access> allAccesses = [];
    final List<dynamic> businesses = userAccessJson['businesses'];

    for (final business in businesses) {
      if (business.containsKey('branches')) {
        final List<dynamic> branches = business['branches'];
        for (final branch in branches) {
          if (branch.containsKey('accesses')) {
            final List<dynamic> accesses = branch['accesses'];
            for (final accessJson in accesses) {
              allAccesses.add(
                Access(
                  id: accessJson['id'],
                  branchId: accessJson['branch_id'],
                  businessId: accessJson['business_id'],
                  userId: accessJson['user_id'],
                  featureName: accessJson['feature_name'],
                  userType: accessJson['user_type'],
                  accessLevel: accessJson['access_level'],
                  status: accessJson['status'],
                  createdAt: accessJson['created_at'] != null
                      ? DateTime.tryParse(accessJson['created_at'])
                      : null,
                ),
              );
            }
          }
        }
      }
    }

    return allAccesses;
  }

  @override
  Future<void> cleanDuplicatePlans() async {
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) return;

    List<Plan> plans = await repository.get<Plan>(
      query:
          brick.Query(where: [brick.Where('businessId').isExactly(businessId)]),
    );

    if (plans.length < 2) return;

    // Separate paid and unpaid plans
    final paidPlans =
        plans.where((p) => p.paymentCompletedByUser ?? false).toList();
    final unpaidPlans =
        plans.where((p) => !(p.paymentCompletedByUser ?? false)).toList();

    Plan? planToKeep;

    if (paidPlans.isNotEmpty) {
      // If there are paid plans, keep the most recent one
      paidPlans.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      planToKeep = paidPlans.first;

      // Delete all other paid plans and all unpaid plans
      for (final plan in plans) {
        if (plan.id != planToKeep.id) {
          await repository.delete<Plan>(plan);
        }
      }
    } else if (unpaidPlans.isNotEmpty) {
      // If there are only unpaid plans, keep the most recent one
      unpaidPlans.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
      planToKeep = unpaidPlans.first;

      // Delete all other unpaid plans
      for (final plan in unpaidPlans) {
        if (plan.id != planToKeep.id) {
          await repository.delete<Plan>(plan);
        }
      }
    }
  }

  @override
  Stream<List<models.BusinessAnalytic>> streamRemoteAnalytics(
      {required String branchId}) {
    return repository.subscribeToRealtime<BusinessAnalytic>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: Query(
        where: [Where('branchId').isExactly(branchId)],
        orderBy: [OrderBy('date', ascending: false)],
      ),
    );
  }
}
