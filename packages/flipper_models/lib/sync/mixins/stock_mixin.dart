import 'package:flipper_models/SyncStrategy.dart';
import 'dart:async';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart'
    as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

import 'package:supabase_models/brick/models/all_models.dart' as models;
// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

mixin StockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Stock?> getStockById({required String id}) async {
    return await ProxyService.getStrategy(
      Strategy.capella,
    ).getStockById(id: id);
  }

  @override
  Future<Map<String, Stock>> batchGetStocksByIds(List<String> ids) async {
    return ProxyService.getStrategy(Strategy.capella).batchGetStocksByIds(ids);
  }

  @override
  Stream<Stock?> watchStockByVariantId({required String stockId}) {
    throw UnimplementedError('watchStockByVariantId needs to be implemented');
  }

  @override
  Stream<Map<String, Stock?>> watchStocksByIds(List<String> stockIds) {
    return ProxyService.getStrategy(
      Strategy.capella,
    ).watchStocksByIds(stockIds);
  }

  /// Recreates the Capella/Ditto stock document behind [stockId] when it is gone.
  ///
  /// A Stock row can live in Brick with no Ditto document: `repository.upsert`
  /// deliberately skips Ditto for Stock (Capella owns live qty at runtime), while
  /// every read here — [getStockById] — goes through Capella. Editing such a
  /// product then failed with "stock <id> not found" and silently dropped the
  /// typed quantity.
  ///
  /// Healing is only allowed when a Variant actually points at [stockId], so a
  /// stale or mistyped id still fails loudly instead of littering the store with
  /// orphan stock. The document is created zeroed — the caller's own update runs
  /// right after, so nothing is double-counted.
  Future<Stock?> _healMissingStockDocument(String stockId) async {
    Variant? variant;
    try {
      variant = await ProxyService.strategy.getVariant(stockId: stockId) ??
          await ProxyService.getStrategy(
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
      final healed = await ProxyService.getStrategy(Strategy.capella).saveStock(
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
      return healed;
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
    Stock? stock =
        await getStockById(id: stockId) ??
        await _healMissingStockDocument(stockId);
    if (stock == null) {
      talker.error('updateStock: stock $stockId not found');
      throw StateError('Stock with ID $stockId not found');
    }
    Variant? variant = await ProxyService.strategy.getVariant(
      stockId: stock.id,
    );

    // If appending, add to existing values; otherwise, replace.
    if (currentStock != null) {
      stock.currentStock = appending
          ? (stock.currentStock ?? 0) + currentStock
          : currentStock;
    }
    if (rsdQty != null) {
      stock.rsdQty = appending ? (stock.rsdQty ?? 0) + rsdQty : rsdQty;
    }
    if (initialStock != null) {
      stock.initialStock = appending
          ? (stock.initialStock ?? 0) + initialStock
          : initialStock;
    }
    if (value != null) {
      stock.value = appending ? (variant!.retailPrice! * currentStock!) : value;
    }

    // These fields should always be replaced, not appended
    if (ebmSynced != null) {
      stock.ebmSynced = ebmSynced;
    }
    if (lastTouched != null) {
      stock.lastTouched = lastTouched;
    }

    await repository.upsert(stock);

    // Keep Capella/Ditto in sync — POS tiles and transfers read stock there.
    // Brick-only upsert previously left Capella ahead/behind and caused false OOS.
    try {
      await ProxyService.getStrategy(Strategy.capella).updateStock(
        stockId: stockId,
        qty: qty,
        rsdQty: stock.rsdQty,
        initialStock: stock.initialStock,
        ebmSynced: stock.ebmSynced,
        currentStock: stock.currentStock,
        value: stock.value,
        appending: false,
        lastTouched: stock.lastTouched,
      );
    } catch (e, st) {
      talker.warning(
        'updateStock Capella mirror failed for $stockId: $e\n$st',
      );
    }
  }

  @override
  Future<void> batchUpdateStocks(
    Map<String, ({double currentStock, double rsdQty})> byStockId,
  ) async {
    for (final e in byStockId.entries) {
      await updateStock(
        stockId: e.key,
        currentStock: e.value.currentStock,
        rsdQty: e.value.rsdQty,
      );
    }
  }

  @override
  Future<void> batchDeductStocks(Map<String, double> deltaByStockId) async {
    for (final e in deltaByStockId.entries) {
      final delta = e.value;
      if (delta <= 0) continue;
      // Brick path: append negative (same as Capella absolute race risk; sales
      // use Capella).
      await updateStock(
        stockId: e.key,
        currentStock: -delta,
        rsdQty: -delta,
        appending: true,
      );
    }
  }

  @override
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    // This should be implemented by specific sync strategies (e.g., Capella)
    throw UnimplementedError();
  }

  @override
  Stream<List<InventoryRequest>> requestsStreamOutgoing({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    // This should be implemented by specific sync strategies (e.g., Capella)
    throw UnimplementedError();
  }

  @override
  Future<List<InventoryRequest>> stockRequestsToBranch({
    required String destinationBranchId,
    DateTime? start,
    DateTime? end,
    String status = 'all',
    int limit = 500,
  }) async {
    return ProxyService.getStrategy(Strategy.capella).stockRequestsToBranch(
      destinationBranchId: destinationBranchId,
      start: start,
      end: end,
      status: status,
      limit: limit,
    );
  }

  @override
  Future<List<InventoryRequest>> requests({
    String? branchId,
    String? requestId,
  }) async {
    if (requestId == null || requestId.isEmpty) {
      return [];
    }
    return ProxyService.getStrategy(Strategy.capella).requests(
      requestId: requestId,
    );
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
    final stock = Stock(
      id: id ?? const Uuid().v4(),
      lastTouched: DateTime.now().toUtc(),
      branchId: branchId,
      currentStock: currentStock,
      rsdQty: rsdQty,
      value: value,
    );
    return await repository.upsert<Stock>(stock);
  }

  @override
  Future<String> createStockRequest(
    List<models.TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  }) async {
    throw UnimplementedError();
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
    return ProxyService.getStrategy(Strategy.capella).updateStockRequest(
      stockRequestId: stockRequestId,
      updatedAt: updatedAt,
      status: status,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      deliveryNote: deliveryNote,
      orderNote: orderNote,
    );
  }

  @override
  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    int? quantityRequested,
    bool? ignoreForReport,
  }) async {
    return ProxyService.getStrategy(Strategy.capella).updateStockRequestItem(
      requestId: requestId,
      transactionItemId: transactionItemId,
      quantityApproved: quantityApproved,
      quantityRequested: quantityRequested,
      ignoreForReport: ignoreForReport,
    );
  }
}
