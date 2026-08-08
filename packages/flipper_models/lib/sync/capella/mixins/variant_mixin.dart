import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_models/sync/capella/capella_brick_mirror.dart';
import 'package:flipper_models/sync/capella/reference_data_ditto.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/pos_catalog_search.dart';
import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaVariantMixin implements VariantInterface {
  DittoService get dittoService => DittoService.instance;
  Repository get repository;
  Talker get talker;

  bool get isMobileDevice => isAndroid || isIos;

  Future<void> _syncStockToDitto(Stock stock) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    await ditto.store.execute(
      "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",

      arguments: {'doc': stock.toJson()},
    );
    await seedStockMilliIfAbsentOnStore(
      ditto.store,
      stockId: stock.id,
      qty: stock.currentStock ?? 0,
    );
  }

  Future<bool> _stockDocumentExists(String stockId) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return false;
    // Selects no COUNTER field, so no `COLLECTION stocks (… COUNTER)` declaration
    // is needed here.
    final result = await ditto.store.execute(
      'SELECT _id FROM stocks WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': stockId},
    );
    return result.items.isNotEmpty;
  }

  /// Writes [stock] to Ditto only when the document does not exist yet.
  ///
  /// An untyped `INSERT INTO stocks DOCUMENTS` sets the `currentStock`/`rsdQty`
  /// REGISTERS and leaves the `currentStockMilli` COUNTER untouched. Readers
  /// prefer the COUNTER, and the next qty write reconciles COUNTER *from* the
  /// registers (`stockMilliPrepAction` → `reconcileFromRegister`), so re-upserting
  /// an existing row from an in-memory snapshot resurrects quantity that a
  /// concurrent sale or transfer already deducted. Absolute qty writes must go
  /// through `StockInterface.updateStock`; saving a variant must not move qty.
  Future<void> _syncStockToDittoIfAbsent(Stock stock) async {
    if (await _stockDocumentExists(stock.id)) {
      // Still safe: a no-op when the counter is already there.
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        await seedStockMilliIfAbsentOnStore(
          ditto.store,
          stockId: stock.id,
          qty: stock.currentStock ?? 0,
        );
      }
      return;
    }
    // Ditto only on this branch — `stocks` is in data-connector's SYNC_TABLES,
    // so Supabase still receives it without the Brick mirror main keeps here.
    await _syncStockToDitto(stock);
  }

  /// Skip null / empty-branchId Ditto rows so qty-based display stock is kept.
  Future<void> _attachAuthenticCapellaStock(Variant variant) async {
    final sid = variant.stockId?.trim();
    if (sid == null || sid.isEmpty) return;
    try {
      final fetched = await (this as StockInterface).getStockById(id: sid);
      if (fetched == null || fetched.branchId.trim().isEmpty) return;
      variant.stock = fetched;
    } catch (e, st) {
      talker.warning(
        '_attachAuthenticCapellaStock($sid) failed: $e\n$st',
      );
    }
  }

  Future<void> _syncVariantToDitto(Variant variant) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    await ditto.store.execute(
      "INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
      arguments: {'doc': variant.toFlipperJson()},
    );
  }

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
    String? itemTyCd,
  }) async {
    final logService = LogService();
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting variants fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
              'userId':
                  (ProxyService.box
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

      if (branchId.isEmpty) {
        final boxBranch = ProxyService.box.getBranchId();
        talker.warning(
          'variants(): empty branchId param (box.getBranchId()=$boxBranch). '
          'Check login / branch selection and prefs merge after Ditto open.',
        );
        return PagedVariants(variants: [], totalCount: 0);
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Ditto instance available',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
      query +=
          " AND name NOT IN ('Cash In', 'Cash Out', 'Utility', '$CUSTOM_PRODUCT')";
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
        final placeholders = taxTyCds
            .asMap()
            .keys
            .map((i) => ':tax$i')
            .join(', ');
        query += ' AND taxTyCd IN ($placeholders)';
        for (int i = 0; i < taxTyCds.length; i++) {
          arguments['tax$i'] = taxTyCds[i];
        }
      }

      if (itemTyCd != null) {
        query += ' AND itemTyCd = :itemTyCd';
        arguments['itemTyCd'] = itemTyCd;
      }

      // Exact barcode match (scan / POS). Avoids "123" matching "123456789".
      if (bcd != null && bcd.trim().isNotEmpty) {
        query += " AND LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact";
        arguments['bcdExact'] = bcd.trim().toLowerCase();
        talker.info('Added exact barcode filter');
      }

      var orderSuffix = ' ORDER BY lastTouched DESC';
      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        orderSuffix += ' LIMIT :limit OFFSET :offset';
        arguments['limit'] = itemsPerPage;
        arguments['offset'] = offset;
      }

      // Product filter
      if (productId != null) {
        query += ' AND productId = :productId';
        arguments['productId'] = productId;
      }

      final bool isCatalogTextSearch =
          bcd == null && name != null && name.trim().isNotEmpty;
      final String? searchTerm =
          isCatalogTextSearch ? name.trim().toLowerCase() : null;

      final bool barcodeLikeSearch =
          searchTerm != null && isLikelyCatalogBarcodeQuery(searchTerm);

      // Name / product name / RRA item name search (substring). Barcode-like
      // tokens try exact bcd/itemCd first (see execute path below).
      if (searchTerm != null && !barcodeLikeSearch) {
        query +=
            " AND (LOWER(COALESCE(name, '')) LIKE :searchLike OR "
            "LOWER(COALESCE(itemNm, '')) LIKE :searchLike OR "
            "LOWER(COALESCE(productName, '')) LIKE :searchLike OR "
            "LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact OR "
            "LOWER(TRIM(COALESCE(itemCd, ''))) = :bcdExact)";
        arguments['searchLike'] = '%$searchTerm%';
        arguments['bcdExact'] = searchTerm;
        talker.info(
          'Added variant text search filter (case-insensitive): $searchTerm',
        );
      }

      // Filters only — barcode/fallback queries below append their own
      // conditions and must add the ORDER BY/LIMIT suffix exactly once.
      final String filterQuery = query;
      query += orderSuffix;

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared Ditto query',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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

      List<dynamic> items = [];
      int? totalCount;

      // Pull from Ditto cloud (e.g. data-connector bulk writes) before local query.
      await ensureBranchCatalogCloudSubscriptions(
        ditto: ditto,
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId(),
      );

      // Replication: broad branch subscription only. Filtered SELECT (search,
      // taxes, pagination) runs via execute below; Ditto 5 can reject complex
      // subscription predicates even after ORDER BY/LIMIT stripping.

      Future<List<dynamic>> runExecute(String sql, Map<String, dynamic> args) async {
        final r = await ditto.store.execute(sql, arguments: args);
        return r.items.toList();
      }

      if (barcodeLikeSearch) {
        final barcodeQuery = catalogBarcodeExactQuery(filterQuery, orderSuffix);
        final barcodeArgs = Map<String, dynamic>.from(arguments)
          ..['bcdExact'] = searchTerm;
        talker.info('Catalog barcode search (exact): $searchTerm');
        items = await runExecute(barcodeQuery, barcodeArgs);
        if (items.isEmpty) {
          final fallbackQuery = catalogBarcodeNameFallbackQuery(
            filterQuery,
            orderSuffix,
          );
          final fallbackArgs = Map<String, dynamic>.from(arguments)
            ..['searchLike'] = '%$searchTerm%';
          talker.info('Catalog barcode fallback to name search: $searchTerm');
          items = await runExecute(fallbackQuery, fallbackArgs);
        }
      } else {
        items = await runExecute(query, arguments);
      }

      // First page only: empty may mean sync not landed yet; later pages empty
      // usually means end of list, not worth waiting.
      final isFirstPage = page == null || page == 0;
      final shouldWaitForRemote =
          fetchRemote &&
          isFirstPage &&
          (name == null || name.trim().isEmpty) &&
          productId == null &&
          variantId == null &&
          bcd == null;
      if (items.isEmpty && shouldWaitForRemote) {
        const delays = <Duration>[
          Duration(milliseconds: 2000),
          Duration(milliseconds: 3500),
          Duration(milliseconds: 5000),
        ];
        for (final d in delays) {
          await Future.delayed(d);
          items = await runExecute(query, arguments);
          if (items.isNotEmpty) break;
        }
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Executed query successfully',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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

      // Prepare count query if pagination enabled (skip during catalog text search —
      // LIKE across thousands of variants is slow and blocks showing the first page).
      if (page != null && itemsPerPage != null && !isCatalogTextSearch) {
        try {
          String countQuery =
              'SELECT COUNT(*) as cnt FROM variants WHERE branchId = :branchId';
          countQuery +=
              " AND name NOT IN ('Cash In', 'Cash Out','Utility', '$CUSTOM_PRODUCT')";
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
            final placeholders = taxTyCds
                .asMap()
                .keys
                .map((i) => ':tax$i')
                .join(', ');
            countQuery += ' AND taxTyCd IN ($placeholders)';
          }

          if (itemTyCd != null) {
            countQuery += ' AND itemTyCd = :itemTyCd';
          }

          if (bcd != null && bcd.trim().isNotEmpty) {
            countQuery += " AND LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact";
          }

          if (name != null && name.isNotEmpty) {
            countQuery +=
                " AND (LOWER(COALESCE(name, '')) LIKE :searchLike OR "
                "LOWER(COALESCE(itemNm, '')) LIKE :searchLike OR "
                "LOWER(COALESCE(productName, '')) LIKE :searchLike OR "
                "LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact OR "
                "LOWER(TRIM(COALESCE(itemCd, ''))) = :bcdExact)";
          }

          if (productId != null) {
            countQuery += ' AND productId = :productId';
          }

          talker.info(
            'Executing count query: $countQuery with args: $countArgs',
          );

          final countResult = await ditto.store.execute(
            countQuery,
            arguments: countArgs,
          );

          if (countResult.items.isNotEmpty) {
            final v = countResult.items.first.value;
            if (v['cnt'] != null) totalCount = (v['cnt'] as num).toInt();
          }
        } catch (e) {
          talker.warning('Count query failed: $e');
        }
      } else if (isCatalogTextSearch && page != null && itemsPerPage != null) {
        final base = page * itemsPerPage + items.length;
        totalCount = items.length < itemsPerPage ? base : base + 1;
      }

      final stockIds = items
          .map((doc) => Map<String, dynamic>.from(doc.value)['stockId'])
          .whereType<String>()
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();
      final stocksById = stockIds.isEmpty
          ? <String, Stock>{}
          : await (this as StockInterface).batchGetStocksByIds(stockIds);

      for (final id in stockIds) {
        if (stocksById.containsKey(id) &&
            (stocksById[id]?.branchId.trim().isNotEmpty ?? false)) {
          continue;
        }
        final stock = await (this as StockInterface).getStockById(id: id);
        if (stock != null && stock.branchId.trim().isNotEmpty) {
          stocksById[id] = stock;
        }
      }

      // Parse results
      final pagedVariants = <Variant>[];
      for (var doc in items) {
        final variant = Variant.fromJson(Map<String, dynamic>.from(doc.value));
        final sid = variant.stockId?.trim();
        if (sid != null && sid.isNotEmpty) {
          final attached = stocksById[sid];
          if (attached != null && attached.branchId.trim().isNotEmpty) {
            variant.stock = attached;
          }
        }
        pagedVariants.add(variant);
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${pagedVariants.length} variants (totalCount: $totalCount)',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'branchId': branchId.toString(),
            'parsedVariantsCount': pagedVariants.length.toString(),
            'totalCount': totalCount?.toString() ?? 'null',
          },
        );
      }

      talker.info(
        'Returning ${pagedVariants.length} variants (totalCount: $totalCount)',
      );
      return PagedVariants(
        variants: pagedVariants,
        totalCount: totalCount ?? pagedVariants.length,
      );
    } catch (e, st) {
      talker.error('Error fetching variants from Ditto: $e\n$st');
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Failed to fetch variants from Ditto',
          stackTrace: st,
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'variants',
            'error': e.toString(),
          },
        );
      }
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
    bool fetchRemote = false,
  }) async {
    final logService = LogService();
    try {
      // Log initial parameters for debugging
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting getVariant fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
            'fetchRemote': fetchRemote.toString(),
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
              'userId':
                  (ProxyService.box
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
              'userId':
                  (ProxyService.box
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
        final branchId = ProxyService.box.getBranchId();
        if (branchId != null && branchId.isNotEmpty) {
          query += 'branchId = :branchId AND ';
          arguments['branchId'] = branchId;
        }
        // Excel often stores barcodes as numbers ("5" / "5.0"); match both.
        final normalized = bcd.trim().toLowerCase();
        final withoutDotZero = normalized.endsWith('.0')
            ? normalized.substring(0, normalized.length - 2)
            : normalized;
        query +=
            "(LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact OR "
            "LOWER(TRIM(COALESCE(bcd, ''))) = :bcdAlt OR "
            "LOWER(TRIM(COALESCE(bcd, ''))) = :bcdDotZero)";
        arguments['bcdExact'] = normalized;
        arguments['bcdAlt'] = withoutDotZero;
        arguments['bcdDotZero'] = '$withoutDotZero.0';
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Using BCD filter for getVariant',
            type: 'business_fetch',
            tags: {
              'userId':
                  (ProxyService.box
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
              'userId':
                  (ProxyService.box
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
              'userId':
                  (ProxyService.box
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
              'userId':
                  (ProxyService.box
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
            'userId':
                (ProxyService.box
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

      // Local store execute — enough when the document is already present.
      try {
        final existing = await dittoService.dittoInstance!.store.execute(
          query,
          arguments: arguments,
        );
        if (existing.items.isNotEmpty) {
          final data =
              Map<String, dynamic>.from(existing.items.first.value);
          final dittoId = data['_id']?.toString();
          if (dittoId != null &&
              dittoId.isNotEmpty &&
              (data['id'] == null || data['id'].toString().isEmpty)) {
            data['id'] = dittoId;
          }
          final variant = Variant.fromJson(data);
          await _attachAuthenticCapellaStock(variant);
          return variant;
        }
      } catch (e, st) {
        talker.warning(
          'getVariant execute fast-path failed: $e\n$st',
        );
      }

      // Interactive POS/checkout: return after local execute — do not wait on
      // subscription/observer (up to 10s) after a miss.
      if (!fetchRemote) {
        return null;
      }

      // Bulk / fetchRemote: subscribe and wait for a non-empty hit.
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.warning(
          'getVariant: Ditto unavailable for observer fallback',
        );
        return null;
      }

      try {
        final preparedGetVariant = prepareDqlSyncSubscription(query, arguments);
        await ditto.sync.registerSubscription(
          preparedGetVariant.dql,
          arguments: preparedGetVariant.arguments,
        );
      } catch (e, st) {
        talker.warning(
          'getVariant: registerSubscription failed: $e\n'
          '${describeDqlSyncSubscriptionAttempt(query, arguments)}\n'
          '$st',
        );
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registered subscription for getVariant',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          // Keep waiting on empty — first empty callback must not short-circuit
          // bulk sync that is still pulling the document.
          if (completer.isCompleted || result.items.isEmpty) {
            return;
          }
          final data =
              Map<String, dynamic>.from(result.items.first.value);
          final dittoId = data['_id']?.toString();
          if (dittoId != null &&
              dittoId.isNotEmpty &&
              (data['id'] == null || data['id'].toString().isEmpty)) {
            data['id'] = dittoId;
          }
          completer.complete(Variant.fromJson(data));
          if (ProxyService.box.getUserLoggingEnabled() ?? false) {
            logService.logException(
              'GetVariant observer onChange triggered with ${result.items.length} items',
              type: 'business_fetch',
              tags: {
                'userId':
                    (ProxyService.box
                        .getUserId()
                        ?.toString()
                        .hashCode
                        .toString()) ??
                    'unknown',
                'method': 'getVariant',
                'itemCount': result.items.length.toString(),
              },
            );
          }
        },
      );

      try {
        // Wait for synced data or timeout (bulk import only).
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
                    'userId':
                        (ProxyService.box
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
              'userId':
                  (ProxyService.box
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

        if (variant != null) {
          await _attachAuthenticCapellaStock(variant);
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
            'userId':
                (ProxyService.box
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
  Future<Map<String, Variant>> batchGetVariantsByIds(List<String> ids) async {
    final unique = ids
        .where((id) => id.trim().isNotEmpty)
        .map((id) => id.trim())
        .toSet()
        .toList();
    if (unique.isEmpty) return {};

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized batchGetVariantsByIds');
      return {};
    }

    try {
      final placeholders = unique
          .asMap()
          .entries
          .map((e) => ':v${e.key}')
          .join(', ');
      final arguments = <String, dynamic>{
        for (var i = 0; i < unique.length; i++) 'v$i': unique[i],
      };
      final query =
          'SELECT * FROM variants WHERE _id IN ($placeholders) OR id IN ($placeholders)';
      final result = await ditto.store.execute(query, arguments: arguments);

      final out = <String, Variant>{};
      for (final doc in result.items) {
        final data = Map<String, dynamic>.from(doc.value);
        final variant = Variant.fromJson(data);
        if (variant.id.isNotEmpty) {
          out[variant.id] = variant;
        }
        final dittoId = data['_id']?.toString();
        if (dittoId != null && dittoId.isNotEmpty && dittoId != variant.id) {
          out[dittoId] = variant;
        }
      }
      return out;
    } catch (e, st) {
      talker.warning(
        'batchGetVariantsByIds failed ($e), falling back per id\n$st',
      );
      final out = <String, Variant>{};
      for (final id in unique) {
        final v = await getVariant(id: id);
        if (v != null && v.id.isNotEmpty) {
          out[v.id] = v;
          if (id != v.id) out[id] = v;
        }
      }
      return out;
    }
  }

  @override
  Future<int> addVariant({
    required List<Variant> variations,
    required String branchId,
    required bool skipRRaCall,
  }) async {
    final results = await Future.wait(
      variations.map((variant) async {
        try {
          // Create a new variant with a UUID if one doesn't exist
          var variantToSave = variant.id.isEmpty
              ? variant.copyWith(id: const Uuid().v4(), branchId: branchId)
              : variant.copyWith(branchId: branchId);

          // Handle stock if it exists
          if (variantToSave.stock != null) {
            if (variantToSave.stock!.id.isEmpty) {
              final newStockId = const Uuid().v4();
              // Create a new Stock instance with the new ID
              final updatedStock = variantToSave.stock!.copyWith(
                id: newStockId,
              );
              await _syncStockToDitto(updatedStock);

              // Update the variant with the new stock and stockId
              variantToSave = variantToSave.copyWith(
                stock: updatedStock,
                stockId: newStockId,
              );
            } else {
              // Existing stock id: create the document only if it is missing.
              // Saving a variant must not move quantity — re-writing the qty
              // registers here would resurrect stock a concurrent sale or
              // transfer already deducted. See [_syncStockToDittoIfAbsent].
              await _syncStockToDittoIfAbsent(variantToSave.stock!);
            }
          }
          await _syncVariantToDitto(variantToSave);
          Ebm? ebm = await ProxyService.strategy.ebm(
            branchId: ProxyService.box.getBranchId()!,
          );
          if (variantToSave.splyAmt != null) {
            variantToSave.splyAmt = variantToSave.splyAmt!.toPrecision(0);
          }
          await _syncVariantToDitto(variantToSave);
          if (skipRRaCall) {
            return;
          }

          if (variant.ebmSynced == true) {
            return;
          }
          final persisted = await getVariant(id: variantToSave.id);
          if (persisted?.ebmSynced == true) {
            variant.ebmSynced = true;
            return;
          }

          final isTaxEnabled = await ProxyService.strategy.isTaxEnabled(
            businessId: ProxyService.box.getBusinessId()!,
            branchId: ProxyService.box.getBranchId()!,
          );

          if (!isTaxEnabled) {
            return;
          }

          final taxUrl = ebm!.taxServerUrl;
          if (taxUrl == null || taxUrl.isEmpty) {
            return;
          }

          String serverUrl = taxUrl;

          if (isMobileDevice) {
            serverUrl = ebm.remoteServerUrl ?? serverUrl;
          }

          await registerVariantWithRraForAdd(
            repository: repository,
            branchId: branchId,
            variantToSave: variantToSave,
            variantInput: variant,
            serverUrl: serverUrl,
            ebm: ebm,
            ditto: dittoService.dittoInstance,
          );
          await _syncVariantToDitto(variantToSave);
        } catch (e, stackTrace) {
          talker.error('Error adding variant', e, stackTrace);
          rethrow;
        }
      }),
    );

    return results.length;
  }

  Future<List<IUnit>> _unitsFromDitto(Ditto ditto, String branchId) async {
    final result = await ditto.store.execute(
      'SELECT * FROM $unitsCollection WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
    return result.items
        .map((d) => unitFromDittoDoc(Map<String, dynamic>.from(d.value)))
        .toList();
  }

  @override
  Future<List<IUnit>> units({required String branchId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return ProxyService.legacyStrategy.units(branchId: branchId);
    }

    await ensureReferenceSubscription(ditto, unitsCollection, branchId);
    try {
      final fromDitto = await _unitsFromDitto(ditto, branchId);
      if (fromDitto.isNotEmpty) return fromDitto;
    } catch (e, s) {
      talker.error('Ditto units read failed, falling back to Brick: $e', e, s);
      return ProxyService.legacyStrategy.units(branchId: branchId);
    }

    // Empty in Ditto. The legacy getter seeds `mockUnits` when the branch has
    // none at all, so this both backfills pre-migration rows and covers a
    // first-run branch.
    final existing =
        await ProxyService.legacyStrategy.units(branchId: branchId);
    for (final unit in existing) {
      await upsertReferenceDoc(ditto, unitsCollection, unitToDittoDoc(unit));
    }
    return existing;
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return ProxyService.legacyStrategy.addUnits<T>(units: units);
    }

    final branchId = ProxyService.box.getBranchId()!;
    // Dedupe against `units()`, not the raw Ditto read: on a pre-migration
    // branch Ditto is still empty while Brick already holds these names, and
    // seeding fresh rows here would duplicate every unit in the picker.
    // (`this.` — the `units` parameter shadows the method here.)
    final existing = await this.units(branchId: branchId);
    final existingNames = existing.map((u) => u.name).toSet();

    for (final map in units) {
      final name = map['name']?.toString();
      if (existingNames.contains(name)) continue;

      final unit = IUnit(
        active: map['active'] as bool?,
        branchId: branchId,
        name: name,
        value: map['value']?.toString(),
        lastTouched: DateTime.now().toUtc(),
      );
      await upsertReferenceDoc(ditto, unitsCollection, unitToDittoDoc(unit));
      // Brick is still what carries `units` to Supabase.
      scheduleCapellaBrickMirror(repository, unit);
      existingNames.add(name);
    }
    return 200;
  }

  @override
  FutureOr<void> updateVariant({
    required List<Variant> updatables,
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
    Map<String, String>? dates,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    for (var variant in updatables) {
      if (color != null) variant.color = color;
      if (taxTyCd != null) {
        variant.taxTyCd = taxTyCd;
        variant.taxName = taxTyCd;
      }
      if (retailPrice != null) variant.retailPrice = retailPrice;
      if (supplyPrice != null) variant.supplyPrice = supplyPrice;
      if (expirationDate != null) variant.expirationDate = expirationDate;
      if (productName != null) variant.productName = productName;
      if (unit != null) variant.unit = unit;
      if (dcRt != null) variant.dcRt = dcRt;
      if (ebmSynced != null) variant.ebmSynced = ebmSynced;
      if (categoryId != null) variant.categoryId = categoryId;
      if (selectedProductType != null) variant.itemTyCd = selectedProductType;
      if (newRetailPrice != null) {
        variant.retailPrice = newRetailPrice;
        variant.prc = newRetailPrice;
        variant.dftPrc = newRetailPrice;
      }
      if (dates != null && dates.containsKey(variant.id)) {
        variant.expirationDate = DateTime.tryParse(dates[variant.id]!);
      }
      variant.lastTouched = DateTime.now().toUtc();

      await ditto.store.execute(
        "INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
        arguments: {'doc': variant.toFlipperJson()},
      );

      // Handle Stock logic for new variants or missing stock
      if (variant.stock == null && variant.itemTyCd != "3") {
        final newStock = Stock(
          id: const Uuid().v4(),
          currentStock: variant.qty ?? 0,
          branchId: variant.branchId,
          lastTouched: DateTime.now().toUtc(),
          rsdQty: variant.qty ?? 0,
          initialStock: variant.qty ?? 0,
          showLowStockAlert: true,
          active: true,
          ebmSynced: false,
        );
        variant.stock = newStock;
        variant.stockId = newStock.id;

        await ditto.store.execute(
          "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
          arguments: {'doc': newStock.toJson()},
        );
        await seedStockMilliIfAbsentOnStore(
          ditto.store,
          stockId: newStock.id,
          qty: newStock.currentStock ?? 0,
        );
      } else if (variant.stock != null) {
        // Ensure the stock document exists — but never re-write the qty of one
        // that already does (see [_syncStockToDittoIfAbsent]).
        await _syncStockToDittoIfAbsent(variant.stock!);
      }
    }
  }

  @override
  FutureOr<Variant> addStockToVariant({
    required Variant variant,
    Stock? stock,
  }) async {
    final effective = stock ??
        Stock(
          id: const Uuid().v4(),
          currentStock: variant.qty ?? 0,
          branchId: variant.branchId,
          lastTouched: DateTime.now().toUtc(),
        );

    // Create the document if it is new, but never re-write the qty of one that
    // already exists — attaching a stock to a variant must not move quantity.
    // Absolute qty writes go through StockInterface.updateStock.
    // See [_syncStockToDittoIfAbsent].
    await _syncStockToDittoIfAbsent(effective);

    variant.stock = effective;
    variant.stockId = effective.id;
    await _syncVariantToDitto(variant);

    return variant;
  }

  @override
  Future<List<Variant>> getExpiredItems({
    required String branchId,
    int? daysToExpiry,
    int? limit,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return ProxyService.legacyStrategy.getExpiredItems(
        branchId: branchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      );
    }

    // `daysToExpiry` widens the window forward; without it "expired" means
    // already past. Same threshold rule as the Brick implementation.
    final now = DateTime.now().toUtc();
    final threshold =
        daysToExpiry != null ? now.add(Duration(days: daysToExpiry)) : now;

    try {
      final result = await ditto.store.execute(
        'SELECT * FROM variants WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );

      final expiring = <Variant>[];
      for (final item in result.items) {
        final variant = Variant.fromJson(Map<String, dynamic>.from(item.value));
        final expiry = variant.expirationDate;
        if (expiry == null) continue;
        if (expiry.isAfter(threshold)) continue;
        expiring.add(variant);
      }

      // Soonest first — the Brick version left this to insertion order, which
      // put arbitrary rows at the top of the expiry dashboard.
      expiring.sort((a, b) => a.expirationDate!.compareTo(b.expirationDate!));

      final limited = (limit != null && limit < expiring.length)
          ? expiring.sublist(0, limit)
          : expiring;

      // Attach stock so the dashboard can show remaining quantity, matching
      // what the Brick version did via its own stock fetch.
      for (final variant in limited) {
        await _attachAuthenticCapellaStock(variant);
      }
      return limited;
    } catch (e, st) {
      talker.error('Ditto getExpiredItems failed, falling back to Brick: $e\n$st');
      return ProxyService.legacyStrategy.getExpiredItems(
        branchId: branchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      );
    }
  }

  @override
  Future<List<Variant>> variantsByStockId({required String stockId}) async {
    final logService = LogService();
    // Implement fetching variants by stockId using Ditto
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting variantsByStockId fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
              'userId':
                  (ProxyService.box
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
      query +=
          " AND name NOT IN ('Cash In', 'Cash Out', 'Utility', '$CUSTOM_PRODUCT')";
      final arguments = <String, dynamic>{'stockId': stockId};

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared variantsByStockId query',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
      try {
        final preparedByStock = prepareDqlSyncSubscription(query, arguments);
        await ditto.sync.registerSubscription(
          preparedByStock.dql,
          arguments: preparedByStock.arguments,
        );
      } catch (e, st) {
        talker.warning(
          'variantsByStockId: registerSubscription failed: $e\n'
          '${describeDqlSyncSubscriptionAttempt(query, arguments)}\n'
          '$st',
        );
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registered subscription for variantsByStockId',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
            'userId':
                (ProxyService.box
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

      final variants = <Variant>[];
      for (var item in items) {
        final variant = Variant.fromJson(Map<String, dynamic>.from(item.value));
        await _attachAuthenticCapellaStock(variant);
        variants.add(variant);
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${variants.length} variants by stockId',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
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
            'userId':
                (ProxyService.box
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
