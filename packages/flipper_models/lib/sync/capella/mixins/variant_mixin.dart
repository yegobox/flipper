import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/log_service.dart';
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
    final logService = LogService();
    try {
      // Log initial parameters for debugging
      await logService.logException(
        'Starting variants fetch',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
          'productId': productId?.toString() ?? 'null',
          'forImportScreen': forImportScreen.toString(),
          'forPurchaseScreen': forPurchaseScreen.toString(),
          'page': page?.toString() ?? 'null',
          'itemsPerPage': itemsPerPage?.toString() ?? 'null',
          'name': name ?? 'null',
          'bcd': bcd ?? 'null',
          'purchaseId': purchaseId ?? 'null',
          'imptItemSttsCd': imptItemSttsCd ?? 'null',
          'taxTyCds': taxTyCds?.join(',') ?? 'null',
        },
      );

      final ditto = dittoService.dittoInstance;
      dittoService.dittoInstance?.startSync();
      if (ditto == null) {
        talker.error('Ditto not initialized');
        await logService.logException(
          'Ditto service not initialized',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
          },
        );
        return PagedVariants(variants: [], totalCount: 0);
      }

      await logService.logException(
        'Ditto instance available',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
        },
      );

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

      await logService.logException(
        'Prepared Ditto query',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
          'query': query,
          'arguments': arguments.toString(),
        },
      );

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      await logService.logException(
        'Registering Ditto subscription',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
        },
        extra: {'query': query, 'arguments': arguments.toString()},
      );
      await ditto.sync.registerSubscription(query, arguments: arguments);

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      await logService.logException(
        'Registering Ditto observer',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
        },
        extra: {'query': query, 'arguments': arguments.toString()},
      );
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            final itemCount = result.items.length;
            logService.logException(
              'Observer onChange triggered with $itemCount items',
              type: 'business_fetch',
              tags: {
                'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
                'method': 'variants',
                'branchId': branchId.toString(),
                'itemCount': itemCount.toString(),
              },
            ).then((_) {
              if (result.items.isNotEmpty) {
                completer.complete(result.items.toList());
              }
            });
          }
        },
      );

      List<dynamic> items = [];
      await logService.logException(
        'Waiting for observer data',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
        },
      );
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for variants list');
              logService.logException(
                'Observer timeout waiting for variants',
                type: 'business_fetch',
                tags: {
                  'userId':
                      ProxyService.box.getUserId()?.toString() ?? 'unknown',
                  'method': 'variants',
                  'branchId': branchId.toString(),
                },
              );
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      await logService.logException(
        'Received ${items.length} items from observer',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
          'itemsCount': items.length.toString(),
        },
      );

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

      await logService.logException(
        'Successfully parsed ${variants.length} variants (totalCount: $totalCount)',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'branchId': branchId.toString(),
          'parsedVariantsCount': variants.length.toString(),
          'totalCount': totalCount?.toString() ?? 'null',
        },
      );

      talker.info(
          'Returning ${variants.length} variants (totalCount: $totalCount)');
      return PagedVariants(variants: variants, totalCount: totalCount);
    } catch (e, st) {
      talker.error('Error fetching variants from Ditto: $e\n$st');
      await logService.logException(
        'Failed to fetch variants from Ditto',
        stackTrace: st,
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variants',
          'error': e.toString(),
        },
      );
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
    final logService = LogService();
    try {
      // Log initial parameters for debugging
      await logService.logException(
        'Starting getVariant fetch',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'getVariant',
          'id': id?.toString() ?? 'null',
          'modrId': modrId?.toString() ?? 'null',
          'name': name?.toString() ?? 'null',
          'bcd': bcd?.toString() ?? 'null',
          'stockId': stockId?.toString() ?? 'null',
          'taskCd': taskCd?.toString() ?? 'null',
          'itemClsCd': itemClsCd?.toString() ?? 'null',
          'itemNm': itemNm?.toString() ?? 'null',
          'itemCd': itemCd?.toString() ?? 'null',
          'productId': productId?.toString() ?? 'null',
        },
      );

      if (dittoService.dittoInstance == null) {
        talker.error('Ditto not initialized');
        await logService.logException(
          'Ditto service not initialized in getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'id': id?.toString() ?? 'null',
            'bcd': bcd?.toString() ?? 'null',
            'name': name?.toString() ?? 'null',
          },
        );
        return null;
      }

      String query = 'SELECT * FROM variants WHERE ';
      final arguments = <String, dynamic>{};

      if (id != null) {
        query += '_id = :id';
        arguments['id'] = id;
        await logService.logException(
          'Using ID filter for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'filter': 'id',
            'value': id,
          },
        );
      } else if (bcd != null) {
        query += 'bcd = :bcd';
        arguments['bcd'] = bcd;
        await logService.logException(
          'Using BCD filter for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'filter': 'bcd',
            'value': bcd,
          },
        );
      } else if (name != null) {
        query += 'name = :name';
        arguments['name'] = name;
        await logService.logException(
          'Using name filter for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'filter': 'name',
            'value': name,
          },
        );
      } else if (productId != null) {
        query += 'productId = :productId';
        arguments['productId'] = productId;
        await logService.logException(
          'Using productId filter for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'filter': 'productId',
            'value': productId,
          },
        );
      } else {
        await logService.logException(
          'No valid filter provided for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'filtersProvided': 'none',
          },
        );
        return null;
      }

      query += ' LIMIT 1';

      await logService.logException(
        'Prepared getVariant query',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'getVariant',
          'query': query,
          'arguments': arguments.toString(),
        },
      );

      // Subscribe to ensure we have the latest data
      await dittoService.dittoInstance!.sync.registerSubscription(
        query,
        arguments: arguments,
      );

      await logService.logException(
        'Registered subscription for getVariant',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'getVariant',
          'query': query,
        },
      );

      final completer = Completer<Variant?>();
      final observer = dittoService.dittoInstance!.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          final itemCount = result.items.length;
          logService.logException(
            'GetVariant observer onChange triggered with $itemCount items',
            type: 'business_fetch',
            tags: {
              'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
              'method': 'getVariant',
              'itemCount': itemCount.toString(),
            },
          ).then((_) {
            if (!completer.isCompleted) {
              if (result.items.isNotEmpty) {
                completer.complete(Variant.fromJson(
                    Map<String, dynamic>.from(result.items.first.value)));
              }
            }
          });
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
              logService.logException(
                'GetVariant observer timeout',
                type: 'business_fetch',
                tags: {
                  'userId':
                      ProxyService.box.getUserId()?.toString() ?? 'unknown',
                  'method': 'getVariant',
                  'id': id?.toString() ?? 'null',
                  'bcd': bcd?.toString() ?? 'null',
                  'name': name?.toString() ?? 'null',
                },
              );
              completer.complete(null);
            }
            return null;
          },
        );

        await logService.logException(
          'GetVariant completed with ${variant != null ? 'success' : 'null'} result',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'getVariant',
            'hasResult': (variant != null).toString(),
          },
        );

        return variant;
      } finally {
        observer.cancel();
      }
    } catch (e, st) {
      talker.error('Error getting variant from Ditto: $e\n$st');
      await logService.logException(
        'Failed to get variant from Ditto',
        stackTrace: st,
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'getVariant',
          'error': e.toString(),
        },
      );
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
    final logService = LogService();
    // Implement fetching variants by stockId using Ditto
    try {
      await logService.logException(
        'Starting variantsByStockId fetch',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'stockId': stockId,
        },
      );

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        await logService.logException(
          'Ditto service not initialized in variantsByStockId',
          type: 'business_fetch',
          tags: {
            'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
            'method': 'variantsByStockId',
            'stockId': stockId,
          },
        );
        return [];
      }

      String query = 'SELECT * FROM variants WHERE stockId = :stockId';
      final arguments = <String, dynamic>{'stockId': stockId};

      await logService.logException(
        'Prepared variantsByStockId query',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'query': query,
          'arguments': arguments.toString(),
        },
      );

      // Subscribe to ensure we have the latest data
      await ditto.sync.registerSubscription(query, arguments: arguments);

      await logService.logException(
        'Registered subscription for variantsByStockId',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'query': query,
        },
      );

      final result = await ditto.store.execute(query, arguments: arguments);
      var items = result.items;

      await logService.logException(
        'Fetched ${items.length} items from variantsByStockId query',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'itemsCount': items.length.toString(),
          'stockId': stockId,
        },
      );

      final variants = items
          .map(
              (item) => Variant.fromJson(Map<String, dynamic>.from(item.value)))
          .toList();

      await logService.logException(
        'Successfully parsed ${variants.length} variants by stockId',
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'parsedVarsCount': variants.length.toString(),
          'stockId': stockId,
        },
      );

      return variants;
    } catch (e, st) {
      talker.error('Error fetching variants by stockId: $e\n$st');
      await logService.logException(
        'Failed to fetch variants by stockId',
        stackTrace: st,
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'variantsByStockId',
          'error': e.toString(),
          'stockId': stockId,
        },
      );
      return [];
    }
  }
}
