import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';

abstract class StockInterface {
  Future<Stock?> getStockById({required String id});
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
}
