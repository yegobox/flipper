import 'dart:async';

import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/stock_recount_interface.dart';
import 'package:flipper_models/sync/stock_recount_rra_validation.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:supabase_models/brick/models/transactionItemUtil.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

/// Ditto-backed stock recount (Capella). Overrides [StockRecountMixin] SQLite/B-repository reads so mesh state is authoritative.
mixin CapellaStockRecountMixin implements StockRecountInterface {
  Repository get repository;
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  dynamic _dittoOrThrow() {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }
    return ditto;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  Stock _stockFromDittoMap(Map<String, dynamic> data) {
    DateTime? lastTouched;
    if (data['lastTouched'] != null) {
      if (data['lastTouched'] is String) {
        lastTouched = DateTime.tryParse(data['lastTouched'].toString());
      }
    }
    return Stock(
      id: (data['_id'] ?? data['id']).toString(),
      tin: data['tin'] as int?,
      bhfId: data['bhfId'] as String?,
      branchId: data['branchId']?.toString() ?? '',
      currentStock: _toDouble(data['currentStock']),
      lowStock: _toDouble(data['lowStock']),
      canTrackingStock: data['canTrackingStock'] as bool? ?? true,
      showLowStockAlert: data['showLowStockAlert'] as bool? ?? true,
      active: data['active'] as bool? ?? true,
      value: _toDouble(data['value']),
      rsdQty: _toDouble(data['rsdQty']),
      lastTouched: lastTouched ?? DateTime.now().toUtc(),
      ebmSynced: data['ebmSynced'] as bool? ?? false,
      initialStock: _toDouble(data['initialStock']),
    );
  }

  StockRecount _stockRecountFromMap(Map<String, dynamic> document) {
    final id = document['_id'] ?? document['id'];
    return StockRecount(
      id: id?.toString(),
      branchId: document['branchId'].toString(),
      status: document['status']?.toString(),
      userId: document['userId']?.toString(),
      deviceId: document['deviceId']?.toString(),
      deviceName: document['deviceName']?.toString(),
      createdAt:
          DateTime.tryParse(document['createdAt']?.toString() ?? '') ??
          DateTime.now().toUtc(),
      submittedAt: DateTime.tryParse(document['submittedAt']?.toString() ?? ''),
      syncedAt: DateTime.tryParse(document['syncedAt']?.toString() ?? ''),
      notes: document['notes']?.toString(),
      totalItemsCounted: (document['totalItemsCounted'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> _stockRecountToDoc(StockRecount model) {
    return {
      '_id': model.id,
      'id': model.id,
      'branchId': model.branchId,
      'status': model.status,
      'userId': model.userId,
      'deviceId': model.deviceId,
      'deviceName': model.deviceName,
      'createdAt': model.createdAt.toIso8601String(),
      'submittedAt': model.submittedAt?.toIso8601String(),
      'syncedAt': model.syncedAt?.toIso8601String(),
      'notes': model.notes,
      'totalItemsCounted': model.totalItemsCounted,
    };
  }

  StockRecountItem _stockRecountItemFromMap(Map<String, dynamic> document) {
    final id = document['_id'] ?? document['id'];
    return StockRecountItem(
      id: id?.toString(),
      recountId: document['recountId'].toString(),
      variantId: document['variantId'].toString(),
      stockId: document['stockId'].toString(),
      productName: document['productName'].toString(),
      previousQuantity: _toDouble(document['previousQuantity']),
      countedQuantity: _toDouble(document['countedQuantity']),
      difference: _toDouble(document['difference']),
      notes: document['notes']?.toString(),
      createdAt:
          DateTime.tryParse(document['createdAt']?.toString() ?? '') ??
          DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> _stockRecountItemToDoc(
    StockRecountItem model, {
    required String branchId,
  }) {
    return {
      '_id': model.id,
      'id': model.id,
      'branchId': branchId,
      'recountId': model.recountId,
      'variantId': model.variantId,
      'stockId': model.stockId,
      'productName': model.productName,
      'previousQuantity': model.previousQuantity,
      'countedQuantity': model.countedQuantity,
      'difference': model.difference,
      'notes': model.notes,
      'createdAt': model.createdAt.toIso8601String(),
    };
  }

  Future<void> _upsertRecountDitto(StockRecount model) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      '''
INSERT INTO stock_recounts
DOCUMENTS (:doc)
ON ID CONFLICT DO UPDATE
''',
      arguments: {'doc': _stockRecountToDoc(model)},
    );
    await repository.upsert<StockRecount>(model);
  }

  Future<void> _upsertRecountItemDitto(
    StockRecountItem model,
    String branchId,
  ) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      '''
INSERT INTO stock_recount_items
DOCUMENTS (:doc)
ON ID CONFLICT DO UPDATE
''',
      arguments: {'doc': _stockRecountItemToDoc(model, branchId: branchId)},
    );
    await repository.upsert<StockRecountItem>(model);
  }

  Future<Stock?> _stockFromDitto(String id) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM stocks WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': id},
    );
    if (result.items.isEmpty) return null;
    return _stockFromDittoMap(
      Map<String, dynamic>.from(result.items.first.value),
    );
  }

  Future<Variant?> _variantFromDitto(String id) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM variants WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': id},
    );
    if (result.items.isEmpty) return null;
    try {
      return Variant.fromJson(
        Map<String, dynamic>.from(result.items.first.value),
      );
    } catch (e, st) {
      talker.warning('CapellaStockRecount: variant parse failed $e\n$st');
      return null;
    }
  }

  Future<void> _refreshRecountItemCount(String recountId) async {
    final items = await getRecountItems(recountId: recountId);
    final recount = await getRecount(recountId: recountId);
    if (recount == null) return;
    await _upsertRecountDitto(
      recount.copyWith(totalItemsCounted: items.length),
    );
  }

  @override
  Future<StockRecount> startRecountSession({
    required String branchId,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? notes,
  }) async {
    final recount = StockRecount(
      branchId: branchId,
      userId: userId,
      deviceId: deviceId,
      deviceName: deviceName,
      notes: notes,
      status: 'draft',
    );
    await _upsertRecountDitto(recount);
    return recount;
  }

  @override
  Future<List<StockRecount>> getRecounts({
    required String branchId,
    String? status,
  }) async {
    final ditto = _dittoOrThrow();
    var sql = 'SELECT * FROM stock_recounts WHERE branchId = :branchId';
    final args = <String, dynamic>{'branchId': branchId};
    if (status != null) {
      sql += ' AND status = :status';
      args['status'] = status;
    }
    sql += ' ORDER BY createdAt DESC';
    final result = await ditto.store.execute(sql, arguments: args);
    return result.items
        .map<StockRecount>(
          (row) => _stockRecountFromMap(Map<String, dynamic>.from(row.value)),
        )
        .toList();
  }

  @override
  Future<StockRecount?> getRecount({required String recountId}) async {
    final ditto = _dittoOrThrow();
    final result = await ditto.store.execute(
      'SELECT * FROM stock_recounts WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': recountId},
    );
    if (result.items.isEmpty) return null;
    return _stockRecountFromMap(
      Map<String, dynamic>.from(result.items.first.value),
    );
  }

  @override
  Future<List<StockRecountItem>> getRecountItems({
    required String recountId,
  }) async {
    final ditto = _dittoOrThrow();
    final result = await ditto.store.execute(
      'SELECT * FROM stock_recount_items WHERE recountId = :rid ORDER BY createdAt ASC',
      arguments: {'rid': recountId},
    );
    return result.items
        .map<StockRecountItem>(
          (row) =>
              _stockRecountItemFromMap(Map<String, dynamic>.from(row.value)),
        )
        .toList();
  }

  @override
  Future<StockRecountItem> addOrUpdateRecountItem({
    required String recountId,
    required String variantId,
    required double countedQuantity,
    String? notes,
  }) async {
    final recount = await getRecount(recountId: recountId);
    if (recount == null) {
      throw Exception('Recount not found: $recountId');
    }

    final variant = await _variantFromDitto(variantId);
    if (variant == null) {
      throw Exception('Variant not found: $variantId');
    }

    Stock? stock;
    if (variant.stockId != null && variant.stockId!.isNotEmpty) {
      stock = await _stockFromDitto(variant.stockId!);
    }

    final previousQuantity = stock?.currentStock ?? 0.0;
    final stockId = stock?.id ?? const Uuid().v4();

    final ditto = _dittoOrThrow();
    final existingResult = await ditto.store.execute(
      '''
SELECT * FROM stock_recount_items
WHERE recountId = :rid AND variantId = :vid
LIMIT 1
''',
      arguments: {'rid': recountId, 'vid': variantId},
    );

    StockRecountItem item;
    if (existingResult.items.isNotEmpty) {
      final existing = _stockRecountItemFromMap(
        Map<String, dynamic>.from(existingResult.items.first.value),
      );
      item = existing.copyWith(
        countedQuantity: countedQuantity,
        difference: countedQuantity - previousQuantity,
        notes: notes,
      );
    } else {
      item = StockRecountItem(
        recountId: recountId,
        variantId: variantId,
        stockId: stockId,
        productName: variant.name,
        previousQuantity: previousQuantity,
        countedQuantity: countedQuantity,
        difference: countedQuantity - previousQuantity,
        notes: notes,
      );
    }

    final validationError = item.validate();
    if (validationError != null) {
      throw Exception('Validation failed: $validationError');
    }

    await _upsertRecountItemDitto(item, recount.branchId);
    await _refreshRecountItemCount(recountId);
    return item;
  }

  @override
  Future<void> removeRecountItem({required String itemId}) async {
    final ditto = _dittoOrThrow();
    final existing = await ditto.store.execute(
      'SELECT * FROM stock_recount_items WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': itemId},
    );
    if (existing.items.isEmpty) {
      throw Exception('Recount item not found: $itemId');
    }
    final row = Map<String, dynamic>.from(existing.items.first.value);
    final recountId = row['recountId']?.toString();

    await ditto.store.execute(
      'DELETE FROM stock_recount_items WHERE _id = :id OR id = :id',
      arguments: {'id': itemId},
    );
    try {
      await repository.delete<StockRecountItem>(_stockRecountItemFromMap(row));
    } catch (e) {
      talker.warning(
        'CapellaStockRecount: Brick mirror delete recount item failed: $e',
      );
    }

    if (recountId != null && recountId.isNotEmpty) {
      await _refreshRecountItemCount(recountId);
    }
  }

  @override
  Future<StockRecount> submitRecount({required String recountId}) async {
    final recount = await getRecount(recountId: recountId);
    if (recount == null) {
      throw Exception('Recount not found: $recountId');
    }

    if (recount.status != 'draft') {
      throw Exception('Can only submit recount in draft status');
    }

    final items = await getRecountItems(recountId: recountId);

    if (items.isEmpty) {
      throw Exception('Cannot submit recount with no items');
    }

    for (final item in items) {
      final error = item.validate();
      if (error != null) {
        throw Exception('Item ${item.productName} validation failed: $error');
      }
    }

    if (kReleaseMode) {
      talker.info(
        'CapellaStockRecount: recount submit — local stock qty only '
        '(RRA/EBM skipped in release builds)',
      );
    }

    final ditto = _dittoOrThrow();

    for (final item in items) {
      final existingStock = await _stockFromDitto(item.stockId);

      final Stock stock;
      if (existingStock == null) {
        stock = Stock(
          id: item.stockId,
          branchId: recount.branchId,
          currentStock: item.countedQuantity,
          initialStock: item.countedQuantity,
          lastTouched: DateTime.now().toUtc(),
          ebmSynced: false,
        );
      } else {
        stock = existingStock.copyWith(
          currentStock: item.countedQuantity,
          lastTouched: DateTime.now().toUtc(),
          ebmSynced: false,
        );
      }

      await ditto.store.execute(
        "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
        arguments: {'doc': stock.toJson()},
      );
      await repository.upsert<Stock>(stock);

      final variant = await _variantFromDitto(item.variantId);
      if (variant == null) {
        continue;
      }

      if (variant.itemTyCd == '3') {
        continue;
      }

      if (kReleaseMode) {
        continue;
      }

      final rraBlockReason = missingRraIdentifiersMessageForStockRecountIo(
        variant,
      );
      if (rraBlockReason != null) {
        throw Exception('${variant.name}: $rraBlockReason');
      }

      final syncHost = this as DatabaseSyncInterface;
      final ebm = await syncHost.ebm(
        branchId: recount.branchId,
        fetchRemote: true,
      );
      final sar = await syncHost.getSar(branchId: recount.branchId);

      if (ebm != null && sar != null) {
        sar.sarNo = sar.sarNo + 1;
        await repository.upsert<Sar>(sar);

        final rwSave = await ProxyService.tax.saveStockItems(
          items: [
            TransactionItemUtil.fromVariant(
              variant,
              itemSeq: 1,
              approvedQty: item.countedQuantity.toDouble(),
            ),
          ],
          tinNumber: ebm.tinNumber.toString(),
          bhFId: ebm.bhfId,
          totalSupplyPrice: variant.supplyPrice ?? 0,
          totalvat: 0,
          totalAmount: variant.retailPrice ?? 0,
          sarTyCd: '06',
          sarNo: sar.sarNo.toString(),
          invoiceNumber: sar.sarNo,
          remark: 'Stock recount adjustment',
          ocrnDt: DateTime.now().toUtc(),
          URI: ebm.taxServerUrl,
          updateMaster: false,
        );
        if (rwSave.resultCd != '000') {
          throw Exception(
            rwSave.resultMsg.isEmpty
                ? 'RRA saveStockItems failed (${rwSave.resultCd})'
                : rwSave.resultMsg,
          );
        }
        await ProxyService.tax.saveStockMaster(
          variant: variant,
          URI: ebm.taxServerUrl,
          stockMasterQty: item.countedQuantity,
        );
      }
    }

    final submittedRecount = recount.submit();
    await _upsertRecountDitto(submittedRecount);
    return submittedRecount;
  }

  @override
  Future<StockRecount> markRecountSynced({required String recountId}) async {
    final recount = await getRecount(recountId: recountId);
    if (recount == null) {
      throw Exception('Recount not found: $recountId');
    }

    if (recount.status != 'submitted') {
      throw Exception('Can only mark submitted recount as synced');
    }

    final syncedRecount = recount.markSynced();
    await _upsertRecountDitto(syncedRecount);
    return syncedRecount;
  }

  @override
  Future<void> deleteRecount({required String recountId}) async {
    final recount = await getRecount(recountId: recountId);
    if (recount == null) {
      throw Exception('Recount not found: $recountId');
    }

    if (recount.status != 'draft') {
      throw Exception('Can only delete recount in draft status');
    }

    final ditto = _dittoOrThrow();
    final items = await getRecountItems(recountId: recountId);
    for (final item in items) {
      await ditto.store.execute(
        'DELETE FROM stock_recount_items WHERE _id = :id OR id = :id',
        arguments: {'id': item.id},
      );
      try {
        await repository.delete<StockRecountItem>(item);
      } catch (e) {
        talker.warning(
          'CapellaStockRecount: Brick mirror delete recount item failed: $e',
        );
      }
    }

    await ditto.store.execute(
      'DELETE FROM stock_recounts WHERE _id = :id OR id = :id',
      arguments: {'id': recountId},
    );
    try {
      await repository.delete<StockRecount>(recount);
    } catch (e) {
      talker.warning(
        'CapellaStockRecount: Brick mirror delete recount failed: $e',
      );
    }
  }

  @override
  Stream<List<StockRecount>> recountsStream({
    required String branchId,
    String? status,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized — recountsStream');
      return Stream.value([]);
    }

    final controller = StreamController<List<StockRecount>>.broadcast();
    dynamic observer;

    var query = 'SELECT * FROM stock_recounts WHERE branchId = :branchId';
    final arguments = <String, dynamic>{'branchId': branchId};
    if (status != null) {
      query += ' AND status = :status';
      arguments['status'] = status;
    }
    query += ' ORDER BY createdAt DESC';

    () async {
      try {
        final prepared = prepareDqlSyncSubscription(query, arguments);
        await ditto.sync.registerSubscription(
          prepared.dql,
          arguments: prepared.arguments,
        );

        observer = ditto.store.registerObserver(
          query,
          arguments: arguments,
          onChange: (queryResult) {
            if (controller.isClosed) return;
            final list = queryResult.items
                .map<StockRecount>(
                  (row) => _stockRecountFromMap(
                    Map<String, dynamic>.from(row.value),
                  ),
                )
                .toList();
            controller.add(list);
          },
        );
      } catch (e, st) {
        talker.error('Capella recountsStream failed: $e\n$st');
        if (!controller.isClosed) controller.add([]);
      }
    }();

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<Map<String, double>> getStockSummary({
    required String branchId,
    List<String>? variantIds,
  }) async {
    final ditto = _dittoOrThrow();
    final stocksResult = await ditto.store.execute(
      'SELECT * FROM stocks WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );

    final summary = <String, double>{};
    final filter = variantIds != null && variantIds.isNotEmpty
        ? variantIds.toSet()
        : null;

    for (final doc in stocksResult.items) {
      final stock = _stockFromDittoMap(Map<String, dynamic>.from(doc.value));
      final vr = await ditto.store.execute(
        'SELECT * FROM variants WHERE stockId = :sid LIMIT 5',
        arguments: {'sid': stock.id},
      );
      for (final vDoc in vr.items) {
        try {
          final v = Variant.fromJson(Map<String, dynamic>.from(vDoc.value));
          if (filter != null && !filter.contains(v.id)) continue;
          summary[v.id] = stock.currentStock ?? 0.0;
        } catch (_) {}
      }
    }

    return summary;
  }
}
