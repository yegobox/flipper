import 'dart:async';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaStockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<String> createStockRequest(
    List<TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  }) async {
    try {
      final String requestId = const Uuid().v4();
      final String? bhfId = await ProxyService.box.bhfId();
      int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);

      FinanceProvider? provider;
      if (financingId != null) {
        provider = (await repository.get<FinanceProvider>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: Query(where: [Where('id').isExactly(financingId)]),
        )).firstOrNull;
      }

      final financing = Financing(
        id: provider?.id,
        provider: provider,
        requested: true,
        amount: items.fold(
          0,
          (previousValue, element) => previousValue! + element.price,
        ),
        status: 'pending',
        financeProviderId: provider?.id,
        approvalDate: DateTime.now().toUtc(),
      );

      // await repository.upsert(financing);

      final InventoryRequest request = InventoryRequest(
        id: requestId,
        mainBranchId: mainBranchId,
        subBranchId: subBranchId,
        financing: financing,
        createdAt: DateTime.now().toUtc(),
        status: RequestStatus.pending,
        deliveryNote: deliveryNote,
        orderNote: orderNote,
        bhfId: bhfId,
        tinNumber: tin!.toString(),
        branchId: (await ProxyService.strategy.activeBranch(
          branchId: ProxyService.box.getBranchId()!,
        )).id,
        financingId: financingId,
        itemCounts: items.length,
        transactionItems: items
            .map((item) => item.copyWith(inventoryRequestId: requestId))
            .toList(),
      );

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        throw Exception('Ditto not initialized:004');
      }

      final requestDoc = {
        '_id': request.id,
        'mainBranchId': request.mainBranchId,
        'subBranchId': request.subBranchId,
        'branchId': request.branchId,
        'createdAt': request.createdAt?.toIso8601String(),
        'status': request.status,
        'deliveryDate': request.deliveryDate?.toIso8601String(),
        'deliveryNote': request.deliveryNote,
        'orderNote': request.orderNote,
        'customerReceivedOrder': request.customerReceivedOrder,
        'driverRequestDeliveryConfirmation':
            request.driverRequestDeliveryConfirmation,
        'driverId': request.driverId,
        'updatedAt': request.updatedAt?.toIso8601String(),
        'itemCounts': request.itemCounts,
        'bhfId': request.bhfId,
        'tinNumber': request.tinNumber,
        'financingId': request.financingId,
        'transactionItems': request.transactionItems
            ?.map(
              (item) => {
                'id': item.id,
                'name': item.name,
                'qty': item.qty,
                'price': item.price,
                'discount': item.discount,
                'prc': item.prc,
                'ttCatCd': item.ttCatCd,
                'quantityRequested': item.qty,
                'quantityApproved': 0,
                'quantityShipped': 0,
                'transactionId': item.transactionId,
                'variantId': item.variantId,
                'inventoryRequestId': item.inventoryRequestId,
              },
            )
            .toList(),
      };

      await ditto.store.execute(
        '''
  INSERT INTO stock_requests
  DOCUMENTS (:request)
  ON ID CONFLICT DO UPDATE
  ''',
        arguments: {'request': requestDoc},
      );

      // Link lines to the request and persist approval qty fields used by Approve All.
      for (var item in items) {
        final qtyRequested =
            item.quantityRequested ?? item.qty.round().clamp(1, 1 << 30);
        await ditto.store.execute(
          'UPDATE transaction_items SET '
          'inventoryRequestId = :requestId, '
          'quantityRequested = :quantityRequested, '
          'quantityApproved = :quantityApproved '
          'WHERE _id = :id OR id = :id',
          arguments: {
            'requestId': requestId,
            'quantityRequested': qtyRequested,
            'quantityApproved': item.quantityApproved ?? 0,
            'id': item.id,
          },
        );
      }

      return requestId;
    } catch (e) {
      talker.error('Error in createStockRequest: $e');
      rethrow;
    }
  }

  @override
  Future<Stock?> getStockById({required String id}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:3');
        throw Exception('Ditto not initialized:4');
      }
      var result = await ditto.store.execute(
        stockSelectWithMilliDql(
          whereClause: '_id = :id OR id = :id LIMIT 1',
        ),
        arguments: {'id': id},
      );

      if (result.items.isEmpty) return null;

      final stockData = Map<String, dynamic>.from(result.items.first.value);
      return _convertFromDittoDocument(stockData);
    } catch (e) {
      talker.error('Error getting stock by ID: $e');
      return null;
    }
  }

  @override
  Future<Map<String, Stock>> batchGetStocksByIds(List<String> ids) async {
    final unique = ids
        .where((id) => id.trim().isNotEmpty)
        .map((id) => id.trim())
        .toSet()
        .toList();
    if (unique.isEmpty) return {};

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized batchGetStocksByIds');
      return {};
    }

    try {
      final placeholders = unique
          .asMap()
          .entries
          .map((e) => ':s${e.key}')
          .join(', ');
      final arguments = <String, dynamic>{
        for (var i = 0; i < unique.length; i++) 's$i': unique[i],
      };
      final query = stockSelectWithMilliDql(
        whereClause:
            '_id IN ($placeholders) OR id IN ($placeholders)',
      );
      final result = await ditto.store.execute(query, arguments: arguments);

      final out = <String, Stock>{};
      for (final doc in result.items) {
        final data = Map<String, dynamic>.from(doc.value);
        final stock = _convertFromDittoDocument(data);
        _indexStockByIdKeys(out, stock, data);
      }
      return out;
    } catch (e, st) {
      talker.warning(
        'batchGetStocksByIds failed ($e), falling back per id\n$st',
      );
      final out = <String, Stock>{};
      for (final id in unique) {
        try {
          final stock = await getStockById(id: id);
          if (stock != null) out[id] = stock;
        } catch (_) {}
      }
      return out;
    }
  }

  /// Watch stock by ID and get updates as a stream
  Stream<Stock?> watchStockById(String id) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:5');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;

      // Initialize async to register subscription first
      () async {
        try {
          final query = stockSelectWithMilliDql(whereClause: '_id = :id');
          final arguments = {'id': id};

          // Subscribe to ensure we have the latest data from Ditto mesh
          final prepared = prepareDqlSyncSubscription(query, arguments);
          await ditto.sync.registerSubscription(
            prepared.dql,
            arguments: prepared.arguments,
          );

          // Use registerObserver with initial data fetch
          final completer = Completer<Stock?>();
          observer = ditto.store.registerObserver(
            query,
            arguments: arguments,
            onChange: (queryResult) {
              if (controller.isClosed) return;

              if (queryResult.items.isNotEmpty) {
                final stockData = Map<String, dynamic>.from(
                  queryResult.items.first.value,
                );
                final stock = _convertFromDittoDocument(stockData);

                // Complete on first data if not yet completed
                if (!completer.isCompleted) {
                  completer.complete(stock);
                }

                controller.add(stock);
              } else {
                if (!completer.isCompleted) {
                  completer.complete(null);
                }
                controller.add(null);
              }
            },
          );

          // Wait for initial data or timeout
          await completer.future.timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              if (!completer.isCompleted) {
                talker.warning('Timeout waiting for stock: $id');
                completer.complete(null);
              }
              return null;
            },
          );
        } catch (e) {
          talker.error('Error setting up stock observer: $e');
          controller.add(null);
        }
      }();

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching stock by ID: $e');
      return Stream.value(null);
    }
  }

  /// Convert Ditto document to Stock model
  void _indexStockByIdKeys(
    Map<String, Stock> out,
    Stock stock,
    Map<String, dynamic> data,
  ) {
    out[stock.id] = stock;
    final logicalId = data['id']?.toString();
    if (logicalId != null && logicalId.isNotEmpty) {
      out[logicalId] = stock;
    }
    final dittoId = data['_id']?.toString();
    if (dittoId != null && dittoId.isNotEmpty) {
      out[dittoId] = stock;
    }
  }

  Stock _convertFromDittoDocument(Map<String, dynamic> data) {
    DateTime? lastTouched;
    if (data['lastTouched'] != null) {
      if (data['lastTouched'] is String) {
        lastTouched = DateTime.parse(data['lastTouched']);
      } else {
        lastTouched = data['lastTouched'];
      }
    }

    final registerQty = _parseDouble(data['currentStock']);
    final milli = parseStockMilli(data[stockCurrentStockMilliField]);
    // New clients: prefer CRDT milli when present so UI matches concurrent deducts.
    final qtyFromMilli = milli != null ? fromMilli(milli) : null;
    final currentStock = qtyFromMilli ?? registerQty;
    final rsdRegister = _parseDouble(data['rsdQty']);
    final rsdQty = qtyFromMilli ?? rsdRegister;

    return Stock(
      id: data['_id'] ?? data['id'],
      tin: data['tin'],
      bhfId: data['bhfId'],
      branchId: data['branchId'],
      currentStock: currentStock,
      lowStock: _parseDouble(data['lowStock']),
      canTrackingStock: data['canTrackingStock'],
      showLowStockAlert: data['showLowStockAlert'],
      active: data['active'],
      value: _parseDouble(data['value']),
      rsdQty: rsdQty,
      lastTouched: lastTouched,
      ebmSynced: data['ebmSynced'],
      initialStock: _parseDouble(data['initialStock']),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Future<Map<String, dynamic>?> _selectStockRaw(String stockId) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      stockSelectWithMilliDql(
        whereClause: '_id = :stockId OR id = :stockId LIMIT 1',
      ),
      arguments: {'stockId': stockId},
    );
    if (result.items.isEmpty) return null;
    return Map<String, dynamic>.from(result.items.first.value);
  }

  /// Seed or reconcile [currentStockMilli] from register (coexistence with old tills).
  /// Returns on-hand milli after prep (equals [toMilli] of register).
  Future<int> _ensureAndReconcileStockMilli({
    required String stockId,
    required Map<String, dynamic> data,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized: stock milli');
    }
    final registerQty = _parseDouble(data['currentStock']) ?? 0.0;
    final milli = parseStockMilli(data[stockCurrentStockMilliField]);
    final action = stockMilliPrepAction(milli: milli, registerQty: registerQty);
    final targetMilli = stockMilliAfterPrep(milli: milli, registerQty: registerQty);
    if (action != StockMilliPrepAction.none) {
      await ditto.store.execute(
        stockRestartMilliDql(),
        arguments: {'stockId': stockId, 'milli': targetMilli},
      );
      data[stockCurrentStockMilliField] = targetMilli;
    }
    return targetMilli;
  }

  Future<void> _restartStockMilli({
    required String stockId,
    required int milli,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized: restart milli');
    }
    await ditto.store.execute(
      stockRestartMilliDql(),
      arguments: {'stockId': stockId, 'milli': milli},
    );
  }

  Future<void> _incrementStockMilli({
    required String stockId,
    required int deltaMilli,
  }) async {
    if (deltaMilli == 0) return;
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized: increment milli');
    }
    await ditto.store.execute(
      stockIncrementMilliDql(),
      arguments: {'stockId': stockId, 'delta': deltaMilli},
    );
  }

  Future<void> _dualWriteRegistersFromMilli({
    required String stockId,
    required int milli,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized: dual-write registers');
    }
    final qty = fromMilli(milli);
    await ditto.store.execute(
      stockDualWriteRegistersDql(),
      arguments: {
        'stockId': stockId,
        'currentStock': qty,
        'rsdQty': qty,
      },
    );
  }

  /// Absolute qty write: COUNTER RESTART + register dual-write (and optional metadata SET).
  Future<void> _setStockQtyViaMilli({
    required String stockId,
    required double currentStock,
    required double rsdQty,
    Map<String, dynamic>? extraRegisterFields,
  }) async {
    final milli = toMilli(currentStock);
    final qty = fromMilli(milli);
    // When rsd matches current (typical), keep them equal after milli rounding.
    final rsdOut = (rsdQty - currentStock).abs() < 1e-9
        ? qty
        : fromMilli(toMilli(rsdQty));
    await _restartStockMilli(stockId: stockId, milli: milli);
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized: set stock qty');
    }
    final updateData = <String, dynamic>{
      'currentStock': qty,
      'rsdQty': rsdOut,
      ...?extraRegisterFields,
    };
    await ditto.store.execute(
      'UPDATE stocks SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :stockId OR id = :stockId',
      arguments: {...updateData, 'stockId': stockId},
    );
  }

  /// Recreates a stock document that is missing from Ditto so an edit does not
  /// lose the quantity the operator typed.
  ///
  /// Stock rows born on the Brick side never reach Ditto (`repository.upsert`
  /// skips Ditto for Stock so a stale Brick row cannot clobber live qty), so a
  /// variant can legitimately hold a `stockId` with no document behind it. Only
  /// ids a Variant still references are healed — anything else stays an error
  /// rather than becoming orphan stock. Created zeroed: the caller's own update
  /// is applied immediately after, so nothing is double-counted.
  Future<Map<String, dynamic>?> _healMissingStockDocument(
    String stockId,
  ) async {
    Variant? variant;
    try {
      variant = await ProxyService.getStrategy(
        Strategy.capella,
      ).getVariant(stockId: stockId);
    } catch (e, st) {
      talker.warning(
        'updateStock heal: variant lookup failed for $stockId: $e\n$st',
      );
    }
    if (variant == null) return null;

    final branchId = variant.branchId.trim().isNotEmpty
        ? variant.branchId
        : (ProxyService.box.getBranchId() ?? '');
    if (branchId.trim().isEmpty) return null;

    try {
      await saveStock(
        id: stockId,
        variant: variant,
        productId: variant.productId ?? '',
        variantId: variant.id,
        branchId: branchId,
        currentStock: 0,
        rsdQty: 0,
        value: 0,
      );
      talker.warning(
        'updateStock: recreated missing stock document $stockId for variant ${variant.id}',
      );
      return await _selectStockRaw(stockId);
    } catch (e, st) {
      talker.error(
        'updateStock heal: failed to recreate stock $stockId: $e\n$st',
      );
      return null;
    }
  }

  @override
  Future<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    bool appending = false,
    DateTime? lastTouched,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:6');
        throw StateError('Ditto not initialized: updateStock');
      }

      final existingData =
          await _selectStockRaw(stockId) ??
          await _healMissingStockDocument(stockId);
      if (existingData == null) {
        talker.error('Stock with ID $stockId not found');
        throw StateError('Stock with ID $stockId not found');
      }

      final meta = <String, dynamic>{};
      if (initialStock != null) {
        final existingInitial =
            (existingData['initialStock'] as num?)?.toDouble() ?? 0;
        meta['initialStock'] =
            appending ? existingInitial + initialStock : initialStock;
      }
      if (value != null) {
        meta['value'] = value;
      }
      if (ebmSynced != null) {
        meta['ebmSynced'] = ebmSynced;
      }
      if (lastTouched != null) {
        meta['lastTouched'] = lastTouched.toIso8601String();
      }

      final touchesQty = currentStock != null || rsdQty != null;
      if (!touchesQty) {
        if (meta.isEmpty) return;
        await ditto.store.execute(
          'UPDATE stocks SET ${meta.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :stockId OR id = :stockId',
          arguments: {...meta, 'stockId': stockId},
        );
        return;
      }

      if (appending && currentStock != null) {
        // Refunds / production: atomic milli INCREMENT after coexistence prep.
        final available = await _ensureAndReconcileStockMilli(
          stockId: stockId,
          data: existingData,
        );
        final deltaMilli = toMilli(currentStock);
        var nextMilli = available + deltaMilli;
        if (nextMilli < 0) nextMilli = 0;
        final appliedDelta = nextMilli - available;
        if (appliedDelta != 0) {
          await _incrementStockMilli(
            stockId: stockId,
            deltaMilli: appliedDelta,
          );
        }
        final qty = fromMilli(nextMilli);
        final updateData = <String, dynamic>{
          'currentStock': qty,
          'rsdQty': qty,
          ...meta,
        };
        await ditto.store.execute(
          'UPDATE stocks SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :stockId OR id = :stockId',
          arguments: {...updateData, 'stockId': stockId},
        );
        return;
      }

      // Absolute SET (default): RESTART milli + dual-write registers.
      final registerQty = _parseDouble(existingData['currentStock']) ?? 0.0;
      final registerRsd = _parseDouble(existingData['rsdQty']) ?? registerQty;
      final nextCurrent = currentStock ?? registerQty;
      final nextRsd = rsdQty ?? (currentStock ?? registerRsd);
      await _ensureAndReconcileStockMilli(
        stockId: stockId,
        data: existingData,
      );
      await _setStockQtyViaMilli(
        stockId: stockId,
        currentStock: nextCurrent,
        rsdQty: nextRsd,
        extraRegisterFields: meta.isEmpty ? null : meta,
      );
    } catch (e) {
      talker.error('Error updating stock: $e');
      rethrow;
    }
  }

  static const int _batchUpdateStocksConcurrency = 8;

  @override
  Future<void> batchUpdateStocks(
    Map<String, ({double currentStock, double rsdQty})> byStockId,
  ) async {
    if (byStockId.isEmpty) return;

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized: batchUpdateStocks');
      throw StateError('Ditto not initialized: batchUpdateStocks');
    }

    Future<void> updateOne(String stockId, double current, double rsd) async {
      final data = await _selectStockRaw(stockId);
      if (data != null) {
        await _ensureAndReconcileStockMilli(stockId: stockId, data: data);
      }
      await _setStockQtyViaMilli(
        stockId: stockId,
        currentStock: current,
        rsdQty: rsd,
      );
    }

    final entries = byStockId.entries.toList();
    for (var i = 0; i < entries.length; i += _batchUpdateStocksConcurrency) {
      final end = (i + _batchUpdateStocksConcurrency < entries.length)
          ? i + _batchUpdateStocksConcurrency
          : entries.length;
      await Future.wait([
        for (var j = i; j < end; j++)
          updateOne(
            entries[j].key,
            entries[j].value.currentStock,
            entries[j].value.rsdQty,
          ),
      ], eagerError: true);
    }
  }

  @override
  Future<void> batchDeductStocks(Map<String, double> deltaByStockId) async {
    if (deltaByStockId.isEmpty) return;

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized: batchDeductStocks');
      throw StateError('Ditto not initialized: batchDeductStocks');
    }

    // Atomic COUNTER INCREMENT (milli) + register dual-write for old clients.
    Future<void> deductOne(String stockId, double delta) async {
      if (delta <= 0) return;
      final data = await _selectStockRaw(stockId);
      if (data == null) {
        talker.warning(
          'batchDeductStocks: missing stock $stockId, skip delta=$delta',
        );
        return;
      }
      final available = await _ensureAndReconcileStockMilli(
        stockId: stockId,
        data: data,
      );
      final deduct = clampDeductMilli(
        availableMilli: available,
        deductMilli: toMilli(delta),
      );
      if (deduct <= 0) {
        await _dualWriteRegistersFromMilli(stockId: stockId, milli: available);
        return;
      }
      await _incrementStockMilli(stockId: stockId, deltaMilli: -deduct);
      await _dualWriteRegistersFromMilli(
        stockId: stockId,
        milli: available - deduct,
      );
    }

    final entries = deltaByStockId.entries.toList();
    for (var i = 0; i < entries.length; i += _batchUpdateStocksConcurrency) {
      final end = (i + _batchUpdateStocksConcurrency < entries.length)
          ? i + _batchUpdateStocksConcurrency
          : entries.length;
      await Future.wait([
        for (var j = i; j < end; j++)
          deductOne(entries[j].key, entries[j].value),
      ], eagerError: true);
    }
  }

  @override
  Future<Stock> saveStock({
    Variant? variant,
    required double rsdQty,
    required String productId,
    required String variantId,
    required String branchId,
    String? id,
    required double currentStock,
    required double value,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:7');
    }
    final stockId = id ?? const Uuid().v4();
    final stock = Stock(
      id: stockId,
      rsdQty: rsdQty,
      branchId: branchId,
      currentStock: currentStock,
      value: value,
      active: true,
      lastTouched: DateTime.now().toUtc(),
      ebmSynced: false,
      initialStock: currentStock,
      showLowStockAlert: true,
      canTrackingStock: true,
      lowStock: 0,
    );
    // Registers only in DOCUMENTS — never put milli in the JSON map (would be a register).
    await ditto.store.execute(
      "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
      arguments: {'doc': stock.toJson()},
    );
    await seedStockMilliIfAbsentOnStore(
      ditto.store,
      stockId: stockId,
      qty: currentStock,
    );
    // Ditto only — `stocks` is in data-connector's SYNC_TABLES, so Supabase
    // still receives this without a Brick mirror.
    return stock;
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:7');
    }

    final result = await ditto.store.execute(
      'SELECT * FROM stock_requests WHERE _id = :requestId',
      arguments: {'requestId': requestId},
    );

    return result.items.map((item) {
      final data = Map<String, dynamic>.from(item.value);
      return _convertInventoryRequestFromDitto(data);
    }).toList();
  }

  @override
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized');
      return Stream.value([]);
    }

    final controller = StreamController<List<InventoryRequest>>.broadcast();
    dynamic observer;

    // Use a basic query for stock requests where we are the main branch (supplier)
    String query =
        'SELECT * FROM stock_requests WHERE mainBranchId = :branchId';
    final arguments = {'branchId': branchId, 'status': filter, 'limit': limit};

    // Add status filter if provided
    // When 'pending' is selected, include both 'pending' and 'processing' orders
    // so that orders in production remain visible (with modified UI)
    if (filter == RequestStatus.pending) {
      query +=
          " AND (status = '${RequestStatus.pending}' OR status = '${RequestStatus.processing}')";
    } else if (filter != 'all') {
      query += ' AND status = :status';
    }

    // Add ordering and limit
    query += ' ORDER BY createdAt DESC LIMIT :limit';

    // Register subscription
    final prepared = prepareDqlSyncSubscription(query, arguments);
    ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) async {
        if (controller.isClosed) return;

        try {
          final requests = <InventoryRequest>[];
          for (final item in queryResult.items) {
            final data = Map<String, dynamic>.from(item.value);
            final request = _convertInventoryRequestFromDitto(data);

            // Fetch requester branch details (subBranchId)
            if (request.subBranchId != null) {
              // Ensure we subscribe to this branch data so it syncs to this device
              final preparedBranch = prepareDqlSyncSubscription(
                "SELECT * FROM branches WHERE _id = :id",
                {'id': request.subBranchId},
              );
              ditto.sync.registerSubscription(
                preparedBranch.dql,
                arguments: preparedBranch.arguments,
              );

              talker.info(
                'Fetching branch details for subBranchId: ${request.subBranchId}',
              );
              final branchResult = await ditto.store.execute(
                'SELECT * FROM branches WHERE _id = :id',
                arguments: {'id': request.subBranchId},
              );

              if (branchResult.items.isNotEmpty) {
                talker.info('Branch found for ${request.subBranchId}');
                request.branch = Branch.fromMap(
                  Map<String, dynamic>.from(branchResult.items.first.value),
                );
              } else {
                talker.error('Branch NOT found for ${request.subBranchId}');
              }
            }
            requests.add(request);
          }
          controller.add(requests);
        } catch (e) {
          talker.error('Error processing requests stream: $e');
        }
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<InventoryRequest>> requestsStreamOutgoing({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized');
      return Stream.value([]);
    }

    final controller = StreamController<List<InventoryRequest>>.broadcast();
    dynamic observer;

    // Query for requests where we are the subBranch (requester)
    String query = 'SELECT * FROM stock_requests WHERE subBranchId = :branchId';
    // Note: 'status' isn't in arguments yet, need to add it conditionally or always
    final arguments = {'branchId': branchId, 'status': filter, 'limit': limit};

    // Add status filter if provided
    // When 'pending' is selected, include both 'pending' and 'processing' orders
    if (filter == RequestStatus.pending) {
      query +=
          " AND (status = '${RequestStatus.pending}' OR status = '${RequestStatus.processing}')";
    } else if (filter != 'all') {
      query += ' AND status = :status';
    }

    // Add ordering and limit
    query += ' ORDER BY createdAt DESC LIMIT :limit';

    // Register subscription
    final preparedOutgoing = prepareDqlSyncSubscription(query, arguments);
    ditto.sync.registerSubscription(
      preparedOutgoing.dql,
      arguments: preparedOutgoing.arguments,
    );

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) async {
        if (controller.isClosed) return;

        try {
          final requests = <InventoryRequest>[];
          for (final item in queryResult.items) {
            final data = Map<String, dynamic>.from(item.value);
            final request = _convertInventoryRequestFromDitto(data);

            // Fetch supplier branch details (mainBranchId)
            if (request.mainBranchId != null) {
              // Ensure subscription
              final preparedBranch = prepareDqlSyncSubscription(
                "SELECT * FROM branches WHERE _id = :id",
                {'id': request.mainBranchId},
              );
              ditto.sync.registerSubscription(
                preparedBranch.dql,
                arguments: preparedBranch.arguments,
              );

              final branchResult = await ditto.store.execute(
                'SELECT * FROM branches WHERE _id = :id',
                arguments: {'id': request.mainBranchId},
              );

              if (branchResult.items.isNotEmpty) {
                request.branch = Branch.fromMap(
                  Map<String, dynamic>.from(branchResult.items.first.value),
                );
              }
            }
            requests.add(request);
          }
          controller.add(requests);
        } catch (e) {
          talker.error('Error processing outgoing requests stream: $e');
        }
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<List<InventoryRequest>> stockRequestsToBranch({
    required String destinationBranchId,
    DateTime? start,
    DateTime? end,
    String status = 'all',
    int limit = 500,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized: stockRequestsToBranch');
    }
    if (destinationBranchId.isEmpty) return [];

    String query =
        'SELECT * FROM stock_requests WHERE subBranchId = :destinationBranchId';
    final arguments = <String, dynamic>{
      'destinationBranchId': destinationBranchId,
      'status': status,
      'limit': limit,
    };

    if (status == RequestStatus.pending) {
      query +=
          " AND (status = '${RequestStatus.pending}' OR status = '${RequestStatus.processing}')";
    } else if (status != 'all') {
      query += ' AND status = :status';
    }

    // For bounded (date-window) reports, apply the window to ALL candidates
    // before limiting, otherwise LIMIT would drop older in-window transfers.
    final bounded = start != null || end != null;
    query += bounded
        ? ' ORDER BY createdAt DESC'
        : ' ORDER BY createdAt DESC LIMIT :limit';

    final result = await ditto.store.execute(query, arguments: arguments);

    var converted = result.items
        .map(
          (item) => _convertInventoryRequestFromDitto(
            Map<String, dynamic>.from(item.value),
          ),
        )
        .toList();

    if (bounded) {
      final startUtc = start?.toUtc();
      final endUtc = end?.toUtc();
      converted = converted
          .where((r) {
            final stamp = r.approvedAt ?? r.createdAt;
            // Bounded reports exclude undated rows (can't confirm the window).
            if (stamp == null) return false;
            final t = stamp.toUtc();
            if (startUtc != null && t.isBefore(startUtc)) return false;
            if (endUtc != null && t.isAfter(endUtc)) return false;
            return true;
          })
          .take(limit)
          .toList();
    }

    // Hydrate source branches, caching by mainBranchId to avoid N+1 queries.
    final branchCache = <String, Branch?>{};
    final requests = <InventoryRequest>[];
    for (final request in converted) {
      final mainId = request.mainBranchId;
      if (mainId != null && mainId.isNotEmpty) {
        Branch? branch;
        if (branchCache.containsKey(mainId)) {
          branch = branchCache[mainId];
        } else {
          try {
            final branchResult = await ditto.store.execute(
              'SELECT * FROM branches WHERE _id = :id',
              arguments: {'id': mainId},
            );
            if (branchResult.items.isNotEmpty) {
              branch = Branch.fromMap(
                Map<String, dynamic>.from(branchResult.items.first.value),
              );
            }
          } catch (e) {
            talker.warning(
              'stockRequestsToBranch: could not load source branch '
              '$mainId: $e',
            );
          }
          branchCache[mainId] = branch;
        }
        if (branch != null) request.branch = branch;
      }
      requests.add(request);
    }

    return requests;
  }

  InventoryRequest _convertInventoryRequestFromDitto(
    Map<String, dynamic> data,
  ) {
    // Parse transactionItems from embedded data
    List<TransactionItem>? items;
    if (data['transactionItems'] != null) {
      if (data['transactionItems'] is List) {
        talker.info(
          'Parsing ${data['transactionItems'].length} embedded items for Request ${data['_id']}',
        );
        try {
          items = (data['transactionItems'] as List).map((itemData) {
            final itemMap = Map<String, dynamic>.from(itemData);
            return TransactionItem(
              id: itemMap['id'],
              name: itemMap['name'],
              qty: (itemMap['qty'] as num?)?.toDouble() ?? 0.0,
              price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
              discount: (itemMap['discount'] as num?)?.toDouble() ?? 0.0,
              prc: (itemMap['prc'] as num?)?.toDouble() ?? 0.0,
              ttCatCd: itemMap['ttCatCd'],
              quantityRequested:
                  (itemMap['quantityRequested'] as num?)?.toInt() ?? 0,
              quantityApproved:
                  (itemMap['quantityApproved'] as num?)?.toInt() ?? 0,
              quantityShipped:
                  (itemMap['quantityShipped'] as num?)?.toInt() ?? 0,
              transactionId: itemMap['transactionId'],
              variantId: itemMap['variantId'],
              inventoryRequestId: itemMap['inventoryRequestId'],
            );
          }).toList();
        } catch (e) {
          talker.error('Error parsing embedded items: $e');
        }
      } else {
        talker.error(
          'transactionItems is not a List: ${data['transactionItems'].runtimeType}',
        );
      }
    } else {
      talker.warning('No transactionItems found in request ${data['_id']}');
    }

    return InventoryRequest(
      id: data['_id'] ?? data['id'],
      mainBranchId: data['mainBranchId'],
      subBranchId: data['subBranchId'],
      branchId: data['branchId'],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
      status: data['status'],
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.tryParse(data['deliveryDate'])
          : null,
      deliveryNote: data['deliveryNote'],
      orderNote: data['orderNote'],
      customerReceivedOrder: data['customerReceivedOrder'],
      driverRequestDeliveryConfirmation:
          data['driverRequestDeliveryConfirmation'],
      driverId: data['driverId'],
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
      itemCounts: data['itemCounts'],
      bhfId: data['bhfId'],
      tinNumber: data['tinNumber'],
      financingId: data['financingId'],
      transactionItems: items,
      approvedBy: data['approvedBy'],
      approvedAt: data['approvedAt'] != null
          ? DateTime.tryParse(data['approvedAt'])
          : null,
    );
  }

  @override
  Stream<Map<String, Stock?>> watchStocksByIds(List<String> stockIds) {
    final unique = stockIds
        .where((id) => id.trim().isNotEmpty)
        .map((id) => id.trim())
        .toSet()
        .toList();
    if (unique.isEmpty) {
      return Stream.value(const {});
    }

    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized watchStocksByIds');
        return Stream.value(const {});
      }

      final placeholders = unique
          .asMap()
          .entries
          .map((e) => ':s${e.key}')
          .join(', ');
      final arguments = <String, dynamic>{
        for (var i = 0; i < unique.length; i++) 's$i': unique[i],
      };
      final query =
          'SELECT * FROM stocks WHERE _id IN ($placeholders) OR id IN ($placeholders)';

      final controller = StreamController<Map<String, Stock?>>.broadcast();
      dynamic observer;

      final prepared = prepareDqlSyncSubscription(query, arguments);
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          if (controller.isClosed) return;
          final out = <String, Stock?>{for (final id in unique) id: null};
          for (final doc in queryResult.items) {
            final data = Map<String, dynamic>.from(doc.value);
            final stock = _convertFromDittoDocument(data);
            for (final key in <String>{
              stock.id,
              data['id']?.toString() ?? '',
              data['_id']?.toString() ?? '',
            }) {
              if (key.isNotEmpty) out[key] = stock;
            }
          }
          controller.add(out);
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching stocks by ids: $e');
      return Stream.value(const {});
    }
  }

  @override
  Stream<Stock?> watchStockByVariantId({required String stockId}) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:8');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;
      final preparedStockId = prepareDqlSyncSubscription(
        "SELECT * FROM stocks WHERE id = :id",
        {'id': stockId},
      );
      ditto.sync.registerSubscription(
        preparedStockId.dql,
        arguments: preparedStockId.arguments,
      );
      observer = ditto.store.registerObserver(
        'SELECT * FROM stocks WHERE id = :id',
        arguments: {'id': stockId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          if (queryResult.items.isNotEmpty) {
            final stockData = Map<String, dynamic>.from(
              queryResult.items.first.value,
            );
            final stock = _convertFromDittoDocument(stockData);
            controller.add(stock);
          } else {
            controller.add(null);
          }
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching stock by variant ID: $e');
      return Stream.value(null);
    }
  }

  @override
  FutureOr<void> updateStockRequest({
    required String stockRequestId,
    DateTime? updatedAt,
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? deliveryNote,
    String? orderNote,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:9');
      return;
    }

    final updateData = <String, dynamic>{};
    if (updatedAt != null) {
      updateData['updatedAt'] = updatedAt.toIso8601String();
    }
    if (status != null) {
      updateData['status'] = status;
    }
    if (approvedBy != null) {
      updateData['approvedBy'] = approvedBy;
    }
    if (approvedAt != null) {
      updateData['approvedAt'] = approvedAt.toIso8601String();
    }
    if (deliveryNote != null) {
      updateData['deliveryNote'] = deliveryNote;
    }
    if (orderNote != null) {
      updateData['orderNote'] = orderNote;
    }

    if (updateData.isNotEmpty) {
      await ditto.store.execute(
        'UPDATE stock_requests SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :id',
        arguments: {...updateData, 'id': stockRequestId},
      );
    }
  }

  @override
  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    int? quantityRequested,
    bool? ignoreForReport,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:10');
      throw Exception('Ditto not initialized:10');
    }

    try {
      // 1. Fetch the stock request
      final result = await ditto.store.execute(
        'SELECT * FROM stock_requests WHERE _id = :id',
        arguments: {'id': requestId},
      );

      if (result.items.isEmpty) {
        talker.error('Stock request not found: $requestId');
        return;
      }

      final requestData = Map<String, dynamic>.from(result.items.first.value);
      final List<dynamic> transactionItems = List.from(
        requestData['transactionItems'] ?? [],
      );

      bool itemFound = false;
      final updatedItems = transactionItems.map((item) {
        final itemMap = Map<String, dynamic>.from(item);
        if (itemMap['id'] == transactionItemId) {
          itemFound = true;
          if (quantityApproved != null) {
            itemMap['quantityApproved'] = quantityApproved;
          }
          if (quantityRequested != null) {
            itemMap['qty'] = quantityRequested;
            itemMap['quantityRequested'] = quantityRequested;
          }
        }
        return itemMap;
      }).toList();

      if (!itemFound) {
        talker.warning('Item not found in stock request: $transactionItemId');
        return;
      }

      // 2. Update stock request with modified items
      await ditto.store.execute(
        'UPDATE stock_requests SET transactionItems = :items WHERE _id = :id',
        arguments: {'items': updatedItems, 'id': requestId},
      );

      // 3. Update the actual transaction item in the table
      if (quantityRequested != null) {
        await ditto.store.execute(
          'UPDATE transaction_items SET qty = :qty, quantityRequested = :qty WHERE _id = :id',
          arguments: {'qty': quantityRequested, 'id': transactionItemId},
        );
      }
      if (quantityApproved != null) {
        await ditto.store.execute(
          'UPDATE transaction_items SET quantityApproved = :quantityApproved WHERE _id = :id',
          arguments: {
            'quantityApproved': quantityApproved,
            'id': transactionItemId,
          },
        );
      }
    } catch (e) {
      talker.error('Error updating stock request item: $e');
      rethrow;
    }
  }
}
