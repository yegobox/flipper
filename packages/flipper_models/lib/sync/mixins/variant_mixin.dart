import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/cache/cache_manager.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:uuid/uuid.dart';

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
    bool forImportScreen = false,
    bool? stockSynchronized,
    List<String>? taxTyCds,
    bool scanMode = false,
  }) async {
    try {
      final List<WhereCondition> conditions = [
        Where('branchId').isExactly(branchId),
        Where('assigned').isExactly(false),
      ];

      // Apply taxTyCds filter FIRST and ensure it's always respected
      if (taxTyCds != null && taxTyCds.isNotEmpty) {
        conditions.add(Where('taxTyCd').isIn(taxTyCds));
      }

      if (forImportScreen) {
        conditions.addAll([
          Where('imptItemSttsCd').isExactly("2"),
          Or('imptItemSttsCd').isExactly("3"),
          Or('imptItemSttsCd').isExactly("4"),
          Or('dclDe').isNot(null),
        ]);
      } else if (forPurchaseScreen) {
        conditions.add(Where('pchsSttsCd').isIn(["01", "02", "04", "03"]));
      } else if (variantId != null) {
        conditions.add(Where('id').isExactly(variantId));
      } else if (name != null && name.isNotEmpty) {
        if (scanMode) {
          conditions.add(Where('bcd').isExactly(name));
        } else {
          conditions.add(Where('name').contains(name));
        }
      } else if (stockSynchronized != null) {
        conditions.add(Where('stockSynchronized').isExactly(stockSynchronized));
      } else if (purchaseId != null) {
        conditions.add(Where('purchaseId').isExactly(purchaseId));
      } else if (productId != null) {
        conditions.add(Where('productId').isExactly(productId));
      } else if (pchsSttsCd != null) {
        conditions.add(Where('pchsSttsCd').isExactly(pchsSttsCd));
      }
      // General fetch conditions if no specific filter is applied
      else if (name == null &&
          bcd == null &&
          variantId == null &&
          productId == null &&
          pchsSttsCd == null &&
          imptItemSttsCd == null &&
          stockSynchronized == null &&
          purchaseId == null &&
          !forImportScreen &&
          !forPurchaseScreen) {
        conditions.addAll([
          Where('name').isNot(TEMP_PRODUCT),
          Where('productName').isNot(CUSTOM_PRODUCT),
        ]);
        if (excludeApprovedInWaitingOrCanceledItems) {
          conditions.add(Where('pchsSttsCd').isExactly("01"));
          if (purchaseId != null) {
            conditions.add(Where('purchaseId').isExactly(purchaseId));
          }
        }
      }

      // When fetching remotely, exclude variants with stockSynchronized = false
      if (fetchRemote) {
        conditions.add(Where('stockSynchronized').isNot(false));
      }

      final query = Query(
        where: conditions,
        orderBy: [const OrderBy('lastTouched', ascending: false)],
      );

      /// when fetching remotely, fetch all variants and sort them by lastTouched
      List<Variant> fetchedVariants = await repository.get<Variant>(
        query: fetchRemote
            ? Query(
                where: [Where('branchId').isExactly(branchId)],
                orderBy: [const OrderBy('lastTouched', ascending: false)],
              )
            : query,
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
      );

      // Defensively filter by branchId in case the query is not restrictive enough.
      fetchedVariants =
          fetchedVariants.where((v) => v.branchId == branchId).toList();

      // Post-query filtering with taxTyCds validation
      if (!forImportScreen && !forPurchaseScreen) {
        fetchedVariants = fetchedVariants.where((v) {
          final isWaitingImport = v.imptItemSttsCd == "2";
          final isCancelledImport = v.imptItemSttsCd == "4";
          final isCancelledPurchase = v.pchsSttsCd == "04";
          final isWaitingPurchase = v.pchsSttsCd == "01";

          // First check status conditions
          final statusCheck = !isWaitingImport &&
              !isCancelledImport &&
              !isCancelledPurchase &&
              !isWaitingPurchase;

          // Then verify taxTyCds if provided
          if (taxTyCds != null && taxTyCds.isNotEmpty) {
            final taxTyCheck =
                v.taxTyCd != null && taxTyCds.contains(v.taxTyCd);
            return statusCheck && taxTyCheck;
          }

          return statusCheck;
        }).toList();
      }

      if (forImportScreen) {
        fetchedVariants = fetchedVariants.where((v) {
          final isImportItemSttsCdNull =
              v.imptItemSttsCd == null || v.imptItemSttsCd!.isEmpty;

          // Additional taxTyCds validation for import screen
          if (taxTyCds != null && taxTyCds.isNotEmpty) {
            final taxTyCheck =
                v.taxTyCd != null && taxTyCds.contains(v.taxTyCd);
            return !isImportItemSttsCdNull && taxTyCheck;
          }

          return !isImportItemSttsCdNull;
        }).toList();
      }

      // Final validation: Double-check taxTyCds filter wasn't bypassed
      if (taxTyCds != null && taxTyCds.isNotEmpty) {
        fetchedVariants = fetchedVariants.where((v) {
          return v.taxTyCd != null && taxTyCds.contains(v.taxTyCd);
        }).toList();
      }

      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        if (offset >= fetchedVariants.length) return [];
        return fetchedVariants
            .skip(offset)
            .take(itemsPerPage)
            .where((v) => v.branchId == branchId)
            .toList();
      }

      return fetchedVariants.where((v) => v.branchId == branchId).toList();
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
    final results = await Future.wait(
      variations.map((variant) async {
        try {
          // Create a new variant with a UUID if one doesn't exist
          final variantToSave = variant.id.isEmpty
              ? variant.copyWith(
                  id: const Uuid().v4(),
                  branchId: branchId,
                )
              : variant.copyWith(branchId: branchId);

          // Handle stock if it exists
          if (variantToSave.stock != null && variantToSave.stock!.id.isEmpty) {
            final newStockId = const Uuid().v4();
            // Create a new Stock instance with the new ID
            final updatedStock = variantToSave.stock!.copyWith(id: newStockId);
            await repository.upsert<Stock>(updatedStock);
            await CacheManager().saveStocks([updatedStock]);
            // Update the variant with the new stock and stockId
            return await repository.upsert<Variant>(
              variantToSave.copyWith(
                stock: updatedStock,
                stockId: newStockId,
              ),
            );
          }

          final newVariantSaved =
              await repository.upsert<Variant>(variantToSave);
          final ebmSyncService = TurboTaxService(repository);
          if (newVariantSaved.imptItemSttsCd != "1" ||
              newVariantSaved.pchsSttsCd != "1") {
            // get the sar
            final sar = await ProxyService.strategy.getSar(branchId: branchId);
            await ebmSyncService.stockIo(
              invoiceNumber: sar?.sarNo ?? 1,
              variant: newVariantSaved,
              serverUrl: (await ProxyService.box.getServerUrl())!,
            );
            // increament sar and save
            sar!.sarNo = sar.sarNo + 1;
            await repository.upsert<Sar>(sar);
          }
          return newVariantSaved;
        } catch (e, stackTrace) {
          talker.error('Error adding variant', e, stackTrace);
          rethrow;
        }
      }),
    );

    return results.length;
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
      double? prc,
      bool updateIo = true,
      double? dftPrc,
      num? approvedQty,
      num? invoiceNumber,
      Purchase? purchase,
      bool? ebmSynced}) async {
    if (variantId != null) {
      Variant? variant = await getVariant(id: variantId);
      if (variant != null) {
        variant.productName = productName ?? variant.productName;
        variant.productId = productId ?? variant.productId;
        variant.taxTyCd = taxTyCd ?? variant.taxTyCd;
        variant.unit = unit ?? variant.unit;
        variant.prc = variant.retailPrice;
        variant.dftPrc = variant.retailPrice;
        variant.retailPrice = retailPrice ?? variant.retailPrice;
        variant.supplyPrice = supplyPrice ?? variant.supplyPrice;
        repository.upsert(variant);
      }
      return;
    }
    try {
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
        updatables[i].categoryName =
            category?.name ?? updatables[i].categoryName;
        updatables[i].itemStdNm = name;
        updatables[i].spplrItemNm = name;
        updatables[i].prc =
            newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
        updatables[i].dftPrc =
            newRetailPrice == null ? updatables[i].retailPrice : newRetailPrice;
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

        if (retailPrice != null) {
          updatables[i].retailPrice = retailPrice;
        }
        if (supplyPrice != 0 && supplyPrice != null) {
          updatables[i].supplyPrice = supplyPrice;
        }

        updatables[i].lastTouched = DateTime.now().toUtc();
        updatables[i].qty =
            (approvedQty ?? updatables[i].stock?.currentStock)?.toDouble();

        await CacheManager().saveStocks([updatables[i].stock!]);
        final updated = await repository.upsert<Variant>(updatables[i]);

        /// still experimenting bellow.
        if (updateIo == true) {
          await updateIoFunc(
              variant: updated,
              purchase: purchase,
              approvedQty: approvedQty?.toDouble());
        }
      }
    } catch (e, stackTrace) {
      talker.error('Error updating variant', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateIoFunc(
      {required Variant variant,
      Purchase? purchase,
      double? approvedQty}) async {
    final ebmSyncService = TurboTaxService(repository);

    final sar = await ProxyService.strategy
        .getSar(branchId: ProxyService.box.getBranchId()!);
    await ebmSyncService.stockIo(
      approvedQty: approvedQty,
      invoiceNumber: sar?.sarNo ?? 1,
      variant: variant,
      purchase: purchase,
      serverUrl: (await ProxyService.box.getServerUrl())!,
    );
    // increament sar and save
    sar!.sarNo = sar.sarNo + 1;
    await repository.upsert<Sar>(sar);
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
