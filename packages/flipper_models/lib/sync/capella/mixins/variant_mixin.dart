import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

mixin CapellaVariantMixin implements VariantInterface {
  DittoService get dittoService => DittoService.instance;
  Talker get talker;
  @override
  Future<PagedVariants> variants({
    required int branchId,
    String? productId,
    bool scanMode = false,
    int? page,
    bool? stockSynchronized,
    bool forImportScreen = false,
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
    List<String>? taxTyCds,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return PagedVariants(variants: [], totalCount: 0);
      }

      // Base query
      String query = 'SELECT * FROM variants WHERE branchId = :branchId';
      final arguments = <String, dynamic>{'branchId': branchId};

      // Assigned filter for specific screens
      if (forImportScreen || forPurchaseScreen) {
        query += ' AND assigned = :assigned';
        arguments['assigned'] = false;
      }

      // Screen-specific filters
      if (forImportScreen) {
        query +=
            " AND (imptItemSttsCd IN ('2', '3', '4') OR dclDe IS NOT NULL)";
      } else if (forPurchaseScreen) {
        query += " AND pchsSttsCd IN ('01', '02', '03', '04')";
      } else {
        // Exclude certain statuses but still allow NULL
        query +=
            " AND (imptItemSttsCd IS NULL OR imptItemSttsCd NOT IN ('2', '4'))";
        query += " AND (pchsSttsCd IS NULL OR pchsSttsCd NOT IN ('01', '04'))";
      }

      // Tax filters
      if (taxTyCds != null && taxTyCds.isNotEmpty) {
        final taxConditions = taxTyCds
            .asMap()
            .entries
            .map((entry) => 'taxTyCd = :tax${entry.key}')
            .join(' OR ');
        query += ' AND ($taxConditions)';
        for (int i = 0; i < taxTyCds.length; i++) {
          arguments['tax$i'] = taxTyCds[i];
        }
      }

      // Name / barcode search
      if (name != null && name.isNotEmpty) {
        query +=
            " AND (UPPER(name) LIKE UPPER(:namePattern) OR UPPER(bcd) LIKE UPPER(:bcdPattern))";
        arguments['namePattern'] = '%$name%';
        arguments['bcdPattern'] = '%$name%';
        talker.info('Added name filter: $name');
      }

      // Product filter
      if (productId != null) {
        query += ' AND productId = :productId';
        arguments['productId'] = productId;
      }

      // Sorting
      query += ' ORDER BY lastTouched DESC';

      // Pagination
      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        query += ' LIMIT :limit OFFSET :offset';
        arguments['limit'] = itemsPerPage;
        arguments['offset'] = offset;
      }

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      await ditto.sync.registerSubscription(query, arguments: arguments);

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            if (result.items.isNotEmpty) {
              completer.complete(result.items.toList());
            } else {
              completer.complete([]);
            }
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
              talker.warning('Timeout waiting for variants list');
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      // Prepare count query if pagination enabled
      int? totalCount;
      if (page != null && itemsPerPage != null) {
        try {
          String countQuery =
              'SELECT COUNT(*) as cnt FROM variants WHERE branchId = :branchId';
          final countArgs = Map<String, dynamic>.from(arguments)
            ..remove('limit')
            ..remove('offset');

          if (forImportScreen || forPurchaseScreen) {
            countQuery += ' AND assigned = :assigned';
          }

          if (forImportScreen) {
            countQuery +=
                " AND (imptItemSttsCd IN ('2', '3', '4') OR dclDe IS NOT NULL)";
          } else if (forPurchaseScreen) {
            countQuery += " AND pchsSttsCd IN ('01', '02', '03', '04')";
          } else {
            countQuery +=
                " AND (imptItemSttsCd IS NULL OR imptItemSttsCd NOT IN ('2', '4'))";
            countQuery +=
                " AND (pchsSttsCd IS NULL OR pchsSttsCd NOT IN ('01', '04'))";
          }

          if (taxTyCds != null && taxTyCds.isNotEmpty) {
            final taxConditions = taxTyCds
                .asMap()
                .entries
                .map((entry) => 'taxTyCd = :tax${entry.key}')
                .join(' OR ');
            countQuery += ' AND ($taxConditions)';
          }

          if (name != null && name.isNotEmpty) {
            countQuery +=
                " AND (UPPER(name) LIKE UPPER(:namePattern) OR UPPER(bcd) LIKE UPPER(:bcdPattern))";
          }

          if (productId != null) {
            countQuery += ' AND productId = :productId';
          }

          talker
              .info('Executing count query: $countQuery with args: $countArgs');
          final countResult =
              await ditto.store.execute(countQuery, arguments: countArgs);

          if (countResult.items.isNotEmpty) {
            final v = countResult.items.first.value;
            if (v['cnt'] != null) totalCount = (v['cnt'] as num).toInt();
          }
        } catch (e) {
          talker.warning('Count query failed: $e');
        }
      }

      // Parse results
      final variants = items
          .map((doc) => Variant.fromJson(Map<String, dynamic>.from(doc.value)))
          .toList();

      talker.info(
          'Returning ${variants.length} variants (totalCount: $totalCount)');
      return PagedVariants(variants: variants, totalCount: totalCount);
    } catch (e, st) {
      talker.error('Error fetching variants from Ditto: $e\n$st');
      return PagedVariants(variants: [], totalCount: 0);
    }
  }

  @override
  Future<Variant?> getVariant({
    String? id,
    String? modrId,
    String? name,
    String? bcd,
    String? stockId,
    String? taskCd,
    String? itemClsCd,
    String? itemNm,
    String? itemCd,
    String? productId,
  }) async {
    try {
      if (dittoService.dittoInstance == null) {
        talker.error('Ditto not initialized');
        return null;
      }

      String query = 'SELECT * FROM variants WHERE ';
      final arguments = <String, dynamic>{};

      if (id != null) {
        query += '_id = :id';
        arguments['id'] = id;
      } else if (bcd != null) {
        query += 'bcd = :bcd';
        arguments['bcd'] = bcd;
      } else if (name != null) {
        query += 'name = :name';
        arguments['name'] = name;
      } else if (productId != null) {
        query += 'productId = :productId';
        arguments['productId'] = productId;
      } else {
        return null;
      }

      query += ' LIMIT 1';

      // Subscribe to ensure we have the latest data
      await dittoService.dittoInstance!.sync.registerSubscription(
        query,
        arguments: arguments,
      );

      final completer = Completer<Variant?>();
      final observer = dittoService.dittoInstance!.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            if (result.items.isNotEmpty) {
              completer.complete(Variant.fromJson(
                  Map<String, dynamic>.from(result.items.first.value)));
            } else {
              completer.complete(null);
            }
          }
        },
      );

      try {
        // Wait for data or timeout
        // If data is already there, onChange is called immediately
        // If not, we wait up to 10 seconds for sync
        final variant = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for variant: $id / $bcd / $name');
              completer.complete(null);
            }
            return null;
          },
        );
        return variant;
      } finally {
        observer.cancel();
      }
    } catch (e) {
      talker.error('Error getting variant from Ditto: $e');
      return null;
    }
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations,
      required int branchId,
      required bool skipRRaCall}) {
    throw UnimplementedError('addVariant needs to be implemented for Capella');
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    throw UnimplementedError('units needs to be implemented for Capella');
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    throw UnimplementedError('addUnits needs to be implemented for Capella');
  }

  @override
  FutureOr<void> updateVariant(
      {required List<Variant> updatables,
      String? color,
      String? taxTyCd,
      Purchase? purchase,
      num? approvedQty,
      num? invoiceNumber,
      bool updateIo = true,
      String? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<String, String>? rates,
      double? supplyPrice,
      DateTime? expirationDate,
      String? selectedProductType,
      String? productId,
      String? categoryId,
      String? productName,
      double? prc,
      double? dftPrc,
      String? unit,
      String? pkgUnitCd,
      double? dcRt,
      bool? ebmSynced,
      String? propertyTyCd,
      String? roomTypeCd,
      String? ttCatCd,
      Map<String, String>? dates}) {
    throw UnimplementedError(
        'updateVariant needs to be implemented for Capella');
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) {
    throw UnimplementedError(
        'addStockToVariant needs to be implemented for Capella');
  }

  @override
  Future<List<Variant>> getExpiredItems({
    required int branchId,
    int? daysToExpiry,
    int? limit,
  }) async {
    throw UnimplementedError(
        'getExpiredItems needs to be implemented for Capella');
  }

  @override
  Future<List<Variant>> variantsByStockId({
    required String stockId,
  }) async {
    // Implement fetching variants by stockId using Ditto
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return [];
      }

      String query = 'SELECT * FROM variants WHERE stockId = :stockId';
      final arguments = <String, dynamic>{'stockId': stockId};

      // Subscribe to ensure we have the latest data
      await ditto.sync.registerSubscription(query, arguments: arguments);

      final result = await ditto.store.execute(query, arguments: arguments);
      var items = result.items;
      return items
          .map(
              (item) => Variant.fromJson(Map<String, dynamic>.from(item.value)))
          .toList();
    } catch (e) {
      talker.error('Error fetching variants by stockId: $e');
      return [];
    }
  }
}
