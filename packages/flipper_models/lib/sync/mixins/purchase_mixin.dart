import 'dart:async';
import 'dart:math';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../interfaces/purchase_interface.dart';
import '../interfaces/branch_interface.dart';
import '../interfaces/business_interface.dart';
import '../interfaces/variant_interface.dart';
import '../interfaces/product_interface.dart';

mixin PurchaseMixin
    implements
        PurchaseInterface,
        BranchInterface,
        BusinessInterface,
        VariantInterface,
        ProductInterface {
  Repository get repository;
  Talker get talker;
  String get apihub;

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
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastRequestdate,
  }) async {
    try {
      int branchId;

      // Fetch active branch
      final activeBranch =
          await branch(serverId: ProxyService.box.getBranchId()!);
      if (activeBranch == null) throw Exception("Active branch not found");
      branchId = ProxyService.box.getBranchId()!;

      // Fetch business details
      final business =
          await getBusinessById(businessId: ProxyService.box.getBusinessId()!);
      if (business == null) throw Exception("Business details not found");

      // Fetch last request date for import items
      final lastRequestRecords = await repository.get<ImportPurchaseDates>(
        policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: brick.Query(
          orderBy: [const OrderBy('lastRequestDate', ascending: false)],
          where: [
            brick.Where('branchId').isExactly(activeBranch.id),
            brick.Where('requestType').isExactly("IMPORT"),
          ],
        ),
      );

      // Determine lastReqDt
      if (lastRequestRecords.isNotEmpty) {
        lastRequestdate = lastRequestRecords.first.lastRequestDate!;
      } else {
        // Default to today's date if no saved date found
        lastRequestdate = DateTime.now().toYYYYMMddHHmmss();
      }

      List<Variant> variantsList;
      RwApiResponse response;

      try {
        // Fetch new data from the API
        response = await ProxyService.tax.selectImportItems(
          tin: tin,
          bhfId: bhfId,
          lastReqDt: lastRequestdate,
          URI: (await ProxyService.box.getServerUrl() ?? ""),
        );

        if (response.data == null || response.data!.itemList == null) {
          variantsList = await variants(
            branchId: ProxyService.box.getBranchId()!,
            imptItemSttsCd: "2",
            excludeApprovedInWaitingOrCanceledItems: false,
          );
          print(
              "Total variants found: ${variantsList.length}"); // Log total variants
          return variantsList;
        }
      } catch (apiError) {
        rethrow; // If API call fails for any reason, propagate the exception.
      }

      // Save the last request date AND Process Items only if the API request was successful
      if (response.data!.itemList!.isNotEmpty) {
        // Save the last request date
        try {
          await repository.upsert<ImportPurchaseDates>(
              ImportPurchaseDates(
                lastRequestDate: DateTime.now().toYYYYMMddHHmmss(),
                // lastRequestDate: response.resultDt,
                branchId: activeBranch.id,
                requestType: "IMPORT",
              ),
              query: brick.Query(
                where: [
                  brick.Where('branchId').isExactly(branchId),
                ],
              ));
        } catch (saveError) {}

        for (final item in response.data!.itemList!) {
          print("Processing item with taskCd: ${item.taskCd}"); // Log taskCd

          if (item.imptItemSttsCd!.isNotEmpty) {
            print("Saving variant with taskCd: ${item.taskCd}");
            await saveVariant(item, business, activeBranch.serverId!);
          } else {
            print(
                "Item with taskCd ${item.taskCd} has empty imptItemSttsCd. Skipping.");
          }
        }
      }

      // Return the newly imported variants OR existing variants if no API call was made
      variantsList = await variants(
        branchId: ProxyService.box.getBranchId()!,
        imptItemSttsCd: "2",
        excludeApprovedInWaitingOrCanceledItems: true,
      );

      return variantsList;
    } catch (e, stackTrace) {
      print("Error in selectImportItems: $e\n$stackTrace");
      rethrow;
    }
  }

  @override
  Future<List<Variant>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    required String lastRequestdate,
    String? pchsSttsCd,
  }) async {
    try {
      RwApiResponse response;
      // Fetch active branch
      final activeBranch =
          await branch(serverId: ProxyService.box.getBranchId()!);
      if (activeBranch == null) throw Exception("Active branch not found");

      // Fetch business details
      final business =
          await getBusinessById(businessId: ProxyService.box.getBusinessId()!);
      if (business == null) throw Exception("Business details not found");

      final businessId = ProxyService.box.getBusinessId()!;

      final tinNumber = business.tinNumber!;

      // Fetch last request date for purchases
      final lastRequestRecords = await repository.get<ImportPurchaseDates>(
        policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: brick.Query(
          orderBy: [const OrderBy('lastRequestDate', ascending: false)],
          where: [
            brick.Where('branchId').isExactly(activeBranch.id),
            brick.Where('requestType').isExactly("PURCHASE"),
          ],
        ),
      );

      // Determine lastReqDt
      if (lastRequestRecords.isNotEmpty) {
        lastRequestdate = lastRequestRecords.first.lastRequestDate!;
      } else {
        // Default to today's date if no saved date found
        lastRequestdate = DateTime.now().toYYYYMMddHHmmss();
      }

      List<Variant> variantsList;

      int branchId = ProxyService.box.getBranchId()!;

      try {
        response = await ProxyService.tax.selectTrnsPurchaseSales(
          URI: url,
          tin: tin,
          bhfId: (await ProxyService.box.bhfId()) ?? "00",
          lastReqDt: lastRequestdate,
        );

        if (response.data?.saleList?.isEmpty ?? false) {
          variantsList = await variants(
            branchId: branchId,
            forPurchaseScreen: true,
            pchsSttsCd: pchsSttsCd,
          );
          return variantsList;
        }
      } catch (apiError) {
        rethrow;
      }

      // Process purchases
      if (response.data?.saleList?.isNotEmpty ?? false) {
        // Only process if there's data
        List<Future<void>> futures = []; // Explicitly typed for clarity
        for (final Purchase purchase in response.data?.saleList ?? []) {
          // Ensure createdAt is set from API or fallback to now

          purchase.createdAt = DateTime.now();

          if (purchase.variants != null) {
            // Check if variants is null. Protect from null exception
            for (final variant in purchase.variants!) {
              purchase.branchId = ProxyService.box.getBranchId()!;
              // Using non-null assertion operator safely because of previous null check
              futures.add(() async {
                // Wrap in an explicit `async` function for safety.
                try {
                  final barCode = variant.bcd?.isNotEmpty == true
                      ? variant.bcd!
                      : randomNumber().toString();

                  talker.warning("How ofthen we are in this branch");
                  await createProduct(
                    saleListId: purchase.id,
                    businessId: businessId,
                    branchId: branchId,
                    pkgUnitCd: variant.pkgUnitCd,
                    qty: variant.qty ?? 1,
                    tinNumber: tinNumber,
                    taxblAmt: variant.taxblAmt,
                    bhFId: (await ProxyService.box.bhfId()) ?? "00",
                    itemCd: variant.itemCd,
                    spplrItemCd: variant.itemCd,
                    itemClasses: {barCode: variant.itemClsCd ?? ""},
                    supplyPrice: variant.splyAmt!,
                    retailPrice: variant.prc!,
                    purchase: purchase,
                    ebmSynced: false,
                    createItemCode: variant.itemCd?.isEmpty == true,
                    taxTypes: {barCode: variant.taxTyCd!},
                    totAmt: variant.totAmt,
                    taxAmt: variant.taxAmt,
                    pchsSttsCd: "01",
                    product: Product(
                      color: randomizeColor(),
                      name: variant.itemNm ?? variant.name,
                      lastTouched: DateTime.now().toUtc(),
                      branchId: branchId,
                      businessId: businessId,
                      createdAt: DateTime.now().toUtc(),
                      spplrNm: purchase.spplrNm,
                      barCode: barCode,
                    ),
                  );
                } catch (variantError, variantStackTrace) {
                  print(
                      "Error processing variant: $variantError\n$variantStackTrace");
                  talker.error("Error processing variant", variantError,
                      variantStackTrace);
                  // Handle the error.  Perhaps log it or increment an error counter.
                  //Critically:  Do NOT rethrow here. You want to continue processing other variants.
                }
              }());
            }
          }
        }
        // Await all variant processing, even if some failed.
        await Future.wait(futures);

        // Save the actual request time *after* successful processing
        try {
          final newImportDate = ImportPurchaseDates(
            branchId: activeBranch.id,
            requestType: "PURCHASE",
            // lastRequestDate: response.resultDt,
            lastRequestDate: DateTime.now().toYYYYMMddHHmmss(),
          );

          await repository.upsert<ImportPurchaseDates>(
            newImportDate,
            query: brick.Query(
              where: [
                brick.Where('branchId').isExactly(activeBranch.id),
                brick.Where('requestType').isExactly("PURCHASE"),
              ],
            ),
          ); // Upsert ensures either creates or updates
        } catch (saveError, saveStackTrace) {
          print(
              "Error saving ImportPurchaseDates: $saveError\n$saveStackTrace");
          talker.error(
              "Error saving ImportPurchaseDates", saveError, saveStackTrace);
        }
      }

      variantsList = await variants(
        branchId: branchId,
        forPurchaseScreen: true,
      );

      return variantsList;
    } catch (e, stackTrace) {
      print("Error in selectPurchases: $e\n$stackTrace");
      rethrow;
    }
  }

  String randomizeColor() {
    return '#${(Random().nextInt(0x1000000) | 0x800000).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  Future<List<Purchase>> purchases() async {
    // Fetch all purchases with unapproved variants
    final purchases = await repository.get<Purchase>(
      query: brick.Query(
        where: [
          brick.Where('branchId').isExactly(ProxyService.box.getBranchId()!)
        ],
      ),
    );

    if (purchases.isEmpty) return [];

    List<Future<Purchase?>> purchaseUpdates = [];

    for (final purchase in purchases) {
      purchaseUpdates.add(_processPurchase(purchase));
    }

    // Wait for all updates to complete
    final updatedPurchases = await Future.wait(purchaseUpdates);

    // Remove null values and return the updated list
    return updatedPurchases.whereType<Purchase>().toList();
  }

  Future<Purchase?> _processPurchase(Purchase purchase) async {
    // Fetch all variants for the current purchase
    final allVariantsForPurchase = await repository.get<Variant>(
      query: brick.Query(
        where: [brick.Where('purchaseId').isExactly(purchase.id)],
      ),
    );

    // Assign the filtered list to purchase.variants
    // This is crucial for the PurchaseTable UI
    purchase.variants = allVariantsForPurchase;

    // Determine if the purchase has any unapproved variants based on the relevant variants
    bool newHasUnapprovedVariant =
        allVariantsForPurchase.any((variant) => variant.pchsSttsCd == '01');

    if (purchase.hasUnApprovedVariant != newHasUnapprovedVariant) {
      // If the status changed, update the purchase object directly
      purchase.hasUnApprovedVariant = newHasUnapprovedVariant;
      // Upsert the modified purchase object
      await repository.upsert<Purchase>(purchase);
      // The 'purchase' instance is now updated in the database and in memory.
      // It already has purchase.variants = relevantVariants from the lines above.
      return purchase;
    } else {
      // If no change in hasUnApprovedVariant, still return the purchase with its variants populated.
      // purchase.variants was already set earlier.
      return purchase;
    }
  }

  @override
  FutureOr<Purchase?> getPurchase({
    required String id,
  }) async {
    final purchase = await repository.get<Purchase>(
      query: brick.Query(
        where: [brick.Where('id').isExactly(id)],
      ),
    );
    return purchase.firstOrNull;
  }

  @override
  Future<void> hydrateDate({required String branchId}) async {
    await repository.get<ImportPurchaseDates>(
      policy: brick.OfflineFirstGetPolicy.alwaysHydrate,
      query: brick.Query(
        where: [brick.Where('branchId').isExactly(branchId)],
      ),
    );
  }
}
