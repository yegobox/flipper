import 'dart:async';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/sync/interfaces/stock_recount_interface.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';

mixin StockRecountMixin implements StockRecountInterface, VariantInterface {
  Repository get repository;

  @override
  Future<StockRecount> startRecountSession({
    required int branchId,
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

    await repository.upsert<StockRecount>(recount);
    return recount;
  }

  @override
  Future<List<StockRecount>> getRecounts({
    required int branchId,
    String? status,
  }) async {
    final query = Query(
      where: [
        Where('branchId').isExactly(branchId),
        if (status != null) Where('status').isExactly(status),
      ],
    );

    return await repository.get<StockRecount>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<StockRecount?> getRecount({required String recountId}) async {
    final query = Query(where: [Where('id').isExactly(recountId)]);

    final results = await repository.get<StockRecount>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<List<StockRecountItem>> getRecountItems({
    required String recountId,
  }) async {
    final query = Query(
      where: [Where('recountId').isExactly(recountId)],
    );

    return await repository.get<StockRecountItem>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<StockRecountItem> addOrUpdateRecountItem({
    required String recountId,
    required String variantId,
    required double countedQuantity,
    String? notes,
  }) async {
    // Fetch the variant to get product name and stock info
    final variantQuery = Query(where: [Where('id').isExactly(variantId)]);
    final variants = await repository.get<Variant>(
      query: variantQuery,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    if (variants.isEmpty) {
      throw Exception('Variant not found: $variantId');
    }

    final variant = variants.first;

    // Fetch current stock
    Stock? stock;
    if (variant.stockId != null) {
      final stockQuery =
          Query(where: [Where('id').isExactly(variant.stockId!)]);
      final stocks = await repository.get<Stock>(
        query: stockQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
      stock = stocks.isNotEmpty ? stocks.first : null;
    }

    final previousQuantity = stock?.currentStock ?? 0.0;
    final stockId = stock?.id ?? const Uuid().v4();

    // Check if item already exists in this recount
    final existingItemsQuery = Query(where: [
      Where('recountId').isExactly(recountId),
      Where('variantId').isExactly(variantId),
    ]);

    final existingItems = await repository.get<StockRecountItem>(
      query: existingItemsQuery,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    StockRecountItem item;
    if (existingItems.isNotEmpty) {
      // Update existing item
      item = existingItems.first.copyWith(
        countedQuantity: countedQuantity,
        difference: countedQuantity - previousQuantity,
        notes: notes,
      );
    } else {
      // Create new item
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

    // Validate
    final validationError = item.validate();
    if (validationError != null) {
      throw Exception('Validation failed: $validationError');
    }

    await repository.upsert<StockRecountItem>(item);

    // Update recount's total items count
    final recount = await getRecount(recountId: recountId);
    if (recount != null) {
      final allItems = await getRecountItems(recountId: recountId);
      final updatedRecount =
          recount.copyWith(totalItemsCounted: allItems.length);
      await repository.upsert<StockRecount>(updatedRecount);
    }

    return item;
  }

  @override
  Future<void> removeRecountItem({required String itemId}) async {
    final query = Query(where: [Where('id').isExactly(itemId)]);
    final items = await repository.get<StockRecountItem>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    if (items.isEmpty) {
      throw Exception('Recount item not found: $itemId');
    }

    final item = items.first;
    await repository.delete<StockRecountItem>(item);

    // Update recount's total items count
    final recount = await getRecount(recountId: item.recountId);
    if (recount != null) {
      final remainingItems = await getRecountItems(recountId: item.recountId);
      final updatedRecount =
          recount.copyWith(totalItemsCounted: remainingItems.length);
      await repository.upsert<StockRecount>(updatedRecount);
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

    // Get all items in this recount
    final items = await getRecountItems(recountId: recountId);

    if (items.isEmpty) {
      throw Exception('Cannot submit recount with no items');
    }

    // Validate all items
    for (final item in items) {
      final error = item.validate();
      if (error != null) {
        throw Exception('Item ${item.productName} validation failed: $error');
      }
    }

    // Update Stock records for each item
    for (final item in items) {
      // Fetch the current stock
      final stockQuery = Query(where: [Where('id').isExactly(item.stockId)]);
      final stocks = await repository.get<Stock>(
        query: stockQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      Stock stock;
      if (stocks.isEmpty) {
        // Create new stock if it doesn't exist
        stock = Stock(
          id: item.stockId,
          branchId: recount.branchId,
          currentStock: item.countedQuantity,
          initialStock: item.countedQuantity,
          lastTouched: DateTime.now().toUtc(),
          ebmSynced: false, // Mark for RRA sync
        );
      } else {
        // Update existing stock
        stock = stocks.first.copyWith(
          currentStock: item.countedQuantity,
          lastTouched: DateTime.now().toUtc(),
          ebmSynced: false, // Mark for RRA sync
        );
      }

      await repository.upsert<Stock>(stock);

      // Trigger RRA stock IO for the variant
      final variantQuery = Query(where: [Where('id').isExactly(item.variantId)]);
      final variants = await repository.get<Variant>(query: variantQuery);
      if (variants.isNotEmpty) {
        await updateIoFunc(
          variant: variants.first,
          approvedQty: item.countedQuantity,
        );
      }
    }

    // Mark recount as submitted
    final submittedRecount = recount.submit();
    await repository.upsert<StockRecount>(submittedRecount);

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
    await repository.upsert<StockRecount>(syncedRecount);

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

    // Delete all items first
    final items = await getRecountItems(recountId: recountId);
    for (final item in items) {
      await repository.delete<StockRecountItem>(item);
    }

    // Delete the recount
    await repository.delete<StockRecount>(recount);
  }

  @override
  Stream<List<StockRecount>> recountsStream({
    required int branchId,
    String? status,
  }) {
    final query = Query(
      where: [
        Where('branchId').isExactly(branchId),
        if (status != null) Where('status').isExactly(status),
      ],
    );

    return repository.subscribe<StockRecount>(query: query);
  }

  @override
  Future<Map<String, double>> getStockSummary({
    required int branchId,
    List<String>? variantIds,
  }) async {
    final query = Query(
      where: [
        Where('branchId').isExactly(branchId),
        if (variantIds != null && variantIds.isNotEmpty)
          Where('id').isIn(variantIds),
      ],
    );

    final stocks = await repository.get<Stock>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    final summary = <String, double>{};
    for (final stock in stocks) {
      // Need to find the variant for this stock
      final variantQuery = Query(where: [Where('stockId').isExactly(stock.id)]);
      final variants = await repository.get<Variant>(
        query: variantQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      if (variants.isNotEmpty) {
        summary[variants.first.id] = stock.currentStock ?? 0.0;
      }
    }

    return summary;
  }
}
