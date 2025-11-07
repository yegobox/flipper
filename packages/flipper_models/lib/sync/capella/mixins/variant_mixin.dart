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

      // Start query
      String query = 'SELECT * FROM variants WHERE branchId = :branchId';
      final arguments = <String, dynamic>{'branchId': branchId};

      // Handle tax filters
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

      // Name / barcode filtering
      if (name != null && name.isNotEmpty) {
        // Case-insensitive search for name, exact match for barcode
        query +=
            " AND (LOWER(name) LIKE '%' || LOWER(:name) || '%' OR bcd = :bcd)";
        arguments['name'] = name;
        arguments['bcd'] = name;
      }

      // Filter by product
      if (productId != null) {
        query += ' AND productId = :productId';
        arguments['productId'] = productId;
      }

      // Add sorting
      query += ' ORDER BY lastTouched DESC';

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Execute query for items
      // If pagination requested and Ditto supports LIMIT/OFFSET via SQL, append it.
      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        query += ' LIMIT :limit OFFSET :offset';
        arguments['limit'] = itemsPerPage;
        arguments['offset'] = offset;
      }

      final result = await ditto.store.execute(query, arguments: arguments);
      var items = result.items;

      // Attempt to get total count when paginating by running a COUNT query
      int? totalCount;
      if (page != null && itemsPerPage != null) {
        try {
          String countQuery =
              'SELECT COUNT(*) as cnt FROM variants WHERE branchId = :branchId';
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
                " AND (LOWER(name) LIKE '%' || LOWER(:name) || '%' OR bcd = :bcd)";
          }
          if (productId != null) {
            countQuery += ' AND productId = :productId';
          }
          final countResult =
              await ditto.store.execute(countQuery, arguments: arguments);
          if (countResult.items.isNotEmpty) {
            final v = countResult.items.first.value;
            if (v['cnt'] != null) {
              totalCount = (v['cnt'] as num).toInt();
            }
          }
        } catch (e) {
          talker.info('Count query failed: $e');
        }
      }

      // Parse to Variant objects
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

      final result = await dittoService.dittoInstance!.store.execute(
        query,
        arguments: arguments,
      );

      return result.items.isNotEmpty
          ? Variant.fromJson(
              Map<String, dynamic>.from(result.items.first.value))
          : null;
    } catch (e) {
      talker.error('Error getting variant from Ditto: $e');
      return null;
    }
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) {
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
      bool updateStock = true,
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
