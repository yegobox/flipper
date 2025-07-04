import 'package:flipper_models/db_model_export.dart';

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
  Future<Stock> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
      required double currentStock,
      required double value});
}
