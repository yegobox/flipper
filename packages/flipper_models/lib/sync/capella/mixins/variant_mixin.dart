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
    required String branchId,
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
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting variants fetch',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
            'productId': productId?.toString() ?? 'null',
            'forImportScreen': forImportScreen.toString(),
            'forPurchaseScreen': forPurchaseScreen.toString(),
            'page': page?.toString() ?? 'null',
            'itemsPerPage': itemsPerPage?.toString() ?? 'null',
            'name': name != null ? '***' : 'null',
            'bcd': bcd != null ? '***' : 'null',
            'purchaseId': purchaseId != null ? '***' : 'null',
            'imptItemSttsCd': imptItemSttsCd ?? 'null',
            'taxTyCds': taxTyCds != null ? 'masked_list' : 'null',
          },
        );
      }

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:15');
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Ditto service not initialized',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'variants',
              'branchId': branchId.toString(),
            },
          );
        }
        return PagedVariants(variants: [], totalCount: 0);
      }

      /// a work around to first register to whole data instead of subset
      /// this is because after test on new device, it can't pull data using complex query
      /// there is open issue on ditto https://support.ditto.live/hc/en-us/requests/2648?page=1
      ///
      ditto.sync.registerSubscription(
        "SELECT * FROM variants WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM variants WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );

      /// end of workaround
      ///
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Ditto instance available',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
          },
        );
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
        final placeholders =
            taxTyCds.asMap().keys.map((i) => ':tax$i').join(', ');
        query += ' AND taxTyCd IN ($placeholders)';
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

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared Ditto query',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
            'query_length': query.length.toString(),
            'arguments_keys': arguments.keys.join(','),
          },
        );
      }

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registering Ditto subscription',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
          },
          extra: {'query_metadata': 'redacted', 'args_count': arguments.length},
        );
      }
      await ditto.sync.registerSubscription(query, arguments: arguments);

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registering Ditto observer',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
          },
          extra: {'query_metadata': 'redacted', 'args_count': arguments.length},
        );
      }
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            final itemCount = result.items.length;
            // Complete the completer immediately to avoid hanging
            if (result.items.isNotEmpty) {
              completer.complete(result.items.toList());
            }
            // Log asynchronously without waiting for completion
            if (ProxyService.box.getUserLoggingEnabled() ?? false) {
              logService.logException(
                'Observer onChange triggered with $itemCount items',
                type: 'business_fetch',
                tags: {
                  'userId': (ProxyService.box
                          .getUserId()
                          ?.toString()
                          .hashCode
                          .toString()) ??
                      'unknown',
                  'method': 'variants',
                  'branchId': branchId.toString(),
                  'itemCount': itemCount.toString(),
                },
              );
            }
          }
        },
      );

      List<dynamic> items = [];
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Waiting for observer data',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
          },
        );
      }
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for variants list');
              if (ProxyService.box.getUserLoggingEnabled() ?? false) {
                logService.logException(
                  'Observer timeout waiting for variants',
                  type: 'business_fetch',
                  tags: {
                    'userId': (ProxyService.box
                            .getUserId()
                            ?.toString()
                            .hashCode
                            .toString()) ??
                        'unknown',
                    'method': 'variants',
                    'branchId': branchId.toString(),
                  },
                );
              }
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Received ${items.length} items from observer',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
            'itemsCount': items.length.toString(),
          },
        );
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
            final placeholders =
                taxTyCds.asMap().keys.map((i) => ':tax$i').join(', ');
            countQuery += ' AND taxTyCd IN ($placeholders)';
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

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${variants.length} variants (totalCount: $totalCount)',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
            'parsedVariantsCount': variants.length.toString(),
            'totalCount': totalCount?.toString() ?? 'null',
          },
        );
      }

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
          'userId':
              (ProxyService.box.getUserId()?.toString().hashCode.toString()) ??
                  'unknown',
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
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting getVariant fetch',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'getVariant',
            'id': id != null ? '***' : 'null',
            'modrId': modrId != null ? '***' : 'null',
            'name': name != null ? '***' : 'null',
            'bcd': bcd != null ? '***' : 'null',
            'stockId': stockId != null ? '***' : 'null',
            'taskCd': taskCd?.toString() ?? 'null',
            'itemClsCd': itemClsCd?.toString() ?? 'null',
            'itemNm': itemNm != null ? '***' : 'null',
            'itemCd': itemCd?.toString() ?? 'null',
            'productId': productId?.toString() ?? 'null',
          },
        );
      }

      if (dittoService.dittoInstance == null) {
        talker.error('Ditto not initialized:16');
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Ditto service not initialized in getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'id': id != null ? '***' : 'null',
              'bcd': bcd != null ? '***' : 'null',
              'name': name != null ? '***' : 'null',
            },
          );
        }
        return null;
      }

      String query = 'SELECT * FROM variants WHERE ';
      final arguments = <String, dynamic>{};

      if (id != null) {
        query += '_id = :id';
        arguments['id'] = id;
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Using ID filter for getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'filter': 'id',
              'value': '***',
            },
          );
        }
      } else if (bcd != null) {
        query += 'bcd = :bcd';
        arguments['bcd'] = bcd;
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Using BCD filter for getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'filter': 'bcd',
              'value': '***',
            },
          );
        }
      } else if (name != null) {
        query += 'name = :name';
        arguments['name'] = name;
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Using name filter for getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'filter': 'name',
              'value': '***',
            },
          );
        }
      } else if (productId != null) {
        query += 'productId = :productId';
        arguments['productId'] = productId;
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Using productId filter for getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'filter': 'productId',
              'value': productId,
            },
          );
        }
      } else {
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'No valid filter provided for getVariant',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'filtersProvided': 'none',
            },
          );
        }
        return null;
      }

      query += ' LIMIT 1';

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared getVariant query',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'getVariant',
            'query_metadata': 'redacted',
            'arguments_keys': arguments.keys.join(','),
          },
        );
      }

      // Subscribe to ensure we have the latest data
      await dittoService.dittoInstance!.sync.registerSubscription(
        query,
        arguments: arguments,
      );

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registered subscription for getVariant',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'getVariant',
            'query_metadata': 'redacted',
          },
        );
      }

      final completer = Completer<Variant?>();
      final observer = dittoService.dittoInstance!.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          final itemCount = result.items.length;
          // Complete the completer immediately to avoid hanging
          if (!completer.isCompleted) {
            if (result.items.isNotEmpty) {
              completer.complete(Variant.fromJson(
                  Map<String, dynamic>.from(result.items.first.value)));
            }
          }
          // Log asynchronously without waiting for completion
          if (ProxyService.box.getUserLoggingEnabled() ?? false) {
            logService.logException(
              'GetVariant observer onChange triggered with $itemCount items',
              type: 'business_fetch',
              tags: {
                'userId': (ProxyService.box
                        .getUserId()
                        ?.toString()
                        .hashCode
                        .toString()) ??
                    'unknown',
                'method': 'getVariant',
                'itemCount': itemCount.toString(),
              },
            );
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
              if (ProxyService.box.getUserLoggingEnabled() ?? false) {
                logService.logException(
                  'GetVariant observer timeout',
                  type: 'business_fetch',
                  tags: {
                    'userId': (ProxyService.box
                            .getUserId()
                            ?.toString()
                            .hashCode
                            .toString()) ??
                        'unknown',
                    'method': 'getVariant',
                    'id': id != null ? '***' : 'null',
                    'bcd': bcd != null ? '***' : 'null',
                    'name': name != null ? '***' : 'null',
                  },
                );
              }
              completer.complete(null);
            }
            return null;
          },
        );

        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'GetVariant completed with ${variant != null ? 'success' : 'null'} result',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'getVariant',
              'hasResult': (variant != null).toString(),
            },
          );
        }

        return variant;
      } finally {
        observer.cancel();
      }
    } catch (e, st) {
      talker.error('Error getting variant from Ditto: $e\n$st');
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Failed to get variant from Ditto',
          stackTrace: st,
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'getVariant',
            'error': e.toString(),
          },
        );
      }
      return null;
    }
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations,
      required String branchId,
      required bool skipRRaCall}) {
    throw UnimplementedError('addVariant needs to be implemented for Capella');
  }

  @override
  Future<List<IUnit>> units({required String branchId}) {
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
    required String branchId,
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
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting variantsByStockId fetch',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'stockId': '***',
          },
        );
      }

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:17');
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Ditto service not initialized in variantsByStockId',
            type: 'business_fetch',
            tags: {
              'userId': (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'variantsByStockId',
              'stockId': '***',
            },
          );
        }
        return [];
      }

      String query = 'SELECT * FROM variants WHERE stockId = :stockId';
      final arguments = <String, dynamic>{'stockId': stockId};

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared variantsByStockId query',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'query_metadata': 'redacted',
            'arguments_keys': arguments.keys.join(','),
          },
        );
      }

      // Subscribe to ensure we have the latest data
      await ditto.sync.registerSubscription(query, arguments: arguments);

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registered subscription for variantsByStockId',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'query_metadata': 'redacted',
          },
        );
      }

      final result = await ditto.store.execute(query, arguments: arguments);
      var items = result.items;

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Fetched ${items.length} items from variantsByStockId query',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'itemsCount': items.length.toString(),
            'stockId': '***',
          },
        );
      }

      final variants = items
          .map(
              (item) => Variant.fromJson(Map<String, dynamic>.from(item.value)))
          .toList();

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${variants.length} variants by stockId',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'parsedVarsCount': variants.length.toString(),
            'stockId': '***',
          },
        );
      }

      return variants;
    } catch (e, st) {
      talker.error('Error fetching variants by stockId: $e\n$st');
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Failed to fetch variants by stockId',
          stackTrace: st,
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variantsByStockId',
            'error': e.toString(),
            'stockId': '***',
          },
        );
      }
      return [];
    }
  }
}
