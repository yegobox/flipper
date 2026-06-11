import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:flipper_services/kafka_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

/// Ditto-backed import/purchase (Capella). Overrides [PurchaseMixin] repository
/// reads/writes so mesh state is authoritative; SQLite is mirrored for sync.
mixin CapellaPurchaseMixin on PurchaseMixin implements PurchaseInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  dynamic _dittoOrThrow() {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }
    return ditto;
  }

  Future<void> _upsertPurchaseDitto(Purchase purchase) async {
    final ditto = _dittoOrThrow();
    final doc = await PurchaseDittoAdapter.instance.toDittoDocument(purchase);
    await ditto.store.execute(
      'INSERT INTO purchases DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
    await repository.upsert<Purchase>(purchase);
  }

  Future<List<Purchase>> _purchasesFromDitto({
    String? branchId,
    String? spplrTin,
    int? spplrInvcNo,
    String? id,
    bool orderByCreatedAtDesc = false,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];

    String query;
    final args = <String, dynamic>{};

    if (id != null) {
      query = 'SELECT * FROM purchases WHERE _id = :id OR id = :id LIMIT 1';
      args['id'] = id;
    } else {
      query = 'SELECT * FROM purchases WHERE branchId = :branchId';
      args['branchId'] = branchId;
      if (spplrTin != null) {
        query += ' AND spplrTin = :spplrTin';
        args['spplrTin'] = spplrTin;
      }
      if (spplrInvcNo != null) {
        query += ' AND spplrInvcNo = :spplrInvcNo';
        args['spplrInvcNo'] = spplrInvcNo;
      }
      if (orderByCreatedAtDesc) {
        query += ' ORDER BY createdAt DESC';
      }
    }

    final result = await ditto.store.execute(query, arguments: args);
    final purchases = <Purchase>[];
    for (final item in result.items) {
      final purchase = await PurchaseDittoAdapter.instance.fromDittoDocument(
        Map<String, dynamic>.from(item.value),
      );
      if (purchase != null) purchases.add(purchase);
    }
    return purchases;
  }

  Future<void> _upsertImportPurchaseDateDitto(
    ImportPurchaseDates record,
  ) async {
    final ditto = _dittoOrThrow();
    final doc = await ImportPurchaseDatesDittoAdapter.instance.toDittoDocument(
      record,
    );
    await ditto.store.execute(
      'INSERT INTO import_purchase_dates DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
    await repository.upsert<ImportPurchaseDates>(record);
  }

  Future<ImportPurchaseDates?> _latestImportDateDitto({
    required String branchId,
    required String requestType,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;

    final result = await ditto.store.execute(
      'SELECT * FROM import_purchase_dates '
      'WHERE branchId = :branchId AND requestType = :requestType '
      'ORDER BY lastRequestDate DESC LIMIT 1',
      arguments: {'branchId': branchId, 'requestType': requestType},
    );
    if (result.items.isEmpty) return null;

    return ImportPurchaseDatesDittoAdapter.instance.fromDittoDocument(
      Map<String, dynamic>.from(result.items.first.value),
    );
  }

  Future<void> _upsertStockDitto(Stock stock) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      'INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': stock.toJson()},
    );
    await repository.upsert<Stock>(stock);
  }

  Future<void> _upsertVariantDitto(Variant variant) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      'INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': variant.toFlipperJson()},
    );
    await repository.upsert<Variant>(variant);
  }

  Future<List<Variant>> _variantsFromDitto({
    required String query,
    required Map<String, dynamic> arguments,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];

    final result = await ditto.store.execute(query, arguments: arguments);
    final variants = <Variant>[];
    for (final item in result.items) {
      try {
        variants.add(Variant.fromJson(Map<String, dynamic>.from(item.value)));
      } catch (e, st) {
        talker.warning('CapellaPurchase: variant parse failed: $e\n$st');
      }
    }
    return variants;
  }

  Future<List<Variant>> _variantsForPurchaseId(String purchaseId) async {
    var variants = await _variantsFromDitto(
      query: 'SELECT * FROM variants WHERE purchaseId = :purchaseId',
      arguments: {'purchaseId': purchaseId},
    );
    if (variants.isNotEmpty) return variants;

    variants = await repository.get<Variant>(
      query: Query(where: [Where('purchaseId').isExactly(purchaseId)]),
      policy: OfflineFirstGetPolicy.localOnly,
    );
    for (final variant in variants) {
      try {
        await _upsertVariantDitto(variant);
      } catch (e) {
        talker.warning('Failed to seed variant ${variant.id} to Ditto: $e');
      }
    }
    return variants;
  }

  /// Branch purchases from Ditto, falling back to SQLite (pre-Capella rows).
  /// Always hydrates [Purchase.variants] — required by the purchase UI.
  Future<List<Purchase>> _purchasesForBranch(String branchId) async {
    var purchases = await _purchasesFromDitto(branchId: branchId);
    if (purchases.isEmpty) {
      purchases = await repository.get<Purchase>(
        query: Query(where: [Where('branchId').isExactly(branchId)]),
        policy: OfflineFirstGetPolicy.localOnly,
      );
      for (final purchase in purchases) {
        try {
          await _upsertPurchaseDitto(purchase);
        } catch (e) {
          talker.warning('Failed to seed purchase ${purchase.id} to Ditto: $e');
        }
      }
    }
    if (purchases.isEmpty) return [];

    final enriched = await Future.wait(purchases.map(_processPurchaseDitto));
    return enriched.whereType<Purchase>().toList();
  }

  Future<bool> _purchaseInvoiceExists({
    required String branchId,
    required String spplrTin,
    required int spplrInvcNo,
  }) async {
    final fromDitto = await _purchasesFromDitto(
      branchId: branchId,
      spplrTin: spplrTin,
      spplrInvcNo: spplrInvcNo,
    );
    if (fromDitto.isNotEmpty) return true;

    final fromRepo = await repository.get<Purchase>(
      query: Query(
        where: [
          Where('spplrTin').isExactly(spplrTin),
          Where('spplrInvcNo').isExactly(spplrInvcNo),
          Where('branchId').isExactly(branchId),
        ],
      ),
      policy: OfflineFirstGetPolicy.localOnly,
    );
    return fromRepo.isNotEmpty;
  }

  Future<void> _upsertSupplierDitto(Supplier supplier) async {
    final ditto = _dittoOrThrow();
    final doc = await SupplierDittoAdapter.instance.toDittoDocument(supplier);
    await ditto.store.execute(
      'INSERT INTO suppliers DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
    await repository.upsert<Supplier>(supplier);
  }

  Future<bool> _supplierExistsDitto({
    required String custNm,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return false;

    final result = await ditto.store.execute(
      'SELECT * FROM suppliers WHERE custNm = :custNm AND branchId = :branchId LIMIT 1',
      arguments: {'custNm': custNm, 'branchId': branchId},
    );
    return result.items.isNotEmpty;
  }

  @override
  Future<String?> getLastRequestDate({
    required String branchId,
    required String requestType,
  }) async {
    final record = await _latestImportDateDitto(
      branchId: branchId,
      requestType: requestType,
    );
    return record?.lastRequestDate;
  }

  @override
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
  }) async {
    try {
      final ebm = await ProxyService.strategy.ebm(
        branchId: ProxyService.box.getBranchId()!,
      );
      final activeBranch = await branch(
        serverId: ProxyService.box.getBranchId()!,
      );
      if (activeBranch == null) throw Exception('Active branch not found');
      final branchId = ProxyService.box.getBranchId()!;

      final business = await getBusinessById(
        businessId: ProxyService.box.getBusinessId()!,
      );
      if (business == null) throw Exception('Business details not found');

      final lastRecord = await _latestImportDateDitto(
        branchId: activeBranch.id,
        requestType: 'IMPORT',
      );

      final lastReqDt =
          lastRecord?.lastRequestDate ?? DateTime.now().toYYYYMMddHHmmss();
      final uri = ebm?.taxServerUrl ?? '';

      final response = await ProxyService.tax.selectImportItems(
        tin: tin,
        bhfId: bhfId,
        lastReqDt: lastReqDt,
        URI: uri,
      );

      if (response.data == null ||
          response.data!.itemList == null ||
          response.data!.itemList!.isEmpty) {
        try {
          KafkaService().sendMessage('There is no search result.');
        } catch (e) {
          talker.debug('Error sending message to Kafka: $e');
        }
        final paged = await variants(
          branchId: branchId,
          forImportScreen: true,
          taxTyCds: ebm?.vatEnabled == true
              ? ['A', 'B', 'C', 'TT']
              : ['D', 'TT'],
        );
        return List<Variant>.from(paged.variants);
      }

      final saveVariantTasks = <Future<void>>[];
      for (final item in response.data!.itemList!) {
        item.imptItemSttsCd = '2';
        item.itemClsCd = '2';
        item.taxTyCd = ebm?.vatEnabled == true ? 'B' : 'D';
        item.color = randomizeColor();
        item.itemCd = '2';
        saveVariantTasks.add(
          saveVariant(item, business, activeBranch.id, skipRRaCall: true),
        );
      }
      await Future.wait(saveVariantTasks);

      if (!(ProxyService.box.enableDebug() ?? false)) {
        await _upsertImportPurchaseDateDitto(
          ImportPurchaseDates(
            id: lastRecord?.id,
            lastRequestDate: DateTime.now().toYYYYMMddHHmmss(),
            branchId: activeBranch.id,
            requestType: 'IMPORT',
          ),
        );
      }

      final paged = await variants(
        branchId: branchId,
        forImportScreen: true,
        taxTyCds: ebm?.vatEnabled == true ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'],
      );
      return List<Variant>.from(paged.variants);
    } catch (e, stackTrace) {
      talker.error('Error in selectImportItems (Capella): $e', stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Purchase>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    String? pchsSttsCd,
  }) async {
    try {
      final ebm = await ProxyService.strategy.ebm(
        branchId: ProxyService.box.getBranchId()!,
      );
      final activeBranch = await branch(
        serverId: ProxyService.box.getBranchId()!,
      );
      if (activeBranch == null) throw Exception('Active branch not found');

      final business = await getBusinessById(
        businessId: ProxyService.box.getBusinessId()!,
      );
      if (business == null) throw Exception('Business details not found');

      final businessId = ProxyService.box.getBusinessId()!;
      final tinNumber = (await effectiveTin(business: business))!;
      final branchId = ProxyService.box.getBranchId()!;

      final lastRecord = await _latestImportDateDitto(
        branchId: activeBranch.id,
        requestType: 'PURCHASE',
      );

      final RwApiResponse response;
      try {
        response = await ProxyService.tax.selectTrnsPurchaseSales(
          URI: url,
          tin: tinNumber,
          bhfId: ebm?.bhfId ?? '00',
          lastReqDt:
              lastRecord?.lastRequestDate ?? DateTime.now().toYYYYMMddHHmmss(),
        );
      } catch (apiError, st) {
        talker.warning(
          'RRA purchase fetch failed; loading local purchases: $apiError',
          st,
        );
        return _purchasesForBranch(branchId);
      }

      if (response.data?.saleList?.isEmpty ?? true) {
        try {
          KafkaService().sendMessage('There is no search result.');
        } catch (e) {
          talker.debug('Error sending message to Kafka: $e');
        }
        return _purchasesForBranch(branchId);
      }

      final purchaseCount = response.data?.saleList?.length ?? 0;
      talker.info('Processing $purchaseCount purchases (Capella)...');

      for (final purchase in response.data?.saleList ?? <Purchase>[]) {
        try {
          final exists = await _purchaseInvoiceExists(
            branchId: branchId,
            spplrTin: purchase.spplrTin,
            spplrInvcNo: purchase.spplrInvcNo,
          );
          if (exists) {
            talker.info(
              'Skipping purchase invoice ${purchase.spplrInvcNo} from TIN '
              '${purchase.spplrTin}: already saved in Ditto',
            );
            continue;
          }

          await processIncomingPurchase(
            purchase: purchase,
            branchId: branchId,
            businessId: businessId,
            tinNumber: tinNumber,
            bhfId: bhfId,
            ebm: ebm,
          );

          if (!(ProxyService.box.enableDebug() ?? false)) {
            await _upsertImportPurchaseDateDitto(
              ImportPurchaseDates(
                id: lastRecord?.id,
                branchId: activeBranch.id,
                requestType: 'PURCHASE',
                lastRequestDate: DateTime.now().toYYYYMMddHHmmss(),
              ),
            );
          }
        } catch (e, s) {
          talker.error('Error processing purchase (Capella): $e', s);
          continue;
        }
      }

      return _purchasesForBranch(branchId);
    } catch (e, stackTrace) {
      talker.error('Error in selectPurchases (Capella): $e', stackTrace);
      rethrow;
    }
  }

  @override
  Future<Purchase> processIncomingPurchase({
    required Purchase purchase,
    required String branchId,
    required String businessId,
    required int tinNumber,
    required String bhfId,
    Ebm? ebm,
  }) async {
    purchase.createdAt = DateTime.now().toUtc();
    purchase.branchId = branchId;

    await _upsertPurchaseDitto(purchase);
    talker.info(
      'Saved purchase ${purchase.id} to Ditto with '
      '${purchase.variants?.length ?? 0} variants',
    );

    final saveVariantTasks = <Future<void>>[];
    final processedBarcodes = <String>{};

    for (final variant in purchase.variants ?? <Variant>[]) {
      if (variant.itemNm?.isEmpty != false) {
        talker.warning('Skipping variant with no name: ${variant.id}');
        continue;
      }

      final barCode = variant.bcd?.isNotEmpty == true
          ? variant.bcd!
          : randomString();
      if (processedBarcodes.contains(barCode)) {
        talker.info('Skipping duplicate variant with barcode: $barCode');
        continue;
      }
      processedBarcodes.add(barCode);

      saveVariantTasks.add(() async {
        if (variant.stock != null) {
          await _upsertStockDitto(variant.stock!);
        }

        final createdProduct = await createProduct(
          skipRRaCall: true,
          saleListId: purchase.id,
          businessId: businessId,
          branchId: branchId,
          pkgUnitCd: variant.pkgUnitCd,
          qty: variant.qty ?? 1,
          tinNumber: tinNumber,
          itemCd: variant.itemCd,
          taxAmt: variant.taxAmt,
          taxblAmt: variant.taxblAmt,
          taxTyCd: variant.taxTyCd,
          itemClasses: {barCode: variant.itemClsCd ?? ''},
          pchsSttsCd: '01',
          splyAmt: variant.splyAmt,
          pkg: variant.pkg,
          qtyUnitCd: variant.qtyUnitCd,
          bhFId: bhfId,
          createItemCode: variant.itemCd?.isEmpty == true,
          product: Product(
            color: randomizeColor(),
            name: variant.itemNm!,
            barCode: barCode,
            lastTouched: DateTime.now().toUtc(),
            createdAt: DateTime.now().toUtc(),
            branchId: branchId,
            businessId: businessId,
            spplrNm: purchase.spplrNm,
          ),
          purchase: purchase,
          supplyPrice: variant.splyAmt ?? 0,
          retailPrice: variant.splyAmt ?? 0,
          skipRegularVariant: true,
        );

        if (createdProduct == null) {
          talker.error(
            'Failed to create product for variant: ${variant.itemNm}',
          );
          return;
        }

        variant.productId = createdProduct.id;
        variant.purchaseId = purchase.id;
        variant.pchsSttsCd = '01';
        variant.unit = 'Per Item';
        variant.taxName = variant.taxTyCd ?? 'B';
        variant.isrcAmt = null;
        variant.useYn = 'N';
        variant.spplrItemCd = variant.itemCd;
        variant.spplrNm = purchase.spplrNm;
        variant.color = randomizeColor();
        variant.itemTyCd = '2';
        variant.spplrItemClsCd = variant.itemClsCd;
        variant.orgnNatCd = 'RW';
        variant.stockSynchronized = true;
        variant.isrcAplcbYn = 'N';
        variant.imptItemSttsCd = null;
        variant.bhfId = ebm?.bhfId ?? '00';
        variant.tin = tinNumber;
        variant.modrNm = variant.itemNm;
        variant.regrNm = variant.itemNm;
        variant.modrId = randomNumber().toString().substring(0, 5);
        variant.regrId = randomNumber().toString().substring(0, 5);
        variant.name = variant.itemNm!;
        variant.productName = variant.itemNm!;
        variant.lastTouched = DateTime.now().toUtc();
        variant.retailPrice = variant.splyAmt;
        variant.supplyPrice = variant.splyAmt;
        variant.branchId = branchId;
        await _upsertVariantDitto(variant);
      }());
    }

    await Future.wait(saveVariantTasks);
    purchase.variants = purchase.variants;
    return purchase;
  }

  @override
  Future<Purchase> saveManualPurchase({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
  }) async {
    final business = await getBusinessById(
      businessId: ProxyService.box.getBusinessId()!,
    );
    if (business == null) throw Exception('Business details not found');
    final businessId = ProxyService.box.getBusinessId()!;
    final tinNumber = (await effectiveTin(business: business))!;
    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    final bhfId = ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? '00';

    if (supplier != null && (supplier.custNm?.isNotEmpty ?? false)) {
      final exists = await _supplierExistsDitto(
        custNm: supplier.custNm!,
        branchId: branchId,
      );
      if (!exists) {
        await _upsertSupplierDitto(supplier);
      }
    }

    return processIncomingPurchase(
      purchase: purchase,
      branchId: branchId,
      businessId: businessId,
      tinNumber: tinNumber,
      bhfId: bhfId,
      ebm: ebm,
    );
  }

  Future<Purchase?> _processPurchaseDitto(Purchase purchase) async {
    final allVariantsForPurchase = await _variantsForPurchaseId(purchase.id);
    purchase.variants = allVariantsForPurchase;

    final newHasUnapprovedVariant = allVariantsForPurchase.any(
      (variant) => variant.pchsSttsCd == '01',
    );

    if (purchase.hasUnApprovedVariant != newHasUnapprovedVariant) {
      purchase.hasUnApprovedVariant = newHasUnapprovedVariant;
      await _upsertPurchaseDitto(purchase);
      return purchase;
    }
    return purchase;
  }

  @override
  Future<List<Purchase>> purchases() async {
    final branchId = ProxyService.box.getBranchId()!;
    return _purchasesForBranch(branchId);
  }

  @override
  FutureOr<Purchase?> getPurchase({required String id}) async {
    final purchases = await _purchasesFromDitto(id: id);
    return purchases.firstOrNull;
  }

  @override
  Future<void> hydrateDate({required String branchId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    await ditto.store.execute(
      'SELECT * FROM import_purchase_dates WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
  }

  @override
  Future<List<Variant>> allImportsToDate() async {
    final branchId = ProxyService.box.getBranchId()!;
    return _variantsFromDitto(
      query:
          'SELECT * FROM variants WHERE branchId = :branchId '
          "AND (imptItemSttsCd = '2' OR (imptItemSttsCd = '3' AND dclNo IS NOT NULL))",
      arguments: {'branchId': branchId},
    );
  }

  @override
  Future<List<PurchaseReportItem>> allPurchasesToDate() async {
    final branchId = ProxyService.box.getBranchId()!;

    final purchases = await _purchasesFromDitto(
      branchId: branchId,
      orderByCreatedAtDesc: true,
    );
    if (purchases.isEmpty) return [];

    final variants = await _variantsFromDitto(
      query:
          'SELECT * FROM variants WHERE branchId = :branchId '
          "AND pchsSttsCd IN ('01', '02', '04') AND purchaseId IS NOT NULL",
      arguments: {'branchId': branchId},
    );

    final purchaseVariants = <String, List<Variant>>{};
    for (final variant in variants) {
      final purchaseId = variant.purchaseId;
      if (purchaseId == null || purchaseId.isEmpty) continue;
      purchaseVariants.putIfAbsent(purchaseId, () => []).add(variant);
    }

    return purchases
        .where((purchase) => purchaseVariants.containsKey(purchase.id))
        .map(
          (purchase) => PurchaseReportItem(
            variant: purchaseVariants[purchase.id]!.first,
            purchase: purchase,
          ),
        )
        .toList();
  }
}
