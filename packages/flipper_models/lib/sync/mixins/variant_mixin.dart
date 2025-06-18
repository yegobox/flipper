import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/db_model_export.dart';
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
    String? pchsSttsCd,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemSttsCd,
    bool forPurchaseScreen = false,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  }) async {
    try {
      final List<WhereCondition> conditions = [];

      if (forPurchaseScreen) {
        conditions.addAll([
          // (branchId = ? AND pchsSttsCd = '01')
          Where('branchId').isExactly(branchId),
          Where('pchsSttsCd').isExactly("01"),

          // OR (branchId = ? AND pchsSttsCd = '02')
          Or('branchId').isExactly(branchId),
          Where('pchsSttsCd').isExactly("02"),

          // OR (branchId = ? AND pchsSttsCd = '04')
          Or('branchId').isExactly(branchId),
          Where('pchsSttsCd').isExactly("04"),
        ]);
      } else if (variantId != null) {
        conditions.add(Where('id').isExactly(variantId));
      } else if (name != null && name.isNotEmpty) {
        conditions.addAll([
          Where('name').contains(name),
          Where('branchId').isExactly(branchId),
        ]);
      } else if (bcd != null) {
        conditions.addAll([
          Where('bcd').isExactly(bcd),
          Where('branchId').isExactly(branchId),
        ]);
      } else if (imptItemSttsCd != null) {
        conditions.addAll([
          Where('imptItemSttsCd').isExactly(imptItemSttsCd),
          Where('branchId').isExactly(branchId),
        ]);
      } else if (purchaseId != null) {
        conditions.addAll([
          Where('purchaseId').isExactly(purchaseId),
          Where('branchId').isExactly(branchId),
        ]);
      } else if (productId != null) {
        conditions.addAll([
          Where('productId').isExactly(productId),
          Where('branchId').isExactly(branchId),
        ]);
      } else if (pchsSttsCd != null) {
        conditions.addAll([
          Where('pchsSttsCd').isExactly(pchsSttsCd),
          Where('branchId').isExactly(branchId),
        ]);
      } else {
        conditions.addAll([
          Where('branchId').isExactly(branchId),
          Where('name').isNot(TEMP_PRODUCT),
          Where('productName').isNot(CUSTOM_PRODUCT),
          Where('assigned').isExactly(false),
        ]);
        if (!excludeApprovedInWaitingOrCanceledItems) {
          conditions.addAll([
            Where('imptItemSttsCd').isNot("2"),
            Where('imptItemSttsCd').isNot("4"),
          ]);
          if (purchaseId == null) {
            conditions.addAll([
              Where('pchsSttsCd').isNot("04"),
              if (forPurchaseScreen) Where('pchsSttsCd').isNot("01"),
            ]);
          }
        } else {
          conditions.add(Where('pchsSttsCd').isExactly("01"));
          if (purchaseId != null) {
            conditions.add(Where('purchaseId').isExactly(purchaseId));
          }
        }
      }

      final query = Query(
        orderBy: [const OrderBy('lastTouched', ascending: false)],
        where: conditions,
      );

      List<Variant> variants = await repository.get<Variant>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
        query: query,
      );

      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        return variants.skip(offset).take(itemsPerPage).toList();
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
      double? dcRt,
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
        if (selectedProductType == "3") {
          updatables[i].stock?.currentStock = 0;
        }
        await addStockToVariant(variant: updatables[i]);
      }

      updatables[i].name = name;
      updatables[i].categoryId = category?.id ?? updatables[i].categoryId;
      updatables[i].categoryName = category?.name ?? updatables[i].categoryName;
      updatables[i].itemStdNm = name;
      updatables[i].spplrItemNm = name;
      if (color != null) {
        updatables[i].color = color;
      }
      updatables[i].bhfId = updatables[i].bhfId ?? "00";
      updatables[i].itemNm = name;
      updatables[i].expirationDate = expirationDate;
      if (dcRt != null) {
        updatables[i].dcRt = dcRt;
      }
      updatables[i].ebmSynced = ebmSynced ?? false;
      updatables[i].retailPrice =
          newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
      if (selectedProductType != null) {
        updatables[i].itemTyCd = selectedProductType;
      }

      updatables[i].expirationDate = dates?[updatables[i].id] == null
          ? null
          : DateTime.tryParse(dates![updatables[i].id]!);

      if (retailPrice != 0 && retailPrice != null) {
        updatables[i].retailPrice = retailPrice;
      }
      if (supplyPrice != 0 && supplyPrice != null) {
        updatables[i].supplyPrice = supplyPrice;
      }

      updatables[i].lastTouched = DateTime.now().toUtc();

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
      final now = DateTime.now().toUtc();
      final expiryThreshold =
          daysToExpiry != null ? now.add(Duration(days: daysToExpiry)) : now;

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
      final filteredVariants = variants
          .where((variant) =>
              variant.expirationDate != null &&
              (variant.expirationDate!.isBefore(expiryThreshold) ||
                  variant.expirationDate!.isAtSameMomentAs(expiryThreshold)))
          .toList();

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
            talker
                .warning('Could not load stock for variant ${variant.id}: $e');
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
