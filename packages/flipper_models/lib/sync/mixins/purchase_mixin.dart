import 'dart:async';
import 'dart:math';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:collection/collection.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
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
      supplyPrice: item.splyAmt ?? 0,
      retailPrice: item.splyAmt ?? 0,
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

      List<Variant> variantsList;
      RwApiResponse response;

      try {
        // Fetch new data from the API
        response = await ProxyService.tax.selectImportItems(
          tin: tin,
          bhfId: bhfId,
          lastReqDt: lastRequestRecords.first.lastRequestDate ??
              DateTime.now().toYYYYMMddHHmmss(),
          URI: (await ProxyService.box.getServerUrl() ?? ""),
        );

        if (response.data == null || response.data!.itemList == null) {
          variantsList = await variants(
              branchId: ProxyService.box.getBranchId()!, forImportScreen: true);
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
            /// when we receive the item from import we set its status to 2 meaning waiting
            /// the reason why we did not take imptItemSttsCd from incoming item it is because it might be null
            /// or change without us knowing.
            item.imptItemSttsCd = "2";
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
          branchId: ProxyService.box.getBranchId()!, forImportScreen: true);

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
          limit: 1,
          orderBy: [const OrderBy('lastRequestDate', ascending: false)],
          where: [
            brick.Where('branchId').isExactly(activeBranch.id),
            brick.Where('requestType').isExactly("PURCHASE"),
          ],
        ),
      );

      List<Variant> variantsList;

      int branchId = ProxyService.box.getBranchId()!;

      try {
        response = await ProxyService.tax.selectTrnsPurchaseSales(
          URI: url,
          tin: tin,
          bhfId: (await ProxyService.box.bhfId()) ?? "00",
          lastReqDt: lastRequestRecords.first.lastRequestDate ??
              DateTime.now().toYYYYMMddHHmmss(),
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
        // Original Code
        // Save purchases count for logging
        final purchaseCount = response.data?.saleList?.length ?? 0;
        talker.info('Processing $purchaseCount purchases...');

        for (final Purchase purchase in response.data?.saleList ?? []) {
          try {
            purchase.createdAt = DateTime.now().toUtc();
            purchase.branchId = ProxyService.box.getBranchId()!;

            // Save the purchase first to get an ID
            final savedPurchase = await repository.upsert<Purchase>(purchase);
            talker.info(
                'Saved purchase ${savedPurchase.id} with ${purchase.variants?.length ?? 0} variants');

            if (purchase.variants?.isNotEmpty == true) {
              final List<Variant> updatedVariants = [];
              int variantIndex = 0;
              final Set<String> processedBarcodes = {};

              // Create a copy of the variants list to safely iterate
              final variantsToProcess = List<Variant>.from(purchase.variants!);

              // Process each variant in the purchase
              for (final variant in variantsToProcess) {
                variantIndex++;
                try {
                  // Skip if variant has no name
                  if (variant.itemNm?.isEmpty != false) {
                    talker.warning(
                        'Skipping variant with no name at index $variantIndex');
                    continue;
                  }

                  // Generate or use existing barcode
                  final barCode = variant.bcd?.isNotEmpty == true
                      ? variant.bcd!
                      : randomString();

                  // Skip if we've already processed this barcode
                  if (processedBarcodes.contains(barCode)) {
                    talker.info(
                        'Skipping duplicate variant with barcode: $barCode');
                    continue;
                  }
                  processedBarcodes.add(barCode);

                  talker.info(
                      'Processing variant $variantIndex: ${variant.itemNm}');

                  // Create or update product and variant
                  try {
                    final createdProduct = await createProduct(
                      saleListId: savedPurchase.id,
                      businessId: businessId,
                      branchId: branchId,
                      pkgUnitCd: variant.pkgUnitCd,
                      qty: variant.qty ?? 1,
                      tinNumber: tinNumber,
                      itemCd: variant.itemCd,
                      taxAmt: variant.taxAmt,
                      taxblAmt: variant.taxblAmt,
                      taxTyCd: variant.taxTyCd,
                      itemClasses: {barCode: variant.itemClsCd ?? ""},
                      pchsSttsCd: "01",
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
                      purchase: savedPurchase,
                      supplyPrice: variant.splyAmt ?? 0,
                      retailPrice: variant.splyAmt ?? 0,
                      skipRegularVariant: true,
                    );

                    if (createdProduct == null) {
                      talker.error(
                          'Failed to create product for variant: \\${variant.itemNm}');
                      continue;
                    }

                    // Assign the created product's id to the variant
                    variant.productId = createdProduct.id;
                    variant.purchaseId = savedPurchase.id;
                    variant.pchsSttsCd = "01";
                    variant.stockSynchronized = true;
                    variant.imptItemSttsCd = null;
                    variant.bhfId = (await ProxyService.box.bhfId()) ?? "00";
                    variant.tin = business.tinNumber ?? ProxyService.box.tin();
                    variant.modrNm = variant.itemNm;
                    variant.regrNm = variant.itemNm;
                    variant.modrId = randomNumber().toString().substring(0, 5);
                    variant.regrId = randomNumber().toString().substring(0, 5);
                    variant.name = variant.itemNm!;
                    variant.productName = variant.itemNm!;
                    variant.lastTouched = DateTime.now().toUtc();
                    variant.retailPrice = variant.splyAmt;
                    variant.supplyPrice = variant.splyAmt;
                    await repository.upsert<Variant>(variant);
                    // Add to updated variants if successful
                    updatedVariants.add(variant);
                    talker.info(
                        'Successfully processed variant $variantIndex: \\${variant.itemNm}');
                  } catch (e, s) {
                    talker.error(
                        'Error in createProduct for variant \\${variant.itemNm}: $e',
                        s);
                    continue; // Continue with next variant on error
                  }
                } catch (e, s) {
                  talker.error(
                      'Unexpected error processing variant $variantIndex', s);
                  continue;
                }
              }

              // Update purchase with successfully processed variants
              if (updatedVariants.isNotEmpty) {
                try {
                  // Only update variants if we have some
                  savedPurchase.variants = updatedVariants;
                  final updatedPurchase =
                      await repository.upsert<Purchase>(savedPurchase);
                  talker.info(
                      'Successfully updated purchase ${updatedPurchase.id} with ${updatedVariants.length} variants');
                } catch (e, s) {
                  talker.error('Error updating purchase with variants: $e', s);
                  throw Exception('Failed to update purchase with variants');
                }
              } else {
                talker.warning(
                    'No variants were successfully processed for purchase ${savedPurchase.id}');
              }
            }
            //here
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
            );
          } catch (e, s) {
            talker.error('Error processing purchase: $e', s);
            // Continue with next purchase even if one fails
            continue;
          }
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

  @override
  Future<List<Variant>> allImportsToDate() async {
    final branchId = ProxyService.box.getBranchId()!;
    return await repository.get<Variant>(
      query: brick.Query(
        where: [
          Where('branchId').isExactly(branchId),
          Where('imptItemSttsCd').isExactly('2'),
          Or('branchId').isExactly(branchId),
          Where('imptItemSttsCd').isExactly("3"),
          Where('dclNo').isNot(null),
        ],
      ),
    );
  }

  @override
  Future<List<PurchaseReportItem>> allPurchasesToDate() async {
    final branchId = ProxyService.box.getBranchId()!;

    // First, get all purchases for the branch
    final purchases = await repository.get<Purchase>(
      query: brick.Query(
        where: [brick.Where('branchId').isExactly(branchId)],
        orderBy: [brick.OrderBy('createdAt', ascending: false)],
      ),
    );

    if (purchases.isEmpty) return [];

    // Get all variants that might be associated with these purchases
    final variants = await repository.get<Variant>(
      query: brick.Query(
        where: [
          brick.Where('branchId').isExactly(branchId),
          brick.Where('pchsSttsCd').isExactly("01"),
          brick.Or('branchId').isExactly(branchId),
          brick.Where('pchsSttsCd').isExactly("02"),
          brick.Or('branchId').isExactly(branchId),
          brick.Where('pchsSttsCd').isExactly("04"),
        ],
      ),
    );

    // Create a map of purchase ID to its variants
    final purchaseVariants = <String, List<Variant>>{};
    for (final variant in variants) {
      // Assuming purchase.variants is a list of variants
      for (final purchase in purchases) {
        if (purchase.variants?.any((v) => v.id == variant.id) ?? false) {
          purchaseVariants.putIfAbsent(purchase.id, () => []).add(variant);
        }
      }
    }

    // Create report items
    return purchases
        .where((purchase) => purchaseVariants.containsKey(purchase.id))
        .map((purchase) => PurchaseReportItem(
              variant: purchaseVariants[purchase.id]!
                  .first, // or handle multiple variants as needed
              purchase: purchase,
            ))
        .toList();
  }
}
