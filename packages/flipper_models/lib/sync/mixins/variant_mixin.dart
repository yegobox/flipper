import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin VariantMixin implements VariantInterface {
  Repository get repository;

  @override
  Future<Variant?> getVariant({required String id}) async {
    return (await repository.get<Variant>(
      query: Query(where: [Where('id').isExactly(id)]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    ))
        .firstOrNull;
  }

  @override
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    int? page,
    String? variantId,
    String? name,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemsttsCd,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  }) async {
    try {
      final query = Query(where: [
        if (variantId != null)
          Where('id').isExactly(variantId)
        else if (name != null) ...[
          Where('name').contains(name),
          Where('branchId').isExactly(branchId),
        ] else if (bcd != null) ...[
          Where('bcd').isExactly(bcd),
          Where('branchId').isExactly(branchId),
        ] else if (imptItemsttsCd != null) ...[
          Where('imptItemSttsCd').isExactly(imptItemsttsCd),
          Where('branchId').isExactly(branchId)
        ] else if (purchaseId != null) ...[
          Where('purchaseId').isExactly(purchaseId),
          Where('branchId').isExactly(branchId)
        ] else if (productId != null) ...[
          Where('productId').isExactly(productId),
          Where('branchId').isExactly(branchId)
        ] else ...[
          Where('branchId').isExactly(branchId),

          Where('name').isNot(TEMP_PRODUCT),
          Where('productName').isNot(CUSTOM_PRODUCT),
          // Exclude variants with imptItemSttsCd = 2 (waiting) or 4 (canceled),  3 is approved
          if (!excludeApprovedInWaitingOrCanceledItems) ...[
            Where('imptItemSttsCd').isNot("2"),
            Where('imptItemSttsCd').isNot("4"),
            Where('pchsSttsCd').isNot("04"),
            Where('pchsSttsCd').isNot("01"),
          ],

          /// 01 is waiting for approval.
          if (excludeApprovedInWaitingOrCanceledItems)
            Where('pchsSttsCd').isExactly("01"),

          if (purchaseId != null) Where('purchaseId').isExactly(purchaseId),
          // Apply the purchaseId filter only if includePurchases is true
          if (excludeApprovedInWaitingOrCanceledItems)
            Where('purchaseId').isNot(null),
        ]
      ]);
      List<Variant> variants = await repository.get<Variant>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
        query: query,
      );

      // Pagination logic (if needed)
      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        return variants
            .where((variant) =>
                variant.pchsSttsCd != "01" &&
                variant.pchsSttsCd != "04" &&
                variant.pchsSttsCd != "1")
            .skip(offset)
            .take(itemsPerPage)
            .toList();
      }

      return variants;
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  }) async {
    for (var variant in variations) {
      variant.branchId = branchId;
      await repository.upsert<Variant>(variant);
    }
    return variations.length;
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return await repository.get<IUnit>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      for (Map map in units) {
        final existingUnit = (await repository.get<IUnit>(
                query: Query(where: [
          Where('name').isExactly(map['name']),
          Where('branchId').isExactly(branchId),
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
      String? categoryId,
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
    Category? category =
        await ProxyService.strategy.category(id: categoryId ?? "");
    // loop through all variants and update all with retailPrice and supplyPrice

    for (var i = 0; i < updatables.length; i++) {
      final name = (productName ?? updatables[i].productName)!;
      updatables[i].productName = name;
      if (updatables[i].stock == null) {
        await addStockToVariant(variant: updatables[i]);
      }

      updatables[i].name = name;
      updatables[i].categoryId = category?.id ?? updatables[i].categoryId;
      updatables[i].categoryName = category?.name ?? updatables[i].categoryName;
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
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) async {
    variant.stock = stock;
    return await repository.upsert<Variant>(variant);
  }

  @override
  Future<List<Variant>> getExpiredItems({
    required int branchId,
    int? daysToExpiry,
    int? limit,
  }) async {
    try {
      talker.debug('Fetching expired items for branch $branchId');
      
      // Calculate the date threshold for expiring soon items
      final now = DateTime.now();
      final expiryThreshold = daysToExpiry != null
          ? now.add(Duration(days: daysToExpiry))
          : now;
      
      // Create a query to find variants with expiration dates before or on the threshold
      final query = Query(where: [
        Where('branchId').isExactly(branchId),
        Where('expirationDate').isNot(null),
      ]);
      
      // Get variants from the repository
      final variants = await repository.get<Variant>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );
      
      // Filter variants by expiration date
      final filteredVariants = variants.where((variant) => 
        variant.expirationDate != null && 
        (variant.expirationDate!.isBefore(expiryThreshold) || 
        variant.expirationDate!.isAtSameMomentAs(expiryThreshold))
      ).toList();
      
      // Apply limit if specified
      final limitedVariants = limit != null && limit < filteredVariants.length
          ? filteredVariants.take(limit).toList()
          : filteredVariants;
      
      // Fetch stock data for each variant if needed
      for (final variant in limitedVariants) {
        if (variant.stockId != null && variant.stock == null) {
          try {
            final stockResult = await repository.get<Stock>(
              query: Query(where: [Where('id').isExactly(variant.stockId!)]),
              policy: OfflineFirstGetPolicy.localOnly,
            );
            
            if (stockResult.isNotEmpty) {
              variant.stock = stockResult.first;
            }
          } catch (e) {
            talker.warning('Could not load stock for variant ${variant.id}: $e');
          }
        }
      }
      
      talker.debug('Found ${limitedVariants.length} expired or expiring items');
      return limitedVariants;
    } catch (e, stackTrace) {
      talker.error('Error fetching expired items: $e', e, stackTrace);
      return [];
    }
  }
}
