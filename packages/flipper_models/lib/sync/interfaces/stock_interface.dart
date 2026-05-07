import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';

abstract class StockInterface {
  Future<Stock?> getStockById({required String id});

  /// Loads many stocks in as few round-trips as possible (Capella: single Ditto query).
  Future<Map<String, Stock>> batchGetStocksByIds(List<String> ids);

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
  });

  /// Replaces [currentStock] and [rsdQty] for many stocks (non-appending), in fewer
  /// round-trips than repeated [updateStock] (Capella: parallel Ditto UPDATEs).
  Future<void> batchUpdateStocks(
    Map<String, ({double currentStock, double rsdQty})> byStockId,
  );

  Future<List<InventoryRequest>> requests({required String requestId});
  Future<Stock> saveStock({
    Variant? variant,
    required double rsdQty,
    required String productId,
    required String variantId,
    required String branchId,
    required double currentStock,
    required double value,
  });
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  });
  Stream<List<InventoryRequest>> requestsStreamOutgoing({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  });
  Stream<Stock?> watchStockByVariantId({required String stockId});
  Future<String> createStockRequest(
    List<TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  });
  FutureOr<void> updateStockRequest({
    required String stockRequestId,
    DateTime? updatedAt,
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? deliveryNote,
    String? orderNote,
  });
  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    int? quantityRequested,
    bool? ignoreForReport,
  });
}
